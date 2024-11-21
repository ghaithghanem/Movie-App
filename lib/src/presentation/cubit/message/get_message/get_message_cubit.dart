import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/database/hive.dart';
import '../../../../core/network/socketservice.dart';
import '../../../../domain/entities/export_entities.dart';
import '../../../../domain/usecases/export_usecases.dart';

part 'get_message_state.dart';

class GetMessageCubit extends Cubit<GetMessageState> {
  final List<MessageEntity> _messageList = [];
  final SocketService _socketService;
  final MessageUsecases _messageUsecases;
  final String userId;
  final HiveService _hiveService;

  GetMessageCubit(this._messageUsecases, this.userId, this._hiveService,
      this._socketService)
      : super(GetMessageInitial()) {
    // Set up socket event listeners
    //_socketService.onNewMessage = _handleNewMessage;

    _socketService.onUserOnlineStatusUpdate = _handleUserOnlineStatusUpdate;
  }

  Future<void> addNewMessagesAndUpdateBothLists(
      MessageEntity newMessage) async {
    try {
      final updatedGeneralMessages =
          List<MessageEntity>.from(state.generalMessages);

      final existingGeneralMessageIndex = updatedGeneralMessages
          .indexWhere((msg) => msg.sender?.id == newMessage.sender?.id);

      final userIsSender =
          updatedGeneralMessages.indexWhere((msg) => msg.sender!.id == userId);

      if (userIsSender != -1) {
        updatedGeneralMessages.removeAt(userIsSender);
      }

      if (existingGeneralMessageIndex != -1) {
        updatedGeneralMessages.removeAt(existingGeneralMessageIndex);
      }
      updatedGeneralMessages.insert(0, newMessage);
      updatedGeneralMessages.sort((a, b) {
        final aTimestamp = a.timestamp ?? DateTime(0);
        final bTimestamp = b.timestamp ?? DateTime(0);
        return bTimestamp.compareTo(aTimestamp);
      });
      emit(
        GetMessageLoaded(
          generalMessages: updatedGeneralMessages,
        ),
      );
    } catch (e) {
      emit(GetMessageError(message: e.toString()));
    }
  }

  int _page = 1;
  bool hasReachedMax = false;

  Future<void> getMessages() async {
    if (kDebugMode) {
      print("get messagesss");
    }
    if (kDebugMode) {
      print(hasReachedMax);
    }
    if (hasReachedMax) return;

    if (state is! GetMessageLoading && state is! GetMessageLoaded) {
      emit(GetMessageLoading(state));
    }

    try {
      final savedId = _hiveService.getUserId();
      final result =
          await _messageUsecases.getMessages(userId1: savedId!, page: _page);

      result.fold(
        (error) => emit(GetMessageError(message: error.message)),
        (success) {
          _page++;
          _messageList.addAll(success.messages
                  ?.where((movie) => _messageList.contains(movie) == false) ??
              []);
          //_messageList.clear();
          //_messageList.addAll(messageList);

          if ((success.messages?.length ?? 0) < 10) {
            hasReachedMax = true;
          }
          if (kDebugMode) {
            print('mesages list ${success.messages?.length}');
          }
          emit(GetMessageLoaded(generalMessages: List.of(_messageList)));
        },
      );
    } catch (e) {
      emit(GetMessageError(message: 'An unexpected error occurred 2$e'));
    }
  }

  bool isTopLoading = false;

  Future<void> getNewMessages() async {
    if (isTopLoading) return;

    isTopLoading = true;
    try {
      final savedId = _hiveService.getUserId();
      if (savedId == null) {
        emit(const GetMessageError(message: 'User ID is null'));
        return;
      }
      final result =
          await _messageUsecases.getMessages(userId1: savedId, page: _page);
      result.fold(
        (error) => emit(GetMessageError(message: error.message)),
        (newMessages) {
          //_messageList.clear();

          final newSenderIds = newMessages.messages
              ?.where((msg) => msg.sender != null)
              .map((msg) => msg.sender!.id)
              .toSet();
          final newReceiverIds = newMessages.messages
              ?.where((msg) => msg.receiver != null)
              .map((msg) => msg.receiver!.id)
              .toSet();

          _messageList.removeWhere((msg) =>
              newSenderIds!.contains(msg.sender?.id) ||
              newReceiverIds!.contains(msg.receiver?.id));

          _messageList.insertAll(0, newMessages.messages ?? []);

          emit(GetMessageLoaded(
            generalMessages: List.from(_messageList),
          ));
        },
      );
    } catch (e) {
      emit(GetMessageError(message: 'An unexpected error occurred $e'));
    } finally {
      isTopLoading = false;
    }
  }

  // Method to handle adding a new message to conversation messages
  Future<void> addNewMessages(MessageEntity newMessage) async {
    try {
      // Handle general messages
      final updatedGeneralMessages =
          List<MessageEntity>.from(state.generalMessages);
      final existingGeneralMessageIndex = updatedGeneralMessages
          .indexWhere((msg) => msg.sender?.id == newMessage.sender?.id);
      if (existingGeneralMessageIndex != -1) {
        updatedGeneralMessages.removeAt(existingGeneralMessageIndex);
      }
      updatedGeneralMessages.insert(0, newMessage);

      emit(GetMessageLoaded(
        generalMessages: updatedGeneralMessages,
        onlineStatuses: state.onlineStatuses,
        status: state.status,
      ));
    } catch (e) {
      if (kDebugMode) {
        print("Error adding/updating messages: $e");
      }
      emit(GetMessageError(message: e.toString()));
    }
  }

