import 'package:equatable/equatable.dart';

class Terminal extends Equatable {
  const Terminal({
    required this.id,
    required this.name,
    required this.gates,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) {
    return Terminal(
      id: json['id'] as String,
      name: json['name'] as String,
      gates: (json['gates'] as List<dynamic>).cast<String>(),
    );
  }

  final String id;
  final String name;
  final List<String> gates;

  @override
  List<Object?> get props => [id, name, gates];
}
