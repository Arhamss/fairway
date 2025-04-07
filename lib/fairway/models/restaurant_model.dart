import 'package:equatable/equatable.dart';
import 'package:fairway/constants/constants.dart';
import 'package:fairway/fairway/models/category_model.dart';

class RestaurantModel extends Equatable {
  const RestaurantModel({
    required this.id,
    required this.name,
    required this.website,
    required this.images,
    required this.airports,
    required this.categories,
    required this.recommended,
    required this.popularity,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      website: json['website'] as String,
      images: json['images'] as String,
      airports: json['airport'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((cat) => CategoryModel.fromJson(cat as Map<String, dynamic>))
          .toList(),
      recommended: json['recommended'] as bool? ?? false,
      popularity: json['popularity'] as int? ?? 0,
    );
  }

  final String id;
  final String name;
  final String website;
  final String images;
  final String airports;
  final List<CategoryModel> categories;
  final bool recommended;
  final int popularity;

  String get primaryImage =>
      images.isNotEmpty ? images : AppConstants.restaurantPlaceHolder;

  bool hasCategory(String category) =>
      categories.any((cat) => cat.name.toLowerCase() == category.toLowerCase());

  @override
  List<Object?> get props => [
        id,
        name,
        website,
        images,
        airports,
        categories,
        recommended,
        popularity,
      ];
}
