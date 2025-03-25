import 'package:fairway/core/permissions/permission_manager.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/domain/repositories/onboardingflow_repository.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/state.dart';
import 'package:fairway/fairway/models/location_data_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class OnboardingFlowCubit extends Cubit<OnboardingFlowState> {
  OnboardingFlowCubit({required this.repository})
      : super(const OnboardingFlowState());

  final OnboardingFlowRepository repository;

  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(signIn: const DataState.loading()));
    try {
      final response = await repository.signIn(email, password);

      if (response.isSuccess) {
        emit(
          state.copyWith(
            signIn: DataState.loaded(
              data: response.data,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            signIn: DataState.failure(error: response.message),
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(signIn: DataState.failure(error: e.toString())));
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    emit(state.copyWith(signUp: const DataState.loading()));
    try {
      final response = await repository.signUp(name, email, password);

      if (response.isSuccess) {
        emit(
          state.copyWith(
            signUp: DataState.loaded(
              data: response.data,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            signUp: DataState.failure(error: response.message),
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(signUp: DataState.failure(error: e.toString())));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(state.copyWith(forgotPassword: const DataState.loading()));
    try {
      final response = await repository.forgotPassword(email);

      if (response.isSuccess) {
        emit(
          state.copyWith(
            forgotPassword: DataState.loaded(
              data: response.data,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            forgotPassword: DataState.failure(error: response.message),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          forgotPassword: DataState.failure(error: e.toString()),
        ),
      );
    }
  }

  Future<void> getCurrentLocation() async {
    emit(
      state.copyWith(
        location: const DataState.loading(),
        hasSelectedLocation: false,
      ),
    );

    await PermissionManager.requestLocationPermission(
      grantedCallback: () async {
        try {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          final placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );

          if (placemarks.isNotEmpty) {
            final place = placemarks[0];
            final city = place.locality ?? place.subAdministrativeArea ?? '';

            // Find matching airport
            final airports = state.airports?.data?.data?.airports ?? [];
            final matchingAirport = airports.firstWhere(
              (airport) =>
                  airport.name.toLowerCase().contains(city.toLowerCase()),
              orElse: () => airports.first,
            );

            emit(
              state.copyWith(
                location: DataState.loaded(
                  data: '${matchingAirport.name}, ${matchingAirport.code}',
                ),
                selectedAirport: matchingAirport,
                hasSelectedLocation: true,
              ),
            );
          }
        } catch (e) {
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
    if (state.location?.data == null) return;

    emit(
      state.copyWith(
        updateLocation: const DataState.loading(),
      ),
    );

    final response = await repository.updateUserLocation(state.location!.data!);

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

  Future<void> loadAirports() async {
    emit(state.copyWith(airports: const DataState.loading()));

    try {
      final response = await repository.getAirports();

      if (response.isSuccess && response.data?.data != null) {
        emit(
          state.copyWith(
            airports: DataState.loaded(data: response.data),
            filteredAirports: response.data?.data?.airports ?? [],
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
          filteredAirports: [], // Show no airports when search is empty
          hasSelectedLocation: false,
        ),
      );
      return;
    }

    final lowercaseQuery = value.toLowerCase();
    final airports = state.airports?.data?.data?.airports ?? [];

    // Filter airports that match the search query
    final filtered = airports
        .where((airport) {
          return airport.name.toLowerCase().contains(lowercaseQuery) ||
              airport.code.toLowerCase().contains(lowercaseQuery) ||
              airport.name.toLowerCase().contains(lowercaseQuery) == true;
        })
        .take(5)
        .toList(); // Limit to top 5 matches for better performance

    emit(
      state.copyWith(
        filteredAirports: filtered,
        hasSelectedLocation: false,
      ),
    );
  }

  void selectAirport(Airport airport) {
    // Immediately clear filtered airports when selection is made
    emit(
      state.copyWith(
        selectedAirport: airport,
        hasSelectedLocation: true,
        filteredAirports: [], // Clear the list to hide suggestions
      ),
    );
  }

  Future<void> setResetCode(String code) async {
    emit(state.copyWith(resetCode: code));
  }

  Future<void> resetPassword(String code, String password) async {
    if (code.isEmpty) {
      emit(
        state.copyWith(
          resetPassword: const DataState.failure(
            error: 'Reset code is required',
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(resetPassword: const DataState.loading()));
    AppLogger.info('Resetting password...');

    final response = await repository.resetPassword(code, password);
    AppLogger.info('Reset password response: ${response.isSuccess}');

    if (response.data!.statusCode == 200 && response.data!.data != null) {
      AppLogger.info('Password reset successful');
      emit(
        state.copyWith(
          resetPassword: DataState.loaded(data: response.data),
        ),
      );
    } else {
      AppLogger.error('Password reset failed: ${response.message}');
      emit(
        state.copyWith(
          resetPassword: DataState.failure(error: response.message),
        ),
      );
    }
  }
}
