import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';

class Restaurant extends Equatable {
  const Restaurant({
    required this.id,
    required this.name,
    required this.website,
    required this.images,
    required this.airports,
    required this.categories,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final restaurantData = json['restaurants'] as Map<String, dynamic>? ?? json;

    return Restaurant(
      id: restaurantData['id'] as String,
      name: restaurantData['name'] as String,
      website: restaurantData['website'] as String,
      images: (restaurantData['images'] as List<dynamic>).cast<String>(),
      airports: (restaurantData['airports'] as List<dynamic>).cast<String>(),
      categories:
          (restaurantData['categories'] as List<dynamic>).cast<String>(),
    );
  }

  final String id;
  final String name;
  final String website;
  final List<String> images;
  final List<String> airports;
  final List<String> categories;

  String get primaryImage => images.isNotEmpty
      ? images.first
      : 'assets/images/placeholder_restaurant.png';

  bool isInAirport(String airportCode) => airports
      .any((airport) => airport.toLowerCase() == airportCode.toLowerCase());

  bool hasCategory(String category) =>
      categories.any((cat) => cat.toLowerCase() == category.toLowerCase());

  @override
  List<Object?> get props => [
        id,
        name,
        website,
        images,
        airports,
        categories,
      ];
}

class RestaurantList extends Equatable {
  const RestaurantList({
    required this.restaurants,
    this.totalResults = 0,
    this.totalPages = 1,
    this.currentPage = 1,
  });

  factory RestaurantList.fromJson(Map<String, dynamic> json) {
    final restaurantsJson = json['restaurants'] as List<dynamic>? ?? [];

    return RestaurantList(
      restaurants: restaurantsJson
          .map<Restaurant>(
            (restaurant) =>
                Restaurant.fromJson(restaurant as Map<String, dynamic>),
          )
          .toList(),
      totalResults: json['totalResults'] as int? ?? restaurantsJson.length,
      totalPages: json['totalPages'] as int? ?? 1,
      currentPage: json['currentPage'] as int? ?? 1,
    );
  }

  static ResponseModel<BaseApiResponse<RestaurantList>> parseResponse(
      Response response) {
    return ResponseModel.fromApiResponse<BaseApiResponse<RestaurantList>>(
      response,
      (json) => BaseApiResponse<RestaurantList>.fromJson(
          json, RestaurantList.fromJson),
    );
  }

  final List<Restaurant> restaurants;
  final int totalResults;
  final int totalPages;
  final int currentPage;

  @override
  List<Object?> get props =>
      [restaurants, totalResults, totalPages, currentPage];
}
