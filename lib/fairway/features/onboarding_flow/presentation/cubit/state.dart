import 'package:equatable/equatable.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class OnboardingFlowState extends Equatable {
  const OnboardingFlowState({
    this.signIn = const DataState.initial(),
    this.signUp = const DataState.initial(),
    this.forgotPassword = const DataState.initial(),
  });

  final DataState<Map<String, dynamic>>? signIn;
  final DataState<Map<String, dynamic>>? signUp;
  final DataState<Map<String, dynamic>>? forgotPassword;

  OnboardingFlowState copyWith({
    DataState<Map<String, dynamic>>? signIn,
    DataState<Map<String, dynamic>>? signUp,
    DataState<Map<String, dynamic>>? forgotPassword,
  }) {
    return OnboardingFlowState(
      signIn: signIn ?? this.signIn,
      signUp: signUp ?? this.signUp,
      forgotPassword: forgotPassword ?? this.forgotPassword,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        signIn,
        signUp,
        forgotPassword,
      ];
}
