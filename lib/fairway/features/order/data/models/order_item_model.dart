import 'package:equatable/equatable.dart';

class OrderItemModel extends Equatable {
  const OrderItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
    );
  }
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String image;

  @override
  List<Object?> get props => [id, name, quantity, price, image];
}
