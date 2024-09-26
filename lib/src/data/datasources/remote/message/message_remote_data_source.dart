import 'package:movie_app/src/data/models/message_model/conversation_pagination_model.dart';

import '../../../models/export_models.dart';

abstract class MessageRemoteDataSource {
  Future<MessagePaginationModel> getMessage(
      {required String userId1, required int page});
  Future<ConversationPaginationModel> getConversation(
      {required String userId1, required String userId2, required int page});
  Future<MessageModel> sendMessage(
      String sender, String receiver, String? message, String? voiceMessageId);
}
