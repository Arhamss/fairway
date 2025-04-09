import 'dart:async';

import 'package:fairway/core/enums/sort_options_enum.dart';
import 'package:fairway/fairway/features/restaurant/domain/repository/restaurant_repository.dart';
import 'package:fairway/fairway/features/restaurant/presentation/cubit/state.dart';
import 'package:fairway/fairway/models/saved_locations/saved_location_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:fairway/utils/helpers/toast_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit({required this.repository}) : super(const RestaurantState());

  final RestaurantRepository repository;
  Timer? _debounceTimer;

  Future<void> getRestaurants() async {
    emit(
      state.copyWith(
        restaurants: const DataState.loading(),
        nearbyCurrentPage: 1,
      ),
    );

    final response = await repository.getRestaurants();

    if (response.isSuccess && response.data != null) {
      final hasMore = response.data!.restaurants.length >= 5;
      emit(
        state.copyWith(
          restaurants: DataState.loaded(data: response.data),
          nearbyCurrentPage: 1,
          hasMoreNearbyRestaurants: hasMore,
        ),
      );
    } else {
      emit(
        state.copyWith(
          restaurants: DataState.failure(
            error: response.message ?? 'Failed to load restaurants',
          ),
        ),
      );
    }
  }

  Future<void> loadMoreRestaurants() async {
    if (state.isLoadingMoreNearby || !state.hasMoreNearbyRestaurants) {
      return;
    }

    emit(state.copyWith(isLoadingMoreNearby: true));

    final nextPage = state.nearbyCurrentPage + 1;

    final response = await repository.getRestaurants(page: nextPage);

    if (response.isSuccess && response.data != null) {
      final newData = response.data!;
      final currentData = state.restaurants.data!;

      final hasMore = newData.restaurants.length >= 5;

      final combinedRestaurants = [
        ...currentData.restaurants,
        ...newData.restaurants,
      ];

      final updatedData = currentData.copyWith(
        restaurants: combinedRestaurants,
        currentPage: nextPage,
      );

      emit(
        state.copyWith(
          restaurants: DataState.loaded(data: updatedData),
          nearbyCurrentPage: nextPage,
          hasMoreNearbyRestaurants: hasMore,
          isLoadingMoreNearby: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoadingMoreNearby: false,
        ),
      );

      ToastHelper.showErrorToast(
        response.message ?? 'Failed to load more restaurants',
      );
    }
  }

  Future<void> loadBestPartners({int limit = 5}) async {
    emit(
      state.copyWith(
        bestPartnerRestaurants: const DataState.loading(),
        bestPartnersCurrentPage: 1, // Reset page number
      ),
    );

    try {
      final response = await repository.getBestPartnerRestaurants(limit: limit);

      if (response.isSuccess && response.data != null) {
        final hasMore = response.data!.restaurants.length >= limit;
        emit(
          state.copyWith(
            bestPartnerRestaurants: DataState.loaded(data: response.data),
            bestPartnersCurrentPage: 1,
            hasMoreBestPartners: hasMore,
          ),
        );
      } else {
        emit(
          state.copyWith(
            bestPartnerRestaurants: DataState.failure(
              error: response.message ?? 'Failed to load best partners',
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

  Future<void> loadMoreBestPartners({int limit = 5}) async {
    if (state.isLoadingMoreBestPartners || !state.hasMoreBestPartners) {
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
              hasMoreBestPartners: hasMore,
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

  void resetNearbyPagination() {
    emit(
      state.copyWith(
        nearbyCurrentPage: 1,
        hasMoreNearbyRestaurants: true,
        isLoadingMoreNearby: false,
      ),
    );
  }

  void resetBestPartnersPagination() {
    emit(
      state.copyWith(
        bestPartnersCurrentPage: 1,
        hasMoreBestPartners: true,
        isLoadingMoreBestPartners: false,
      ),
    );
  }

  Future<void> loadNearbyRestaurants({
    required List<SavedLocation>? savedLocations,
    String? airport,
    int limit = 5,
  }) async {
    emit(state.copyWith(nearbyRestaurants: const DataState.loading()));

    try {
      final userAirport = airport ??
          savedLocations
              ?.firstWhere((loc) => loc.isCurrent, orElse: SavedLocation.empty)
              .airportName;

      final response = await repository.getRestaurants();

      if (response.isSuccess && response.data != null) {
        emit(
          state.copyWith(
            nearbyRestaurants: DataState.loaded(data: response.data),
          ),
        );
      } else {
        emit(
          state.copyWith(
            nearbyRestaurants: DataState.failure(
              error: response.message ?? 'Failed to load nearby restaurants',
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          nearbyRestaurants: DataState.failure(error: e.toString()),
        ),
      );
    }
  }

  Future<void> loadAllRestaurantsData({
    required List<SavedLocation>? savedLocations,
  }) async {
    await loadBestPartners();
    await loadNearbyRestaurants(savedLocations: savedLocations);
  }

  Future<void> searchRestaurants(String query) async {
    emit(state.copyWith(searchResults: const DataState.loading()));

    try {
      final response = await repository.searchRestaurants(query);

      if (response.isSuccess && response.data != null) {
        emit(
          state.copyWith(
            searchResults: DataState.loaded(data: response.data),
          ),
        );

        // Refresh recent searches after successful search
        await loadRecentSearches();
      } else {
        emit(
          state.copyWith(
            searchResults: DataState.failure(
              error: response.message ?? 'No results found',
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          searchResults: DataState.failure(error: e.toString()),
        ),
      );
    }
  }

  Future<void> getSearchSuggestions(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(searchSuggestions: const DataState.initial()));
      return;
    }

    emit(state.copyWith(searchSuggestions: const DataState.loading()));

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
    emit(state.copyWith(recentSearchesData: const DataState.loading()));

    final response = await repository.getRecentSearches();

    if (response.isSuccess && response.data != null) {
      emit(
        state.copyWith(
          recentSearchesData: DataState.loaded(data: response.data),
          recentSearches: response.data?.recentSearches,
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
          searchResults: const DataState.initial(),
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
      emit(state.copyWith(
        searchSuggestions: DataState.loaded(data: response.data),
        searchResults: const DataState.initial(), // clear previous results
      ));
    } else {
      emit(state.copyWith(
        searchSuggestions: DataState.failure(
          error: response.message ?? 'Failed to fetch suggestions',
        ),
      ));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  void clearRecentSearches() {
    emit(state.copyWith(recentSearches: []));
  }

  void selectOrderMethod(String method) {
    emit(state.copyWith(selectedOrderMethod: method));
  }

  void clearOrderMethod() {
    emit(state.copyWith());
  }

  void setSelectedSortOption(SortByOption option) {
    emit(
      state.copyWith(
        selectedSortOption: option,
      ),
    );
  }

  void setSelectedFilter(String filter) {
    emit(
      state.copyWith(selectedFilter: filter),
    );
  }
}
