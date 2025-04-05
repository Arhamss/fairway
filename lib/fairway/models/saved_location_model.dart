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

  factory SavedLocation.empty() => SavedLocation(
        airportName: '',
        airportCode: '',
        terminal: '',
        gate: '',
        addedAt: DateTime.now(),
      );

  factory SavedLocation.fromJson(Map<String, dynamic> json) {
    return SavedLocation(
      airportName: json['airportName'] as String,
      airportCode: json['airportCode'] as String,
      terminal: json['terminal'] as String,
      gate: json['gate'] as String,
      isCurrent: json['isCurrent'] as bool? ?? false,
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'] as String)
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
