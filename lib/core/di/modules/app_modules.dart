import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/app_preferences/timestamp_adapter.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class AppModule {
  static late final GetIt _container;

  static Future<void> setup(GetIt container) async {
    _container = container;
    await _setupHive();
    await _setupAppPreferences();
    await _setupAPIService();
  }

  static Future<void> _setupHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TimestampAdapter());
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
}
