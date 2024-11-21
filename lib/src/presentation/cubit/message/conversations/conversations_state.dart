part of 'conversations_bloc.dart';

abstract class ConversationsState extends Equatable {
  final List<MessageEntity> conversationMessages;

  const ConversationsState({
    this.conversationMessages = const [],
  });

  @override
  List<Object?> get props => [conversationMessages];
}

class ConversationsInitial extends ConversationsState {}

class GetConversationsLoading extends ConversationsState {
  GetConversationsLoading(ConversationsState state)
      : super(
          conversationMessages: state.conversationMessages,
        );
}

class GetConversationsLoaded extends ConversationsState {
  final List<MessageEntity> conversationMessages;

  const GetConversationsLoaded({
    required this.conversationMessages,
  }) : super(
          conversationMessages: conversationMessages,
        );

  @override
  List<Object?> get props => [conversationMessages];

  // Method to add more messages to the existing list
  GetConversationsLoaded copyWithNewMessages(List<MessageEntity> newMessages) {
    return GetConversationsLoaded(
      conversationMessages: List.from(conversationMessages)
        ..addAll(newMessages),
    );
  }
}

class LoadingMoreMessages extends ConversationsState {
  final List<MessageEntity> conversationMessages;

  LoadingMoreMessages({
    required this.conversationMessages,
  });

  @override
  List<Object?> get props => [conversationMessages];
}

class MessageError extends ConversationsState {
  final String message;

  const MessageError({required this.message});

  @override
  List<Object?> get props => [message];
}
