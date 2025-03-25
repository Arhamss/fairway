import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/api_response_model.dart';

class ErrorData extends Equatable {
  final int code;
  final String message;
  final DateTime timestamp;

  const ErrorData({
    required this.code,
    required this.message,
    required this.timestamp,
  });

  factory ErrorData.fromJson(Map<String, dynamic> json) {
    final errorData = json['error'] as Map<String, dynamic>;
    return ErrorData(
      code: errorData['code'] as int,
      message: errorData['message'] as String,
      timestamp: DateTime.parse(errorData['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': {
        'code': code,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
      },
    };
  }

  @override
  List<Object?> get props => [code, message, timestamp];
}

typedef ErrorResponse = ApiResponse<ErrorData>;

extension ErrorResponseParser on ErrorResponse {
  static ErrorResponse fromJson(Map<String, dynamic> json) {
    return ApiResponse.fromJson(
      json,
      ErrorData.fromJson,
    );
  }
}
