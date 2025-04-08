import 'package:fairway/fairway/features/restaurant/data/model/restaurant_response_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class RestaurantRepository {
  Future<RepositoryResponse<RestaurantResponseModel>> getRestaurants({
    int page = 1,
    int limit = 10,
  });
  Future<RepositoryResponse<RestaurantResponseModel>> searchRestaurants(
    String query, {
    int page,
    int limit,
  });

  Future<RepositoryResponse<RestaurantResponseModel>>
      getBestPartnerRestaurants({
    int page,
    int limit,
  });
}
