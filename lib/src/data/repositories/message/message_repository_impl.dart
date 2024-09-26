import 'package:dio/dio.dart';
import 'package:fpdart/src/either.dart';
import 'package:movie_app/src/core/exceptions/network/network_exception.dart';
import 'package:movie_app/src/data/datasources/export_datasources.dart';
import 'package:movie_app/src/domain/repositories/export_repositories.dart';

import '../../../domain/entities/export_entities.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource _messageRemoteDataSource;

  MessageRepositoryImpl(this._messageRemoteDataSource);

  @override
  Future<Either<NetworkException, MessagePaginationEntity>> getMessages(
      {required String userId1, required int page}) async {
    try {
      final result = await _messageRemoteDataSource.getMessage(
          userId1: userId1, page: page);

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }

  @override
  Future<Either<NetworkException, ConversationPaginationEntity>>
      getConversation(
          {required String userId1,
          required String userId2,
          required int page}) async {
    try {
      final result = await _messageRemoteDataSource.getConversation(
          userId1: userId1, userId2: userId2, page: page);

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }

  @override
  Future<Either<NetworkException, MessageEntity>> sendMessage(String sender,
      String receiver, String? message, String? voiceMessageId) async {
    try {
      final result = await _messageRemoteDataSource.sendMessage(
          sender, receiver, message, voiceMessageId);

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }
}
