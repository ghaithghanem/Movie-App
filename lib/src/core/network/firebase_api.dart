import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../constants/url_constants.dart';
import '../database/hive.dart';
import 'dio_client.dart';

late final HiveService _hiveService;
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (kDebugMode) {
    print('Title: ${message.notification?.title}');
  }
  if (kDebugMode) {
    print('Body: ${message.notification?.body}');
  }
  if (kDebugMode) {
    print('Payload: ${message.data}');
  }
  //_onNavigatePressed(context);
  final targetRoute = message.data['route'];
  await _hiveService.saveAuthToken(targetRoute);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  late final DioClient _dioClient;

  FirebaseApi({
    required DioClient dioClient,
    required HiveService hiveService,
  }) {
    _dioClient = dioClient;
  }
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    // Attempt to get the token initially
    await _trySaveFCMToken();

    // Listen for token updates
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      if (kDebugMode) {
        print('New FCM Token: $newToken');
      }
      await _trySaveFCMToken(newToken);
    });
    FirebaseMessaging.onBackgroundMessage(
        handleBackgroundMessage as BackgroundMessageHandler);
  }

  Future<void> _trySaveFCMToken([String? token]) async {
    //String? fCMToken = token ?? await _firebaseMessaging.getToken();

    //print('Token: $fCMToken');
  }

  Future<void> saveTokenToBackend(String userId, String fCMToken) async {
    try {
      final response = await _dioClient.post(
        UrlConstants.getFirebaseToken,
        data: {'userId': userId, 'firebaseToken': fCMToken},
      );

      if (response.statusCode == 200) {
        print('Fire Base Token saved successfully');
      } else {
        print('Failed to save token');
      }
    } catch (e) {
      print('Error saving token: $e');
    }
  }
}

/*
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    if (fCMToken != null) {
      final savedId = await _hiveService.getUserId();
      await saveTokenToBackend(savedId!, fCMToken);
    }
    FirebaseMessaging.onBackgroundMessage(
        handleBackgroundMessage as BackgroundMessageHandler);
  }
 */
