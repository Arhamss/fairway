import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/features/location/data/models/terminal_model.dart';

class Airport extends Equatable {
  const Airport({
    required this.id,
    required this.name,
    required this.code,
    this.terminals = const [],
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      terminals: (json['terminals'] as List<dynamic>?)
              ?.map((t) => Terminal.fromJson(t as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  final String id;
  final String name;
  final String code;
  final List<Terminal> terminals;

  @override
  List<Object?> get props => [id, name, code, terminals];
}
