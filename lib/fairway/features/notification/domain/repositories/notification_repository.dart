

import 'package:fairway/fairway/features/notification/data/models/notification_response_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class NotificationRepository {
    Future<RepositoryResponse<void>> sendFcmToken({
    required String fcmToken,
  });

  Future<RepositoryResponse<NotificationResponseData>> fetchNotifications();

  Future<RepositoryResponse<NotificationResponseData>> markNotificationAsRead({
    required String notificationId,
  });
}