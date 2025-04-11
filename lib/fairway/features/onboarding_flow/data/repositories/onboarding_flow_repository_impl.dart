import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/api_service/app_api_exception.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/onboarding_flow/domain/repositories/onboarding_flow_repository.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';
import 'package:fairway/fairway/models/auth_data_model.dart';
import 'package:fairway/utils/helpers/logger_helper.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

class OnboardingFlowRepositoryImpl implements OnboardingFlowRepository {
  OnboardingFlowRepositoryImpl({
    ApiService? apiService,
    AppPreferences? baseStorage,
  })  : _apiService = apiService ?? ApiService(),
        _cache = baseStorage ?? Injector.resolve<AppPreferences>();

  final ApiService _apiService;
  final AppPreferences _cache;

  @override
  Future<RepositoryResponse<AuthData>> signIn(
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

      final result = AuthData.parseResponse(response);
      final authData = result.response?.data;

      if (result.isSuccess && authData != null) {
        _cache
          ..setToken(authData.token)
          ..setUserId(authData.id);

        AppLogger.info('Sign in successful: ${authData.name}');

        return RepositoryResponse(
          isSuccess: true,
          data: authData,
        );
      } else {
        AppLogger.info('Sign in failed: ${result.error}');
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Sign in failed',
        );
      }
    } catch (e, s) {
      AppLogger.error('Sign in exception:', e, s);

      return RepositoryResponse(
        isSuccess: false,
        message: extractApiErrorMessage(e, 'Sign in failed'),
      );
    }
  }

  @override
  Future<RepositoryResponse<AuthData>> signUp(
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
          'role': 'user',
        },
      );

      final result = AuthData.parseResponse(response);
      final authData = result.response?.data;

      if (result.isSuccess && authData != null) {
        _cache
          ..setToken(authData.token)
          ..setUserId(authData.id);

        AppLogger.info('Signup successful: ${authData.name}');
        return RepositoryResponse(
          isSuccess: true,
          data: authData,
        );
      } else {
        AppLogger.error('Signup failed: ${result.error}');
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Sign up failed',
        );
      }
    } catch (e, s) {
      AppLogger.error('Signup exception:', e, s);

      return RepositoryResponse(
        isSuccess: false,
        message: extractApiErrorMessage(e, 'Sign up failed'),
      );
    }
  }

  @override
  Future<RepositoryResponse<bool>> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(
        endpoint: Endpoints.forgotPassword,
        data: {
          'email': email,
        },
      );

      final result = ResponseModel.fromApiResponse<BaseApiResponse<void>>(
        response,
        (json) => BaseApiResponse<void>.fromJson(json, (_) {}),
      );

      if (result.isSuccess) {
        AppLogger.info('Password reset email sent to: $email');
        return RepositoryResponse(
          isSuccess: true,
          data: true,
          message: 'Password reset email sent',
        );
      } else {
        AppLogger.info('Password reset failed: ${result.error}');
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to reset password',
          data: false,
        );
      }
    } catch (e, s) {
      AppLogger.error('Password reset exception:', e, s);

      return RepositoryResponse(
        isSuccess: false,
        message: extractApiErrorMessage(e, 'Failed to reset Password'),
        data: false,
      );
    }
  }

  @override
  Future<RepositoryResponse<bool>> resetPassword(
    String code,
    String password,
  ) async {
    try {
      final response = await _apiService.post(
        endpoint: Endpoints.resetPassword,
        data: {
          'token': code,
          'newPassword': password,
        },
      );

      final result = ResponseModel.fromApiResponse<BaseApiResponse<void>>(
        response,
        (json) => BaseApiResponse<void>.fromJson(json, (_) {}),
      );

      if (result.isSuccess) {
        AppLogger.info('Password reset successful');
        return RepositoryResponse(
          isSuccess: true,
          data: true,
          message: 'Password reset successful',
        );
      } else {
        AppLogger.info('Password reset failed: ${result.error}');
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to reset password',
          data: false,
        );
      }
    } catch (e, s) {
      AppLogger.error('Password reset exception:', e, s);

      return RepositoryResponse(
        isSuccess: false,
        message: extractApiErrorMessage(e, 'Failed to reset password'),
        data: false,
      );
    }
  }
}
