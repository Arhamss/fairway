import 'package:equatable/equatable.dart';

class AirportRequestModel extends Equatable {
  const AirportRequestModel({
    required this.airportCode,
    required this.terminal,
    required this.gate,
  });

  factory AirportRequestModel.fromJson(Map<String, dynamic> json) {
    return AirportRequestModel(
      airportCode: json['airportCode'] as String,
      terminal: json['terminal'] as String,
      gate: json['gate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airportCode': airportCode,
      'terminal': terminal,
      'gate': gate,
    };
  }

  final String airportCode;
  final String terminal;
  final String gate;

  @override
  List<Object?> get props => [
        airportCode,
        terminal,
        gate,
      ];
}
