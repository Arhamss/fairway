import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

 part 'saved_location_model.g.dart';

@HiveType(typeId: 2)
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

  @HiveField(0)
  final String airportName;

  @HiveField(1)
  final String airportCode;

  @HiveField(2)
  final String terminal;

  @HiveField(3)
  final String gate;

  @HiveField(4)
  final bool isCurrent;

  @HiveField(5)
  final DateTime addedAt;

  Map<String, dynamic> toJson() => {
        'airportName': airportName,
        'airportCode': airportCode,
        'terminal': terminal,
        'gate': gate,
        'isCurrent': isCurrent,
        'addedAt': addedAt.toIso8601String(),
      };

  SavedLocation copyWith({
    String? airportName,
    String? airportCode,
    String? terminal,
    String? gate,
    bool? isCurrent,
    DateTime? addedAt,
  }) {
    return SavedLocation(
      airportName: airportName ?? this.airportName,
      airportCode: airportCode ?? this.airportCode,
      terminal: terminal ?? this.terminal,
      gate: gate ?? this.gate,
      isCurrent: isCurrent ?? this.isCurrent,
      addedAt: addedAt ?? this.addedAt,
    );
  }

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
