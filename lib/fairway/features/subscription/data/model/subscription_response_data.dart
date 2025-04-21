import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';

class SubscriptionResponseData extends Equatable {
  const SubscriptionResponseData({
    required this.userData,
  });

  factory SubscriptionResponseData.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponseData(
      userData: SubscriptionUserData.fromJson(
        json['userData'] as Map<String, dynamic>,
      ),
    );
  }
  final SubscriptionUserData userData;

  static ResponseModel<BaseApiResponse<SubscriptionResponseData>> parseResponse(
    Response response,
  ) {
    return ResponseModel.fromApiResponse<
        BaseApiResponse<SubscriptionResponseData>>(
      response,
      (json) => BaseApiResponse<SubscriptionResponseData>.fromJson(
        json,
        SubscriptionResponseData.fromJson,
      ),
    );
  }

  @override
  List<Object?> get props => [userData];

  SubscriptionResponseData copyWith({SubscriptionUserData? userData}) {
    return SubscriptionResponseData(
      userData: userData ?? this.userData,
    );
  }
}

class SubscriptionUserData extends Equatable {
  const SubscriptionUserData({
    required this.subscriber,
    this.subscriptionStart,
    this.subscriptionEnd,
  });

  factory SubscriptionUserData.fromJson(Map<String, dynamic> json) {
    return SubscriptionUserData(
      subscriber: json['subscriber'] as bool,
      subscriptionStart: json['subscriptionStart'] != null
          ? DateTime.parse(json['subscriptionStart'] as String)
          : null,
      subscriptionEnd: json['subscriptionEnd'] != null
          ? DateTime.parse(json['subscriptionEnd'] as String)
          : null,
    );
  }
  final bool subscriber;
  final DateTime? subscriptionStart;
  final DateTime? subscriptionEnd;

  SubscriptionUserData copyWith({
    bool? subscriber,
    DateTime? subscriptionStart,
    DateTime? subscriptionEnd,
  }) {
    return SubscriptionUserData(
      subscriber: subscriber ?? this.subscriber,
    );
  }

  @override
  List<Object?> get props => [subscriber, subscriptionStart, subscriptionEnd];
}
