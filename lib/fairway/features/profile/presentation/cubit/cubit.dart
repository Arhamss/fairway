import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/profile/domain/repositories/profile_repository.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.repository}) : super(const ProfileState());
  final ProfileRepository repository;

  Future<void> updateUserProfile(String name) async {
    emit(
      state.copyWith(
        updateProfile: const DataState.loading(),
      ),
    );
    try {
      final response = await repository.updateUserProfile(name);
      if (response.isSuccess) {
        emit(
          state.copyWith(
            updateProfile: DataState.loaded(data: response.data),
          ),
        );
      } else {
        emit(
          state.copyWith(
            updateProfile: DataState.failure(error: response.message),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          updateProfile: DataState.failure(error: e.toString()),
        ),
      );
    }
  }

  Future<void> updateUserPassword(String oldPass, String newPass) async {
    emit(
      state.copyWith(
        updatePassword: const DataState.loading(),
      ),
    );
    try {
      final response = await repository.updateUserPassword(oldPass, newPass);
      if (response.isSuccess) {
        emit(
          state.copyWith(
            updatePassword: DataState.loaded(data: response.data),
          ),
        );
      } else {
        emit(
          state.copyWith(
            updatePassword: DataState.failure(error: response.message),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          updatePassword: DataState.failure(error: e.toString()),
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      emit(state.copyWith(logoutStatus: const DataState.loading()));

      // Clear user data from cache
      Injector.resolve<AppPreferences>().clearAuthData();

      // Log analytics event if needed
      AppLogger.info('User logged out successfully');

      // Emit success state
      emit(state.copyWith(logoutStatus: const DataState.loaded()));
    } catch (e) {
      AppLogger.error('Logout failed: $e');
      emit(
        state.copyWith(
          logoutStatus: DataState.failure(error: 'Failed to logout: $e'),
        ),
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      emit(state.copyWith(deleteAccountStatus: const DataState.loading()));

      // Call API to delete account
      final response = await repository.deleteAccount();

      if (response.isSuccess) {
        // Clear user data from cache
        Injector.resolve<AppPreferences>().clearAll();

        // Log analytics event if needed
        AppLogger.info('Account deleted successfully');

        // Emit success state
        emit(state.copyWith(deleteAccountStatus: const DataState.loaded()));
      } else {
        emit(
          state.copyWith(
            deleteAccountStatus: DataState.failure(
              error: response.message ?? 'Failed to delete account',
            ),
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Delete account failed: $e');
      emit(
        state.copyWith(
          deleteAccountStatus: DataState.failure(
            error: 'Failed to delete account: $e',
          ),
        ),
      );
    }
  }
}
