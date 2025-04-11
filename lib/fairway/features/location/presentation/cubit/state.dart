import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/location/data/models/airport_model.dart';
import 'package:fairway/fairway/features/location/data/models/location_data_model.dart';
import 'package:fairway/fairway/features/location/data/models/terminal_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:geolocator/geolocator.dart';

class LocationState extends Equatable {
  const LocationState({
    this.location = const DataState.initial(),
    this.updateLocation = const DataState.initial(),
    this.setCurrentLocation = const DataState.initial(),
    this.airports = const DataState.initial(),
    this.selectedAirport = const Airport.empty(),
    this.hasSelectedLocation = false,
    this.selectedTerminal = const Terminal.empty(),
    this.selectedGate,
    this.availableTerminals = const [],
    this.availableGates = const [],
    this.loadingTerminals = false,
    this.loadingGates = false,
    this.selectedLocationIndex,
  });

  final DataState<Position> location;
  final bool hasSelectedLocation;
  final DataState<bool> updateLocation;
  final DataState<bool> setCurrentLocation;
  final DataState<LocationData> airports;
  final Airport selectedAirport;
  final Terminal selectedTerminal;
  final String? selectedGate;
  final List<Terminal> availableTerminals;
  final List<String> availableGates;
  final bool loadingTerminals;
  final bool loadingGates;
  final int? selectedLocationIndex;
  LocationState copyWith({
    DataState<Position>? location,
    bool? hasSelectedLocation,
    DataState<bool>? updateLocation,
    DataState<bool>? setCurrentLocation,
    DataState<LocationData>? airports,
    List<Airport>? filteredAirports,
    Airport? selectedAirport,
    Terminal? selectedTerminal,
    String? selectedGate,
    List<Terminal>? availableTerminals,
    List<String>? availableGates,
    List<Terminal>? filteredTerminals,
    List<String>? filteredGates,
    bool? loadingTerminals,
    bool? loadingGates,
    int? selectedLocationIndex,
  }) {
    return LocationState(
      location: location ?? this.location,
      hasSelectedLocation: hasSelectedLocation ?? this.hasSelectedLocation,
      updateLocation: updateLocation ?? this.updateLocation,
      setCurrentLocation: setCurrentLocation ?? this.setCurrentLocation,
      airports: airports ?? this.airports,
      selectedAirport: selectedAirport ?? this.selectedAirport,
      selectedTerminal: selectedTerminal ?? this.selectedTerminal,
      selectedGate: selectedGate ?? this.selectedGate,
      availableTerminals: availableTerminals ?? this.availableTerminals,
      availableGates: availableGates ?? this.availableGates,
      loadingTerminals: loadingTerminals ?? this.loadingTerminals,
      loadingGates: loadingGates ?? this.loadingGates,
      selectedLocationIndex:
          selectedLocationIndex ?? this.selectedLocationIndex,
    );
  }

  @override
  List<Object?> get props => [
        location,
        hasSelectedLocation,
        updateLocation,
        setCurrentLocation,
        airports,
        selectedAirport,
        selectedTerminal,
        selectedGate,
        availableTerminals,
        availableGates,
        loadingTerminals,
        loadingGates,
        selectedLocationIndex,
      ];
}
