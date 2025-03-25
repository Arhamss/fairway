import 'dart:math' as LoggerHelper;

import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/onboarding_flow/domain/repositories/onboardingflow_repository.dart';
import 'package:fairway/fairway/models/api_response_model.dart';
import 'package:fairway/fairway/models/auth_data_model.dart';
import 'package:fairway/fairway/models/location_data_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
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
  Future<RepositoryResponse<ApiResponse<AuthData>>> signIn(
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

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        AuthData.fromJson,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _cache.setToken(apiResponse.data!.token);
        AppLogger.info('Login successful: ${apiResponse.data!.name}');
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse,
        );
      } else {
        AppLogger.info('Login failed: ${apiResponse.errorMessage}');
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Sign in failed',
          data: apiResponse,
        );
      }
    } catch (e) {
      AppLogger.info('Login exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Sign in failed: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<ApiResponse<AuthData>>> signUp(
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

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        AuthData.fromJson,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _cache.setToken(apiResponse.data!.token);
        AppLogger.info('Signup successful: ${apiResponse.data!.name}');
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse,
        );
      } else {
        AppLogger.info('Signup failed: ${apiResponse.errorMessage}');
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Sign up failed',
          data: apiResponse,
        );
      }
    } catch (e) {
      AppLogger.info('Signup exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Sign up failed: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<ApiResponse<dynamic>>> forgotPassword(
    String email,
  ) async {
    try {
      final response = await _apiService.post(
        endpoint: Endpoints.forgotPassword,
        data: {
          'email': email,
        },
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json, // Just pass through the data
      );

      if (apiResponse.isSuccess) {
        AppLogger.info('Password reset email sent to: $email');
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse,
        );
      } else {
        AppLogger.info('Password reset failed: ${apiResponse.errorMessage}');
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Failed to reset password',
          data: apiResponse,
        );
      }
    } catch (e) {
      AppLogger.info('Password reset exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to reset password: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<ApiResponse<dynamic>>> resetPassword(
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

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json,
      );

      if (apiResponse.isSuccess) {
        AppLogger.info('Password reset successful');
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse,
        );
      } else {
        AppLogger.info('Password reset failed: ${apiResponse.errorMessage}');
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Failed to reset password',
          data: apiResponse,
        );
      }
    } catch (e) {
      AppLogger.info('Password reset exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to reset password: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<ApiResponse<UserData>>> updateUserLocation(
    String location,
  ) async {
    try {
      AppLogger.info('Updating location to: $location');
      final response = await _apiService.put(
        Endpoints.profile,
        {
          'location': location,
        },
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        UserData.fromJson,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        AppLogger.info(
          'Location updated successfully: ${apiResponse.data!.location}',
        );
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse,
          message: 'Location updated successfully',
        );
      } else {
        AppLogger.info('Location update failed: ${apiResponse.errorMessage}');
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Failed to update location',
          data: apiResponse,
        );
      }
    } catch (e) {
      AppLogger.info('Location update exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Location update failed: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<ApiResponse<LocationData>>> getAirports() async {
    try {
      final response = await _apiService.get(
        Endpoints.airports,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        LocationData.fromJson,
      );

      if (apiResponse.isSuccess) {
        AppLogger.info('Airports fetched successfully');
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse,
        );
      } else {
        AppLogger.error(
          'Failed to fetch airports: ${apiResponse.errorMessage}',
        );
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Failed to fetch airports',
          data: apiResponse,
        );
      }
    } catch (e) {
      AppLogger.error('Airports fetch exception: $e');
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to fetch airports: $e',
      );
    }
  }
}
