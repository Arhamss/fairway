import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fairway/core/notifications/firebase_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  factory LocalNotificationService() {
    return _instance;
  }

  LocalNotificationService._internal();

  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeLocalNotifications() async {
    tz.initializeTimeZones();

    // Setup notification channel for Android
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher', // Black color
    );

    const darwinInitializationSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> _onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final payload = notificationResponse.payload;

    if (payload == null) {
      debugPrint('No payload in notification response.');
      return;
    }

    try {
      final decodedPayload = json.decode(payload) as Map<String, dynamic>;
      debugPrint('Parsed payload: $decodedPayload');
      FirebaseNotificationService()
          .navigationStreamController
          .add(decodedPayload);
    } catch (e) {
      debugPrint('Error parsing notification payload: $e');
    }
  }

  Future<void> sendLocalNotification(
    String? title,
    String? body,
    String payload,
  ) async {
    const androidNotificationDetails = AndroidNotificationDetails(
      'quitbettingid',
      'Quit Betting',
      channelDescription: 'dawlati',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
