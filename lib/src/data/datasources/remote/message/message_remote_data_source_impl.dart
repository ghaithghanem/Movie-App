import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_app/src/data/models/message_model/conversation_pagination_model.dart';
import 'package:path/path.dart'; // For basename function

import '../../../../core/constants/url_constants.dart';
import '../../../../core/database/hive.dart';
import '../../../../core/network/dio_client.dart';
import '../../../models/export_models.dart';
import 'message_remote_data_source.dart';

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final DioClient _dioClient;
  final HiveService _hiveService;

  MessageRemoteDataSourceImpl(this._dioClient, this._hiveService);

  @override
  Future<MessagePaginationModel> getMessage(
      {required String userId1, required int page}) async {
    try {
      final savedId = _hiveService.getUserId();
      if (kDebugMode) {
        if (kDebugMode) {
          print('id check late get it $savedId');
        }
      }

      final url =
          replacePlaceholder(UrlConstants.getMessages, '{user_id1}', userId1);

      final response = await _dioClient.get(
        url,
        queryParameters: {'userId': savedId, 'page': page},
      );

      final model = MessagePaginationModel.fromJson(
          response.data as Map<String, dynamic>);

      return model;
    } catch (e) {
      if (kDebugMode) {
        print('Error in getMessage: $e');
      }
      rethrow;
    }
  }

  String replacePlaceholder(
    String url,
    String placeholder,
    String value,
  ) {
    return url.replaceAll(placeholder, value);
  }

  @override
  Future<ConversationPaginationModel> getConversation(
      {required String userId1,
      required String userId2,
      required int page}) async {
    final url = replacePlaceholder1(UrlConstants.getConversation, '{user_id1}',
        userId1, '{user_id2}', userId2);
    final response = await _dioClient.get(
      url,
      queryParameters: {
        'userId1': userId1,
        'userId2': userId2,
        'page': page // Use savedId here
      },
    );

    final model = ConversationPaginationModel.fromJson(
        response.data as Map<String, dynamic>);

    return model;
  }

  String replacePlaceholder1(String url, String placeholder1, String value1,
      String placeholder2, String value2) {
    return url
        .replaceAll(placeholder1, value1)
        .replaceAll(placeholder2, value2);
  }

  @override
  Future<MessageModel> sendMessage(String sender, String receiver,
      String? message, String? voiceMessage) async {
    try {
      // Prepare the form data for the request
      FormData formData = FormData.fromMap({
        'sender': sender,
        'receiver': receiver,
        if (message != null && message.isNotEmpty)
          'message': message, // Send message if not null
        if (voiceMessage != null)
          'voiceMessage': await MultipartFile.fromFile(
            voiceMessage,
            filename: basename(voiceMessage), // Extracts filename from path
          ),
      });

      // Send the POST request using Dio
      final response = await _dioClient.post(
        UrlConstants.sendMesaage,
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'multipart/form-data',
          },
        ),
      );

      // Parse and return the response data
      return MessageModel.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print('Error in sending message: $e');
      }
      rethrow; // Re-throw the error after logging it
    }
  }
/*
  @override
  Future<MessageModel> sendMessage(String sender, String receiver,
      String? message, String? voiceMessage) async {
    try {
      // Extracting the filename from the path
      String? filename =
      voiceMessage != null ? voiceMessage.split('/').last : null;

      FormData formData = FormData.fromMap({
        'sender': sender,
        'receiver': receiver,
        'message': message,
        if (voiceMessage != null)
          'voiceMessage': await MultipartFile.fromFile(voiceMessage,
              filename: filename), // Use extracted filename
      });

      final response = await _dioClient.post(
        UrlConstants.sendMesaage,
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'multipart/form-data',
          },
        ),
      );

      return MessageModel.fromJson(response.data);
    } catch (e) {
      print('Error in sending message: $e');
      rethrow;
    }
  } */
}
