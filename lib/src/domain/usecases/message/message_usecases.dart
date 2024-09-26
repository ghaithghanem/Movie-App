import 'package:fpdart/fpdart.dart';
import 'package:movie_app/src/core/exceptions/network/network_exception.dart';
import 'package:movie_app/src/domain/repositories/export_repositories.dart';

import '../../entities/export_entities.dart';

class MessageUsecases {
  final MessageRepository _messageRepository;

  MessageUsecases(this._messageRepository);

  Future<Either<NetworkException, MessagePaginationEntity>> getMessages(
      {required String userId1, required int page}) async {
    return _messageRepository.getMessages(userId1: userId1, page: page);
  }

  Future<Either<NetworkException, ConversationPaginationEntity>>
      getConversation(
          {required String userId1,
          required String userId2,
          required int page}) async {
    return _messageRepository.getConversation(
        userId1: userId1, userId2: userId2, page: page);
  }

  Future<Either<NetworkException, MessageEntity>> sendMessage(String sender,
      String receiver, String? message, String? voiceMessageId) async {
    return _messageRepository.sendMessage(
        sender, receiver, message, voiceMessageId);
  }
}
