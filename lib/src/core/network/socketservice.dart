import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../data/models/export_models.dart';
import '../../presentation/cubit/message/conversations/conversations_bloc.dart';
import '../../presentation/cubit/message/get_message/get_message_cubit.dart';
import '../constants/app_constants.dart';

class SocketService {
  late IO.Socket socket;
  Function(dynamic)? onNewMessage;
  Function(dynamic)? onNewMessageConversation;
  Function(dynamic)? onUserOnlineStatusUpdate;
  final Map<String, bool> _onlineStatus = {};
  Function(dynamic)? statusUpdate;
  final Map<String, int> _status = {};
  void connect(String userId, BuildContext context) {
    socket = IO.io(AppConstants.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      print('Socket connected');
      socket.emit('joinRoom', userId);
    });
    socket.on('userOnline', (data) {
      final userId = data['userId'] as String;
      final isOnline = data['online'] as bool;
      _onlineStatus[userId] = isOnline;
      print('User online status updated: $userId, isOnline: $isOnline');
      if (onUserOnlineStatusUpdate != null) {
        onUserOnlineStatusUpdate!(data as Map<String, dynamic>);
      }
    });
    socket.on('messageStatusesUpdated', (data) {
      print('Received messageStatusesUpdated event: $data');

      // Parse the messageId and status from the data
      final messageId = data['id'] as String;
      final status = data['status'] ?? 0; // Ensure status is an int

      print('Received messageStatusesUpdated event 1: $status $messageId');

      // Notify cubit/bloc of the status update
      final getMessageCubit = context.read<GetMessageCubit>();
      getMessageCubit.updateMessageStatus(messageId, status);
    });

    socket.on('disconnect', (_) {
      print('Socket disconnected');
    });

    /* socket.on('userMessages', (data) {
      print('Received userMessages event on socket: $data');
      try {
        if (data is List) {
         // final messages = data.map((message) => MessageModel.fromJson(message).toEntity()).toList();
        } else {
          print('Unexpected data type received: $data');
        }
      } catch (e) {
        print('Error processing userMessages event: $e');
      }
    }); */

    socket.on('newMessage', (data) async {
      print('Received newMessage event: $data');

      final newMessage = MessageModel.fromJson(data).toEntity();

      // Update the messages in the Cubit
      final getMessageCubit = context.read<GetMessageCubit>();
      await getMessageCubit.addNewMessagesAndUpdateBothLists(newMessage);

      // Compare with the current conversation in the Bloc
      final conversationsBloc = context.read<ConversationsBloc>();
      if (conversationsBloc.isCurrentConversation(
          newMessage.sender?.id ?? '', newMessage.receiver?.id ?? '')) {
        // Add the new message to the conversation if it's part of the current conversation
        conversationsBloc.add(AddNewMessageEvent(newMessage));
      }

      print(
          "Verifying IDs in socket: senderId: ${newMessage.sender?.id ?? ''}");
    });

    socket.on('messageAcknowledgment', (data) {
      print('Received messageAcknowledgment event: $data');
      if (data['status'] == 'success') {
        print('Message successfully acknowledged');
      } else {
        print('Error acknowledging message: ${data['error']}');
      }
    });
  }

  void sendMessage(String sender, String receiver, String message) {
    socket.emit('receiveMessage',
        {'sender': sender, 'receiver': receiver, 'message': message});
  }

  void messageOpened(String messageId) {
    final cleanedMessageId = messageId.trim();
    print('messageOpened event : $cleanedMessageId');
    socket.emit('messageOpened', cleanedMessageId);
  }

  bool isUserOnline(String userId, BuildContext context) {
    final status = _onlineStatus[userId];

    print('Checking online status for 555555555 $userId: $status');
    return status ?? false;
  }

  void dispose() {
    socket.dispose();
  }
}
