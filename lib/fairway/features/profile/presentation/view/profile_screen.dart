import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/profile/presentation/widget/account_information_sheet.dart';
import 'package:fairway/fairway/features/profile/presentation/widget/change_password_sheet.dart';
import 'package:fairway/fairway/features/profile/presentation/widgets/account_type_widget.dart';
import 'package:fairway/fairway/features/profile/presentation/widgets/profile_item.dart';
import 'package:fairway/fairway/features/profile/presentation/widgets/user_avatar.dart';
import 'package:fairway/utils/widgets/core_widgets/custom_dialog.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.logoutStatus.isLoaded) {
          context.goNamed(AppRouteNames.signIn);
        } else if (state.logoutStatus.isFailure) {
          ToastHelper.showErrorToast(
            state.logoutStatus.errorMessage ??
                'An unexpected error occurred while logging out. Please try again',
          );
        }
      },
      builder: (context, profileState) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            forceMaterialTransparency: true,
            title: Text(
              'Profile',
              style: context.h2.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  AssetPaths.notificationIcon,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, homeState) {
              final userProfile = homeState.userProfile.data;

              if (homeState.userProfile.isLoading) {
                return const LoadingWidget();
              }

              if (homeState.userProfile.isFailure) {
                return RetryWidget(
                  onRetry: () {
                    context.read<HomeCubit>().loadUserProfile();
                  },
                  message: homeState.userProfile.errorMessage ??
                      'Failed to load user profile',
                );
              }

              return ColoredBox(
                color: AppColors.darkWhiteBackground,
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                          ),
                          child: Column(
                            children: [
                              UserAvatar(
                                showEditIcon: true,
                                imageUrl: userProfile?.image,
                                onEditTap: () {
                                  print('Edit icon tapped');
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                userProfile?.name ?? 'User',
                                style: context.h2.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (userProfile?.signupType?.toLowerCase() ==
                                  'google')
                                const AccountTypeWidget(
                                  accountType: AccountType.google,
                                ),
                              if (userProfile?.signupType?.toLowerCase() ==
                                  'apple')
                                const AccountTypeWidget(
                                  accountType: AccountType.apple,
                                ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        'General',
                                        style: context.b1.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: AppColors.greyShade5,
                                      thickness: 1,
                                    ),
                                    ProfileItem(
                                      title: 'Account Information',
                                      subtitle:
                                          'Change your Account information',
                                      onTap: () =>
                                          _showAccountInformationSheet(context),
                                      iconPath: AssetPaths.accountInfoLogo,
                                    ),
                                    const SizedBox(height: 8),
                                    if (userProfile?.signupType == 'email')
                                      ProfileItem(
                                        iconPath: AssetPaths.passwordIcon,
                                        title: 'Password',
                                        subtitle: 'Change your Password',
                                        onTap: () =>
                                            _showChangePasswordSheet(context),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        'Notifications',
                                        style: context.b1.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: AppColors.greyShade5,
                                      thickness: 1,
                                    ),
                                    ProfileItem(
                                      title: 'Notifications',
                                      subtitle: 'Manage notifications settings',
                                      switchValue: profileState
                                          .userNotificationPreference,
                                      onSwitchChanged: (value) {
                                        context
                                            .read<ProfileCubit>()
                                            .updateNotificationPreference(
                                              value,
                                            );
                                      },
                                      iconPath:
                                          AssetPaths.notificationSwitchLogo,
                                      type: ProfileItemType.notification,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              ProfileItem(
                                title: 'Log Out',
                                onTap: () => _showLogoutDialog(
                                  context,
                                  profileState.logoutStatus.isLoading,
                                ),
                                iconPath: AssetPaths.logoutIcon,
                              ),
                              const SizedBox(height: 24),
                              FairwayButton(
                                borderColor: AppColors.error,
                                borderRadius: 12,
                                text: 'Delete Account',
                                fontWeight: FontWeight.bold,
                                onPressed: () => context
                                    .goNamed(AppRouteNames.deleteAccount),
                                backgroundColor: Colors.transparent,
                                textColor: AppColors.error,
                                isLoading:
                                    profileState.deleteAccountStatus.isLoading,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, bool isLoading) {
    CustomDialog.showActionDialog(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to log out?',
      confirmText: 'Yes',
      isLoading: isLoading,
      isDanger: true,
      onConfirm: () {
        context.read<ProfileCubit>().logout();
      },
    );
  }

  void _showAccountInformationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AccountInformationSheet(),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChangePasswordSheet(),
    );
  }
}
