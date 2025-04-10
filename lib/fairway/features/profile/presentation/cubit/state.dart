import 'package:equatable/equatable.dart';
import 'package:fairway/fairway/models/user_model/user_model.dart';
import 'package:fairway/utils/helpers/data_state.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.updateProfile = const DataState.initial(),
    this.updatePassword = const DataState.initial(),
    this.logoutStatus = const DataState.initial(),
    this.deleteAccountStatus = const DataState.initial(),
    this.notificationPreference = const DataState.initial(),
    this.checkBoxChecked = false,
    this.userNotificationPreference = false,
  });

  final DataState<UserModel> updateProfile;
  final DataState<dynamic> updatePassword;
  final DataState<void> logoutStatus;
  final DataState<void> deleteAccountStatus;
  final DataState<void> notificationPreference;
  final bool checkBoxChecked;
  final bool userNotificationPreference;

  @override
  List<Object?> get props => [
        updateProfile,
        updatePassword,
        logoutStatus,
        deleteAccountStatus,
        notificationPreference,
        checkBoxChecked,
        userNotificationPreference,
      ];

  ProfileState copyWith({
    DataState<UserModel>? updateProfile,
    DataState<dynamic>? updatePassword,
    DataState<void>? logoutStatus,
    DataState<void>? deleteAccountStatus,
    DataState<void>? notificationPreference,
    bool? checkBoxChecked,
    bool? userNotificationPreference,
  }) {
    return ProfileState(
      updateProfile: updateProfile ?? this.updateProfile,
      updatePassword: updatePassword ?? this.updatePassword,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      deleteAccountStatus: deleteAccountStatus ?? this.deleteAccountStatus,
      notificationPreference:
          notificationPreference ?? this.notificationPreference,
      checkBoxChecked: checkBoxChecked ?? this.checkBoxChecked,
      userNotificationPreference:
          userNotificationPreference ?? this.userNotificationPreference,
    );
  }
}
