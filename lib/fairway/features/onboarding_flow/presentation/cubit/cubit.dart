import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/domain/repositories/onboardingflow_repository.dart';
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
      emit(state.copyWith(
          forgotPassword: DataState.failure(error: e.toString())));
    }
  }
}
