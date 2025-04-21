import 'package:equatable/equatable.dart';

class OrderAirportModel extends Equatable {
  final String airportName;
  final String airportCode;
  final String terminal;
  final String gate;

  const OrderAirportModel({
    required this.airportName,
    required this.airportCode,
    required this.terminal,
    required this.gate,
  });

  factory OrderAirportModel.fromJson(Map<String, dynamic> json) {
    return OrderAirportModel(
      airportName: json['airportName'] as String,
      airportCode: json['airportCode'] as String,
      terminal: json['terminal'] as String,
      gate: json['gate'] as String,
    );
  }

  @override
  List<Object?> get props => [airportName, airportCode, terminal, gate];
}