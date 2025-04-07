import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/api_service/app_api_exception.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/home/domain/repositories/home_repository.dart';
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
  Future<RepositoryResponse<UserData>> getUserProfile() async {
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
      );

      AppLogger.info('User profile response: ${response.data}');

      final result = UserData.parseResponse(response);
      final userData = result.response?.data;

      if (result.isSuccess && userData != null) {
        AppLogger.info('User profile loaded: ${userData.name}');
        return RepositoryResponse(
          isSuccess: true,
          data: userData,
        );
      } else {
        AppLogger.error('Failed to load user profile: ${result.error}');
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to load user profile',
        );
      }
    } catch (e, s) {
      AppLogger.error('User profile exception:', e, s);
      return RepositoryResponse(
        isSuccess: false,
        message: extractApiErrorMessage(e, 'Failed to load user profile'),
      );
    }
  }

  @override
  Future<RepositoryResponse<RestaurantList>> getRestaurants() async {
    try {
      final response = await _apiService.get(Endpoints.restaurants);

      final result = RestaurantList.parseResponse(response);
      final data = result.response?.data;

      if (result.isSuccess && data != null) {
        AppLogger.info('Restaurants loaded successfully');
        return RepositoryResponse(
          isSuccess: true,
          data: data,
        );
      } else {
        AppLogger.error('Failed to load restaurants: ${result.error}');
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to load restaurants',
        );
      }
    } catch (e, s) {
      AppLogger.error('Restaurant fetch exception:', e, s);
      return RepositoryResponse(
        isSuccess: false,
        message: extractApiErrorMessage(e, 'Failed to load restaurants'),
      );
    }
  }

  @override
  Future<RepositoryResponse<RestaurantList>> searchRestaurants(String query) {
    throw UnimplementedError();
  }

  @override
  Future<RepositoryResponse<UserData>> updateUserProfile() {
    throw UnimplementedError();
  }
}
