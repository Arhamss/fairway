import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/fairway/features/profile/domain/repositories/profile_repository.dart';
import 'package:fairway/fairway/models/api_response/api_response_model.dart';
import 'package:fairway/fairway/models/api_response/base_api_response.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

class ProfileRepositoryImplementation implements ProfileRepository {
  ProfileRepositoryImplementation({
    ApiService? apiService,
    AppPreferences? baseStorage,
  })  : _apiService = apiService ?? ApiService(),
        _cache = baseStorage ?? AppPreferences();

  final ApiService _apiService;
  final AppPreferences _cache;
  @override
  Future<RepositoryResponse<UserData>> updateUserProfile(String name) async {
    try {
      final response = await _apiService.get(
        Endpoints.customerProfile,
        queryParams: {'name': name},
      );

      final result = UserData.parseResponse(response);
      final userData = result.response?.data;

      if (result.isSuccess && userData != null) {
        return RepositoryResponse(
          isSuccess: true,
          data: userData,
        );
      } else {
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to update user profile',
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to update user profile: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<bool>> updateUserPassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final response = await _apiService.post(
        endpoint: Endpoints.changePassword,
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      final result = ResponseModel.fromApiResponse<BaseApiResponse<void>>(
        response,
        (json) => BaseApiResponse<void>.fromJson(json, (_) {}),
      );

      if (result.isSuccess) {
        return RepositoryResponse(
          isSuccess: true,
          data: true,
          message: 'Password updated successfully',
        );
      } else {
        return RepositoryResponse(
          isSuccess: false,
          message: result.error ?? 'Failed to update password',
          data: false,
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to update password: $e',
        data: false,
      );
    }
  }

  @override
  Future<RepositoryResponse<bool>> deleteAccount() async {
    try {
      final response = await _apiService.delete(Endpoints.deleteAccount);

      if (response.statusCode == 200) {
        return RepositoryResponse(
          isSuccess: true,
          data: true,
          message: 'Account deleted successfully',
        );
      }

      return RepositoryResponse(
        isSuccess: false,
        data: false,
        message: 'Failed to delete account',
      );
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        data: false,
        message: 'Error: $e',
      );
    }
  }
}
