import 'package:dio/dio.dart';
import 'package:fairway/core/api_service/authentication_interceptor.dart';
import 'package:fairway/core/api_service/log_interceptor.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:flutter/material.dart';

class ApiService {
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${Endpoints.baseUrl}/${Endpoints.apiVersion}/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(AuthInterceptor(_appPreferences, _dio));
    _dio.interceptors.add(LoggingInterceptor());
  }
  static final ApiService _instance = ApiService._internal();

  late final Dio _dio;
  final AppPreferences _appPreferences = Injector.resolve<AppPreferences>();

  /// GET Request
  Future<Response<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    return _handleRequest(
      () => _dio.get(endpoint, queryParameters: queryParams),
    );
  }

  /// POST Request
  Future<Response<dynamic>> post({
    required String endpoint,
    dynamic data,
  }) async {
    return _handleRequest(() => _dio.post(endpoint, data: data));
  }

  /// PUT Request
  Future<Response<dynamic>> put(String endpoint, dynamic data) async {
    return _handleRequest(() => _dio.put(endpoint, data: data));
  }

  /// PATCH Request
  Future<Response<dynamic>> patch(String endpoint, dynamic data) async {
    return _handleRequest(() => _dio.patch(endpoint, data: data));
  }

  /// DELETE Request
  Future<Response<dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    return _handleRequest(
      () => _dio.delete(endpoint, queryParameters: queryParams),
    );
  }

  /// Handles Requests & Centralized Error Handling
  Future<Response<dynamic>> _handleRequest(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      debugPrint('Unhandled error: $e');
      throw Exception('Unexpected error occurred.');
    }
  }

  /// Standardized API Error Handling
  Response<dynamic> _handleDioError(DioException e) {
    var errorMessage = 'An unknown error occurred';

    if (e.response != null) {
      switch (e.response?.statusCode) {
        case 400:
          errorMessage = 'Bad request';
        case 401:
          errorMessage = 'Unauthorized - Token may be expired';
        case 403:
          errorMessage = 'Forbidden access';
        case 404:
          errorMessage = 'Resource not found';
        case 500:
          errorMessage = 'Internal server error';
        default:
          errorMessage = 'Unexpected error: ${e.response?.statusMessage}';
      }
    } else {
      errorMessage = e.message ?? 'Network error';
    }

    debugPrint('❌ API Error: $errorMessage');
    throw DioException(
      requestOptions: e.requestOptions,
      error: errorMessage,
      response: e.response,
      type: e.type,
    );
  }
}
