import 'package:dio/dio.dart';

import '../../../../core/constants/url_constants.dart';
import '../../../../core/database/hive.dart';
import '../../../../core/exceptions/network/dio_exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../models/auth_model/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;
  final HiveService _hiveService;

  const AuthRemoteDataSourceImpl(this._dioClient, this._hiveService);

  @override
  Future<UserModel> login(
      String email, String password, bool rememberMe) async {
    try {
      final response = await _dioClient.post(UrlConstants.login,
          data: {'email': email, 'password': password});
      final user = UserModel.fromJson(response.data);
      if (user.id != null) {
        print('User id from response: ${user.id}');
        await _hiveService.saveUserId(user.id!);
        final savedId = await _hiveService.getUserId();
        print('id saved in Hive: $savedId');
        ;
      }
      if (user.token != null) {
        print('User token from response: ${user.token}');
        await _hiveService.saveAuthToken(user.token!);
        final savedToken = await _hiveService.getAuthToken();
        print('Token saved in Hive: $savedToken');
      }
      if (user.refreshToken != null) {
        print('refreshToken from response: ${user.refreshToken}');
        await _hiveService.saveRefreshToken(user.refreshToken!);
        final savedToken = await _hiveService.getRefreshToken();
        print('refreshToken saved in Hive: $savedToken');
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signup(
    String firstName,
    String lastName,
    String username,
    String email,
    String password,
    DateTime dateOfBirth,
    String? profilePhotoPath,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'email': email,
        'password': password,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        if (profilePhotoPath != null)
          'profilePhoto': await MultipartFile.fromFile(profilePhotoPath,
              filename: 'profile_photo.jpg'),
      });

      final response =
          await _dioClient.post(UrlConstants.signup, data: formData);
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> resetPassword(String email) async {
    try {
      final response =
          await _dioClient.post('/resetpassword', data: {'email': email});
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final response = await _dioClient.get(UrlConstants.getUser);
      final user = UserModel.fromJson(response.data);
      if (user.id != null) {
        print('User id from response: ${user.id}');
        await _hiveService.saveUserId(user.id!);
        final savedId = await _hiveService.getUserId();
        print('id saved in Hive: $savedId');
      }
      if (user.refreshToken != null) {
        print('refreshToken from response: ${user.refreshToken}');
        await _hiveService.saveRefreshToken(user.refreshToken!);
        final savedToken = await _hiveService.getRefreshToken();
        print('refreshToken saved in Hive: $savedToken');
      }

      return user;
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 403) {
          // Attempt to refresh the token if a 403 error is received
          final refreshToken = await _hiveService.getRefreshToken();
          if (refreshToken != null) {
            try {
              // Refresh the token
              final refreshResponse = await _dioClient.post(
                  UrlConstants.refresh_token,
                  data: {'refreshToken': refreshToken});
              final newToken = refreshResponse.data['token'];

              // Save the new tokens
              await _hiveService.saveAuthToken(newToken);

              // Logging for debugging
              print('New token: $newToken');

              // Retry the original request with the new token
              final retryOptions =
                  Options(headers: {'Authorization': 'Bearer $newToken'});
              final retryResponse = await _dioClient.get(UrlConstants.getUser,
                  options: retryOptions);

              // Logging for debugging
              print('Retry response status code: ${retryResponse.statusCode}');
              print('Retry response data: ${retryResponse.data}');

              return UserModel.fromJson(retryResponse.data);
            } catch (refreshError) {
              // Handle refresh token failure
              if (refreshError is DioError) {
                throw DioExceptions.fromDioError(refreshError);
              } else {
                throw Exception(
                    'Unexpected error occurred during token refresh');
              }
            }
          } else {
            throw Exception('Refresh token not found');
          }
        } else {
          throw DioExceptions.fromDioError(e);
        }
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }
}
