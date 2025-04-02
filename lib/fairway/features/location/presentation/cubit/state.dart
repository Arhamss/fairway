import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/location/data/models/airport_model.dart';
import 'package:fairway/fairway/features/location/data/models/location_data_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:geolocator/geolocator.dart';

class LocationState extends Equatable {
  const LocationState({
    this.location = const DataState.initial(),
    this.updateLocation = const DataState.initial(),
    this.airports = const DataState.initial(),
    this.filteredAirports = const [],
    this.selectedAirport,
    this.hasSelectedLocation = false,
  });

  final DataState<Position> location;
  final bool hasSelectedLocation;
  final DataState<UserData> updateLocation;
  final DataState<LocationData> airports;
  final List<Airport> filteredAirports;
  final Airport? selectedAirport;

  LocationState copyWith({
    DataState<Position>? location,
    bool? hasSelectedLocation,
    DataState<UserData>? updateLocation,
    DataState<LocationData>? airports,
    List<Airport>? filteredAirports,
    Airport? selectedAirport,
  }) {
    return LocationState(
      location: location ?? this.location,
      hasSelectedLocation: hasSelectedLocation ?? this.hasSelectedLocation,
      updateLocation: updateLocation ?? this.updateLocation,
      airports: airports ?? this.airports,
      filteredAirports: filteredAirports ?? this.filteredAirports,
      selectedAirport: selectedAirport ?? this.selectedAirport,
    );
  }

  @override
  List<Object?> get props => [
        location,
        hasSelectedLocation,
        updateLocation,
        airports,
        filteredAirports,
        selectedAirport,
      ];
}
