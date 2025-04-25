import 'package:equatable/equatable.dart';

class RestaurantModel extends Equatable {
  const RestaurantModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String? ?? json['_id'] as String,
      name: json['name'] as String,
      image: json['images'] as String,
    );
  }
  final String id;
  final String name;
  final String image;

  @override
  List<Object?> get props => [id, name, image];
}
