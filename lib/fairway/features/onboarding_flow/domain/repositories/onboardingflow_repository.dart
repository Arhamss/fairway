import 'package:fairway/fairway/models/api_response_model.dart';
import 'package:fairway/fairway/models/auth_data_model.dart';
import 'package:fairway/fairway/models/location_data_model.dart';
import 'package:fairway/fairway/models/user_data_model.dart';
import 'package:fairway/utils/helpers/repository_response.dart';

abstract class OnboardingFlowRepository {
  Future<RepositoryResponse<ApiResponse<AuthData>>> signIn(
    String email,
    String password,
  );

  Future<RepositoryResponse<ApiResponse<AuthData>>> signUp(
    String name,
    String email,
    String password,
  );

  Future<RepositoryResponse<ApiResponse<dynamic>>> forgotPassword(String email);

  Future<RepositoryResponse<ApiResponse<UserData>>> updateUserLocation(
    String location,
  );

  Future<RepositoryResponse<ApiResponse<LocationData>>> getAirports();

  Future<RepositoryResponse<ApiResponse<dynamic>>> resetPassword(
    String code,
    String password,
  );
}
