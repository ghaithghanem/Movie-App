// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receiver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiverModel _$ReceiverModelFromJson(Map<String, dynamic> json) =>
    ReceiverModel(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
    );

Map<String, dynamic> _$ReceiverModelToJson(ReceiverModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePhoto': instance.profilePhoto,
    };
