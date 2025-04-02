import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/location/data/models/airport_model.dart';

class LocationData extends Equatable {
  const LocationData({
    required this.airports,
    required this.totalResults,
    required this.totalPages,
    required this.currentPage,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    final airportsJson = data['airports'] as List<dynamic>;
    return LocationData(
      airports: airportsJson
          .map<Airport>(
            (dynamic airport) =>
                Airport.fromJson(airport as Map<String, dynamic>),
          )
          .toList(),
      totalResults: data['totalResults'] as int,
      totalPages: data['totalPages'] as int,
      currentPage: data['currentPage'] as int,
    );
  }

  final List<Airport> airports;
  final int totalResults;
  final int totalPages;
  final int currentPage;

  @override
  List<Object?> get props => [airports, totalResults, totalPages, currentPage];
}
