import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/api_service/app_api_exception.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/home/domain/repositories/home_repository.dart';
import 'package:fairway/fairway/models/restaurant_response_model.dart';
import 'package:fairway/fairway/models/user_model/user_model.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

class HomeRepositoryImplementation implements HomeRepository {
  HomeRepositoryImplementation({
    ApiService? apiService,
    AppPreferences? baseStorage,
  })  : _apiService = apiService ?? Injector.resolve<ApiService>(),
        _cache = baseStorage ?? Injector.resolve<AppPreferences>();

  final ApiService _apiService;
  final AppPreferences _cache;

  @override
  Future<RepositoryResponse<UserModel>> getUserProfile() async {
    try {
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

      final result = UserModel.parseResponse(response);
      final userData = result.response?.data;

      if (result.isSuccess && userData != null) {
        AppLogger.info('User profile loaded: ${userData.name}');
        _cache.setUserModel(userData);
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
  Future<RepositoryResponse<RestaurantResponseModel>> getRestaurants({
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final response = await _apiService.get(
        Endpoints.restaurants,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final result = RestaurantResponseModel.parseResponse(response);

      if (result.isSuccess && result.response?.data != null) {
        return RepositoryResponse(
          isSuccess: true,
          data: result.response!.data,
        );
      } else {
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to fetch restaurants',
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to fetch restaurants: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<RestaurantResponseModel>> searchRestaurants(
    String query, {
    int page = 1,
    int limit = 5,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<RepositoryResponse<UserModel>> updateUserProfile() {
    throw UnimplementedError();
  }

  @override
  Future<RepositoryResponse<RestaurantResponseModel>> getBestPartnerRestaurants(
      {int page = 1, int limit = 5}) async {
    try {
      final response = await _apiService.get(
        Endpoints.bestPartnerRestaurants,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final result = RestaurantResponseModel.parseResponse(response);

      if (result.isSuccess && result.response?.data != null) {
        return RepositoryResponse(
          isSuccess: true,
          data: result.response!.data,
        );
      } else {
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to fetch best partner restaurants',
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to fetch best partner restaurants: $e',
      );
    }
  }
}
