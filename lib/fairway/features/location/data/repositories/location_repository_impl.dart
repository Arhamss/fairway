import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/location/data/models/airport_request_model.dart';
import 'package:fairway/fairway/features/location/data/models/location_data_model.dart';
import 'package:fairway/fairway/features/location/domain/repositories/location_repository.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';
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
    String? query,
    String? code,
    double? lat,
    double? long,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if ((query ?? '').isNotEmpty) queryParams['airportName'] = query;
      if ((code ?? '').isNotEmpty) queryParams['code'] = code;
      if (lat != null && long != null) {
        queryParams['lat'] = lat.toString();
        queryParams['long'] = long.toString();
      }

      final response = await _apiService.get(
        Endpoints.customerAirportSearch,
        queryParams: queryParams,
      );

      final result = LocationData.parseResponse(response);
      final airportsData = result.response?.data;

      if (result.isSuccess && airportsData != null) {
        AppLogger.info('Airports fetched successfully');
        return RepositoryResponse(
          isSuccess: true,
          data: airportsData,
        );
      } else {
        AppLogger.error('Failed to fetch airports: ${result.error}');
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to fetch airports',
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

      final result = LocationData.parseResponse(response);
      final locationData = result.response?.data;

      if (result.isSuccess && locationData != null) {
        AppLogger.info('Airports fetched successfully by lat/long');
        return RepositoryResponse(
          isSuccess: true,
          data: locationData,
        );
      } else {
        AppLogger.error(
          'Failed to fetch airports by lat/long: ${result.error}',
        );
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to fetch airports by lat/long',
        );
      }
    } catch (e) {
      AppLogger.error('Airports fetch by lat/long exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to fetch airports by lat/long: $e',
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

      final result = ResponseModel.fromApiResponse<BaseApiResponse<void>>(
        response,
        (json) => BaseApiResponse<void>.fromJson(json, (_) {}),
      );

      if (result.isSuccess && result.response?.statusCode == 200) {
        AppLogger.info('Current location set successfully');
        return RepositoryResponse(
          isSuccess: true,
          data: true,
          message: 'Current location set successfully',
        );
      } else {
        final errorMsg = result.error ?? 'Failed to set current location';
        AppLogger.error('Set current location failed: $errorMsg');
        return RepositoryResponse(
          isSuccess: false,
          message: errorMsg,
          data: false,
        );
      }
    } catch (e) {
      AppLogger.error('Set current location exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Set current location failed: $e',
        data: false,
      );
    }
  }
}
