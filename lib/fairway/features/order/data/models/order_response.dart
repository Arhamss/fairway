import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:fairway/fairway/features/order/data/models/order_model.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';

class OrderResponseData extends Equatable {
  final String defaultOrderType;
  final OrderModel order;
  final dynamic locker;

  const OrderResponseData({
    required this.defaultOrderType,
    required this.order,
    this.locker,
  });

  factory OrderResponseData.fromJson(Map<String, dynamic> json) {
    return OrderResponseData(
      defaultOrderType: json['defaultOrderType'] as String,
      order: OrderModel.fromJson(json['order'] as Map<String, dynamic>),
      locker: json['locker'],
    );
  }

  static ResponseModel<BaseApiResponse<OrderResponseData>> parseResponse(
      Response response) {
    return ResponseModel.fromApiResponse<BaseApiResponse<OrderResponseData>>(
      response,
      (json) => BaseApiResponse<OrderResponseData>.fromJson(
          json, OrderResponseData.fromJson),
    );
  }

  @override
  List<Object?> get props => [defaultOrderType, order, locker];
}