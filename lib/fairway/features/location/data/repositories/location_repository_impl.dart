import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/location/data/models/location_data_model.dart';
import 'package:fairway/fairway/features/location/domain/repositories/location_repository.dart';
import 'package:fairway/fairway/models/api_response_model.dart';
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
  Future<RepositoryResponse<UserData>> updateUserLocation(
    String location,
  ) async {
    try {
      AppLogger.info('Updating location to: $location');
      final response = await _apiService.put(
        Endpoints.customerLocation,
        {
          'airportCode': location,
        },
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        UserData.fromJson,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        AppLogger.info(
          'Location updated successfully: ${apiResponse.data!.location}',
        );
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse.data,
          message: 'Location updated successfully',
        );
      } else {
        AppLogger.info('Location update failed: ${apiResponse.errorMessage}');
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Failed to update location',
          data: apiResponse.data,
        );
      }
    } catch (e) {
      AppLogger.info('Location update exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Location update failed: $e',
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
}
