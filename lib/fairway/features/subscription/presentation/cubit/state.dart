import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/subscription/data/model/subscription_response_data.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class SubscriptionState extends Equatable {
  const SubscriptionState({
    this.subscriptionData = const DataState.initial(),
    this.isLoading = false,
    
  });
  final DataState<SubscriptionResponseData> subscriptionData;
  final bool isLoading;

  SubscriptionState copyWith({
    DataState<SubscriptionResponseData>? subscriptionData,
    bool? isLoading,

  }) {
    return SubscriptionState(
      subscriptionData: subscriptionData ?? this.subscriptionData,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        subscriptionData,
        isLoading,
      ];
}
