part of 'chat_input_bloc.dart';

class ChatInputState extends Equatable {
  final bool isSendButtonActive;
  final int recordDuration;
  final bool cancelRecording;
  final bool isEmojiPickerVisible;
  final bool isRecording;
  final double dragOffset;

  const ChatInputState({
    this.recordDuration = 0,
    this.cancelRecording = false,
    this.isSendButtonActive = false,
    this.isEmojiPickerVisible = false,
    this.isRecording = false,
    this.dragOffset = 0.0,
  });

  ChatInputState copyWith({
    bool? isSendButtonActive,
    bool? isEmojiPickerVisible,
    bool? isRecording,
    int? recordDuration,
    bool? cancelRecording,
    double? dragOffset,
  }) {
    return ChatInputState(
      isSendButtonActive: isSendButtonActive ?? this.isSendButtonActive,
      isEmojiPickerVisible: isEmojiPickerVisible ?? this.isEmojiPickerVisible,
      isRecording: isRecording ?? this.isRecording,
      recordDuration: recordDuration ?? this.recordDuration,
      cancelRecording: cancelRecording ?? this.cancelRecording,
      dragOffset: dragOffset ?? this.dragOffset,
    );
  }

  @override
  List<Object> get props => [
        isSendButtonActive,
        isEmojiPickerVisible,
        isRecording,
        dragOffset,
        recordDuration,
        cancelRecording
      ];
}
