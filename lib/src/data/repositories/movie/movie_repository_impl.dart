import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:isar/isar.dart';

import '../../../core/exceptions/database/database_exception.dart';
import '../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/export_entities.dart';
import '../../../domain/repositories/movie/movie_repository.dart';
import '../../datasources/export_datasources.dart';
import '../../datasources/local/_collections/export_collections.dart';
import '../../datasources/local/movie/movie_local_data_source.dart';


class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _movieRemoteDataSource;
  final MovieLocalDataSource _movieLocalDataSource;

  MovieRepositoryImpl(this._movieRemoteDataSource, this._movieLocalDataSource);

  //* REMOTE
  @override
  Future<Either<NetworkException, MovieListingsEntity>> getPopularMovies({required int page}) async {
    try {
      final result = await _movieRemoteDataSource.getPopularMovies(page: page);

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }

  @override
  Future<Either<NetworkException, MovieListingsEntity>> getTopRatedMovies({required int page}) async {
    try {
      final result = await _movieRemoteDataSource.getTopRatedMovies(page: page);

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }
//* LOCAL
  @override
  Future<Either<DatabaseException, List<MovieDetailEntity>>> getSavedMovieDetails() async {
    try {
      final result = await _movieLocalDataSource.getSavedMovieDetails();

      return Right(result.map((e) => e.toEntity()).toList());
    } on IsarError catch (e) {
      return Left(DatabaseException.fromIsarError(e));
    }
  }

  @override
  Future<Either<DatabaseException, void>> saveMovieDetails({required MovieDetailEntity? movieDetailEntity}) async {
    try {
      final result = await _movieLocalDataSource.saveMovieDetail(
        movieDetailCollection: MovieDetailCollection().fromEntity(movieDetailEntity),
      );

      return Right(result);
    } on IsarError catch (e) {
      return Left(DatabaseException.fromIsarError(e));
    }
  }

  @override
  Future<Either<DatabaseException, void>> deleteMovieDetail({required String? movieId}) async {
    try {
      final result = await _movieLocalDataSource.deleteMovieDetail(movieId: movieId);

      return Right(result);
    } on IsarError catch (e) {
      return Left(DatabaseException.fromIsarError(e));
    }
  }

  @override
  Future<Either<DatabaseException, bool>> isSavedMovieDetail({required String? movieId}) async {
    try {
      final result = await _movieLocalDataSource.isSavedMovieDetail(movieId: movieId);

      return Right(result);
    } on IsarError catch (e) {
      return Left(DatabaseException.fromIsarError(e));
    }
  }

}
