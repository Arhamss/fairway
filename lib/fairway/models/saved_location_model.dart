import 'package:equatable/equatable.dart';

class SavedLocation extends Equatable {
  SavedLocation({
    required this.airportName,
    required this.airportCode,
    required this.terminal,
    required this.gate,
    this.isCurrent = false,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  factory SavedLocation.fromJson(Map<String, dynamic> json) {
    // Handle different response formats
    final responseJson = json['savedLocations'] ?? json;
    return SavedLocation(
      airportName: responseJson['airportName'] as String,
      airportCode: responseJson['airportCode'] as String,
      terminal: responseJson['terminal'] as String,
      gate: responseJson['gate'] as String,
      isCurrent: responseJson['isCurrent'] as bool? ?? false,
      addedAt: responseJson['addedAt'] != null
          ? DateTime.parse(responseJson['addedAt'] as String)
          : null,
    );
  }

  final String airportName;
  final String airportCode;
  final String terminal;
  final String gate;
  final bool isCurrent;
  final DateTime addedAt;

  Map<String, dynamic> toJson() => {
        'airportName': airportName,
        'airportCode': airportCode,
        'terminal': terminal,
        'gate': gate,
        'isCurrent': isCurrent,
        'addedAt': addedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        airportName,
        airportCode,
        terminal,
        gate,
        isCurrent,
        addedAt,
      ];
}
