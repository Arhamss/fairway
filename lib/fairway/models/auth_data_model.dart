import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/api_response_model.dart';

class AuthData extends Equatable {
  const AuthData({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    final authData = json['auth'] as Map<String, dynamic>? ?? json;
    return AuthData(
      id: authData['id'] as String,
      name: authData['name'] as String,
      email: authData['email'] as String,
      token: authData['token'] as String,
    );
  }
  final String id;
  final String name;
  final String email;
  final String token;

  @override
  List<Object?> get props => [id, name, email, token];
}

typedef AuthResponse = ApiResponse<AuthData>;

extension AuthResponseParser on AuthResponse {
  static AuthResponse fromJson(Map<String, dynamic> json) {
    return ApiResponse.fromJson(
      json,
      AuthData.fromJson,
    );
  }
}
