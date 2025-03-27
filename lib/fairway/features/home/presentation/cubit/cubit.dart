import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairway/fairway/features/home/domain/repositories/home_repository.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.repository}) : super(const HomeState());

  final HomeRepository repository;

  Future<void> loadUserProfile() async {
    emit(state.copyWith(userProfile: const DataState.loading()));

    try {
      final response = await repository.getUserProfile();

      if (response.isSuccess && response.data?.data != null) {
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

      if (response.isSuccess && response.data?.data != null) {
        emit(
          state.copyWith(
            restaurants: DataState.loaded(data: response.data),
          ),
        );
        AppLogger.info('Restaurants loaded in cubit');
      } else {
        emit(
          state.copyWith(
            restaurants: DataState.failure(
              error: response.message ?? 'Failed to load restaurants',
            ),
          ),
        );
        AppLogger.error(
          'Failed to load restaurants in cubit: ${response.message}',
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

  // Load featured restaurants (for best partners)
  Future<void> loadFeaturedRestaurants({int limit = 5}) async {
    emit(state.copyWith(featuredRestaurants: const DataState.loading()));

    try {
      final response = await repository.getRestaurants();

      if (response.isSuccess && response.data?.data != null) {
        emit(
          state.copyWith(
            featuredRestaurants: DataState.loaded(data: response.data),
          ),
        );
      } else {
        emit(
          state.copyWith(
            featuredRestaurants: DataState.failure(
              error: response.message ?? 'Failed to load featured restaurants',
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          featuredRestaurants: DataState.failure(error: e.toString()),
        ),
      );
    }
  }

  // Load nearby restaurants based on user location
  Future<void> loadNearbyRestaurants({String? airport, int limit = 5}) async {
    emit(state.copyWith(nearbyRestaurants: const DataState.loading()));

    try {
      // Get user's airport from profile if not provided
      final userAirport =
          airport ?? state.userProfile?.data?.data?.location ?? '';

      final response = await repository.getRestaurants();

      if (response.isSuccess && response.data?.data != null) {
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

  // Load both featured and nearby restaurants at once
  Future<void> loadAllRestaurantsData() async {
    await loadFeaturedRestaurants();
    await loadNearbyRestaurants();
  }

  Future<void> searchRestaurants(String query) async {
    emit(state.copyWith(searchResults: const DataState.loading()));

    try {
      final response = await repository.searchRestaurants(query);

      if (response.isSuccess && response.data?.data != null) {
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

  // Add a query to recent searches
  void _addToRecentSearches(String query) {
    final updatedSearches = List<String>.from(state.recentSearches);
    if (!updatedSearches.contains(query)) {
      updatedSearches.insert(0, query); // Add to the top
    }
    emit(state.copyWith(recentSearches: updatedSearches));
  }

  // Clear all recent searches
  void clearRecentSearches() {
    emit(state.copyWith(recentSearches: []));
  }
}
