import 'package:equatable/equatable.dart';
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

  final DataState<AuthData> signIn;
  final DataState<AuthData> signUp;
  final DataState<dynamic> forgotPassword;
  final String? resetCode;
  final DataState<dynamic> resetPassword;

  OnboardingFlowState copyWith({
    DataState<AuthData>? signIn,
    DataState<AuthData>? signUp,
    DataState<dynamic>? forgotPassword,
    String? resetCode,
    DataState<dynamic>? resetPassword,
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
