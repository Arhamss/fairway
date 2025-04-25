import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/order/data/models/order_model.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';

class OrderResponseData extends Equatable {
  const OrderResponseData({
    required this.order,
  });

  factory OrderResponseData.fromJson(Map<String, dynamic> json) {
    return OrderResponseData(
      order: OrderModel.fromJson(
          json['orderData']['order'] as Map<String, dynamic>),
    );
  }

  final OrderModel order;

  static ResponseModel<BaseApiResponse<OrderResponseData>> parseResponse(
    Response response,
  ) {
    return ResponseModel.fromApiResponse<BaseApiResponse<OrderResponseData>>(
      response,
      (json) => BaseApiResponse<OrderResponseData>.fromJson(
        json,
        OrderResponseData.fromJson,
      ),
    );
  }

  @override
  List<Object> get props => [order];

  OrderResponseData copyWith({OrderModel? order}) {
    return OrderResponseData(
      order: order ?? this.order,
    );
  }
}
