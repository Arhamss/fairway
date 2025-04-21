import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/domain/repositories/onboarding_flow_repository.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/data_state.dart';

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

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(signInWithGoogle: const DataState.loading()));
    try {
      final response = await repository.signInWithGoogle();

      if (response.isSuccess) {
        emit(
          state.copyWith(
            signInWithGoogle: DataState.loaded(
              data: response.data,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            signInWithGoogle: DataState.failure(error: response.message),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          signInWithGoogle: DataState.failure(error: e.toString()),
        ),
      );
    }
  }

  Future<void> signInWithApple() async {
    emit(state.copyWith(signInWithApple: const DataState.loading()));
    try {
      final response = await repository.signInWithApple();

      if (response.isSuccess) {
        emit(
          state.copyWith(
            signInWithApple: DataState.loaded(
              data: response.data,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            signInWithApple: DataState.failure(error: response.message),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          signInWithApple: DataState.failure(error: e.toString()),
        ),
      );
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
