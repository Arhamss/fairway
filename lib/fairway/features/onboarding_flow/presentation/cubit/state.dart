import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/api_response_model.dart';
import 'package:fairway/fairway/models/auth_data_model.dart';
import 'package:fairway/fairway/models/location_data_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:geolocator/geolocator.dart';

class OnboardingFlowState extends Equatable {
  const OnboardingFlowState({
    this.signIn = const DataState.initial(),
    this.signUp = const DataState.initial(),
    this.forgotPassword = const DataState.initial(),
    this.resetCode,
    this.resetPassword = const DataState.initial(),
    this.location = const DataState.initial(),
    this.hasSelectedLocation = false,
    this.updateLocation = const DataState.initial(),
    this.airports = const DataState.initial(),
    this.filteredAirports = const [],
    this.selectedAirport,
  });

  final DataState<ApiResponse<AuthData>> signIn;
  final DataState<ApiResponse<AuthData>> signUp;
  final DataState<ApiResponse<dynamic>> forgotPassword;
  final String? resetCode;
  final DataState<ApiResponse<dynamic>>? resetPassword;
  final DataState<Position>? location;
  final bool hasSelectedLocation;
  final DataState<ApiResponse<UserData>>? updateLocation;
  final DataState<ApiResponse<LocationData>>? airports;
  final List<Airport> filteredAirports;
  final Airport? selectedAirport;

  OnboardingFlowState copyWith({
    DataState<ApiResponse<AuthData>>? signIn,
    DataState<ApiResponse<AuthData>>? signUp,
    DataState<ApiResponse<dynamic>>? forgotPassword,
    String? resetCode,
    DataState<ApiResponse<dynamic>>? resetPassword,
    DataState<Position>? location,
    bool? hasSelectedLocation,
    DataState<ApiResponse<UserData>>? updateLocation,
    DataState<ApiResponse<LocationData>>? airports,
    List<Airport>? filteredAirports,
    Airport? selectedAirport,
  }) {
    return OnboardingFlowState(
      signIn: signIn ?? this.signIn,
      signUp: signUp ?? this.signUp,
      forgotPassword: forgotPassword ?? this.forgotPassword,
      resetCode: resetCode ?? this.resetCode,
      resetPassword: resetPassword ?? this.resetPassword,
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
        signIn,
        signUp,
        forgotPassword,
        resetCode,
        location,
        hasSelectedLocation,
        updateLocation,
        airports,
        filteredAirports,
        selectedAirport,
      ];
}
