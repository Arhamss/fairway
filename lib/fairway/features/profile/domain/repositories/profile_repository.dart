import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class ProfileRepository {
  Future<RepositoryResponse<UserData>> updateUserProfile(String name);
  Future<RepositoryResponse<dynamic>> updateUserPassword(
    String oldPassword,
    String newPassword,
  );
  Future<RepositoryResponse<void>> deleteAccount();
}
