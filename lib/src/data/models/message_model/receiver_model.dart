import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/export_entities.dart';
import '../../../domain/entities/message_entities/receiver_entity.dart';
import '../../datasources/_mappers/entity_convertable.dart';
import 'package:equatable/equatable.dart';

part 'receiver_model.g.dart';
@JsonSerializable()
class ReceiverModel extends Equatable with EntityConvertible<ReceiverModel, ReceiverEntity> {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'firstName')
  final String? firstName;

  @JsonKey(name: 'lastName')
  final String? lastName;

  @JsonKey(name: 'profilePhoto')
  final String? profilePhoto;

  const ReceiverModel({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePhoto,
  });

  factory ReceiverModel.fromJson(Map<String, dynamic> json) => _$ReceiverModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiverModelToJson(this);

  @override
  ReceiverEntity toEntity() => ReceiverEntity(
    id: id,
    firstName: firstName,
    lastName: lastName,
    profilePhoto: profilePhoto,
  );

  @override
  List<Object?> get props => [id, firstName, lastName, profilePhoto];
}
