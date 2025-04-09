import 'package:equatable/equatable.dart';
import 'package:fairway/core/enums/sort_options_enum.dart';
import 'package:fairway/fairway/features/restaurant/data/model/recent_searches_model.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_response_model.dart';
import 'package:fairway/fairway/features/restaurant/data/model/search_suggestions_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class RestaurantState extends Equatable {
  const RestaurantState({
    this.restaurants = const DataState.initial(),
    this.bestPartnerRestaurants = const DataState.initial(),
    this.nearbyRestaurants = const DataState.initial(),
    this.searchResults = const DataState.initial(),
    this.searchSuggestions = const DataState.initial(),
    this.recentSearchesData = const DataState.initial(),
    this.recentSearches = const [],
    this.selectedFilter = 'Nearby',
    this.selectedSortOption = SortByOption.mostPopular,
    this.nearbyCurrentPage = 1,
    this.hasMoreNearbyRestaurants = true,
    this.isLoadingMoreNearby = false,
    this.bestPartnersCurrentPage = 1,
    this.hasMoreBestPartners = true,
    this.isLoadingMoreBestPartners = false,
    this.selectedOrderMethod,
  });

  final DataState<RestaurantResponseModel> restaurants;
  final DataState<RestaurantResponseModel> bestPartnerRestaurants;
  final DataState<RestaurantResponseModel> nearbyRestaurants;
  final DataState<RestaurantResponseModel> searchResults;
  final DataState<SearchSuggestionsModel> searchSuggestions;
  final DataState<RecentSearchesModel> recentSearchesData;
  final List<String> recentSearches;
  final String selectedFilter;
  final SortByOption selectedSortOption;

  // Nearby restaurants pagination
  final int nearbyCurrentPage;
  final bool hasMoreNearbyRestaurants;
  final bool isLoadingMoreNearby;

  // Best partners pagination
  final int bestPartnersCurrentPage;
  final bool hasMoreBestPartners;
  final bool isLoadingMoreBestPartners;

  final String? selectedOrderMethod; // 'Pick Yourself' or 'Concierge'

  // Maintaining backward compatibility
  int get currentPage => nearbyCurrentPage;
  bool get hasMoreRestaurants => hasMoreNearbyRestaurants;
  bool get isLoadingMore => isLoadingMoreNearby;
  bool get isIdle => searchSuggestions.isInitial && searchResults.isInitial;

  RestaurantState copyWith({
    DataState<RestaurantResponseModel>? restaurants,
    DataState<RestaurantResponseModel>? bestPartnerRestaurants,
    DataState<RestaurantResponseModel>? nearbyRestaurants,
    DataState<RestaurantResponseModel>? searchResults,
    DataState<SearchSuggestionsModel>? searchSuggestions,
    DataState<RecentSearchesModel>? recentSearchesData,
    List<String>? recentSearches,
    String? selectedFilter,
    SortByOption? selectedSortOption,

    // Nearby restaurants pagination
    int? nearbyCurrentPage,
    bool? hasMoreNearbyRestaurants,
    bool? isLoadingMoreNearby,

    // Best partners pagination
    int? bestPartnersCurrentPage,
    bool? hasMoreBestPartners,
    bool? isLoadingMoreBestPartners,

    // Legacy fields (for backward compatibility)
    int? currentPage,
    bool? hasMoreRestaurants,
    bool? isLoadingMore,
    String? selectedOrderMethod,
  }) {
    return RestaurantState(
      restaurants: restaurants ?? this.restaurants,
      bestPartnerRestaurants:
          bestPartnerRestaurants ?? this.bestPartnerRestaurants,
      nearbyRestaurants: nearbyRestaurants ?? this.nearbyRestaurants,
      searchResults: searchResults ?? this.searchResults,
      searchSuggestions: searchSuggestions ?? this.searchSuggestions,
      recentSearchesData: recentSearchesData ?? this.recentSearchesData,
      recentSearches: recentSearches ?? this.recentSearches,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,

      // Use the legacy fields or new fields
      nearbyCurrentPage:
          nearbyCurrentPage ?? currentPage ?? this.nearbyCurrentPage,
      hasMoreNearbyRestaurants: hasMoreNearbyRestaurants ??
          hasMoreRestaurants ??
          this.hasMoreNearbyRestaurants,
      isLoadingMoreNearby:
          isLoadingMoreNearby ?? isLoadingMore ?? this.isLoadingMoreNearby,

      bestPartnersCurrentPage:
          bestPartnersCurrentPage ?? this.bestPartnersCurrentPage,
      hasMoreBestPartners: hasMoreBestPartners ?? this.hasMoreBestPartners,
      isLoadingMoreBestPartners:
          isLoadingMoreBestPartners ?? this.isLoadingMoreBestPartners,

      selectedOrderMethod: selectedOrderMethod ?? this.selectedOrderMethod,
    );
  }

  @override
  List<Object?> get props => [
        restaurants,
        bestPartnerRestaurants,
        nearbyRestaurants,
        searchResults,
        searchSuggestions,
        recentSearchesData,
        recentSearches,
        selectedFilter,
        selectedSortOption,
        nearbyCurrentPage,
        hasMoreNearbyRestaurants,
        isLoadingMoreNearby,
        bestPartnersCurrentPage,
        hasMoreBestPartners,
        isLoadingMoreBestPartners,
        selectedOrderMethod,
      ];
}
