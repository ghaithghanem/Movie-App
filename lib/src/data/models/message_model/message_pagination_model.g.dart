// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagePaginationModel _$MessagePaginationModelFromJson(
        Map<String, dynamic> json) =>
    MessagePaginationModel(
      totalMessages: (json['totalMessages'] as num?)?.toInt(),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MessagePaginationModelToJson(
        MessagePaginationModel instance) =>
    <String, dynamic>{
      'totalMessages': instance.totalMessages,
      'messages': instance.messages,
      'page': instance.page,
    };
