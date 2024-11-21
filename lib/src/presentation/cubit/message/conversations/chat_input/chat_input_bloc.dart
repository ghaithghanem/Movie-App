import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../get_message/get_message_cubit.dart';

part 'chat_input_event.dart';
part 'chat_input_state.dart';

/// Define the BLoC
class ChatInputBloc extends Bloc<ChatInputEvent, ChatInputState> {
  final FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();
  final GetMessageCubit getMessageCubit;
  Timer? _timer;

  ChatInputBloc(this.getMessageCubit) : super(const ChatInputState()) {
    on<TextChanged>((event, emit) {
      emit(state.copyWith(
        isSendButtonActive: event.text.isNotEmpty,
      ));
    });

    on<ToggleEmojiPicker>((event, emit) {
      emit(state.copyWith(
        isEmojiPickerVisible: !state.isEmojiPickerVisible,
      ));
    });

    on<ToggleRecording>((event, emit) {
      emit(state.copyWith(
        isRecording: !state.isRecording,
      ));
    });

    on<DragUpdateEvent>((event, emit) {
      emit(state.copyWith(dragOffset: event.dragOffset));
    });

    on<StartRecording>((event, emit) async {
      // Request permissions before recording
      await _requestPermissions();
      // Open the recorder if not already open
      if (!_myRecorder.isRecording) {
        await _myRecorder.openRecorder();
      }

      final String filePath = await _getFilePath();
      // Start recording and update the state
      await _myRecorder.startRecorder(
        toFile: filePath,
        codec: Codec.aacMP4,
      );
      // Emit state to indicate recording has started and reset duration
      emit(state.copyWith(
        isRecording: true,
      ));

      // Start the timer to update the recording duration
    });

    on<StopRecording>((event, emit) async {
      try {
        // Stop the recorder
        final String? recordedFilePath = await _myRecorder.stopRecorder();

        if (recordedFilePath != null && File(recordedFilePath).existsSync()) {
          _timer?.cancel(); // Stop the timer

          emit(state.copyWith(
            isRecording: false,
            recordDuration: 0,
          ));

          await _sendMessage(
            voiceMessagePath: recordedFilePath,
            senderId: event.senderId,
            receiverId: event.receiverId,
          );

          if (kDebugMode) {
            print('Recording stopped, file path: $recordedFilePath');
          }
        } else {
          if (kDebugMode) {
            print('No file was recorded or the file does not exist.');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error while stopping the recording: $e');
        }
      }
    });

    on<UpdateRecordingDuration>((event, emit) {
      emit(state.copyWith(
        recordDuration: event.newDuration, // Use the newDuration from the event
      ));
    });

    on<CancelRecording>((event, emit) async {
      await _myRecorder.stopRecorder();
      _timer?.cancel();
      _cancelRecording(emit);
    });

    on<ResetRecording>((event, emit) {
      if (kDebugMode) {
        print(
            'Before emit: isRecording: ${state.isRecording}, cancelRecording: ${state.cancelRecording}');
      }
      emit(state.copyWith(
        isRecording: false,
        cancelRecording: false,
        recordDuration: 0,
      ));
      if (kDebugMode) {
        print(
            'After emit: isRecording: ${state.isRecording}, cancelRecording: ${state.cancelRecording}');
      }
    });

    on<LongPressMoveUpdate>((event, emit) {
      if (event.positionY <
          MediaQuery.of(context as BuildContext).size.height - 150) {
        emit(state.copyWith(dragOffset: event.positionY));
      }
    });

    on<SendMessage>((event, emit) async {
      await _sendMessage(
        senderId: event.senderId,
        receiverId: event.receiverId,
        message: event.message,
        voiceMessagePath: event.voiceMessagePath,
      );

      emit(state.copyWith(isSendButtonActive: false));
    });
  }
  // Get file path for saving the audio
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/audio_record.m4a';
  }

  Future<void> _restRecording(Emitter<ChatInputState> emit) async {
    emit(state.copyWith(
        isRecording: false, cancelRecording: false, recordDuration: 0));
  }

  Future<void> _stopRecording(Emitter<ChatInputState> emit) async {
    _timer?.cancel();
    emit(state.copyWith(isRecording: false, recordDuration: 0));
  }

  Future<void> _cancelRecording(Emitter<ChatInputState> emit) async {
    _timer?.cancel();
    emit(state.copyWith(
        isRecording: false, cancelRecording: true, recordDuration: 0));
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _sendMessage({
    required String senderId,
    required String receiverId,
    String? message,
    String? voiceMessagePath,
  }) async {
    if (kDebugMode) {
      print('Voice message path: $voiceMessagePath');
    }

    // Use the injected GetMessageCubit to send the message
    await getMessageCubit.sendMessage(
      senderId,
      receiverId,
      message?.isNotEmpty == true ? message : null,
      voiceMessagePath,
    );
  }
}

/*
          Usage in the UI:

              ChatInputBloc(
                senderId: 'yourSenderId',
                receiverId: 'yourReceiverId',
                getMessageCubit: context.read<GetMessageCubit>(), // Pass the cubit directly here
              )

*/
