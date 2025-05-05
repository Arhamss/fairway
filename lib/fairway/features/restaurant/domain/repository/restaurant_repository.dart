import 'package:fairway/core/enums/restaurant_filter.dart';
import 'package:fairway/core/enums/sort_options_enum.dart';
import 'package:fairway/fairway/features/restaurant/data/model/recent_searches_model.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_response_model.dart';
import 'package:fairway/fairway/features/restaurant/data/model/search_suggestions_model.dart';
import 'package:fairway/fairway/models/category_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class RestaurantRepository {
  Future<RepositoryResponse<RestaurantResponseModel>> getRestaurants({
    int? page,
    int? limit,
    SortByOption? sortBy,
    RestaurantTag? filter,
  });

  Future<RepositoryResponse<RestaurantResponseModel>> searchRestaurants(
    String query, {
    int page = 1,
    int limit = 5,
  });

  Future<RepositoryResponse<RestaurantResponseModel>>
      getBestPartnerRestaurants({
    int? page,
    int? limit,
    SortByOption? sortBy,
    RestaurantTag? filter,
  });

  Future<RepositoryResponse<SearchSuggestionsModel>> getSearchSuggestions(
    String query,
  );

  Future<RepositoryResponse<RecentSearchesModel>> getRecentSearches();

  Future<RepositoryResponse<void>> clearRecentSearch();

  Future<RepositoryResponse<List<CategoryModel>>> getCategories();

  Future<RepositoryResponse<RestaurantResponseModel>> getFilteredRestaurants(
   {
    int? page,
    int? limit,
    SortByOption? sortBy,
    List<String>? categoryIds, 
  });
}