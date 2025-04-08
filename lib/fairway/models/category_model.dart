import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.picture,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String? ?? json['_id'] as String,
      name: json['name'] as String,
      picture: json['picture'] as String? ?? '',
    );
  }

  final String id;
  final String name;
  final String picture;

  String get imageOrPlaceholder => picture.isNotEmpty ? picture : '';

  @override
  List<Object?> get props => [
        id,
        name,
        picture,
      ];
}
