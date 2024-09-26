import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/export_entities.dart';
import '../../datasources/_mappers/entity_convertable.dart';
import '../export_models.dart';

part 'message_pagination_model.g.dart';

@JsonSerializable()
class MessagePaginationModel extends Equatable with EntityConvertible<MessagePaginationModel, MessagePaginationEntity> {
  @JsonKey(name: 'totalMessages')
  final int? totalMessages;
  @JsonKey(name: 'messages')
  final List<MessageModel>? messages;
  @JsonKey(name: 'page')
  final int? page;



  const MessagePaginationModel({
    this.totalMessages,
    this.messages,
    this.page,

  });

  factory MessagePaginationModel.fromJson(Map<String, dynamic> json) {
    return _$MessagePaginationModelFromJson(json);
  }

  @override
  MessagePaginationEntity toEntity() => MessagePaginationEntity(
    page: page,
    messages: messages?.map((e) => e.toEntity()).toList(),
    totalMessages: totalMessages,
  );
  Map<String, dynamic> toJson() => _$MessagePaginationModelToJson(this);

  @override
  List<Object?> get props => [page, messages, page];
}