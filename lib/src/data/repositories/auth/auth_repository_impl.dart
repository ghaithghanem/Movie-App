import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:isar/isar.dart';

import '../../../core/exceptions/database/database_exception.dart';
import '../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/export_entities.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../../domain/repositories/movie/movie_repository.dart';
import '../../datasources/export_datasources.dart';
import '../../datasources/local/_collections/export_collections.dart';
import '../../datasources/local/movie/movie_local_data_source.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;


  AuthRepositoryImpl(this._authRemoteDataSource);

  //* REMOTE
  @override
  Future<Either<NetworkException, UserEntity>> login(String email, String password,bool rememberMe) async {
    try {
      final result = await _authRemoteDataSource.login(email,password,rememberMe);

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }

  @override
  Future<Either<NetworkException, UserEntity>> signup(String firstName,
      String lastName, String username, String email, String password,DateTime dateOfBirth,
      String? profilePhotoPath) async {
    try {
      final result = await _authRemoteDataSource.signup(
          firstName,
          lastName,
          username,
          email,
          password,
          dateOfBirth,
          profilePhotoPath);

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }

  @override
  Future<Either<NetworkException, void>> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<NetworkException, void>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Either<NetworkException, UserEntity>> getUserFromToken()async {
    try {
      final result = await _authRemoteDataSource.getUser();

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }


}