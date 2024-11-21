part of 'get_message_cubit.dart';

sealed class GetMessageState extends Equatable {
  final List<MessageEntity> generalMessages;
  final List<MessageEntity> conversationMessages;
  final Map<String, bool> onlineStatuses;
  final int status;
  const GetMessageState(
      {this.generalMessages = const [],
      this.conversationMessages = const [],
      this.onlineStatuses = const {},
      this.status = 1});

  @override
  List<Object> get props =>
      [generalMessages, conversationMessages, onlineStatuses, status];
}

final class GetMessageInitial extends GetMessageState {}

final class GetMessageLoading extends GetMessageState {
  GetMessageLoading(GetMessageState state)
      : super(
            generalMessages: state.generalMessages,
            conversationMessages: state.conversationMessages,
            onlineStatuses: state.onlineStatuses,
            status: state.status);
}

class GetMessageLoaded extends GetMessageState {
  GetMessageLoaded({
    List<MessageEntity> generalMessages = const [],
    List<MessageEntity> conversationMessages = const [],
    Map<String, bool> onlineStatuses = const {},
    int status = 0,
  }) : super(
            conversationMessages: conversationMessages,
            generalMessages: generalMessages,
            onlineStatuses: onlineStatuses,
            status: status);
}

final class GetMessageError extends GetMessageState {
  final String message;

  const GetMessageError({required this.message});

  @override
  List<Object> get props => [message];
}

final class GetConversationLoading extends GetMessageState {
  GetConversationLoading(GetMessageState state)
      : super(
            generalMessages: state.generalMessages,
            conversationMessages: state.conversationMessages,
            onlineStatuses: state.onlineStatuses,
            status: state.status);
}

final class GetConversationLoaded extends GetMessageState {
  const GetConversationLoaded({
    List<MessageEntity> generalMessages = const [],
    List<MessageEntity> conversationMessages = const [],
    Map<String, bool> onlineStatuses = const {},
    int status = 0,
  }) : super(
          generalMessages: generalMessages,
          conversationMessages: conversationMessages,
          onlineStatuses: onlineStatuses,
          status: status,
        );
}
