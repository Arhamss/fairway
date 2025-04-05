import 'package:fairway/fairway/models/auth_data_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class OnboardingFlowRepository {
  Future<RepositoryResponse<AuthData>> signIn(
    String email,
    String password,
  );

  Future<RepositoryResponse<AuthData>> signUp(
    String name,
    String email,
    String password,
  );

  Future<RepositoryResponse<dynamic>> forgotPassword(String email);

  Future<RepositoryResponse<dynamic>> resetPassword(
    String code,
    String password,
  );
}
