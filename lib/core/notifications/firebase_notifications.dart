import 'dart:async';
import 'dart:convert';

import 'package:fairway/core/notifications/local_notification_service.dart';
import 'package:fairway/export.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;

class FirebaseNotificationService {
  factory FirebaseNotificationService() {
    return _instance;
  }

  FirebaseNotificationService._internal();

  static final FirebaseNotificationService _instance =
      FirebaseNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final StreamController<Map<String, dynamic>> navigationStreamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get navigationStream =>
      navigationStreamController.stream;

  Future<String?> getFcmToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $token');

      if (token != null) {
        return token;
      }
    } catch (e) {
      debugPrint('Error fetching FCM token: $e');
    }
    return null;
  }

  Future<bool> deleteFCMToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      return true;
    } catch (e) {
      debugPrint('Error deleting FCM token: $e');
    }
    return false;
  }

  Future<void> initialize() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions();

    /// Background notifications
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    /// Tapping on notifications
    FirebaseMessaging.onMessageOpenedApp.listen(firebaseMessagingOnTapHandler);

    /// Foreground notifications
    FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
  }

  @pragma('vm:entry-point')
  Future<void> firebaseMessagingOnTapHandler(RemoteMessage message) async {
    navigationStreamController.add(message.data);
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingForegroundHandler(RemoteMessage message) async {
  AppLogger.info('onMessage: $message');
  final data = message.data;

  await LocalNotificationService().sendLocalNotification(
    message.notification?.title,
    message.notification?.body,
    jsonEncode(message.data),
  );

  if (data.isNotEmpty) {
    debugPrint('onMessage: data: $data');
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.info('onMessage: $message');
  final data = message.data;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();

  await LocalNotificationService().sendLocalNotification(
    message.notification?.title,
    message.notification?.body,
    jsonEncode(message.data),
  );

  if (data.isNotEmpty) {
    debugPrint('onMessage: data: $data');
  }
}
