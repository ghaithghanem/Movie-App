import 'package:fpdart/fpdart.dart';

import '../../../core/exceptions/network/network_exception.dart';
import '../../entities/auth_entities/user_entity.dart';
import '../../entities/export_entities.dart';

abstract class AuthRepository {
  //* Remote Data Source
  Future<Either<NetworkException, UserEntity>> login(String email, String password,bool rememberMe);
  Future<Either<NetworkException, UserEntity>> signup(String firstName,
      String lastName, String username, String email, String password,DateTime dateOfBirth,
      String? profilePhotoPath);
  Future<Either<NetworkException, void>> signOut();
  Future<Either<NetworkException, void>> resetPassword(String email);
  Future<Either<NetworkException, UserEntity>> getUserFromToken();
}