import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/app_preferences/timestamp_adapter.dart';
import 'package:fairway/core/notifications/firebase_notifications.dart';
import 'package:fairway/core/notifications/local_notification_service.dart';
import 'package:fairway/fairway/models/saved_locations/saved_location_model.dart';
import 'package:fairway/fairway/models/user_model/user_model.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class AppModule {
  static late final GetIt _container;

  static Future<void> setup(GetIt container) async {
    _container = container;
    await _setupHive();
    await _setupAppPreferences();
    await _setupAPIService();
    //await _setupFirebaseNotifications();
    //await _setupLocalNotificationService();
  }

  static Future<void> _setupHive() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(TimestampAdapter())
      ..registerAdapter(UserModelAdapter())
      ..registerAdapter(SavedLocationAdapter());
  }

  static Future<void> _setupAppPreferences() async {
    final appPreferences = AppPreferences();
    await appPreferences.init('app-storage');
    _container.registerSingleton<AppPreferences>(appPreferences);
  }

  static Future<void> _setupAPIService() async {
    final apiService = ApiService();
    _container.registerSingleton<ApiService>(apiService);
  }

  static Future<void> _setupFirebaseNotifications() async {
    final firebaseNotificationService = FirebaseNotificationService();
    await firebaseNotificationService.initialize();
    _container.registerSingleton<FirebaseNotificationService>(
      firebaseNotificationService,
    );
  }

  static Future<void> _setupLocalNotificationService() async {
    final instance = LocalNotificationService();
    await instance.initializeLocalNotifications();
    _container.registerSingleton<LocalNotificationService>(instance);
  }
}