  void addMessage(MessageEntity newMessage) async {
    if (newMessage.sender!.id == userId) {
      _messageList.removeWhere(
          (message) => message.receiver!.id == newMessage.receiver!.id);
    } else {
      _messageList.removeWhere(
          (message) => message.sender!.id == newMessage.sender!.id);
    }

    final existingMessageIndex =
        _messageList.indexWhere((msg) => msg.id == newMessage.id);
    if (existingMessageIndex != -1) {
      _messageList[existingMessageIndex] = newMessage;
    } else {
      _messageList.insert(0, newMessage);
    }

    emit(GetMessageLoaded(
      generalMessages: List.from(_messageList),
      onlineStatuses: state.onlineStatuses,
      status: state.status,
    ));
  }

  /* Future<void> getConversation(String userId1, String userId2) async {
    if (state is! GetConversationLoaded) {
      emit(GetConversationLoading(state));
    }

    if (hasReachedMax) return;
    final savedId = await _hiveService.getUserId();
    if (savedId == null) {
      emit(GetMessageError(message: 'User ID is null'));
      return;
    }
    try {
      final result = await _messageUsecases.getConversation(
          userId1: userId1, userId2: userId2, page: _page);

      result.fold(
        (error) => emit(GetMessageError(message: error.message)),
        (conversationList) {
          _page++;

          _messageList.addAll(conversationList.conversation
                  ?.where((movie) => _messageList.contains(movie) == false) ??
              []);

          if ((conversationList.conversation?.length ?? 0) < 10) {
            hasReachedMax = true;
          }

          for (var message in conversationList.conversation ?? []) {
            _socketService.messageOpened(message.id!);
          }
          /*for (var message in conversationList.conversation ?? []) {
            if (message.sender!.id == savedId) {
              print('Message ID: ${message.id}, isSender: ${message.isSender}');
            } else {
              _socketService.messageOpened(message.id!);

            }
          } */
          emit(GetConversationLoaded(
            conversationMessages: List.from(_messageList),
            generalMessages: state.generalMessages,
            onlineStatuses: state.onlineStatuses,
            status: state.status,
          ));
        },
      );
    } catch (e) {
      emit(GetMessageError(message: 'An unexpected error occurred $e'));
    }
  }
*/
  Future<void> sendMessage(String sender, String receiver, String? message,
      String? voiceMessageId) async {
    try {
      final result = await _messageUsecases.sendMessage(
          sender, receiver, message, voiceMessageId);

      result.fold(
        (error) => emit(GetMessageError(message: error.message)),
        (messageEntity) {
          if (messageEntity.sender!.id == userId) {
            _messageList.removeWhere((message) =>
                message.receiver!.id == messageEntity.receiver!.id);
          } else {
            _messageList.removeWhere(
                (message) => message.sender!.id == messageEntity.sender!.id);
          }

          _messageList.insert(0, messageEntity);

          emit(GetMessageLoaded(generalMessages: List.from(_messageList)));

          //_socketService.sendMessage(sender, receiver, message);
        },
      );
    } catch (e) {
      emit(GetMessageError(message: 'send an unexpected error occurred $e'));
    }
  }

  void updateMessageStatus(String messageId, int newStatus) {
    final updatedGeneralMessages = state.generalMessages.map((message) {
      if (message.sender!.id == messageId) {
        if (kDebugMode) {
          print(
              'Updating message in generalMessages with ID: $messageId to status: $newStatus');
        }
        return message.copyWith(status: newStatus);
      }
      return message;
    }).toList();

    emit(GetMessageLoaded(
      generalMessages: updatedGeneralMessages,
      onlineStatuses: state.onlineStatuses,
      status: newStatus,
    ));

    if (kDebugMode) {
      print("Emitting new state with updated messages in both lists");
    }
  }

  void _handleUserOnlineStatusUpdate(dynamic data) {
    if (data is Map<String, dynamic>) {
      final userId = data['userId'] as String;
      final isOnline = data['online'] as bool;

      if (kDebugMode) {
        print('User online status updated: $userId, isOnline: $isOnline');
      }

      if (state is GetMessageLoaded) {
        if (kDebugMode) {
          print('Current state is GetMessageLoaded');
        }
        final currentState = state as GetMessageLoaded;
        final updatedOnlineStatuses =
            Map<String, bool>.from(currentState.onlineStatuses);
        updatedOnlineStatuses[userId] = isOnline;

        if (kDebugMode) {
          print('Updated online statuses: $updatedOnlineStatuses');
        }

        final updatedMessages = List<MessageEntity>.from(_messageList);

        for (var message in updatedMessages) {
          if (message.sender == userId || message.receiver == userId) {
            final updatedMessage = MessageEntity(
              id: message.id,
              sender: message.sender,
              receiver: message.receiver,
              online: isOnline,
            );

            final index = updatedMessages.indexWhere(
                (msg) => msg.sender == userId && msg.id == message.id);

            if (index != -1) {
              updatedMessages[index] = updatedMessage;
            }
          }
        }

        emit(GetMessageLoaded(
          conversationMessages: state.conversationMessages,
          generalMessages: updatedMessages,
          onlineStatuses: updatedOnlineStatuses,
        ));
      } else {
        emit(GetMessageLoaded(
          conversationMessages: state.conversationMessages,
          generalMessages: List.from(_messageList),
          onlineStatuses: {userId: isOnline},
        ));
      }
    }
  }
}
