// import 'dart:async';
// import 'dart:convert';
//
// import 'package:bammbuu/core/notifications/firebase_notifications.dart';
// import 'package:bammbuu/l10n/localization_service.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class LocalNotificationService {
//   factory LocalNotificationService() {
//     return _instance;
//   }
//
//   LocalNotificationService._internal();
//
//   static final LocalNotificationService _instance =
//       LocalNotificationService._internal();
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   Future<void> initializeLocalNotifications() async {
//     const androidInitializationSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const darwinInitializationSettings = DarwinInitializationSettings();
//
//     const initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: darwinInitializationSettings,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
//     );
//   }
//
//   Future<void> _onDidReceiveNotificationResponse(
//     NotificationResponse notificationResponse,
//   ) async {
//     final payload = notificationResponse.payload;
//
//     if (payload == null) {
//       debugPrint('No payload in notification response.');
//       return;
//     }
//
//     try {
//       final decodedPayload = json.decode(payload) as Map<String, dynamic>;
//       debugPrint('Parsed payload: $decodedPayload');
//       FirebaseNotificationService()
//           .navigationStreamController
//           .add(decodedPayload);
//     } catch (e) {
//       debugPrint('Error parsing notification payload: $e');
//     }
//   }
//
//   Future<void> sendLocalNotification(
//     String? title,
//     String? body,
//     String payload,
//   ) async {
//     const androidNotificationDetails = AndroidNotificationDetails(
//       'bammbuuId',
//       'bammbuu',
//       channelDescription: 'dawlati',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );
//
//     const notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: DarwinNotificationDetails(),
//     );
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title ?? Localization.unknownSender,
//       body ?? Localization.unknown,
//       notificationDetails,
//       payload: payload,
//     );
//   }
// }
