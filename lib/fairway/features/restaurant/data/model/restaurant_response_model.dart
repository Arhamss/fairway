import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/restaurant/data/model/restaurant_model.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';

class RestaurantResponseModel extends Equatable {
  const RestaurantResponseModel({
    required this.restaurants,
    this.totalResults = 0,
    this.totalPages = 1,
    this.currentPage = 1,
  });

  factory RestaurantResponseModel.fromJson(Map<String, dynamic> json) {
    return RestaurantResponseModel(
      restaurants: (json['restaurants'] as List<dynamic>?)
              ?.map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalResults: json['totalResults'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 1,
      currentPage: json['currentPage'] as int? ?? 1,
    );
  }

  static ResponseModel<BaseApiResponse<RestaurantResponseModel>> parseResponse(
    Response response,
  ) {
    return ResponseModel.fromApiResponse<
        BaseApiResponse<RestaurantResponseModel>>(
      response,
      (json) => BaseApiResponse<RestaurantResponseModel>.fromJson(
        json,
        RestaurantResponseModel.fromJson,
      ),
    );
  }

  final List<RestaurantModel> restaurants;
  final int totalResults;
  final int totalPages;
  final int currentPage;

  RestaurantResponseModel copyWith({
    List<RestaurantModel>? restaurants,
    int? totalResults,
    int? totalPages,
    int? currentPage,
  }) {
    return RestaurantResponseModel(
      restaurants: restaurants ?? this.restaurants,
      totalResults: totalResults ?? this.totalResults,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
        restaurants,
        totalResults,
        totalPages,
        currentPage,
      ];
}
