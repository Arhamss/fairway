import 'package:fairway/export.dart';
import 'package:fairway/fairway/models/api_response_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class ProfileRepository {
  Future<RepositoryResponse<ApiResponse<UserData>>> updateUserProfile(
      String name);
  Future<RepositoryResponse<ApiResponse<dynamic>>> updateUserPassword(
    String oldPassword,
    String newPassword,
  );
  Future<RepositoryResponse<void>> deleteAccount();
}
