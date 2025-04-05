import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/location/data/models/airport_request_model.dart';
import 'package:fairway/fairway/features/location/data/models/location_data_model.dart';
import 'package:fairway/fairway/features/location/domain/repositories/location_repository.dart';
import 'package:fairway/fairway/models/api_response_model.dart';
import 'package:fairway/fairway/models/saved_location_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl({
    ApiService? apiService,
    AppPreferences? baseStorage,
  })  : _apiService = apiService ?? Injector.resolve<ApiService>(),
        _cache = baseStorage ?? Injector.resolve<AppPreferences>();

  final ApiService _apiService;
  final AppPreferences _cache;

  @override
  Future<RepositoryResponse<bool>> updateUserLocation(
    AirportRequestModel location,
  ) async {
    try {
      AppLogger.info('Updating location to: $location');
      final response = await _apiService.post(
        endpoint: Endpoints.customerLocation,
        data: location.toJson(),
      );

      // Check if the response is successful based on status code
      final responseData = response.data as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.info('Location updated successfully');
        return RepositoryResponse(
          isSuccess: true,
          data: true,
          message: 'Location updated successfully',
        );
      } else {
        final errorMessage =
            responseData['error'] ?? 'Failed to update location';
        AppLogger.info('Location update failed: $errorMessage');
        return RepositoryResponse(
          isSuccess: false,
          message: errorMessage.toString(),
          data: false,
        );
      }
    } catch (e) {
      AppLogger.info('Location update exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Location update failed: $e',
        data: false,
      );
    }
  }

  @override
  Future<RepositoryResponse<LocationData>> getAirports({
    required int page,
    required int limit,
    String? query,
    String? code,
    double? lat,
    double? long,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (query != null && query.isNotEmpty) {
        queryParams['airportName'] = query;
      }

      if (code != null && code.isNotEmpty) {
        queryParams['code'] = code;
      }

      if (lat != null && long != null) {
        queryParams['lat'] = lat.toString();
        queryParams['long'] = long.toString();
      }

      final response = await _apiService.get(
        Endpoints.customerAirportSearch,
        queryParams: queryParams,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        LocationData.fromJson,
      );

      if (apiResponse.isSuccess) {
        AppLogger.info('Airports fetched successfully');
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse.data,
        );
      } else {
        AppLogger.error(
          'Failed to fetch airports: ${apiResponse.errorMessage}',
        );
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Failed to fetch airports',
          data: apiResponse.data,
        );
      }
    } catch (e) {
      AppLogger.error('Airports fetch exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to fetch airports: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<LocationData>> getAirportsByLatLong({
    required double lat,
    required double long,
  }) async {
    try {
      final response = await _apiService.get(
        Endpoints.getCurrentLocation,
        queryParams: {
          'latitude': lat.toString(),
          'longitude': long.toString(),
        },
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        LocationData.fromJson,
      );

      if (apiResponse.isSuccess) {
        AppLogger.info('Airports fetched successfully by lat long');
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse.data,
        );
      } else {
        AppLogger.error(
          'Failed to fetch airports by lat long: ${apiResponse.errorMessage}',
        );
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Failed to fetch airports',
        );
      }
    } catch (e) {
      AppLogger.error('Airports fetch by lat long exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to fetch airports by lat long: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<bool>> setCurrentLocation(
    AirportRequestModel location,
  ) async {
    try {
      AppLogger.info('Setting current location to: $location');
      final response = await _apiService.put(
        Endpoints.setCurrentLocation,
        location.toJson(),
      );

      // Check if the response is successful based on status code
      final responseData = response.data as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.info('Current location set successfully');
        return RepositoryResponse(
          isSuccess: true,
          data: true,
          message: 'Current location set successfully',
        );
      } else {
        final errorMessage =
            responseData['error'] ?? 'Failed to set current location';
        AppLogger.info('Set current location failed: $errorMessage');
        return RepositoryResponse(
          isSuccess: false,
          message: errorMessage.toString(),
          data: false,
        );
      }
    } catch (e) {
      AppLogger.info('Set current location exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Set current location failed: $e',
        data: false,
      );
    }
  }
}
