import 'package:fairway/config/flavor_config.dart';

/// API Environments & Configurations
enum ApiEnvironment {
  production(
    baseUrl: 'https://fairways-backend.onrender.com/api/',
    apiVersion: 'v1',
  ),
  staging(
    baseUrl: 'https://fairways-backend.onrender.com/api/',
    apiVersion: 'v1',
  ),
  development(
    baseUrl: 'https://fairways-backend.onrender.com/api/',
    apiVersion: 'v1',
  ),
  qa(
    baseUrl: 'https://fairways-backend.onrender.com/api/',
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
      case Flavor.staging:
        return ApiEnvironment.staging;
      case Flavor.development:
        return ApiEnvironment.development;
      case Flavor.qa:
        return ApiEnvironment.qa;
    }
  }
}
