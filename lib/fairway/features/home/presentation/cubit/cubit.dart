import 'package:fairway/core/enums/sort_options_enum.dart';
import 'package:fairway/fairway/features/home/domain/repositories/home_repository.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/models/saved_locations/saved_location_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';
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

  // Load all restaurants
  Future<void> loadRestaurants({
    String? category,
    String? airport,
    int page = 1,
    int limit = 10,
  }) async {
    emit(state.copyWith(restaurants: const DataState.loading()));

    try {
      final response = await repository.getRestaurants();

      if (response.isSuccess && response.data != null) {
        emit(
          state.copyWith(
            restaurants: DataState.loaded(data: response.data),
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
    } catch (e) {
      emit(
        state.copyWith(
          restaurants: DataState.failure(error: e.toString()),
        ),
      );
      AppLogger.error('Exception in loadRestaurants: $e');
    }
  }

  Future<void> loadBestPartners({int limit = 5}) async {
    emit(
      state.copyWith(
        bestPartnerRestaurants: const DataState.loading(),
      ),
    );

    try {
      final response = await repository.getRestaurants();

      if (response.isSuccess && response.data != null) {
        print('Best partners loaded successfully');
        print("Response: ${response.data}");
        print("Response length: ${response.data?.restaurants.length}");
        emit(
          state.copyWith(
            bestPartnerRestaurants: DataState.loaded(data: response.data),
          ),
        );
      } else {
        emit(
          state.copyWith(
            bestPartnerRestaurants: DataState.failure(
              error: response.message ?? 'Failed to load featured restaurants',
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
}
