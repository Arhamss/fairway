import 'package:fairway/core/permissions/permission_manager.dart';
import 'package:fairway/fairway/features/location/data/models/airport_model.dart';
import 'package:fairway/fairway/features/location/data/models/airport_request_model.dart';
import 'package:fairway/fairway/features/location/data/models/terminal_model.dart';
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
          await loadAirportswithLatLong(
            lat: position.latitude,
            long: position.longitude,
          );
          emit(
            state.copyWith(
              location: DataState.loaded(data: position),
              selectedAirport: state.airports.data?.airports.first,
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

  Future<void> setCurrentLocation() async {
    if (state.location.data == null) return;

    emit(
      state.copyWith(
        setCurrentLocation: const DataState.loading(),
      ),
    );

    final response = await repository.setCurrentLocation(
      AirportRequestModel(
        airportCode: state.selectedAirport?.code ?? '',
        terminal: state.selectedTerminal?.name ?? '',
        gate: state.selectedGate ?? '',
      ),
    );

    if (response.isSuccess) {
      emit(
        state.copyWith(
          setCurrentLocation: const DataState.loaded(data: true),
        ),
      );
    } else {
      emit(
        state.copyWith(
          setCurrentLocation: DataState.failure(error: response.message),
        ),
      );
    }
  }

  Future<void> updateLocation() async {
    if (state.selectedAirport == null || state.selectedTerminal == null) return;

    emit(
      state.copyWith(
        updateLocation: const DataState.loading(),
      ),
    );

    final selectedAirport = state.selectedAirport!;
    final selectedTerminal = state.selectedTerminal!;
    final selectedGate = state.selectedGate;

    final response = await repository.updateUserLocation(
      AirportRequestModel(
        airportCode: selectedAirport.code,
        terminal: selectedTerminal.name,
        gate: selectedGate ?? '',
      ),
    );

    if (response.isSuccess) {
      emit(
        state.copyWith(
          updateLocation: const DataState.loaded(data: true),
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

  Future<void> loadAirportswithLatLong({
    required double lat,
    required double long,
  }) async {
    emit(state.copyWith(airports: const DataState.loading()));

    try {
      final response = await repository.getAirportsByLatLong(
        lat: lat,
        long: long,
      );

      if (response.isSuccess && response.data != null) {
        emit(
          state.copyWith(
            airports: DataState.loaded(data: response.data),
            filteredAirports: response.data?.airports ?? [],
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

  Future<void> loadAirports({
    double? lat,
    double? long,
    String? query,
    String? code,
    int page = 1,
    int limit = 10,
  }) async {
    emit(state.copyWith(airports: const DataState.loading()));

    try {
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

    loadAirports(query: value);

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

  void selectAirport(Airport? airport) {
    if (airport == null) {
      emit(
        state.copyWith(
          availableTerminals: const [],
          filteredTerminals: const [],
          availableGates: const [],
          filteredGates: const [],
          hasSelectedLocation: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        selectedAirport: airport,
        hasSelectedLocation: true,
        filteredAirports: [],
        availableGates: const [],
        filteredGates: const [],
        loadingTerminals: true,
      ),
    );

    // Load terminals for the selected airport
    loadTerminals(airport.code);
  }

  Future<void> loadTerminals(String airportCode) async {
    emit(state.copyWith(loadingTerminals: true));

    try {
      // Sample terminals - replace with actual API call
      final terminals = state.selectedAirport?.terminals ?? [];

      emit(
        state.copyWith(
          availableTerminals: terminals,
          filteredTerminals: [],
          loadingTerminals: false,
        ),
      );
    } catch (e) {
      AppLogger.error('Error loading terminals: $e');
      emit(
        state.copyWith(
          loadingTerminals: false,
        ),
      );
    }
  }

  void onTerminalInput(String value) {
    if (value.isEmpty) {
      emit(
        state.copyWith(
          filteredTerminals: [],
        ),
      );
      return;
    }

    final lowercaseQuery = value.toLowerCase();
    final terminals = state.availableTerminals;

    final filtered = terminals
        .where(
          (terminal) => terminal.name.toLowerCase().contains(lowercaseQuery),
        )
        .toList();

    emit(
      state.copyWith(
        filteredTerminals: filtered,
      ),
    );
  }

  void selectTerminal(Terminal? terminal) {
    emit(
      state.copyWith(
        selectedTerminal: terminal,
        filteredTerminals: [],
        filteredGates: [],
        loadingGates: true,
      ),
    );

    // Load gates for the selected terminal
    if (terminal != null) {
      loadGates(terminal);
    }
  }

  Future<void> loadGates(Terminal terminal) async {
    emit(state.copyWith(loadingGates: true));

    try {
      // Sample gates - replace with actual API call
      final gates = terminal.gates;

      emit(
        state.copyWith(
          availableGates: gates,
          filteredGates: [],
          loadingGates: false,
        ),
      );
    } catch (e) {
      AppLogger.error('Error loading gates: $e');
      emit(
        state.copyWith(
          loadingGates: false,
        ),
      );
    }
  }

  void onGateInput(String value) {
    if (value.isEmpty) {
      emit(
        state.copyWith(
          filteredGates: [],
        ),
      );
      return;
    }

    final lowercaseQuery = value.toLowerCase();
    final gates = state.availableGates;

    final filtered = gates
        .where(
          (gate) => gate.toLowerCase().contains(lowercaseQuery),
        )
        .toList();

    emit(
      state.copyWith(
        filteredGates: filtered,
      ),
    );
  }

  void selectGate(String gate) {
    emit(
      state.copyWith(
        selectedGate: gate,
        filteredGates: [],
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

  void clearGateLocationState() {
    emit(
      state.copyWith(
        selectedGate: '', // Reset selected gate
        filteredGates: const [], // Clear filtered gates
      ),
    );
  }

  void clearLocationState() {
    emit(
      state.copyWith(
        location: const DataState.initial(),
        hasSelectedLocation: false,
        filteredAirports: [],
        selectedGate: '', // Reset gate since airport is cleared
        availableTerminals: const [],
        availableGates: const [],
        filteredTerminals: const [],
        filteredGates: const [],
        loadingTerminals: false,
        loadingGates: false,
      ),
    );
  }

  void clearTerminalSelection() {
    emit(
      state.copyWith(
        selectedGate: '', // Reset gate since terminal is cleared
        availableGates: const [],
        filteredGates: const [],
        filteredTerminals: const [], // Clear filtered terminals
        loadingGates: false,
      ),
    );
  }
}
