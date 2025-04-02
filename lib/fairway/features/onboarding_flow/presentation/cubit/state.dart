import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/api_response_model.dart';
import 'package:fairway/fairway/models/auth_data_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class OnboardingFlowState extends Equatable {
  const OnboardingFlowState({
    this.signIn = const DataState.initial(),
    this.signUp = const DataState.initial(),
    this.forgotPassword = const DataState.initial(),
    this.resetCode,
    this.resetPassword = const DataState.initial(),
  });

  final DataState<ApiResponse<AuthData>> signIn;
  final DataState<ApiResponse<AuthData>> signUp;
  final DataState<ApiResponse<dynamic>> forgotPassword;
  final String? resetCode;
  final DataState<ApiResponse<dynamic>> resetPassword;

  OnboardingFlowState copyWith({
    DataState<ApiResponse<AuthData>>? signIn,
    DataState<ApiResponse<AuthData>>? signUp,
    DataState<ApiResponse<dynamic>>? forgotPassword,
    String? resetCode,
    DataState<ApiResponse<dynamic>>? resetPassword,
  }) {
    return OnboardingFlowState(
      signIn: signIn ?? this.signIn,
      signUp: signUp ?? this.signUp,
      forgotPassword: forgotPassword ?? this.forgotPassword,
      resetCode: resetCode ?? this.resetCode,
      resetPassword: resetPassword ?? this.resetPassword,
    );
  }

  @override
  List<Object?> get props => [
        signIn,
        signUp,
        forgotPassword,
        resetCode,
      ];
}
