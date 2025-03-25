import 'package:equatable/equatable.dart';

class LocationData extends Equatable {
  const LocationData({
    required this.airports,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    // Handle both data structures
    final airportsJson = json['airports'] as List<dynamic>;
    return LocationData(
      airports: airportsJson
          .map<Airport>((dynamic airport) =>
              Airport.fromJson(airport as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<Airport> airports;

  @override
  List<Object?> get props => [airports];
}

class Airport extends Equatable {
  const Airport({
    required this.id,
    required this.name,
    required this.code,
    required this.createdAt,
    this.terminals =
        const [], // Made terminals optional with empty list default
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      id: json['_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      terminals:
          (json['terminals'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  final String id;
  final String name;
  final String code;
  final DateTime createdAt;
  final List<String> terminals;

  @override
  List<Object?> get props => [id, name, code, createdAt, terminals];
}
