import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/location/data/models/terminal_model.dart';

class Airport extends Equatable {
  const Airport({
    required this.id,
    required this.name,
    required this.code,
    this.lat,
    this.long,
    this.terminals = const [],
    this.createdAt,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    // Handle different response formats
    final id = json['id'] as String? ?? json['_id'] as String?;

    // Parse terminals if available
    var terminals = <Terminal>[];
    if (json['terminals'] != null) {
      final terminalsJson = json['terminals'] as List<dynamic>;
      terminals = terminalsJson
          .map(
            (terminal) => Terminal.fromJson(terminal as Map<String, dynamic>),
          )
          .toList();
    }

    return Airport(
      id: id ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      lat: json['lat'] as double?,
      long: json['long'] as double?,
      terminals: terminals,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  final String id;
  final String name;
  final String code;
  final double? lat;
  final double? long;
  final List<Terminal> terminals;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'lat': lat,
        'long': long,
        'terminals': terminals.map((terminal) => terminal.toJson()).toList(),
        'createdAt': createdAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, name, code, lat, long, terminals, createdAt];
}
