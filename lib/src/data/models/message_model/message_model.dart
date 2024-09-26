import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/src/data/datasources/_mappers/entity_convertable.dart';
import 'package:movie_app/src/data/models/message_model/receiver_model.dart';
import 'package:movie_app/src/data/models/message_model/sender_model.dart';
import 'package:movie_app/src/domain/entities/export_entities.dart';

import '../../../domain/entities/message_entities/receiver_entity.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel extends Equatable
    with EntityConvertible<MessageModel, MessageEntity> {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'sender')
  final dynamic sender;

  @JsonKey(name: 'receiver')
  final dynamic receiver;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'timestamp')
  final DateTime? timestamp;

  @JsonKey(name: 'isSender')
  final bool isSender;

  @JsonKey(name: 'status')
  final int status;

  @JsonKey(name: 'online')
  final bool online;

  @JsonKey(name: 'voiceMessageId')
  final String? voiceMessageId; // Add the voiceMessageId field

  const MessageModel({
    this.id,
    this.sender,
    this.receiver,
    this.message,
    this.timestamp,
    required this.isSender,
    this.status = 0,
    required this.online,
    this.voiceMessageId, // Initialize the voiceMessageId
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final senderJson = json['sender'];
    final receiverJson = json['receiver'];

    return MessageModel(
      id: json['_id'] as String?,
      sender: senderJson is Map<String, dynamic>
          ? SenderModel.fromJson(senderJson as Map<String, dynamic>)
          : senderJson
              as String?, // If senderJson is not a Map, treat it as a String (ID)
      receiver: receiverJson is Map<String, dynamic>
          ? ReceiverModel.fromJson(receiverJson as Map<String, dynamic>)
          : receiverJson
              as String?, // If receiverJson is not a Map, treat it as a String (ID)
      message: json['message'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      isSender: json['isSender'] as bool? ?? false,
      status: json['status'] as int? ?? 0,
      online: json['online'] as bool? ?? false,
      voiceMessageId:
          json['voiceMessageId'] as String?, // Deserialize voiceMessageId
    );
  }

  Map<String, dynamic> toJson() {
    final senderJson = sender is SenderModel
        ? (sender as SenderModel).toJson()
        : sender; // Convert SenderModel to JSON or use the ID directly

    final receiverJson = receiver is ReceiverModel
        ? (receiver as ReceiverModel).toJson()
        : receiver; // Convert ReceiverModel to JSON or use the ID directly

    return <String, dynamic>{
      '_id': id,
      'sender': senderJson,
      'receiver': receiverJson,
      'message': message,
      'timestamp': timestamp?.toIso8601String(),
      'isSender': isSender,
      'status': status,
      'online': online,
      'voiceMessageId': voiceMessageId, // Serialize voiceMessageId
    };
  }

  @override
  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      sender: sender is SenderModel
          ? (sender as SenderModel)
              .toEntity() // Convert SenderModel to SenderEntity
          : SenderEntity(
              id: sender as String?), // Handle case where sender is an ID
      receiver: receiver is ReceiverModel
          ? (receiver as ReceiverModel)
              .toEntity() // Convert ReceiverModel to ReceiverEntity
          : ReceiverEntity(
              id: receiver as String?), // Handle case where receiver is an ID
      message: message,
      timestamp: timestamp,
      isSender: isSender,
      status: status,
      online: online,
      voiceMessageId:
          voiceMessageId, // Add voiceMessageId to the entity conversion
    );
  }

  @override
  List<Object?> get props => [
        id,
        sender,
        receiver,
        message,
        timestamp,
        isSender,
        status,
        online,
        voiceMessageId
      ];
}
