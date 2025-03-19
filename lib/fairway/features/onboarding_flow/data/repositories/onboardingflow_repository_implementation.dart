import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/app_preferences/base_storage.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/onboarding_flow/domain/repositories/onboardingflow_repository.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

class OnboardingFlowRepositoryImplementation
    implements OnboardingFlowRepository {
  OnboardingFlowRepositoryImplementation({
    ApiService? apiService,
    AppPreferences? baseStorage,
  })  : _apiService = apiService ?? ApiService(),
        _cache = baseStorage ?? AppPreferences();

  final ApiService _apiService;
  final AppPreferences _cache;

  @override
  Future<RepositoryResponse<Map<String, dynamic>>> signIn(
    String email,
    String password,
  ) async {
    try {
      final response = await _apiService.post(
        endpoint: Endpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      AppLogger.info(
        'Sign in id: ${response.data['data']['id']}',
      );

      _cache.setToken(response.data['data']['token'].toString());
      return RepositoryResponse(
        isSuccess: true,
        data: response.data as Map<String, dynamic>,
      );
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Sign in failed: $e',
        data: {},
      );
    }
  }

  @override
  Future<RepositoryResponse<Map<String, dynamic>>> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _apiService.post(
        endpoint: Endpoints.signup,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      _cache.setToken(response.data['data']['token'].toString());

      return RepositoryResponse(
        isSuccess: true,
        data: response.data as Map<String, dynamic>,
      );
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Sign up failed: $e',
        data: {},
      );
    }
  }
  
  @override
  Future<RepositoryResponse<Map<String, dynamic>>> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(
        endpoint: Endpoints.forgotPassword,
        data: {
          'email': email,
        },
      );
      return RepositoryResponse(
        isSuccess: true,
        data: response.data as Map<String, dynamic>,
      );
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Forgot password failed: $e',
        data: {},
      );
    }
  }
}
