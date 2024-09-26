import 'package:firebase_messaging/firebase_messaging.dart';

import '../constants/url_constants.dart';
import '../database/hive.dart';
import 'dio_client.dart';

late final HiveService _hiveService;
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
  //_onNavigatePressed(context);
  final targetRoute = message.data['route'];
  await _hiveService.saveAuthToken(targetRoute);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  late final DioClient _dioClient;
  late final HiveService _hiveService;

  FirebaseApi({
    required DioClient dioClient,
    required HiveService hiveService,
  }) {
    _dioClient = dioClient;
    _hiveService = hiveService;
  }
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    FirebaseMessaging.onBackgroundMessage(
        handleBackgroundMessage as BackgroundMessageHandler);
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
