import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/profile/presentation/widgets/account_type_widget.dart';
import 'package:fairway/fairway/features/profile/presentation/widgets/profile_item.dart';
import 'package:fairway/utils/widgets/core_widgets/custom_dialog.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // Handle successful logout
        if (state.logoutStatus.isLoaded) {
          context.goNamed(AppRouteNames.signIn);
        }
      },
      builder: (context, profileState) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            elevation: 0,
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
                icon: const Icon(Icons.notifications, color: AppColors.black),
                onPressed: () {
                  // Handle notifications
                },
              ),
            ],
          ),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, homeState) {
              final userProfile = homeState.userProfile.data;

              if (homeState.userProfile.isLoading) {
                return const Center(child: LoadingWidget());
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile section (truly no padding)
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                        ),
                        child: Column(
                          children: [
                            // Profile picture
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                AppConstants
                                    .placeholderUserAvatar, // Replace with actual image
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Name
                            Text(
                              userProfile?.name ?? 'User',
                              style: context.h2.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Email
                            // Text(
                            //   userProfile?.email ?? 'email@example.com',
                            //   style: context.b2.copyWith(
                            //     color: AppColors.greyShade4,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Add padding for sections below
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (userProfile?.signupType == 'google')
                              const AccountTypeWidget(
                                accountType: AccountType.google,
                              ),

                            if (userProfile?.signupType == 'apple')
                              const AccountTypeWidget(
                                accountType: AccountType.apple,
                              ),

                            // Account section
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'General',
                                      style: context.b1.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ProfileItem(
                                    title: 'Account Information',
                                    subtitle: 'Change your Account information',
                                    onTap: () => context.pushNamed(
                                      AppRouteNames.accountInformation,
                                    ),
                                    iconPath: AssetPaths.accountInfoLogo,
                                  ),
                                  const SizedBox(height: 8),
                                  if (userProfile?.signupType == 'email')
                                    ProfileItem(
                                      iconPath: AssetPaths.passwordIcon,
                                      title: 'Password',
                                      subtitle: 'Change your Password',
                                      onTap: () => context.pushNamed(
                                        AppRouteNames.changePassword,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Preferences section
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Notifications',
                                      style: context.b1.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Notifications items
                                  ProfileItem(
                                    title: 'Notifications',
                                    subtitle: 'Manage notifications settings',
                                    switchValue:
                                        profileState.userNotificationPreference,
                                    onSwitchChanged: (value) {
                                      context
                                          .read<ProfileCubit>()
                                          .updateNotificationPreference(value);
                                    },
                                    iconPath: AssetPaths.notificationSwitchLogo,
                                    type: ProfileItemType.notification,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Logout button
                            ProfileItem(
                              title: 'Log Out',
                              onTap: () => _showLogoutDialog(
                                context,
                                profileState.logoutStatus.isLoading,
                              ),
                              iconPath: AssetPaths.logoutIcon,
                            ),
                            const SizedBox(height: 24),

                            // Delete account button
                            FairwayButton(
                              borderColor: AppColors.error,
                              borderRadius: 12,
                              text: 'Delete Account',
                              onPressed: () =>
                                  context.goNamed(AppRouteNames.deleteAccount),
                              backgroundColor: Colors.white,
                              textColor: AppColors.error,
                              isLoading:
                                  profileState.deleteAccountStatus.isLoading,
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
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
}
