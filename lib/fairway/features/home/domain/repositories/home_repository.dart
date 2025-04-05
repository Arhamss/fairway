import 'package:fairway/fairway/models/restaurant_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class HomeRepository {
  Future<RepositoryResponse<UserData>> getUserProfile();
  Future<RepositoryResponse<UserData>> updateUserProfile();
  Future<RepositoryResponse<RestaurantList>> getRestaurants();
  Future<RepositoryResponse<RestaurantList>> searchRestaurants(String query);
}
