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
      try {
        print('Received messageStatusUpdate event: $data');

        if (data is Map<String, dynamic>) {
          final messageId = data['id'] as String?;
          final status = data['status'] as int?;

          if (messageId != null && status != null) {
            print('Message status updated: $messageId, status: $status');
            _status[messageId] = status;
            if (statusUpdate != null) {
              statusUpdate!(data);
            }
          } else {
            print(
                'Data is missing required fields. MessageId: $messageId, Status: $status');
          }
        } else {
          print(
              'Expected data to be a map with id and status. Received: $data');
        }
      } catch (e) {
        print('Error handling messageStatusesUpdated event: $e');
      }
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
      final getMessageCubit = context.read<GetMessageCubit>();
      final newMessage = MessageModel.fromJson(data).toEntity();
      context.read<ConversationsBloc>().add(AddNewMessageEvent(newMessage));
      await getMessageCubit.addNewMessagesAndUpdateBothLists(newMessage);
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
