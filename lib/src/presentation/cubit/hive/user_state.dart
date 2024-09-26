part of 'user_cubit.dart';



abstract class UserIdState extends Equatable {
  const UserIdState();

  @override
  List<Object> get props => [];
}

class UserIdInitial extends UserIdState {}

class UserIdLoaded extends UserIdState {
  final String? userId;

  const UserIdLoaded({required this.userId});

  @override
  List<Object> get props => [userId ?? ''];
}

class UserIdError extends UserIdState {
  final String message;

  const UserIdError({required this.message});

  @override
  List<Object> get props => [message];
}
