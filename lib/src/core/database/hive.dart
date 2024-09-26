import 'package:hive/hive.dart';

class HiveService {
  static const String userid = 'userId';
  static const String authBoxName = 'authBox';
  static const String tokenKey = 'authToken';
  static const String refresh_tokenKey = 'refreshToken';
  static const String rememberMeKey = 'rememberMe';
  static const String routeMessageKey = 'routeMessage';
  final Box _authBox;

  HiveService(this._authBox);

  String? getAuthToken() {
    return _authBox.get(tokenKey);
  }

  Future<void> saveAuthToken(String token) async {
    await _authBox.put(tokenKey, token);
  }

  Future<void> saveMessageRoute(String routeM) async {
    await _authBox.put(routeMessageKey, routeM);
  }
  Future<void> clearAuthToken() async {
    await _authBox.delete(tokenKey);
  }
  bool getRememberMe() {
    return _authBox.get(rememberMeKey, defaultValue: false);
  }

  Future<void> saveRememberMe(bool value) async {
    await _authBox.put(rememberMeKey, value);
  }

  Future<void> clearRememberMe() async {
    await _authBox.delete(rememberMeKey);
  }
  String? getRefreshToken() {
    return _authBox.get(refresh_tokenKey);
  }

  Future<void> saveRefreshToken(String refresh_token) async {
    await _authBox.put(refresh_tokenKey, refresh_token);
  }
  Future<void> saveUserId(String id)async {
    await _authBox.put(userid,id);
  }
  String? getUserId(){
    return _authBox.get(userid);
  }
}
