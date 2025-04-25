import 'package:fairway/fairway/features/subscription/data/model/subscription_response_data.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class SubscriptionRepository {
  Future<RepositoryResponse<SubscriptionResponseData>> getSubscriptionStatus(
    String userId,
  );

  Future<RepositoryResponse<bool>> updateSubscription(
    String userId,
    bool subscriptionValue,
  );
}
