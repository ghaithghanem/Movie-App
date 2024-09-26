import 'package:fpdart/fpdart.dart';
import 'package:movie_app/src/core/exceptions/network/network_exception.dart';
import 'package:movie_app/src/domain/entities/export_entities.dart';

abstract class MessageRepository {
  Future<Either<NetworkException, MessagePaginationEntity>> getMessages(
      {required String userId1, required int page});
  Future<Either<NetworkException, ConversationPaginationEntity>>
      getConversation(
          {required String userId1,
          required String userId2,
          required int page});
  Future<Either<NetworkException, MessageEntity>> sendMessage(
      String sender, String receiver, String? message, String? voiceMessageId);
}
