import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/database/hive.dart';
import '../../../../core/network/socketservice.dart';
import '../../../../domain/entities/export_entities.dart';
import '../../../../domain/usecases/export_usecases.dart';

part 'conversations_event.dart';
part 'conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final List<MessageEntity> _messageList = [];
  final SocketService _socketService;
  final MessageUsecases _messageUsecases;
  final String? userId;
  final HiveService _hiveService;
  int _page = 0;
  bool hasReachedMax = false;
  ConversationsBloc(this._messageUsecases, this.userId, this._hiveService,
      this._socketService)
      : super(ConversationsInitial()) {
    on<LoadConversationEvent>(_loadInitialConversation);
    on<LoadNextPageEvent>(_loadNextPage);
    on<SendMessageEvent>(_onSendMessage);
    on<AddNewMessageEvent>(_onAddNewMessage);

    on<ConversationsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
  void _preserveScrollPosition(ScrollController scrollController) {
    final position = scrollController.position.pixels;
    // Save the current scroll position
    scrollController.jumpTo(position);
  }

  void resetPagination() {
    _messageList.clear();
    _page = 1;
    hasReachedMax = false;
  }

  Future<void> _loadInitialConversation(
      LoadConversationEvent event, Emitter<ConversationsState> emit) async {
    resetPagination();
    emit(GetConversationsLoading());

    final savedId = await _hiveService.getUserId();
    if (savedId == null) {
      emit(MessageError(message: 'User ID is null'));
      return;
    }

    try {
      final result = await _messageUsecases.getConversation(
          userId1: event.userId1, userId2: event.userId2, page: _page);

      result.fold(
        (error) => emit(MessageError(message: error.message)),
        (conversationList) {
          // Increment the page number for pagination
          _page++;

          // Add the first page of messages
          _messageList.addAll(conversationList.conversation ?? []);

          // If less than a full page is fetched, we've reached the end
          if ((conversationList.conversation?.length ?? 0) < 10) {
            hasReachedMax = true;
          }

          emit(GetConversationsLoaded(
            conversationMessages: List.from(_messageList),
          ));
        },
      );
    } catch (e) {
      emit(MessageError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _loadNextPage(
      LoadNextPageEvent event, Emitter<ConversationsState> emit) async {
    if (hasReachedMax) return;

    emit(GetConversationsLoading());

    try {
      final result = await _messageUsecases.getConversation(
          userId1: event.userId1, userId2: event.userId2, page: _page);

      result.fold(
        (error) => emit(MessageError(message: error.message)),
        (conversationList) {
          // Increment the page number for pagination
          _page++;

          // Add the next page of messages
          _messageList.addAll(conversationList.conversation ?? []);

          // If less than a full page is fetched, we've reached the end
          if ((conversationList.conversation?.length ?? 0) < 10) {
            hasReachedMax = true;
          }

          emit(GetConversationsLoaded(
            conversationMessages: List.from(_messageList),
          ));
        },
      );
    } catch (e) {
      emit(MessageError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onLoadConversation(
      LoadConversationEvent event, Emitter<ConversationsState> emit) async {
    _messageList.clear();
    hasReachedMax = false;
    emit(GetConversationsLoading());

    final savedId = await _hiveService.getUserId();
    if (savedId == null) {
      emit(MessageError(message: 'User ID is null'));
      return;
    }

    try {
      // Fetch the first page of the conversation
      final result = await _messageUsecases.getConversation(
          userId1: event.userId1, userId2: event.userId2, page: _page);

      result.fold(
        (error) => emit(MessageError(message: error.message)),
        (conversationList) {
          // Increment the page number for future fetches (pagination)
          _page++;

          // Add new messages to the list (but avoid duplicates)
          _messageList.addAll(conversationList.conversation
                  ?.where((message) => !_messageList.contains(message)) ??
              []);

          // If we get less than a full page of messages, mark that we've reached the end
          if ((conversationList.conversation?.length ?? 0) < 10) {
            hasReachedMax = true;
          }

          // Emit messageOpened event for the appropriate messages
          for (var message in conversationList.conversation ?? []) {
            if (message.sender!.id == savedId) {
              print('Message ID: ${message.id}, isSender: ${message.isSender}');
            } else {
              _socketService.messageOpened(message.id!);
            }
          }

          // Emit the loaded state with the updated list of messages
          emit(GetConversationsLoaded(
            conversationMessages: List.from(_messageList),
          ));
        },
      );
    } catch (e) {
      emit(MessageError(message: 'An unexpected error occurred $e'));
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

  Future<void> _onAddNewMessage(
    AddNewMessageEvent event,
    Emitter<ConversationsState> emit,
  ) async {
    try {
      _messageList.insert(0, event.newMessage);
      emit(GetConversationsLoaded(
        conversationMessages: List<MessageEntity>.from(_messageList),
      ));
    } catch (e) {
      print("Error adding/updating messages: $e");
      emit(MessageError(message: e.toString()));
    }
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
