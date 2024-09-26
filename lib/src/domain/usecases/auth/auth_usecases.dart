import 'package:fpdart/fpdart.dart';

import '../../../core/exceptions/network/network_exception.dart';
import '../../entities/export_entities.dart';

import '../../repositories/export_repositories.dart';
import '../../repositories/auth/auth_repository.dart';

class AuthUsecases  {
 final AuthRepository _authRepository;

  const AuthUsecases(this._authRepository);

  //* REMOTE
  /// This method gets popular movies from the remote data source.
 //* REMOTE
 /// This method gets popular movies from the remote data source.
 Future<Either<NetworkException, UserEntity>> login({
   required String email,
   required String password,
   required bool rememberMe
 }) async {
   return _authRepository.login(email, password,rememberMe);
 }

 Future<Either<NetworkException, UserEntity>> signup(
     String firstName,
     String lastName,
     String username,
     String email,
     String password,
     DateTime dateOfBirth,
     String? profilePhotoPath
     ) async {
   return _authRepository.signup(
       firstName,
       lastName,
       username,
       email,
       password,
       dateOfBirth,
       profilePhotoPath);
 }
 Future<Either<NetworkException, void>> signOut() async {
   return _authRepository.signOut();
 }
 Future<Either<NetworkException, void>> resetPassword( String email,) async {
   return _authRepository.resetPassword(email);
 }
 Future<Either<NetworkException, UserEntity>> getUserFromToken() async {
   return _authRepository.getUserFromToken();
 }

}