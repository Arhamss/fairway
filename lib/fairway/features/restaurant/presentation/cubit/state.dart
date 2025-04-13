import 'package:equatable/equatable.dart';
import 'package:fairway/core/enums/order_method.dart';
import 'package:fairway/core/enums/restaurant_filter.dart';
import 'package:fairway/core/enums/sort_options_enum.dart';
import 'package:fairway/fairway/features/restaurant/data/model/recent_searches_model.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_response_model.dart';
import 'package:fairway/fairway/features/restaurant/data/model/search_suggestions_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class RestaurantState extends Equatable {
  const RestaurantState({
    this.bestPartnerRestaurants = const DataState.initial(),
    this.nearbyRestaurants = const DataState.initial(),
    this.discountRestaurants = const DataState.initial(),
    this.expressRestaurants = const DataState.initial(),
    this.drinksRestaurants = const DataState.initial(),
    this.searchSuggestions = const DataState.initial(),
    this.recentSearchesData = const DataState.initial(),
    this.selectedFilter = RestaurantTag.nearby,
    this.selectedSortOption = SortByOption.mostPopular,
    this.nearbyCurrentPage = 1,
    this.discountCurrentPage = 1,
    this.expressCurrentPage = 1,
    this.drinksCurrentPage = 1,
    this.bestPartnersCurrentPage = 1,
    this.isLoadingMoreBestPartners = false,
  });

  final DataState<RestaurantResponseModel> bestPartnerRestaurants;
  final DataState<RestaurantResponseModel> nearbyRestaurants;
  final DataState<RestaurantResponseModel> discountRestaurants;
  final DataState<RestaurantResponseModel> expressRestaurants;
  final DataState<RestaurantResponseModel> drinksRestaurants;
  final DataState<SearchSuggestionsModel> searchSuggestions;
  final DataState<RecentSearchesModel> recentSearchesData;
  final RestaurantTag selectedFilter;
  final SortByOption selectedSortOption;
  final int nearbyCurrentPage;
  final int discountCurrentPage;
  final int expressCurrentPage;
  final int drinksCurrentPage;
  final int bestPartnersCurrentPage;

  final bool isLoadingMoreBestPartners;

  bool get isIdle => searchSuggestions.isInitial && nearbyRestaurants.isInitial;

  RestaurantState copyWith({
    DataState<RestaurantResponseModel>? bestPartnerRestaurants,
    DataState<RestaurantResponseModel>? nearbyRestaurants,
    DataState<RestaurantResponseModel>? discountRestaurants,
    DataState<RestaurantResponseModel>? expressRestaurants,
    DataState<RestaurantResponseModel>? drinksRestaurants,
    DataState<SearchSuggestionsModel>? searchSuggestions,
    DataState<RecentSearchesModel>? recentSearchesData,
    RestaurantTag? selectedFilter,
    SortByOption? selectedSortOption,
    int? nearbyCurrentPage,
    int? discountCurrentPage,
    int? expressCurrentPage,
    int? drinksCurrentPage,
    int? bestPartnersCurrentPage,
    bool? isLoadingMoreBestPartners,
  }) {
    return RestaurantState(
      nearbyRestaurants: nearbyRestaurants ?? this.nearbyRestaurants,
      discountRestaurants: discountRestaurants ?? this.discountRestaurants,
      expressRestaurants: expressRestaurants ?? this.expressRestaurants,
      drinksRestaurants: drinksRestaurants ?? this.drinksRestaurants,
      bestPartnerRestaurants:
          bestPartnerRestaurants ?? this.bestPartnerRestaurants,
      searchSuggestions: searchSuggestions ?? this.searchSuggestions,
      recentSearchesData: recentSearchesData ?? this.recentSearchesData,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
      nearbyCurrentPage: nearbyCurrentPage ?? this.nearbyCurrentPage,
      bestPartnersCurrentPage:
          bestPartnersCurrentPage ?? this.bestPartnersCurrentPage,
      isLoadingMoreBestPartners:
          isLoadingMoreBestPartners ?? this.isLoadingMoreBestPartners,
      discountCurrentPage: discountCurrentPage ?? this.discountCurrentPage,
      expressCurrentPage: expressCurrentPage ?? this.expressCurrentPage,
      drinksCurrentPage: drinksCurrentPage ?? this.drinksCurrentPage,
    );
  }

  @override
  List<Object?> get props => [
        nearbyRestaurants,
        bestPartnerRestaurants,
        discountRestaurants,
        expressRestaurants,
        drinksRestaurants,
        nearbyCurrentPage,
        discountCurrentPage,
        expressCurrentPage,
        drinksCurrentPage,
        searchSuggestions,
        recentSearchesData,
        selectedFilter,
        selectedSortOption,
        nearbyCurrentPage,
        bestPartnersCurrentPage,
        isLoadingMoreBestPartners,
      ];
}
