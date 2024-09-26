import 'package:equatable/equatable.dart';

class SenderEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? profilePhoto;

  const SenderEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePhoto,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, profilePhoto];
}