import 'package:flutter/material.dart';

/// App Flavors
enum Flavor { development, production }

/// Flavor Configuration Singleton**
class FlavorConfig {
  factory FlavorConfig({required Flavor flavor}) =>
      _instance ??= FlavorConfig._internal(flavor);

  FlavorConfig._internal(this.flavor);
  final Flavor flavor;

  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception(
        'FlavorConfig is not initialized. Call FlavorConfig(flavor: <Flavor>) first.',
      );
    }
    return _instance!;
  }

  static bool isProd() => instance.flavor == Flavor.production;
  static bool isDev() => instance.flavor == Flavor.development;

  static Flavor get currentFlavor => instance.flavor;
}

/// Ensure Initialization for Platform-Specific Configurations
Future<void> ensureInitialized() async {
  WidgetsFlutterBinding.ensureInitialized();
}
