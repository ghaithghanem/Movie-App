import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final String? password;
  final DateTime? dateOfBirth;
  final String? profilePhoto;
  final String? token;

  const UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.password,
    this.dateOfBirth,
    this.profilePhoto,
    this.token
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    username,
    email,
    password,
    dateOfBirth,
    profilePhoto,
    token
  ];
}
