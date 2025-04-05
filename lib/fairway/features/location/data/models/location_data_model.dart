import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/location/data/models/airport_model.dart';

class LocationData extends Equatable {
  const LocationData({
    required this.airports,
    this.totalResults = 0,
    this.totalPages = 0,
    this.currentPage = 0,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    // Check if response is a direct airport response or the usual paginated response
    if (json['id'] != null) {
      // Direct airport response
      final airportJson = json;
      return LocationData(
        airports: [Airport.fromJson(airportJson)],
        totalResults: 1,
        totalPages: 1,
        currentPage: 1,
      );
    }

    // Regular paginated response
    final data = json['data'] as Map<String, dynamic>? ?? json;

    final airportsJson = data['airports'] as List<dynamic>? ?? [];
    return LocationData(
      airports: airportsJson
          .map<Airport>(
            (dynamic airport) =>
                Airport.fromJson(airport as Map<String, dynamic>),
          )
          .toList(),
      totalResults: data['totalResults'] as int? ?? 0,
      totalPages: data['totalPages'] as int? ?? 0,
      currentPage: data['currentPage'] as int? ?? 0,
    );
  }

  final List<Airport> airports;
  final int totalResults;
  final int totalPages;
  final int currentPage;

  @override
  List<Object?> get props => [airports, totalResults, totalPages, currentPage];
}
