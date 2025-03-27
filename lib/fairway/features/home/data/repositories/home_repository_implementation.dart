import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/home/domain/repositories/home_repository.dart';
import 'package:fairway/fairway/models/api_response_model.dart';
import 'package:fairway/fairway/models/restaurant_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

class HomeRepositoryImplementation implements HomeRepository {
  HomeRepositoryImplementation({
    ApiService? apiService,
    AppPreferences? baseStorage,
  })  : _apiService = apiService ?? ApiService(),
        _cache = baseStorage ?? AppPreferences();

  final ApiService _apiService;
  final AppPreferences _cache;

  @override
  Future<RepositoryResponse<ApiResponse<UserData>>> getUserProfile() async {
    try {
      await _cache.init('app-storage');
      final uid = _cache.getUserId() ?? '';
      if (uid.isEmpty) {
        AppLogger.error('User ID is empty, cannot fetch profile');
        return RepositoryResponse(
          isSuccess: false,
          message: 'User ID is empty',
        );
      }

      final response = await _apiService.get(
        Endpoints.customerProfile,
        queryParams: {'id': uid},
      );

      AppLogger.info('User profile response: ${response.data}');
      if (response.data == null) {
        AppLogger.error('User profile response is null');
        return RepositoryResponse(
          isSuccess: false,
          message: 'User profile response is null',
        );
      }

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        UserData.fromJson,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        AppLogger.info('User profile loaded: ${apiResponse.data!.name}');
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse,
        );
      } else {
        AppLogger.error(
          'Failed to load user profile: ${apiResponse.errorMessage}',
        );
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Failed to load user profile',
          data: apiResponse,
        );
      }
    } catch (e) {
      AppLogger.error('User profile exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to load user profile: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<ApiResponse<UserData>>> updateUserProfile() {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }

  @override
  Future<RepositoryResponse<ApiResponse<RestaurantList>>>
      getRestaurants() async {
    try {
      final response = await _apiService.get(
        Endpoints.restaurants,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        RestaurantList.fromJson,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        AppLogger.info('Restaurants loaded successfully');
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse,
        );
      } else {
        AppLogger.error(
          'Failed to load restaurants: ${apiResponse.errorMessage}',
        );
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Failed to load restaurants',
          data: apiResponse,
        );
      }
    } catch (e) {
      AppLogger.error('Restaurant fetch exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to load restaurants: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<ApiResponse<RestaurantList>>> searchRestaurants(
    String query,
  ) async {
    try {
      final response = await _apiService.get(
        Endpoints.restaurantSearch,
        queryParams: {'q': query},
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        RestaurantList.fromJson,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse,
        );
      } else {
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Failed to search restaurants',
          data: apiResponse,
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to search restaurants: $e',
      );
    }
  }
}
