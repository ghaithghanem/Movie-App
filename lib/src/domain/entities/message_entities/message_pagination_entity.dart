import 'package:equatable/equatable.dart';

import '../../../data/models/export_models.dart';
import '../export_entities.dart';


class MessagePaginationEntity extends Equatable{
  final int? totalMessages;
  final List<MessageEntity>? messages;
  final int? page;

  MessagePaginationEntity({
    this.totalMessages,
    this.messages,
    this.page
  });
  @override
  List<Object?> get props => [totalMessages, messages, page];
}