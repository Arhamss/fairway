import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/api_service/app_api_exception.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/subscription/data/model/subscription_response_data.dart';
import 'package:fairway/fairway/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl({
    ApiService? apiService,
  }) : _apiService = apiService ?? Injector.resolve<ApiService>();
  final ApiService _apiService;

  @override
  Future<RepositoryResponse<SubscriptionResponseData>> getSubscriptionStatus(
    String userId,
  ) async {
    try {
      final response = await _apiService.get(
        '${Endpoints.getSubscriptionStatus}/$userId',
      );

      final result = SubscriptionResponseData.parseResponse(response);

      if (result.isSuccess && result.response?.data != null) {
        AppLogger.info('Subscription status fetched successfully');
        return RepositoryResponse(
          isSuccess: true,
          data: result.response!.data,
        );
      } else {
        AppLogger.error('Failed to fetch subscription status: ${result.error}');
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to fetch subscription status',
        );
      }
    } catch (e, s) {
      AppLogger.error('Error fetching subscription status:', e, s);
      return RepositoryResponse(
        isSuccess: false,
        message:
            extractApiErrorMessage(e, 'Failed to fetch subscription status'),
      );
    }
  }

  @override
  Future<RepositoryResponse<bool>> updateSubscription(
    String userId,
    bool subscriptionValue,
  ) async {
    try {
      final response = await _apiService.put(
        '${Endpoints.updateSubscription}/$userId',
        {
          'subscriber': subscriptionValue,
          'durationInDays': 5,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        AppLogger.info(
          'Subscription updated successfully to: $subscriptionValue',
        );
        return RepositoryResponse(
          isSuccess: true,
          data: true,
        );
      } else {
        AppLogger.error(
          'Failed to update subscription: ${response.statusMessage}',
        );
        return RepositoryResponse(
          isSuccess: false,
          message: response.statusMessage ?? 'Failed to update subscription',
        );
      }
    } catch (e, s) {
      AppLogger.error('Error updating subscription:', e, s);
      return RepositoryResponse(
        isSuccess: false,
        message: extractApiErrorMessage(e, 'Failed to update subscription'),
      );
    }
  }
}
