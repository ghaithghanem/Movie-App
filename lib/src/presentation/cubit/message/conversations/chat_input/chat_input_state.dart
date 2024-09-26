part of 'chat_input_bloc.dart';

class ChatInputState extends Equatable {
  final bool isSendButtonActive;
  final bool isEmojiPickerVisible;
  final bool isRecording;
  final double dragOffset;

  const ChatInputState({
    this.isSendButtonActive = false,
    this.isEmojiPickerVisible = false,
    this.isRecording = false,
    this.dragOffset = 0.0,
  });

  ChatInputState copyWith({
    bool? isSendButtonActive,
    bool? isEmojiPickerVisible,
    bool? isRecording,
    double? dragOffset,
  }) {
    return ChatInputState(
      isSendButtonActive: isSendButtonActive ?? this.isSendButtonActive,
      isEmojiPickerVisible: isEmojiPickerVisible ?? this.isEmojiPickerVisible,
      isRecording: isRecording ?? this.isRecording,
      dragOffset: dragOffset ?? this.dragOffset,
    );
  }

  @override
  List<Object> get props =>
      [isSendButtonActive, isEmojiPickerVisible, isRecording, dragOffset];
}
