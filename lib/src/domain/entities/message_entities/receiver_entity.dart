import 'package:equatable/equatable.dart';

class ReceiverEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? profilePhoto;

  ReceiverEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePhoto,
  });
  @override
  List<Object?> get props => [id, firstName, lastName, profilePhoto];
}
