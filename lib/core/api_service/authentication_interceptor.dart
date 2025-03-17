import 'package:dio/dio.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';

class AuthInterceptor extends Interceptor {
  final AppPreferences _appPreferences;
  final Dio _dio;
  bool _isRefreshing = false;
  Future<String?>? _refreshTokenFuture;

  AuthInterceptor(this._appPreferences, this._dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = _appPreferences.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final newToken = await _handleTokenRefresh();

      if (newToken != null) {
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final retryResponse = await _dio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      }
    }

    return handler.next(err);
  }

  /// Token Refresh Logic
  Future<String?> _handleTokenRefresh() async {
    if (_isRefreshing) {
      return _refreshTokenFuture;
    }

    _isRefreshing = true;
    _refreshTokenFuture = _refreshToken();

    final newToken = await _refreshTokenFuture;
    _isRefreshing = false;
    return newToken;
  }

  /// Actual Token Refresh API Call
  Future<String?> _refreshToken() async {
    try {
      final refreshToken = _appPreferences.getRefreshToken();
      if (refreshToken == null) {
        _appPreferences.clearAuthData();
        return null;
      }

      final response = await _dio.post(
        'https://i-love-it.onrender.com/v1/auth/refresh',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      if (response.statusCode == 200) {
        final newToken =
            (response.data as Map<String, dynamic>)['token'] as String;
        _appPreferences.setToken(newToken);
        return newToken;
      } else {
        _appPreferences.clearAuthData();
        return null;
      }
    } catch (e) {
      _appPreferences.clearAuthData();
      return null;
    }
  }
}
