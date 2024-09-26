// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationPaginationModel _$ConversationPaginationModelFromJson(
        Map<String, dynamic> json) =>
    ConversationPaginationModel(
      page: (json['page'] as num?)?.toInt(),
      totalResults: (json['totalResults'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      conversation: (json['conversation'] as List<dynamic>?)
          ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConversationPaginationModelToJson(
        ConversationPaginationModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'totalResults': instance.totalResults,
      'totalPages': instance.totalPages,
      'conversation': instance.conversation,
    };
