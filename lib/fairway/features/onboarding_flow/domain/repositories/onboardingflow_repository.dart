import 'package:fairway/utils/helpers/repository_response.dart';

abstract class OnboardingFlowRepository {
  Future<RepositoryResponse<Map<String, dynamic>>> signIn(
    String email,
    String password,
  );
  Future<RepositoryResponse<Map<String, dynamic>>> signUp(
    String name,
    String email,
    String password,
  );
  Future<RepositoryResponse<Map<String, dynamic>>> forgotPassword(
    String email,
  );
}
