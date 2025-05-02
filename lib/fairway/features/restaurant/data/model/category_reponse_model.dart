
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';
import 'package:fairway/fairway/models/category_model.dart';

class CategoryReponseModel extends Equatable {
  const CategoryReponseModel({
    required this.categories,
  });

  factory CategoryReponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryReponseModel(
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  static ResponseModel<BaseApiResponse<CategoryReponseModel>> parseResponse(
    Response response,
  ) {
    return ResponseModel.fromApiResponse<
        BaseApiResponse<CategoryReponseModel>>(
      response,
      (json) => BaseApiResponse<CategoryReponseModel>.fromJson(
        json,
        CategoryReponseModel.fromJson,
      ),
    );
  }

  final List<CategoryModel> categories;

  CategoryReponseModel copyWith({
    List<CategoryModel>? categories,

  }) {
    return CategoryReponseModel(
      categories: categories ?? this.categories,
  
    );
  }

  @override
  List<Object?> get props => [
        categories,
      ];
}
