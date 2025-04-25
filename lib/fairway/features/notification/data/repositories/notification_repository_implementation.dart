


import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/notification/data/models/notification_response_model.dart';
import 'package:fairway/fairway/features/notification/domain/repositories/notification_repository.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

class NotificationRepositoryImplementation  implements NotificationRepository{
  NotificationRepositoryImplementation({
    ApiService? apiService,
  }) : _apiService = apiService ?? Injector.resolve<ApiService>() ;
  final ApiService _apiService;

  
  @override
  Future<RepositoryResponse<void>> sendFcmToken({required String fcmToken}) async {
    try {
      final fcmResponse = await _apiService.put(
              Endpoints.fcmToken,
              {'fcmToken': fcmToken},
            );

            final fcmResult=fcmResponse.data['data'];
            if (fcmResponse.statusCode == 200) {
              AppLogger.info(
                fcmResult['message'] as String,
              );

              return RepositoryResponse(
                isSuccess: true,
                message: fcmResult['message'] as String,
              );
            } else {
              AppLogger.error(
                'Failed to update FCM token: ${fcmResponse.statusMessage}',
              );
              return RepositoryResponse(
                isSuccess: false,
                message: 'Failed to update FCM token: ${fcmResponse.statusMessage}',
              );
            }


  } catch (e) {
      AppLogger.error(
        'Error sending FCM token: $e',
      );
      return RepositoryResponse(
        isSuccess: false,
        message: 'Error sending FCM token: $e',
      );
      
      }
  }

  
  @override
  Future<RepositoryResponse<NotificationResponseData>> fetchNotifications() {
    // TODO: implement fetchNotifications
    throw UnimplementedError();
  }
  
  @override
  Future<RepositoryResponse<NotificationResponseData>> markNotificationAsRead({required String notificationId}) {
    // TODO: implement markNotificationAsRead
    throw UnimplementedError();
  }
}