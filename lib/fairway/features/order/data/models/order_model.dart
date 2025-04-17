import 'package:equatable/equatable.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/data/models/airport_model.dart';
import 'package:fairway/fairway/features/order/data/models/order_item_model.dart';

class CustomerModel extends Equatable {
  const CustomerModel({
    required this.userId,
    required this.name,
    required this.image,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      userId: json['UserId'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }
  final String userId;
  final String name;
  final String image;

  @override
  List<Object?> get props => [userId, name, image];
}

class ConciergeModel extends Equatable {
  const ConciergeModel({
    required this.conciergeId,
    required this.name,
    required this.image,
  });

  factory ConciergeModel.fromJson(Map<String, dynamic> json) {
    return ConciergeModel(
      conciergeId: json['conciergeId'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );
  }
  final String? conciergeId;
  final String? name;
  final String? image;

  ConciergeModel copyWith({
    String? conciergeId,
    String? name,
    String? image,
  }) {
    return ConciergeModel(
      conciergeId: conciergeId ?? this.conciergeId,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [conciergeId, name, image];
}

class OrderModel extends Equatable {
  const OrderModel({
    required this.id,
    required this.customer,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.statusUpdateCount,
    required this.airport,
    required this.deliveryMethod,
    required this.estimatedTime,
    required this.updatedAt,
    required this.createdAt,
    this.restaurant,
    this.concierge,
    this.lockerOrderCode,
    this.lockerPin,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    AppLogger.info('Parsing OrderModel from JSON: $json');
    return OrderModel(
      id: json['id'] as String,
      customer:
          CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
      restaurant: json['restaurant'] as String?,
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      statusUpdateCount: json['statusUpdateCount'] as int,
      airport:
          OrderAirportModel.fromJson(json['airport'] as Map<String, dynamic>),
      concierge: json['concierge'] != null
          ? ConciergeModel.fromJson(json['concierge'] as Map<String, dynamic>)
          : null,
      lockerOrderCode: json['lockerOrderCode'] as String?,
      lockerPin: json['lockerPin'] as String?,
      deliveryMethod: json['deliveryMethod'] as String,
      estimatedTime: json['estimatedTime'] as int,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  OrderModel copyWith({
    String? id,
    CustomerModel? customer,
    String? restaurant,
    List<OrderItemModel>? items,
    double? totalPrice,
    String? status,
    int? statusUpdateCount,
    OrderAirportModel? airport,
    ConciergeModel? concierge,
    String? lockerOrderCode,
    String? lockerPin,
    String? deliveryMethod,
    int? estimatedTime,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      restaurant: restaurant ?? this.restaurant,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      statusUpdateCount: statusUpdateCount ?? this.statusUpdateCount,
      airport: airport ?? this.airport,
      concierge: concierge ?? this.concierge,
      lockerOrderCode: lockerOrderCode ?? this.lockerOrderCode,
      lockerPin: lockerPin ?? this.lockerPin,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      updatedAt: updatedAt ?? DateTime.now(),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  final String id;
  final CustomerModel customer;
  final String? restaurant;
  final List<OrderItemModel> items;
  final double totalPrice;
  final String status;
  final int statusUpdateCount;
  final OrderAirportModel airport;
  final ConciergeModel? concierge;
  final String? lockerOrderCode;
  final String? lockerPin;
  final String deliveryMethod;
  final int estimatedTime;
  final DateTime updatedAt;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        customer,
        restaurant,
        items,
        totalPrice,
        status,
        statusUpdateCount,
        airport,
        concierge,
        lockerOrderCode,
        lockerPin,
        deliveryMethod,
        estimatedTime,
        updatedAt,
        createdAt,
      ];
}
