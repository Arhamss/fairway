import 'package:fairway/fairway/features/notification/domain/repositories/notification_repository.dart';
import 'package:fairway/fairway/features/notification/presentation/cubit/state.dart';
import 'package:fairway/utils/helpers/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required this.repository,
  }) : super(const NotificationState());

  final NotificationRepository repository;

  Future<void> fetchNotifications({bool refresh = false}) async {
    try {
      if (refresh) {
        emit(state.copyWith(
          currentPage: 1,
          notifications: [],
          fetchNotifications: const DataState.loading(),
        ));
      } else {
        emit(state.copyWith(
          fetchNotifications: const DataState.loading(),
        ));
      }

      final response = await repository.fetchNotifications(
        page: refresh ? 1 : state.currentPage,
      );

      if (response.isSuccess && response.data != null) {
        final newNotifications = refresh
            ? response.data!.notifications
            : [...state.notifications, ...response.data!.notifications];

        emit(state.copyWith(
          notifications: newNotifications,
          fetchNotifications: DataState.loaded(data: newNotifications),
          currentPage: response.data!.currentPage,
          hasMorePages: response.data!.currentPage < response.data!.totalPages,
          totalResults: response.data!.totalResults,
          unreadCount: response.data!.unreadCount,
        ));
      } else {
        emit(state.copyWith(
          fetchNotifications: DataState.failure(
            error: response.message ?? 'Failed to fetch notifications',
          ),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        fetchNotifications: DataState.failure(
          error: 'Failed to fetch notifications: $e',
        ),
      ));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMorePages || state.fetchNotifications.isLoading) return;
    await fetchNotifications();
  }

  Future<void> markAsRead() async {
    try {
      emit(state.copyWith(markAsRead: const DataState.loading()));

      final response = await repository.markAsRead();

      if (response.isSuccess) {
        emit(state.copyWith(
          unreadCount: 0,
          markAsRead: const DataState.loaded(),
        ));
      } else {
        emit(state.copyWith(
          markAsRead: DataState.failure(
            error: response.message ?? 'Failed to mark notifications as read',
          ),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        markAsRead: DataState.failure(
          error: 'Failed to mark notifications as read: $e',
        ),
      ));
    }
  }
}