import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/auth_entities/user_entity.dart';
import '../../datasources/_mappers/entity_convertable.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable with EntityConvertible<UserModel, UserEntity> {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'firstName')
  final String? firstName;

  @JsonKey(name: 'lastName')
  final String? lastName;

  @JsonKey(name: 'username')
  final String? username;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'password')
  final String? password;

  @JsonKey(name: 'dateOfBirth')
  final DateTime? dateOfBirth;

  @JsonKey(name: 'profilePhoto')
  final String? profilePhoto;

  @JsonKey(name: 'token')
  final String? token;

  @JsonKey(name: 'refreshToken')
  final String? refreshToken;

  const UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.password,
    this.dateOfBirth,
    this.profilePhoto,
    this.token,
    this.refreshToken
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  @override
  UserEntity toEntity() => UserEntity(
    firstName: firstName,
    lastName: lastName,
    username: username,
    email: email,
    password: password,
    dateOfBirth: dateOfBirth,
    profilePhoto: profilePhoto,
  );

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [firstName, lastName, username, email, password, dateOfBirth, profilePhoto];
}
