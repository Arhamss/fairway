import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/order/data/models/order_model.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';

class OrderHistoryResponseData extends Equatable {
  const OrderHistoryResponseData({
    required this.orders,
  });

  factory OrderHistoryResponseData.fromJson(Map<String, dynamic> json) {
    final ordersJson = json['orders'] as List<dynamic>? ?? [];
    return OrderHistoryResponseData(
      orders: ordersJson
          .map((order) => OrderModel.fromJson(order as Map<String, dynamic>))
          .toList(),
    );
  }
  final List<OrderModel> orders;

  static ResponseModel<BaseApiResponse<OrderHistoryResponseData>> parseResponse(
    Response response,
  ) {
    return ResponseModel.fromApiResponse<
        BaseApiResponse<OrderHistoryResponseData>>(
      response,
      (json) => BaseApiResponse<OrderHistoryResponseData>.fromJson(
        json,
        OrderHistoryResponseData.fromJson,
      ),
    );
  }

  OrderHistoryResponseData copyWith({
    List<OrderModel>? orders,
  }) {
    return OrderHistoryResponseData(
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object?> get props => [orders];
}
