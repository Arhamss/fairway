import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/restaurant/data/model/recent_searches_model.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_response_model.dart';
import 'package:fairway/fairway/features/restaurant/data/model/search_suggestions_model.dart';
import 'package:fairway/fairway/features/restaurant/domain/repository/restaurant_repository.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  RestaurantRepositoryImpl({
    ApiService? apiService,
    AppPreferences? baseStorage,
  })  : _apiService = apiService ?? Injector.resolve<ApiService>(),
        _cache = baseStorage ?? Injector.resolve<AppPreferences>();

  final ApiService _apiService;
  final AppPreferences _cache;

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
  }) async {
    try {
      final response = await _apiService.get(
        Endpoints.searchRestaurants,
        queryParams: {
          'q': query,
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
          message: result.error ?? 'Failed to search restaurants',
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to search restaurants: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<RestaurantResponseModel>>
      getBestPartnerRestaurants({
    int page = 1,
    int limit = 5,
  }) async {
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

  @override
  Future<RepositoryResponse<SearchSuggestionsModel>> getSearchSuggestions(
    String query,
  ) async {
    try {
      final response = await _apiService.get(
        Endpoints.searchSuggestions,
        queryParams: {
          'q': query,
        },
      );

      final result = SearchSuggestionsModel.parseResponse(response);

      if (result.isSuccess && result.response?.data != null) {
        return RepositoryResponse(
          isSuccess: true,
          data: result.response!.data,
        );
      } else {
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to get search suggestions',
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to get search suggestions: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<RecentSearchesModel>> getRecentSearches() async {
    try {
      final response = await _apiService.get(Endpoints.recentSearches);

      final result = RecentSearchesModel.parseResponse(response);

      if (result.isSuccess && result.response?.data != null) {
        return RepositoryResponse(
          isSuccess: true,
          data: result.response!.data,
        );
      } else {
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to get recent searches',
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to get recent searches: $e',
      );
    }
  }
  
  @override
  Future<RepositoryResponse<void>> clearRecentSearch() async {
    try {
      final response = await _apiService.delete(Endpoints.deleteRecentSearches);

      if (response.statusCode == 200) {
        return RepositoryResponse(
          isSuccess: true,
          data: null,
        );
      } else {
        return RepositoryResponse(
          isSuccess: false,
          message: 'Failed to clear recent searches',
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to clear recent searches: $e',
      );
    }
  }
}
