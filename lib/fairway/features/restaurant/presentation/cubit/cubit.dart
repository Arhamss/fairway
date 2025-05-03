import 'dart:async';

import 'package:fairway/constants/constants.dart';
import 'package:fairway/core/enums/order_method.dart';
import 'package:fairway/core/enums/restaurant_filter.dart';
import 'package:fairway/core/enums/sort_options_enum.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/features/restaurant/domain/repository/restaurant_repository.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:fairway/utils/helpers/toast_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit({required this.repository}) : super(const RestaurantState()) {
    loadBestPartners();
    getNearbyRestaurant();
  }

  final RestaurantRepository repository;
  Timer? _debounceTimer;

  Future<void> loadBestPartners({
    int page = 1,
    int limit = AppConstants.paginationPageLimit,
    SortByOption? sortBy,
    bool showLoading = true,
  }) async {
    if (showLoading && page == 1) {
      emit(
        state.copyWith(
          bestPartnerRestaurants: const DataState.loading(),
          bestPartnersCurrentPage: 1,
        ),
      );
    } else if (page > 1) {
      emit(
        state.copyWith(
          bestPartnerRestaurants:
              DataState.pageLoading(data: state.bestPartnerRestaurants.data),
        ),
      );
    }

    try {
      final response = await repository.getBestPartnerRestaurants(
        page: page,
        limit: limit,
        sortBy: sortBy,
      );

      if (response.isSuccess && response.data != null) {
        final newRestaurants = response.data!;

        final previousList = state.bestPartnerRestaurants.isLoaded ||
                state.bestPartnerRestaurants.isPageLoading
            ? state.bestPartnerRestaurants.data?.restaurants ?? []
            : <RestaurantModel>[];

        final combined = page == 1
            ? newRestaurants.restaurants
            : [...previousList, ...newRestaurants.restaurants];

        final updatedResponse = newRestaurants.copyWith(restaurants: combined);

        emit(
          state.copyWith(
            bestPartnerRestaurants: DataState.loaded(data: updatedResponse),
            bestPartnersCurrentPage: page,
          ),
        );
      } else {
        emit(
          state.copyWith(
            bestPartnerRestaurants: DataState.failure(
              error: response.message ?? 'Failed to load restaurants',
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          bestPartnerRestaurants: DataState.failure(error: e.toString()),
        ),
      );
    }
  }

  Future<void> getNearbyRestaurant({
    int page = 1,
    int limit = AppConstants.paginationPageLimit,
    SortByOption? sortBy,
    bool showLoading = true,
  }) async {
    if (showLoading && page == 1) {
      emit(
        state.copyWith(
          nearbyRestaurants: const DataState.loading(),
          nearbyCurrentPage: 1,
        ),
      );
    } else if (page > 1) {
      emit(
        state.copyWith(
          nearbyRestaurants:
              DataState.pageLoading(data: state.nearbyRestaurants.data),
        ),
      );
    }

    final response = await repository.getRestaurants(
      filter: RestaurantTag.nearby,
      page: page,
      limit: limit,
      sortBy: sortBy,
    );

    if (response.isSuccess && response.data != null) {
      final newRestaurants = response.data!;

      final previousList = state.nearbyRestaurants.isLoaded ||
              state.nearbyRestaurants.isPageLoading
          ? state.nearbyRestaurants.data?.restaurants ?? []
          : <RestaurantModel>[];

      final combined = page == 1
          ? newRestaurants.restaurants
          : [...previousList, ...newRestaurants.restaurants];

      final updatedResponse = newRestaurants.copyWith(restaurants: combined);

      emit(
        state.copyWith(
          nearbyRestaurants: DataState.loaded(data: updatedResponse),
          nearbyCurrentPage: page,
        ),
      );
    } else {
      emit(
        state.copyWith(
          nearbyRestaurants: DataState.failure(
            error: response.message ?? 'Failed to load restaurants',
          ),
        ),
      );
    }
  }

  Future<void> getDiscountRestaurants({
    int page = 1,
    int limit = AppConstants.paginationPageLimit,
    SortByOption? sortBy,
    bool showLoading = true,
  }) async {
    if (showLoading && page == 1) {
      emit(
        state.copyWith(
          discountRestaurants: const DataState.loading(),
          discountCurrentPage: 1,
        ),
      );
    } else if (page > 1) {
      emit(
        state.copyWith(
          discountRestaurants:
              DataState.pageLoading(data: state.discountRestaurants.data),
        ),
      );
    }

    final response = await repository.getRestaurants(
      filter: RestaurantTag.discounts,
      page: page,
      limit: limit,
      sortBy: sortBy,
    );

    if (response.isSuccess && response.data != null) {
      final newRestaurants = response.data!;

      final previousList = state.discountRestaurants.isLoaded ||
              state.discountRestaurants.isPageLoading
          ? state.discountRestaurants.data?.restaurants ?? []
          : <RestaurantModel>[];

      final combined = page == 1
          ? newRestaurants.restaurants
          : [...previousList, ...newRestaurants.restaurants];

      final updatedResponse = newRestaurants.copyWith(restaurants: combined);

      emit(
        state.copyWith(
          discountRestaurants: DataState.loaded(data: updatedResponse),
          discountCurrentPage: page,
        ),
      );
    } else {
      emit(
        state.copyWith(
          discountRestaurants: DataState.failure(
            error: response.message ?? 'Failed to load discount restaurants',
          ),
        ),
      );
    }
  }

  Future<void> getExpressRestaurants({
    int page = 1,
    int limit = AppConstants.paginationPageLimit,
    SortByOption? sortBy,
    bool showLoading = true,
  }) async {
    if (showLoading && page == 1) {
      emit(
        state.copyWith(
          expressRestaurants: const DataState.loading(),
          expressCurrentPage: 1,
        ),
      );
    } else if (page > 1) {
      emit(
        state.copyWith(
          expressRestaurants:
              DataState.pageLoading(data: state.expressRestaurants.data),
        ),
      );
    }

    final response = await repository.getRestaurants(
      filter: RestaurantTag.express,
      page: page,
      limit: limit,
      sortBy: sortBy,
    );

    if (response.isSuccess && response.data != null) {
      final newRestaurants = response.data!;

      final previousList = state.expressRestaurants.isLoaded ||
              state.expressRestaurants.isPageLoading
          ? state.expressRestaurants.data?.restaurants ?? []
          : <RestaurantModel>[];

      final combined = page == 1
          ? newRestaurants.restaurants
          : [...previousList, ...newRestaurants.restaurants];

      final updatedResponse = newRestaurants.copyWith(restaurants: combined);

      emit(
        state.copyWith(
          expressRestaurants: DataState.loaded(data: updatedResponse),
          expressCurrentPage: page,
        ),
      );
    } else {
      emit(
        state.copyWith(
          expressRestaurants: DataState.failure(
            error: response.message ?? 'Failed to load express restaurants',
          ),
        ),
      );
    }
  }

  Future<void> getDrinksRestaurants({
    int page = 1,
    int limit = AppConstants.paginationPageLimit,
    SortByOption? sortBy,
    bool showLoading = true,
  }) async {
    if (showLoading && page == 1) {
      emit(
        state.copyWith(
          drinksRestaurants: const DataState.loading(),
          drinksCurrentPage: 1,
        ),
      );
    } else if (page > 1) {
      emit(
        state.copyWith(
          drinksRestaurants:
              DataState.pageLoading(data: state.drinksRestaurants.data),
        ),
      );
    }

    final response = await repository.getRestaurants(
      filter: RestaurantTag.drinks,
      page: page,
      limit: limit,
      sortBy: sortBy,
    );

    if (response.isSuccess && response.data != null) {
      final newRestaurants = response.data!;

      final previousList = state.drinksRestaurants.isLoaded ||
              state.drinksRestaurants.isPageLoading
          ? state.drinksRestaurants.data?.restaurants ?? []
          : <RestaurantModel>[];

      final combined = page == 1
          ? newRestaurants.restaurants
          : [...previousList, ...newRestaurants.restaurants];

      final updatedResponse = newRestaurants.copyWith(restaurants: combined);

      emit(
        state.copyWith(
          drinksRestaurants: DataState.loaded(data: updatedResponse),
          drinksCurrentPage: page,
        ),
      );
    } else {
      emit(
        state.copyWith(
          drinksRestaurants: DataState.failure(
            error: response.message ?? 'Failed to load drink spots',
          ),
        ),
      );
    }
  }

  Future<void> getFilteredRestaurants({
    int page = 1,
    int limit = AppConstants.paginationPageLimit,
    SortByOption? sortBy,
    String? categoryId,
    bool showLoading = true,
  }) async {
    if (showLoading && page == 1) {
      emit(
        state.copyWith(
          filteredRestaurants: const DataState.loading(),
          filteredRestaurantsCurrentPage: 1,
        ),
      );
    } else if (page > 1) {
      emit(
        state.copyWith(
          filteredRestaurants:
              DataState.pageLoading(data: state.filteredRestaurants.data),
        ),
      );
    }

    final response = await repository.getFilteredRestaurants(
      page: page,
      limit: limit,
      sortBy: sortBy,
      categoryId: categoryId,
    );

    if (response.isSuccess && response.data != null) {
      final newRestaurants = response.data!;

      final previousList = state.filteredRestaurants.isLoaded ||
              state.filteredRestaurants.isPageLoading
          ? state.filteredRestaurants.data?.restaurants ?? []
          : <RestaurantModel>[];

      final combined = page == 1
          ? newRestaurants.restaurants
          : [...previousList, ...newRestaurants.restaurants];

      final updatedResponse = newRestaurants.copyWith(restaurants: combined);

      emit(
        state.copyWith(
          filteredRestaurants: DataState.loaded(data: updatedResponse),
          filteredRestaurantsCurrentPage: page,
        ),
      );
    } else {
      emit(
        state.copyWith(
          filteredRestaurants: DataState.failure(
            error: response.message ?? 'Failed to load filtered restaurants',
          ),
        ),
      );
    }
  }

  Future<void> loadCategories() async {
    emit(
      state.copyWith(
        categories: const DataState.loading(),
      ),
    );

    final response = await repository.getCategories();

    if (response.isSuccess && response.data != null) {
      emit(
        state.copyWith(
          categories: DataState.loaded(data: response.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          categories: DataState.failure(error: response.message),
        ),
      );
    }
  }

  // Future<void> loadMoreRestaurants() async {
  //   if (state.isLoadingMoreNearby || !state.hasMoreNearbyRestaurants) {
  //     return;
  //   }
  //
  //   emit(state.copyWith(isLoadingMoreNearby: true));
  //
  //   final nextPage = state.nearbyCurrentPage + 1;
  //
  //   final response = await repository.getRestaurants(page: nextPage);
  //
  //   if (response.isSuccess && response.data != null) {
  //     final newData = response.data!;
  //     final currentData = state.restaurants.data!;
  //
  //     final hasMore = newData.restaurants.length >= 5;
  //
  //     final combinedRestaurants = [
  //       ...currentData.restaurants,
  //       ...newData.restaurants,
  //     ];
  //
  //     final updatedData = currentData.copyWith(
  //       restaurants: combinedRestaurants,
  //       currentPage: nextPage,
  //     );
  //
  //     emit(
  //       state.copyWith(
  //         restaurants: DataState.loaded(data: updatedData),
  //         nearbyCurrentPage: nextPage,
  //         hasMoreNearbyRestaurants: hasMore,
  //         isLoadingMoreNearby: false,
  //       ),
  //     );
  //   } else {
  //     emit(
  //       state.copyWith(
  //         isLoadingMoreNearby: false,
  //       ),
  //     );
  //
  //     ToastHelper.showErrorToast(
  //       response.message ?? 'Failed to load more restaurants',
  //     );
  //   }
  // }

  Future<void> loadMoreBestPartners({int limit = 5}) async {
    if (state.isLoadingMoreBestPartners) {
      return;
    }

    emit(state.copyWith(isLoadingMoreBestPartners: true));

    final nextPage = state.bestPartnersCurrentPage + 1;

    try {
      final response = await repository.getBestPartnerRestaurants(
        page: nextPage,
        limit: limit,
      );

      if (response.isSuccess && response.data != null) {
        final newRestaurants = response.data!.restaurants;
        final hasMore = newRestaurants.length >= limit;

        if (state.bestPartnerRestaurants.data != null) {
          final currentRestaurants =
              state.bestPartnerRestaurants.data!.restaurants;
          final allRestaurants = [...currentRestaurants, ...newRestaurants];

          final updatedData = state.bestPartnerRestaurants.data!.copyWith(
            restaurants: allRestaurants,
          );

          emit(
            state.copyWith(
              bestPartnerRestaurants: DataState.loaded(data: updatedData),
              bestPartnersCurrentPage: nextPage,
              isLoadingMoreBestPartners: false,
            ),
          );
        }
      } else {
        emit(state.copyWith(isLoadingMoreBestPartners: false));
        ToastHelper.showErrorToast(
          response.message ?? 'Failed to load more best partners',
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoadingMoreBestPartners: false));
      ToastHelper.showErrorToast('Failed to load more best partners: $e');
    }
  }

  void resetBestPartnersPagination() {
    emit(
      state.copyWith(
        bestPartnersCurrentPage: 1,
        isLoadingMoreBestPartners: false,
      ),
    );
  }

  Future<void> searchRestaurants(String query) async {
    await repository.searchRestaurants(query);
  }

  Future<void> getSearchSuggestions(String query) async {
    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchSuggestions: const DataState.initial(),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        searchSuggestions: const DataState.loading(),
      ),
    );

    final response = await repository.getSearchSuggestions(query);

    if (response.isSuccess && response.data != null) {
      emit(
        state.copyWith(
          searchSuggestions: DataState.loaded(data: response.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          searchSuggestions: DataState.failure(error: response.message),
        ),
      );
    }
  }

  Future<void> loadRecentSearches() async {
    emit(
      state.copyWith(
        recentSearchesData: const DataState.loading(),
      ),
    );

    final response = await repository.getRecentSearches();

    if (response.isSuccess && response.data != null) {
      emit(
        state.copyWith(
          recentSearchesData: DataState.loaded(data: response.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          recentSearchesData: DataState.failure(error: response.message),
        ),
      );
    }
  }

  void onSearchTextChanged(String query) {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchSuggestions: const DataState.initial(),
        ),
      );
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _getSuggestionsAndResetResults(query);
    });
  }

  Future<void> _getSuggestionsAndResetResults(String query) async {
    emit(
      state.copyWith(
        searchSuggestions: const DataState.loading(),
      ),
    );

    final response = await repository.getSearchSuggestions(query);

    if (response.isSuccess && response.data != null) {
      emit(
        state.copyWith(
          searchSuggestions: DataState.loaded(data: response.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          searchSuggestions: DataState.failure(
            error: response.message ?? 'Failed to fetch suggestions',
          ),
        ),
      );
    }
  }

  void clearSearch() {
    emit(
      state.copyWith(
        searchSuggestions: const DataState.initial(),
      ),
    );
  }

  /// Resets all search-related state when leaving the search screen
  void resetSearchState() {
    emit(
      state.copyWith(
        searchSuggestions: const DataState.initial(),
      ),
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  void clearRecentSearches() {
    emit(
      state.copyWith(
        recentSearchesData: const DataState.initial(),
      ),
    );

    repository.clearRecentSearch().then((response) {
      if (response.isSuccess) {
        emit(
          state.copyWith(
            recentSearchesData: const DataState.initial(),
          ),
        );
      } else {
        emit(
          state.copyWith(
            recentSearchesData: DataState.failure(error: response.message),
          ),
        );
      }
    }).catchError((error) {
      emit(
        state.copyWith(
          recentSearchesData: DataState.failure(error: error.toString()),
        ),
      );
    });
  }

  void setSelectedSortOption(SortByOption option) {
    emit(
      state.copyWith(
        selectedSortOption: option,
      ),
    );
  }

  void setSelectedFilter(RestaurantTag filter) {
    emit(
      state.copyWith(selectedFilter: filter),
    );
  }

  void setSelectedCategoryIndex(int index) {
    emit(
      state.copyWith(selectedCategoryIndex: index),
    );
  }

  void setSelectedCategoryId(String id) {
    emit(
      state.copyWith(selectedCategoryId: id),
    );
  }

  void resetSelectedCategory() {
    emit(
      state.copyWith(),
    );
  }

  void updateSelectedCategory(int index, String id) {
    emit(
      state.copyWith(
        selectedCategoryIndex: index,
        selectedCategoryId: id,
      ),
    );
  }

  void updateSortOption(SortByOption option) {
    emit(
      state.copyWith(
        selectedSortOption: option,
      ),
    );
  }
}
