import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/user_model/user_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.updateProfile = const DataState.initial(),
    this.updatePassword = const DataState.initial(),
    this.logoutStatus = const DataState.initial(),
    this.deleteAccountStatus = const DataState.initial(),
  });

  final DataState<UserModel>? updateProfile;
  final DataState<dynamic>? updatePassword;
  final DataState<void> logoutStatus;
  final DataState<void> deleteAccountStatus;

  @override
  List<Object?> get props =>
      [updateProfile, updatePassword, logoutStatus, deleteAccountStatus];

  ProfileState copyWith({
    DataState<UserModel>? updateProfile,
    DataState<dynamic>? updatePassword,
    DataState<void>? logoutStatus,
    DataState<void>? deleteAccountStatus,
  }) {
    return ProfileState(
      updateProfile: updateProfile ?? this.updateProfile,
      updatePassword: updatePassword ?? this.updatePassword,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      deleteAccountStatus: deleteAccountStatus ?? this.deleteAccountStatus,
    );
  }
}
