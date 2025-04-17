import 'package:bloc/bloc.dart';
import 'package:fairway/fairway/features/home/data/repositories/home_repository_implementation.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:fairway/fairway/features/subscription/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit({
    required SubscriptionRepository repository,
  })  : _repository = repository,
        super(const SubscriptionState());
  final SubscriptionRepository _repository;

  Future<void> getSubscriptionStatus(String userId) async {
    try {
      emit(
        state.copyWith(
          subscriptionData: const DataState.loading(),
        ),
      );

      final response = await _repository.getSubscriptionStatus(userId);

      if (response.isSuccess && response.data != null) {
        emit(
          state.copyWith(
            subscriptionData: DataState.loaded(data: response.data),
          ),
        );
      } else {
        emit(
          state.copyWith(
            subscriptionData: DataState.failure(error: response.message),
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Error getting subscription status: $e');
      emit(
        state.copyWith(
          subscriptionData: DataState.failure(error: e.toString()),
        ),
      );
    }
  }

  Future<void> updateSubscription(bool subscriptionValue, String userId) async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
        ),
      );
      final response =
          await _repository.updateSubscription(userId, subscriptionValue);

      if (response.isSuccess && response.data != null) {
        emit(
          state.copyWith(
            subscriptionData: DataState.loaded(
              data: state.subscriptionData.data!.copyWith(
                userData: state.subscriptionData.data!.userData.copyWith(
                  subscriber: subscriptionValue,
                ),
              ),
            ),
            isLoading: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            subscriptionData: DataState.failure(
              error: response.message ?? 'Failed to update subscription',
            ),
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Error updating subscription: $e');
      emit(
        state.copyWith(
          subscriptionData: const DataState.failure(
            error: 'An error occurred while updating subscription',
          ),
          isLoading: false,
        ),
      );
    }
  }
}
