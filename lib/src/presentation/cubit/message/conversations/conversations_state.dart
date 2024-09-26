part of 'conversations_bloc.dart';

abstract class ConversationsState extends Equatable {
  const ConversationsState();

  @override
  List<Object?> get props => [];
}

class ConversationsInitial extends ConversationsState {}

class GetConversationsLoading extends ConversationsState {
  @override
  List<Object?> get props => [];
}

class GetConversationsLoaded extends ConversationsState {
  final List<MessageEntity> conversationMessages;

  const GetConversationsLoaded({
    required this.conversationMessages,
  });

  @override
  List<Object?> get props => [
        conversationMessages,
      ];
}

class MessageError extends ConversationsState {
  final String message;

  const MessageError({required this.message});

  @override
  List<Object?> get props => [message];
}
