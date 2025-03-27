import 'package:equatable/equatable.dart';

class LocationData extends Equatable {
  const LocationData({
    required this.airports,
    required this.totalResults,
    required this.totalPages,
    required this.currentPage,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    // Get data from top level structure
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

class Airport extends Equatable {
  const Airport({
    required this.id,
    required this.name,
    required this.code,
    // this.createdAt,
    this.terminals = const [],
    // this.version = 0,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      // createdAt: DateTime.parse(json['createdAt'] as String),
      terminals:
          (json['terminals'] as List<dynamic>?)?.cast<String>() ?? const [],
      // version: json['__v'] as int? ?? 0,
    );
  }

  final String id;
  final String name;
  final String code;
  //final DateTime createdAt;
  final List<String> terminals;
  // final int version;

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        terminals,
      ];
}
