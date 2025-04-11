import 'package:fairway/fairway/features/home/domain/repositories/home_repository.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.repository}) : super(const HomeState());

  final HomeRepository repository;

  Future<void> loadUserProfile() async {
    emit(state.copyWith(userProfile: const DataState.loading()));

    try {
      final response = await repository.getUserProfile();

      if (response.isSuccess && response.data != null) {
        emit(
          state.copyWith(
            userProfile: DataState.loaded(data: response.data),
          ),
        );
        AppLogger.info('User profile loaded in cubit');
      } else {
        emit(
          state.copyWith(
            userProfile: DataState.failure(
              error: response.message ?? 'Failed to load user profile',
            ),
          ),
        );
        AppLogger.error(
          'Failed to load user profile in cubit: ${response.message}',
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          userProfile: DataState.failure(error: e.toString()),
        ),
      );
      AppLogger.error('Exception in loadUserProfile: $e');
    }
  }

  void setFilterExpanded(bool isExpanded) {
    if (!isExpanded) {
      emit(
        state.copyWith(
          isFilterExpanded: isExpanded,
          selectedTabIndex: 0,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        isFilterExpanded: isExpanded,
      ),
    );
  }

  void setSelectedTabIndex(int index) {
    emit(
      state.copyWith(selectedTabIndex: index),
    );
  }
}
