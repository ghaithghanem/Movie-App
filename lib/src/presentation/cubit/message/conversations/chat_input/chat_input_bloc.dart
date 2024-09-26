import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../get_message/get_message_cubit.dart';

part 'chat_input_event.dart';
part 'chat_input_state.dart';

/// Define the BLoC
class ChatInputBloc extends Bloc<ChatInputEvent, ChatInputState> {
  final String senderId;
  final String receiverId;
  final GetMessageCubit getMessageCubit; // Get the cubit as a parameter

  ChatInputBloc(
    this.senderId,
    this.receiverId,
    this.getMessageCubit, // Pass it in the constructor
  ) : super(const ChatInputState()) {
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

    on<CancelRecording>((event, emit) {
      emit(state.copyWith(
        isRecording: false,
        dragOffset: 0.0,
      ));
    });

    on<DragUpdateEvent>((event, emit) {
      emit(state.copyWith(dragOffset: event.dragOffset));
    });

    on<StartRecording>((event, emit) async {
      await _startRecording();
      emit(state.copyWith(isRecording: true));
    });

    on<StopRecording>((event, emit) async {
      await _stopRecording();
      emit(state.copyWith(isRecording: false, dragOffset: 0.0));
    });

    on<LongPressMoveUpdate>((event, emit) {
      if (event.positionY <
          MediaQuery.of(context as BuildContext).size.height - 150) {
        emit(state.copyWith(dragOffset: event.positionY));
      }
    });

    on<SendMessage>((event, emit) async {
      await _sendMessage(event.message ?? '', event.voiceMessagePath);
      emit(state.copyWith(isSendButtonActive: false));
    });
  }

  Future<void> _startRecording() async {
    // Start your recording logic here
    // await _myRecorder.startRecorder();
  }

  Future<void> _stopRecording() async {
    // Stop the recording and return the file path
    // await _myRecorder.stopRecorder();
  }

  Future<void> _sendMessage(String message, String? voiceMessagePath) async {
    await getMessageCubit.sendMessage(
      senderId,
      receiverId,
      message.isNotEmpty ? message : null,
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
