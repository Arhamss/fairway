// import 'package:equatable/equatable.dart';
// import 'package:fairway/fairway/features/order/data/models/airport_model.dart';
// import 'package:fairway/fairway/features/order/data/models/order_item_model.dart';

// class OrderHistoryModel extends Equatable {
//   const OrderHistoryModel({
//     required this.id,
//     required this.user,
//     required this.items,
//     required this.totalPrice,
//     required this.status,
//     required this.statusUpdateCount,
//     required this.airport,
//     required this.deliveryMethod,
//     required this.estimatedTime,
//     required this.updatedAt,
//     required this.createdAt,
//     this.restaurant,
//     this.conciergeName,
//     this.conciergeId,
//     this.lockerOrderCode,
//     this.lockerPin,
//   });

//   factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
//     return OrderHistoryModel(
//       id: json['id'] as String,
//       user: json['user'] as String,
//       restaurant: json['restaurant'] as String?,
//       items: (json['items'] as List)
//           .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
//           .toList(),
//       totalPrice: (json['totalPrice'] as num).toDouble(),
//       status: json['status'] as String,
//       statusUpdateCount: json['statusUpdateCount'] as int,
//       airport:
//           OrderAirportModel.fromJson(json['airport'] as Map<String, dynamic>),
//       conciergeName: json['conciergeName'] as String?,
//       conciergeId: json['conciergeId'] as String?,
//       lockerOrderCode: json['lockerOrderCode'] as String?,
//       lockerPin: json['lockerPin'] as String?,
//       deliveryMethod: json['deliveryMethod'] as String,
//       estimatedTime: json['estimatedTime'] as int,
//       updatedAt: DateTime.parse(json['updatedAt'] as String),
//       createdAt: DateTime.parse(json['createdAt'] as String),
//     );
//   }
//   final String id;
//   final String user;
//   final String? restaurant;
//   final List<OrderItemModel> items;
//   final double totalPrice;
//   final String status;
//   final int statusUpdateCount;
//   final OrderAirportModel airport;
//   final String? conciergeName;
//   final String? conciergeId;
//   final String? lockerOrderCode;
//   final String? lockerPin;
//   final String deliveryMethod;
//   final int estimatedTime;
//   final DateTime updatedAt;
//   final DateTime createdAt;

//   @override
//   List<Object?> get props => [
//         id,
//         user,
//         restaurant,
//         items,
//         totalPrice,
//         status,
//         statusUpdateCount,
//         airport,
//         conciergeName,
//         conciergeId,
//         lockerOrderCode,
//         lockerPin,
//         deliveryMethod,
//         estimatedTime,
//         updatedAt,
//         createdAt,
//       ];
// }
