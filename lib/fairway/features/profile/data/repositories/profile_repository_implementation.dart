import 'package:fairway/core/api_service/api_service.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/endpoints/endpoints.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/profile/domain/repositories/profile_repository.dart';
import 'package:fairway/fairway/models/api_response_model.dart';
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
  Future<RepositoryResponse<ApiResponse<UserData>>> updateUserProfile(
    String name,
  ) async {
    try {
      final response = await _apiService.get(
        Endpoints.customerProfile,
        queryParams: {'name': name},
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        UserData.fromJson,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse,
        );
      } else {
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Failed to search restaurants',
          data: apiResponse,
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to search restaurants: $e',
      );
    }
  }

  @override
  Future<RepositoryResponse<ApiResponse>> updateUserPassword(
      String oldPassword, String newPassword) async {
    try {
      final response = await _apiService.post(
        endpoint: Endpoints.changePassword,
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json,
      );

      if (apiResponse.isSuccess) {
        return RepositoryResponse(
          isSuccess: true,
          data: apiResponse,
        );
      } else {
        return RepositoryResponse(
          isSuccess: false,
          message: apiResponse.errorMessage ?? 'Failed to update password',
          data: apiResponse,
        );
      }
    } catch (e) {
      return RepositoryResponse(
        isSuccess: false,
        message: 'Failed to update password: $e',
      );
    }
  }
  
@override
Future<RepositoryResponse<void>> deleteAccount() async {
  try {
    final response = await _apiService.delete(
      Endpoints.deleteAccount,
      
    );
    
    if (response.statusCode == 200) {
      return RepositoryResponse(
        isSuccess: true,
      );
    }
    
    return RepositoryResponse(
      isSuccess: false,
      message: 'Failed to delete account',
    );
  } catch (e) {
    return RepositoryResponse(
      isSuccess: false,
      message: 'Error: $e',
    );
  }
}
}
