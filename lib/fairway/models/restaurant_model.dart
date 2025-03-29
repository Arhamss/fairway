import 'package:equatable/equatable.dart';

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
    // Handle both direct restaurant data and nested data
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

  // Helper method to get primary image or placeholder
  String get primaryImage => images.isNotEmpty
      ? images.first
      : 'assets/images/placeholder_restaurant.png';

  // Helper method to check if restaurant is in a specific airport
  bool isInAirport(String airportCode) => airports
      .any((airport) => airport.toLowerCase() == airportCode.toLowerCase());

  // Helper method to check if restaurant belongs to a category
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

// You might also want a class for restaurant lists
class RestaurantList extends Equatable {
  const RestaurantList({
    required this.restaurants,
    this.totalResults = 0,
    this.totalPages = 1,
    this.currentPage = 1,
  });

  factory RestaurantList.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    final restaurantsJson = data['restaurants'] as List<dynamic>;
    return RestaurantList(
      restaurants: restaurantsJson
          .map<Restaurant>(
            (dynamic restaurant) =>
                Restaurant.fromJson(restaurant as Map<String, dynamic>),
          )
          .toList(),
      totalResults: data['totalResults'] as int? ?? restaurantsJson.length,
      totalPages: data['totalPages'] as int? ?? 1,
      currentPage: data['currentPage'] as int? ?? 1,
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
