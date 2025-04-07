import 'package:fairway/fairway/models/user_model/user_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class ProfileRepository {
  Future<RepositoryResponse<UserModel>> updateUserProfile(String name);
  Future<RepositoryResponse<dynamic>> updateUserPassword(
    String oldPassword,
    String newPassword,
  );
  Future<RepositoryResponse<void>> deleteAccount();
}
