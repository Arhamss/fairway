import 'package:fairway/fairway/features/notification/data/models/notification_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class NotificationRepository {
  Future<RepositoryResponse<NotificationResponseData>> fetchNotifications({
    int page = 1,
    int limit = 10,
  });
  
  Future<RepositoryResponse<void>> markAsRead();

  Future<RepositoryResponse<void>> sendFcmToken({required String fcmToken});
}