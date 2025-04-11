import 'package:equatable/equatable.dart';

class Terminal extends Equatable {
  const Terminal({
    required this.id,
    required this.name,
    this.gates = const [],
  });

  const Terminal.empty()
      : id = '',
        name = '',
        gates = const [];

  factory Terminal.fromJson(Map<String, dynamic> json) {
    final gates = <String>[];
    if (json['gates'] != null) {
      final gatesJson = json['gates'] as List<dynamic>;
      gates.addAll(gatesJson.map((gate) => gate as String));
    }

    return Terminal(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      gates: gates,
    );
  }

  final String id;
  final String name;
  final List<String> gates;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'gates': gates,
      };

  @override
  List<Object?> get props => [id, name, gates];
}
