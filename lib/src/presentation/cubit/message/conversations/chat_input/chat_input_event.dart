part of 'chat_input_bloc.dart';

/// Define the events
sealed class ChatInputEvent extends Equatable {
  const ChatInputEvent();
  @override
  List<Object> get props => [];
}

class TextChanged extends ChatInputEvent {
  final String text;

  const TextChanged(this.text);
  @override
  List<Object> get props => [text];
}

class ToggleEmojiPicker extends ChatInputEvent {}

class ToggleRecording extends ChatInputEvent {}

class CancelRecording extends ChatInputEvent {}

class DragUpdateEvent extends ChatInputEvent {
  final double dragOffset;

  const DragUpdateEvent(this.dragOffset);

  @override
  List<Object> get props => [dragOffset];
}

class StartRecording extends ChatInputEvent {}

class StopRecording extends ChatInputEvent {
  final String? voiceMessagePath;

  const StopRecording(this.voiceMessagePath);

  @override
  List<Object> get props => [voiceMessagePath ?? ''];
}

class LongPressMoveUpdate extends ChatInputEvent {
  final double positionY;

  const LongPressMoveUpdate(this.positionY);

  @override
  List<Object> get props => [positionY];
}

class SendMessage extends ChatInputEvent {
  final String? message;
  final String? voiceMessagePath;

  const SendMessage(this.message, this.voiceMessagePath);

  @override
  List<Object> get props => [message ?? '', voiceMessagePath ?? ''];
}
