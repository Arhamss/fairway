import 'package:equatable/equatable.dart';
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
    this.isFilterExpanded = false,
    this.selectedTabIndex = 0,
  });

  final DataState<UserData> userProfile;
  final DataState<RestaurantList> restaurants;
  final DataState<RestaurantList> featuredRestaurants;
  final DataState<RestaurantList> nearbyRestaurants;
  final DataState<RestaurantList> searchResults;
  final List<String> recentSearches;
  final bool isFilterExpanded;
  final int selectedTabIndex;

  HomeState copyWith({
    DataState<UserData>? userProfile,
    DataState<RestaurantList>? restaurants,
    DataState<RestaurantList>? featuredRestaurants,
    DataState<RestaurantList>? nearbyRestaurants,
    DataState<RestaurantList>? searchResults,
    List<String>? recentSearches,
    bool? isFilterExpanded,
    int? selectedTabIndex,
  }) {
    return HomeState(
      userProfile: userProfile ?? this.userProfile,
      restaurants: restaurants ?? this.restaurants,
      featuredRestaurants: featuredRestaurants ?? this.featuredRestaurants,
      nearbyRestaurants: nearbyRestaurants ?? this.nearbyRestaurants,
      searchResults: searchResults ?? this.searchResults,
      recentSearches: recentSearches ?? this.recentSearches,
      isFilterExpanded: isFilterExpanded ?? this.isFilterExpanded,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
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
        isFilterExpanded,
        selectedTabIndex,
      ];
}
