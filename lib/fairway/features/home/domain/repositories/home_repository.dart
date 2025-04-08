import 'package:fairway/fairway/models/user_model/user_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class HomeRepository {
  Future<RepositoryResponse<UserModel>> getUserProfile();
  Future<RepositoryResponse<UserModel>> updateUserProfile();
}
