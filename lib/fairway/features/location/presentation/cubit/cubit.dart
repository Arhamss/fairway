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
          await loadAirportsWithLatLong(
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
        airportCode: state.selectedAirport.code,
        terminal: state.selectedTerminal.name,
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
    if (state.selectedAirport == const Airport.empty() ||
        state.selectedTerminal == const Terminal.empty()) {
      return;
    }

    emit(
      state.copyWith(
        updateLocation: const DataState.loading(),
      ),
    );

    final selectedAirport = state.selectedAirport;
    final selectedTerminal = state.selectedTerminal;
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

  Future<void> loadAirportsWithLatLong({
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
  }) async {
    emit(state.copyWith(airports: const DataState.loading()));

    try {
      final response = await repository.getAirports(
        query: query,
        code: code,
        lat: lat,
        long: long,
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

    loadTerminals(airport.code);
  }

  Future<void> loadTerminals(String airportCode) async {
    emit(state.copyWith(loadingTerminals: true));

    try {
      final terminals = state.selectedAirport.terminals;

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

  void selectTerminal(Terminal? terminal) {
    emit(
      state.copyWith(
        selectedTerminal: terminal,
        filteredTerminals: [],
        filteredGates: [],
        loadingGates: true,
      ),
    );

    if (terminal != null) {
      loadGates(terminal);
    }
  }

  Future<void> loadGates(Terminal terminal) async {
    emit(state.copyWith(loadingGates: true));

    try {
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

  void selectGate(String gate) {
    emit(
      state.copyWith(
        selectedGate: gate,
        filteredGates: [],
      ),
    );
  }

  void clearGateLocationState() {
    emit(
      state.copyWith(
        selectedGate: '',
        filteredGates: const [],
      ),
    );
  }

  void clearLocationState() {
    emit(
      state.copyWith(
        location: const DataState.initial(),
        hasSelectedLocation: false,
        filteredAirports: [],
        selectedGate: '',
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
        selectedGate: '',
        availableGates: const [],
        filteredGates: const [],
        filteredTerminals: const [],
        loadingGates: false,
      ),
    );
  }

  void resetUpdateLocationState() {
    emit(
      state.copyWith(
        updateLocation: const DataState.initial(),
        selectedAirport: const Airport.empty(),
        selectedTerminal: const Terminal.empty(),
      ),
    );
  }

  void selectSavedLocationIndex(int index) {
    emit(
      state.copyWith(selectedLocationIndex: index),
    );
  }
}
