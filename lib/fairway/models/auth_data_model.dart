import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';

class AuthData extends Equatable {
  const AuthData({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });
  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
    );
  }

  static ResponseModel<BaseApiResponse<AuthData>> parseResponse(
    Response response,
  ) {
    return ResponseModel.fromApiResponse<BaseApiResponse<AuthData>>(
      response,
      (json) => BaseApiResponse<AuthData>.fromJson(json, AuthData.fromJson),
    );
  }

  final String id;
  final String name;
  final String email;
  final String token;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'token': token,
      };

  AuthData copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
  }) {
    return AuthData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [id, name, email, token];
}
