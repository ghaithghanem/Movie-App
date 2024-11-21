part of 'conversations_bloc.dart';

sealed class ConversationsEvent extends Equatable {
  const ConversationsEvent();
  @override
  List<Object?> get props => [];
}

final class LoadConversationEvent extends ConversationsEvent {
  final String userId1;
  final String userId2;

  const LoadConversationEvent(this.userId1, this.userId2);
  @override
  List<Object?> get props => [userId1, userId2];
}

final class LoadNextPageEvent extends ConversationsEvent {
  final String userId1;
  final String userId2;
  final ScrollController scrollController;

  const LoadNextPageEvent({
    required this.userId1,
    required this.userId2,
    required this.scrollController, // Add the scroll controller
  });
  @override
  List<Object?> get props => [userId1, userId2];
}

final class SendMessageEvent extends ConversationsEvent {
  final String senderId;
  final String receiverId;
  final String message;
  final String voiceMessageId;

  const SendMessageEvent(
      this.senderId, this.receiverId, this.message, this.voiceMessageId);

  @override
  List<Object?> get props => [senderId, receiverId, message, voiceMessageId];
}

class AddNewMessageEvent extends ConversationsEvent {
  final MessageEntity newMessage;

  const AddNewMessageEvent(this.newMessage);

  @override
  List<Object?> get props => [newMessage];
}

class MessageStatusUpdatedEvent extends ConversationsEvent {
  final String messageId;
  final int newStatus;

  const MessageStatusUpdatedEvent(this.messageId, this.newStatus);

  @override
  List<Object> get props => [messageId, newStatus];
}

class ResetConversationEvent extends ConversationsEvent {}

class ActivateConversationEvent extends ConversationsEvent {}

class DeactivateConversationEvent extends ConversationsEvent {}
