import 'package:equatable/equatable.dart';
import 'package:movie_app/src/domain/entities/message_entities/receiver_entity.dart';
import 'package:movie_app/src/domain/entities/message_entities/sender_entity.dart';

class MessageEntity extends Equatable {
  final String? id;
  final SenderEntity? sender;
  final ReceiverEntity? receiver;
  final String? message;
  final DateTime? timestamp;
  final bool? isSender;
  final int? status;
  final bool? online;
  final String? voiceMessageId;

  MessageEntity({
    this.id,
    this.sender,
    this.receiver,
    this.message,
    this.timestamp,
    this.isSender,
    this.status,
    this.online,
    this.voiceMessageId,
  });

  MessageEntity copyWith({
    String? id,
    SenderEntity? sender,
    ReceiverEntity? receiver,
    String? message,
    DateTime? timestamp,
    bool? isSender,
    int? status,
    bool? online,
    String? voiceMessageId,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isSender: isSender ?? this.isSender,
      status: status ?? this.status,
      online: online ?? this.online,
      voiceMessageId: voiceMessageId ?? this.voiceMessageId,
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
