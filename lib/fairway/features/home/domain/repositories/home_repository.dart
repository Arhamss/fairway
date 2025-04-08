import 'package:fairway/fairway/models/restaurant_response_model.dart';
import 'package:fairway/fairway/models/user_model/user_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class HomeRepository {
  Future<RepositoryResponse<UserModel>> getUserProfile();
  Future<RepositoryResponse<UserModel>> updateUserProfile();
  Future<RepositoryResponse<RestaurantResponseModel>> getRestaurants({
    int page = 1,
    int limit = 5,
  });
  Future<RepositoryResponse<RestaurantResponseModel>> searchRestaurants(
    String query, {
    int page = 1,
    int limit = 5,
  });

  Future<RepositoryResponse<RestaurantResponseModel>>
      getBestPartnerRestaurants({
    int page = 1,
    int limit = 5,
  });
}
