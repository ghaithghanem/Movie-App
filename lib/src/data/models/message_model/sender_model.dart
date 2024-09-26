


import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/export_entities.dart';
import '../../datasources/_mappers/entity_convertable.dart';
import 'package:equatable/equatable.dart';
part 'sender_model.g.dart';

@JsonSerializable()
class SenderModel extends Equatable with EntityConvertible<SenderModel, SenderEntity> {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'firstName')
  final String? firstName;

  @JsonKey(name: 'lastName')
  final String? lastName;

  @JsonKey(name: 'profilePhoto')
  final String? profilePhoto;

  const SenderModel({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePhoto,
  });

  factory SenderModel.fromJson(Map<String, dynamic> json) => _$SenderModelFromJson(json);

  Map<String, dynamic> toJson() => _$SenderModelToJson(this);

  @override
  SenderEntity toEntity() => SenderEntity(
    id: id,
    firstName: firstName,
    lastName: lastName,
    profilePhoto: profilePhoto,
  );

  @override
  List<Object?> get props => [id, firstName, lastName, profilePhoto];
}