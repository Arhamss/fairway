import 'package:fairway/core/enums/sort_options_enum.dart';
import 'package:fairway/fairway/features/home/domain/repositories/home_repository.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/models/saved_locations/saved_location_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';
import 'package:fairway/utils/helpers/toast_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.repository}) : super(const HomeState());

  final HomeRepository repository;

  Future<void> loadUserProfile() async {
    emit(state.copyWith(userProfile: const DataState.loading()));

    try {
      final response = await repository.getUserProfile();

      if (response.isSuccess && response.data != null) {
        emit(
          state.copyWith(
            userProfile: DataState.loaded(data: response.data),
          ),
        );
        AppLogger.info('User profile loaded in cubit');
      } else {
        emit(
          state.copyWith(
            userProfile: DataState.failure(
              error: response.message ?? 'Failed to load user profile',
            ),
          ),
        );
        AppLogger.error(
          'Failed to load user profile in cubit: ${response.message}',
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          userProfile: DataState.failure(error: e.toString()),
        ),
      );
      AppLogger.error('Exception in loadUserProfile: $e');
    }
  }

  // Update the getRestaurants method for nearby restaurants
  Future<void> getRestaurants() async {
    emit(
      state.copyWith(
        restaurants: const DataState.loading(),
        nearbyCurrentPage: 1, // Reset page number
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

  // Update loadMoreRestaurants for nearby restaurants
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

  // Add loadBestPartners with pagination support
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

  // Add loadMoreBestPartners method
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

  // Update resetPagination to handle both states
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

  Future<void> loadNearbyRestaurants({String? airport, int limit = 5}) async {
    emit(state.copyWith(nearbyRestaurants: const DataState.loading()));

    try {
      final userAirport = airport ??
          state.userProfile.data?.savedLocations
              .firstWhere((loc) => loc.isCurrent, orElse: SavedLocation.empty)
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

  Future<void> loadAllRestaurantsData() async {
    await loadBestPartners();
    await loadNearbyRestaurants();
  }

  Future<void> searchRestaurants(String query) async {
    emit(state.copyWith(searchResults: const DataState.loading()));

    try {
      final response = await repository.searchRestaurants(query);

      if (response.isSuccess && response.data != null) {
        // Add query to recent searches
        _addToRecentSearches(query);

        emit(
          state.copyWith(
            searchResults: DataState.loaded(data: response.data),
          ),
        );
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

  void _addToRecentSearches(String query) {
    final updatedSearches = List<String>.from(state.recentSearches);
    if (!updatedSearches.contains(query)) {
      updatedSearches.insert(0, query);
    }
    emit(state.copyWith(recentSearches: updatedSearches));
  }

  void clearRecentSearches() {
    emit(state.copyWith(recentSearches: []));
  }

  void setFilterExpanded(bool isExpanded) {
    if (!isExpanded) {
      emit(
        state.copyWith(
          isFilterExpanded: isExpanded,
          selectedTabIndex: 0,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        isFilterExpanded: isExpanded,
      ),
    );
  }

  void setSelectedTabIndex(int index) {
    emit(
      state.copyWith(selectedTabIndex: index),
    );
  }

  void setSelectedSortOption(SortByOption option) {
    emit(
      state.copyWith(selectedSortOption: option),
    );
  }

  void setSelectedFilter(String filter) {
    emit(
      state.copyWith(selectedFilter: filter),
    );
  }

  void selectOrderMethod(String method) {
    emit(state.copyWith(selectedOrderMethod: method));
  }

  void clearOrderMethod() {
    emit(state.copyWith());
  }
}
