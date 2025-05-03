import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/notification/data/models/notification_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class NotificationState extends Equatable {
  const NotificationState({
    this.notifications = const [],
    this.fetchNotifications = const DataState.initial(),
    this.markAsRead = const DataState.initial(),
    this.collectionStatus = const DataState.initial(),
    this.currentPage = 1,
    this.hasMorePages = true,
    this.totalResults = 0,
    this.unreadCount = 0,
  });

  final List<NotificationModel> notifications;
  final DataState<List<NotificationModel>> fetchNotifications;
  final DataState<void> markAsRead;
  final DataState<void> collectionStatus;
  final int currentPage;
  final bool hasMorePages;
  final int totalResults;
  final int unreadCount;

  @override
  List<Object?> get props => [
        notifications,
        fetchNotifications,
        markAsRead,
        collectionStatus,
        currentPage,
        hasMorePages,
        totalResults,
        unreadCount,
      ];

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    DataState<List<NotificationModel>>? fetchNotifications,
    DataState<void>? markAsRead,
    DataState<void>? collectionStatus,
    int? currentPage,
    bool? hasMorePages,
    int? totalResults,
    int? unreadCount,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      fetchNotifications: fetchNotifications ?? this.fetchNotifications,
      markAsRead: markAsRead ?? this.markAsRead,
      collectionStatus: collectionStatus ?? this.collectionStatus,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      totalResults: totalResults ?? this.totalResults,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}