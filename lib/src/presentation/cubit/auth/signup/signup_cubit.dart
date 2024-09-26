import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/auth_entities/user_entity.dart';
import '../../../../domain/usecases/auth/auth_usecases.dart';
import 'package:equatable/equatable.dart';
part 'signup_state.dart';
class SignupCubit extends Cubit<SignupState> {
  final AuthUsecases _signupUseCase;

  SignupCubit(this._signupUseCase) : super(SignupInitial());

  Future<void> signup( String firstName,
      String lastName,
      String username,
      String email,
      String password,
      DateTime dateOfBirth,
      String? profilePhotoPath) async {
    emit(SignupLoading());

    final result = await _signupUseCase.signup( firstName,
        lastName,
        username,
        email,
        password,
        dateOfBirth,
        profilePhotoPath);

    result.fold(
          (error) => emit(SignupError(message: error.message)),
          (user) => emit(SignupSuccess(user: user)),
    );
  }
}