import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/export_entities.dart';
import '../../../domain/entities/message_entities/conversation_pagination_entity.dart';
import '../../datasources/_mappers/entity_convertable.dart';
import '../export_models.dart';

part 'conversation_pagination_model.g.dart';

@JsonSerializable()
class ConversationPaginationModel extends Equatable with EntityConvertible<ConversationPaginationModel, ConversationPaginationEntity> {
  @JsonKey(name: 'page')
  final int? page;

  @JsonKey(name: 'totalResults')
  final int? totalResults;

  @JsonKey(name: 'totalPages')
  final int? totalPages;

  @JsonKey(name: 'conversation')
  final List<MessageModel>? conversation;

  ConversationPaginationModel({
    this.page,
    this.totalResults,
    this.totalPages,
    this.conversation,
  });

  factory ConversationPaginationModel.fromJson(Map<String, dynamic> json) {
    return _$ConversationPaginationModelFromJson(json);
  }

  @override
  ConversationPaginationEntity toEntity() => ConversationPaginationEntity(
    page: page,
    totalResults: totalResults,
    totalPages: totalPages,
    conversation: conversation?.map((e) => e.toEntity()).toList(),
  );

  Map<String, dynamic> toJson() => _$ConversationPaginationModelToJson(this);

  @override
  List<Object?> get props => [page, totalResults, totalPages, conversation];
}
