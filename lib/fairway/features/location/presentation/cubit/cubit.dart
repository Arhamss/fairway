import 'package:fairway/core/permissions/permission_manager.dart';
import 'package:fairway/fairway/features/location/data/models/airport_model.dart';
import 'package:fairway/fairway/features/location/domain/repositories/location_repository.dart';
import 'package:fairway/fairway/features/location/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({required this.repository}) : super(const LocationState());

  final LocationRepository repository;

  Future<void> getCurrentLocation() async {
    emit(
      state.copyWith(
        location: const DataState.loading(),
        hasSelectedLocation: false,
        filteredAirports: [],
      ),
    );

    await PermissionManager.requestLocationPermission(
      grantedCallback: () async {
        try {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          AppLogger.info('Current location: $position');
          await loadAirports();
          emit(
            state.copyWith(
              location: DataState.loaded(data: position),
              hasSelectedLocation: true,
            ),
          );
        } catch (e) {
          AppLogger.error('Error getting location: $e');
          emit(
            state.copyWith(
              location: DataState.failure(error: e.toString()),
              hasSelectedLocation: false,
            ),
          );
        }
      },
      deniedCallback: () {
        emit(
          state.copyWith(
            location: const DataState.failure(
              error: 'Location permission is required to use this feature',
            ),
            hasSelectedLocation: false,
          ),
        );
      },
    );
  }

  Future<void> updateLocation() async {
    if (state.selectedAirport!.code.isEmpty) return;

    emit(
      state.copyWith(
        updateLocation: const DataState.loading(),
      ),
    );

    final response =
        await repository.updateUserLocation(state.selectedAirport!.code);

    if (response.isSuccess) {
      emit(
        state.copyWith(
          updateLocation: DataState.loaded(data: response.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          updateLocation: DataState.failure(error: response.message),
        ),
      );
    }
  }

  Future<void> loadAirports({
    String? query,
    String? code,
    int page = 1,
    int limit = 10,
  }) async {
    emit(state.copyWith(airports: const DataState.loading()));

    try {
      final long = state.location.data?.longitude;
      final lat = state.location.data?.latitude;

      final response = await repository.getAirports(
        query: query,
        code: code,
        lat: lat,
        long: long,
        page: page,
        limit: limit,
      );

      if (response.isSuccess && response.data != null) {
        emit(
          state.copyWith(
            airports: DataState.loaded(data: response.data),
            filteredAirports: response.data?.airports ?? [],
            location: const DataState.initial(),
          ),
        );
      } else {
        emit(
          state.copyWith(
            airports: DataState.failure(error: response.message),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          airports: DataState.failure(error: e.toString()),
        ),
      );
    }
  }

  void onLocationInput(String value) {
    if (value.isEmpty) {
      emit(
        state.copyWith(
          filteredAirports: [],
          hasSelectedLocation: false,
        ),
      );
      return;
    }

    if (value.length > 2) {
      loadAirports(query: value, limit: 5);
      return;
    }

    // Otherwise filter locally
    final lowercaseQuery = value.toLowerCase();
    final airports = state.airports.data?.airports ?? [];

    final filtered = airports
        .where(
          (airport) =>
              airport.name.toLowerCase().contains(lowercaseQuery) ||
              airport.code.toLowerCase().contains(lowercaseQuery),
        )
        .take(5)
        .toList();

    emit(
      state.copyWith(
        filteredAirports: filtered,
        hasSelectedLocation: false,
      ),
    );
  }

  void selectAirport(Airport airport) {
    emit(
      state.copyWith(
        selectedAirport: airport,
        hasSelectedLocation: true,
        filteredAirports: [],
      ),
    );
  }

  void setLocationStateToLoading() {
    emit(
      state.copyWith(
        location: DataState.loading(data: state.location.data),
      ),
    );
  }

  void setLocationStateToLoaded() {
    emit(
      state.copyWith(
        location: DataState.loaded(data: state.location.data),
      ),
    );
  }
}
