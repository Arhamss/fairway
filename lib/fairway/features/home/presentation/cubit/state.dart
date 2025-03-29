import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/api_response_model.dart';
import 'package:fairway/fairway/models/restaurant_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class HomeState extends Equatable {
  const HomeState({
    this.userProfile = const DataState.initial(),
    this.restaurants = const DataState.initial(),
    this.featuredRestaurants = const DataState.initial(),
    this.nearbyRestaurants = const DataState.initial(),
    this.searchResults = const DataState.initial(),
    this.recentSearches = const [],
  });

  final DataState<ApiResponse<UserData>>? userProfile;
  final DataState<ApiResponse<RestaurantList>>? restaurants;
  final DataState<ApiResponse<RestaurantList>>? featuredRestaurants;
  final DataState<ApiResponse<RestaurantList>>? nearbyRestaurants;
  final DataState<ApiResponse<RestaurantList>>? searchResults;
  final List<String> recentSearches;

  HomeState copyWith({
    DataState<ApiResponse<UserData>>? userProfile,
    DataState<ApiResponse<RestaurantList>>? restaurants,
    DataState<ApiResponse<RestaurantList>>? featuredRestaurants,
    DataState<ApiResponse<RestaurantList>>? nearbyRestaurants,
    DataState<ApiResponse<RestaurantList>>? searchResults,
    List<String>? recentSearches,
  }) {
    return HomeState(
      userProfile: userProfile ?? this.userProfile,
      restaurants: restaurants ?? this.restaurants,
      featuredRestaurants: featuredRestaurants ?? this.featuredRestaurants,
      nearbyRestaurants: nearbyRestaurants ?? this.nearbyRestaurants,
      searchResults: searchResults ?? this.searchResults,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }

  @override
  List<Object?> get props => [
        userProfile,
        restaurants,
        featuredRestaurants,
        nearbyRestaurants,
        searchResults,
        recentSearches,
      ];
}
