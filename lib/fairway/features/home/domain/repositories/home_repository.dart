import 'package:fairway/fairway/models/api_response_model.dart';
import 'package:fairway/fairway/models/restaurant_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class HomeRepository {
  Future<RepositoryResponse<ApiResponse<UserData>>> getUserProfile();
  Future<RepositoryResponse<ApiResponse<UserData>>> updateUserProfile();

  // Add method to get all restaurants
  Future<RepositoryResponse<ApiResponse<RestaurantList>>> getRestaurants();
  Future<RepositoryResponse<ApiResponse<RestaurantList>>> searchRestaurants(
      String query);
}
