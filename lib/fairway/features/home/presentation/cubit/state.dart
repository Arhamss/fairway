import 'package:equatable/equatable.dart';
import 'package:fairway/core/enums/sort_options_enum.dart';
import 'package:fairway/fairway/models/restaurant_response_model.dart';
import 'package:fairway/fairway/models/user_model/user_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class HomeState extends Equatable {
  const HomeState({
    this.userProfile = const DataState.initial(),
    this.restaurants = const DataState.initial(),
    this.bestPartnerRestaurants = const DataState.initial(),
    this.nearbyRestaurants = const DataState.initial(),
    this.searchResults = const DataState.initial(),
    this.recentSearches = const [],
    this.isFilterExpanded = false,
    this.selectedTabIndex = 0,
    this.selectedSortOption = SortByOption.mostPopular,
  });

  final DataState<UserModel> userProfile;
  final DataState<RestaurantResponseModel> restaurants;
  final DataState<RestaurantResponseModel> bestPartnerRestaurants;
  final DataState<RestaurantResponseModel> nearbyRestaurants;
  final DataState<RestaurantResponseModel> searchResults;
  final List<String> recentSearches;
  final bool isFilterExpanded;
  final int selectedTabIndex;
  final SortByOption selectedSortOption;
  HomeState copyWith({
    DataState<UserModel>? userProfile,
    DataState<RestaurantResponseModel>? restaurants,
    DataState<RestaurantResponseModel>? bestPartnerRestaurants,
    DataState<RestaurantResponseModel>? nearbyRestaurants,
    DataState<RestaurantResponseModel>? searchResults,
    List<String>? recentSearches,
    bool? isFilterExpanded,
    int? selectedTabIndex,
    SortByOption? selectedSortOption,
  }) {
    return HomeState(
      userProfile: userProfile ?? this.userProfile,
      restaurants: restaurants ?? this.restaurants,
      bestPartnerRestaurants:
          bestPartnerRestaurants ?? this.bestPartnerRestaurants,
      nearbyRestaurants: nearbyRestaurants ?? this.nearbyRestaurants,
      searchResults: searchResults ?? this.searchResults,
      recentSearches: recentSearches ?? this.recentSearches,
      isFilterExpanded: isFilterExpanded ?? this.isFilterExpanded,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
    );
  }

  @override
  List<Object?> get props => [
        userProfile,
        restaurants,
        bestPartnerRestaurants,
        nearbyRestaurants,
        searchResults,
        recentSearches,
        isFilterExpanded,
        selectedTabIndex,
        selectedSortOption,
      ];
}
