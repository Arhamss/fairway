import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/error_data_model.dart';

class ApiResponse<T> extends Equatable {
  const ApiResponse({
    required this.statusCode,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    final hasError = json['error'] != null;
    final hasData = json['data'] != null && !hasError;

    return ApiResponse<T>(
      statusCode: json['statusCode'] as int,
      data: hasData && fromJsonT != null
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
      error: hasError
          ? ErrorData.fromJson(json['error'] as Map<String, dynamic>)
          : null,
    );
  }
  final int statusCode;
  final T? data;
  final ErrorData? error;

  bool get isSuccess => statusCode >= 200 && statusCode < 300 && error == null;
  String? get errorMessage => error?.message;

  @override
  List<Object?> get props => [statusCode, data, error];
}
