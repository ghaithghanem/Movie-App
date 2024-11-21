// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['_id'] as String?,
      sender: json['sender'],
      receiver: json['receiver'],
      message: json['message'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      isSender: json['isSender'] as bool,
      status: (json['status'] as num?)?.toInt() ?? 0,
      online: json['online'] as bool,
      voiceMessageId: json['voiceMessageId'] as String?,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'message': instance.message,
      'timestamp': instance.timestamp?.toIso8601String(),
      'isSender': instance.isSender,
      'status': instance.status,
      'online': instance.online,
      'voiceMessageId': instance.voiceMessageId,
    };
