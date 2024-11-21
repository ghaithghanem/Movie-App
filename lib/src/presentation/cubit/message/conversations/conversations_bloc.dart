import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/database/hive.dart';
import '../../../../core/network/socketservice.dart';
import '../../../../domain/entities/export_entities.dart';
import '../../../../domain/usecases/export_usecases.dart';

part 'conversations_event.dart';
part 'conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  List<MessageEntity> _messageList = [];
  final SocketService _socketService;
  final MessageUsecases _messageUsecases;
  final String? userId;

  String? currentSenderId;
  String? currentReceiverId;
  final HiveService _hiveService;
  int _page = 0;
  bool hasReachedMax = false;
  double _previousScrollPosition = 0.0;
  bool _isActiveConversation = false;
  ConversationsBloc(this._messageUsecases, this.userId, this._hiveService,
      this._socketService)
      : super(ConversationsInitial()) {
    on<LoadConversationEvent>(_loadInitialConversation);
    on<LoadNextPageEvent>(_loadNextPage);
    on<SendMessageEvent>(_onSendMessage);
    on<AddNewMessageEvent>(_onAddNewMessage);
    on<ResetConversationEvent>(_resetConversation);
    on<ActivateConversationEvent>(_onActivateConversation);
    on<DeactivateConversationEvent>(_onDeactivateConversation);
    // Listen for socket message status updates
    _socketService.statusUpdate = (data) {
      add(MessageStatusUpdatedEvent(data['messageId'], data['status']));
    };

    on<MessageStatusUpdatedEvent>(_onMessageStatusUpdated);
    on<ConversationsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
  void _preserveScrollPosition(ScrollController scrollController) {
    final position = scrollController.position.pixels;
    // Save the current scroll position
    scrollController.jumpTo(position);
  }

  void _resetConversation(
      ResetConversationEvent event, Emitter<ConversationsState> emit) {
    _messageList.clear();
    _page = 1;
    hasReachedMax = false;
    emit(ConversationsInitial());
  }

  void resetPagination() {
    _messageList.clear();
    _page = 1;
    hasReachedMax = false;
  }

  void _saveScrollPosition(ScrollController controller) {
    _previousScrollPosition = controller.position.pixels;
  }

  final double _estimatedItemHeight =
      70.0; // Adjust based on the actual item height in your UI

  void _restoreScrollPosition(ScrollController controller, int newItemsCount) {
    // Calculate the offset by multiplying the height of each item by the count of newly loaded items
    final offset = newItemsCount * _estimatedItemHeight;
    controller.jumpTo(_previousScrollPosition + offset);
  }

  Future<void> _loadInitialConversation(
      LoadConversationEvent event, Emitter<ConversationsState> emit) async {
    if (hasReachedMax) return;

    if (state is! GetConversationsLoading && state is! GetConversationsLoaded) {
      emit(GetConversationsLoading(state));
    }

    final savedId = _hiveService.getUserId();
    if (savedId == null) {
      emit(const MessageError(message: 'User ID is null'));
      return;
    }

    try {
      final result = await _messageUsecases.getConversation(
          userId1: event.userId1, userId2: event.userId2, page: _page);

      result.fold(
        (error) => emit(MessageError(message: error.message)),
        (conversationList) {
          _page++;
          _messageList = List.from(_messageList)
            ..addAll(conversationList.conversation ?? []);
          if ((conversationList.conversation?.length ?? 0) < 10) {
            hasReachedMax = true;
          }

          // Only mark messages as read if conversation is active
          if (_isActiveConversation) {
            _markUnreadMessagesAsRead(conversationList.conversation ?? []);
          }

          emit(GetConversationsLoaded(conversationMessages: _messageList));
        },
      );
    } catch (e) {
      emit(MessageError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _loadNextPage(
    LoadNextPageEvent event,
    Emitter<ConversationsState> emit,
  ) async {
    // Return if reached the max number of messages or no scroll controller is attached
    if (hasReachedMax || !event.scrollController.hasClients) return;

    // Save the current scroll position before loading more
    _saveScrollPosition(event.scrollController);

    // Emit loading state for more messages (while retaining previous messages)
    if (state is GetConversationsLoaded) {
      emit(LoadingMoreMessages(
        conversationMessages:
            (state as GetConversationsLoaded).conversationMessages,
      ));
    } else {
      emit(LoadingMoreMessages(
        conversationMessages: _messageList,
      ));
    }

    try {
      // Fetch the next page of conversations
      final result = await _messageUsecases.getConversation(
        userId1: event.userId1,
        userId2: event.userId2,
        page: _page, // Incremented page number for pagination
      );

      result.fold(
        (error) => emit(MessageError(message: error.message)),
        (conversationList) {
          final newMessagesCount = conversationList.conversation?.length ?? 0;

          // Increment page for the next load
          _page++;

          // Check if we've reached the max number of messages
          if (newMessagesCount < 10) {
            hasReachedMax = true;
          }

          // Append the new messages to the existing list
          if (state is GetConversationsLoaded) {
            final currentMessages =
                (state as GetConversationsLoaded).conversationMessages;

            // Use the copyWithNewMessages method to add new messages without overriding the state
            emit((state as GetConversationsLoaded).copyWithNewMessages(
              conversationList.conversation ?? [],
            ));
          } else {
            _messageList.addAll(conversationList.conversation ?? []);
            emit(GetConversationsLoaded(conversationMessages: _messageList));
          }

          // Restore the scroll position after loading new messages
          if (event.scrollController.hasClients) {
            _restoreScrollPosition(event.scrollController, newMessagesCount);
          }
        },
      );
    } catch (e) {
      emit(MessageError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ConversationsState> emit) async {
    try {
      final result = await _messageUsecases.sendMessage(event.senderId,
          event.receiverId, event.message, event.voiceMessageId);

      result.fold(
        (error) => emit(MessageError(message: error.message)),
        (messageEntity) {
          emit(GetConversationsLoaded(
              conversationMessages: List.from(_messageList)));
        },
      );
    } catch (e) {
      emit(MessageError(message: 'send an unexpected error occurred $e'));
    }
  }

  void _onActivateConversation(
      ActivateConversationEvent event, Emitter<ConversationsState> emit) {
    _isActiveConversation = true;
    // Mark existing unread messages as read
    if (state is GetConversationsLoaded) {
      final messages = (state as GetConversationsLoaded).conversationMessages;
      _markUnreadMessagesAsRead(messages);
    }
  }

  void _onDeactivateConversation(
      DeactivateConversationEvent event, Emitter<ConversationsState> emit) {
    _isActiveConversation = false;
  }

  void _markUnreadMessagesAsRead(List<MessageEntity> messages) {
    if (!_isActiveConversation) return; // Exit if conversation is not active

    for (var message in messages) {
      if (message.receiver?.id == userId &&
          message.status != 'read' &&
          isCurrentConversation(
              message.sender?.id ?? '', message.receiver?.id ?? '')) {
        _socketService.messageOpened(message.id!);
      }
    }
  }

  Future<void> _onAddNewMessage(
    AddNewMessageEvent event,
    Emitter<ConversationsState> emit,
  ) async {
    try {
      final newMessage = event.newMessage;

      // Check if the message belongs to the current conversation
      if (isCurrentConversation(
          newMessage.sender?.id ?? '', newMessage.receiver?.id ?? '')) {
        // Emit `messageOpened` for the new message only if the conversation is active
        if (_isActiveConversation && newMessage.receiver?.id == userId) {
          _socketService.messageOpened(newMessage.id!);
          print('New message status updated for message ID: ${newMessage.id}');
        }
      }

      // Add the new message to the top of the list
      final updatedMessages = List<MessageEntity>.from(_messageList)
        ..insert(0, newMessage);

      _messageList = updatedMessages;

      // Emit updated state
      emit(GetConversationsLoaded(
        conversationMessages: List.from(updatedMessages),
      ));
    } catch (e) {
      print("Error adding/updating messages: $e");
      emit(MessageError(message: e.toString()));
    }
  }

  void setCurrentConversation(String senderId, String receiverId) {
    currentSenderId = senderId;
    if (kDebugMode) {
      print("compere idsss 1 ${senderId == currentReceiverId}");
    }
    currentReceiverId = receiverId;
  }

  bool isCurrentConversation(String senderId, String receiverId) {
    if (kDebugMode) {
      print("compere idsss gh ${senderId == currentReceiverId}");
    }
    if (kDebugMode) {
      print("id verif $currentSenderId $currentReceiverId");
    }
    return (senderId == currentSenderId && receiverId == currentReceiverId) ||
        (senderId == currentReceiverId && receiverId == currentSenderId);
  }

  void _onMessageStatusUpdated(
      MessageStatusUpdatedEvent event, Emitter<ConversationsState> emit) {
    final updatedMessages = _messageList.map((message) {
      if (message.id == event.messageId) {
        return message.copyWith(status: event.newStatus);
      }
      return message;
    }).toList();

    _messageList.clear();
    _messageList.addAll(updatedMessages);

    emit(GetConversationsLoaded(conversationMessages: List.from(_messageList)));
  }
}

/*
Future<void> getConversation(String userId1, String userId2) async {
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
