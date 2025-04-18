import 'package:fairway/config/flavor_config.dart';

/// API Environments & Configurations
enum ApiEnvironment {
  production(
    baseUrl: 'https://fairways-backend.onrender.com/',
    apiVersion: 'v1',
  ),
  development(
    baseUrl: 'https://fairways-backend.onrender.com/',
    apiVersion: 'v1',
  );

  const ApiEnvironment({
    required this.baseUrl,
    required this.apiVersion,
  });

  final String baseUrl;
  final String apiVersion;

  /// Get API Environment Based on Current Flavor**
  static ApiEnvironment get current {
    switch (FlavorConfig.instance.flavor) {
      case Flavor.production:
        return ApiEnvironment.production;
      case Flavor.development:
        return ApiEnvironment.development;
    }
  }
}
