import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/profile/presentation/widgets/profile_item.dart';
import 'package:fairway/utils/widgets/core_widgets/custom_dialog.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';

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

        // Handle successful account deletion
        if (state.deleteAccountStatus.isLoaded) {
          context.goNamed(AppRouteNames.signIn);
        }
      },
      builder: (context, profileState) {
        return Scaffold(
          backgroundColor: AppColors.darkWhiteBackground,
          appBar: fairwayAppBar(
            title: 'Profile',
            titleStyle: context.h2.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontSize: 24,
            ),
            centerTitle: true,
            leadingIcon: const Icon(Icons.arrow_back_ios),
            onLeadingPressed: () {
              context.pop();
            },
            actionWidget: IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.black),
              onPressed: () {
                // Handle notifications
              },
            ),
            context: context,
          ),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, homeState) {
              final userProfile = homeState.userProfile.data;

              if (homeState.userProfile.isLoading) {
                return const Center(child: LoadingWidget());
              }

              if (homeState.userProfile.isFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load profile',
                        style: context.b1.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      FairwayButton(
                        onPressed: () =>
                            context.read<HomeCubit>().loadUserProfile(),
                        text: 'Retry',
                        isLoading: false,
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Profile picture
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              'https://placehold.co/600x400', // Replace with actual image
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
                          Text(
                            userProfile?.email ?? 'email@example.com',
                            style: context.b2.copyWith(
                              color: AppColors.greyShade4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Account section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Account',
                        style: context.b1.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Account settings items
                    ProfileItem(
                      icon: Icons.person_outline,
                      label: 'Account Information',
                      subtitle: 'Change your account details',
                      onTap: () =>
                          context.pushNamed(AppRouteNames.accountInformation),
                    ),
                    const SizedBox(height: 8),

                    ProfileItem(
                      icon: Icons.lock_outline,
                      label: 'Change Password',
                      subtitle: 'Change your password',
                      onTap: () =>
                          context.pushNamed(AppRouteNames.changePassword),
                    ),
                    const SizedBox(height: 24),

                    // Preferences section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Preferences',
                        style: context.b1.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Preferences items
                    ProfileItem(
                      icon: Icons.notifications_none_outlined,
                      label: 'Notifications',
                      subtitle: 'Manage notifications settings',
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),

                    // Logout button
                    ProfileItem(
                      icon: Icons.logout,
                      label: 'Log Out',
                      onTap: () => _showLogoutDialog(
                        context,
                        profileState.logoutStatus.isLoading,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Delete account button
                    FairwayButton(
                      text: 'Delete Account',
                      onPressed: () => _showDeleteAccountDialog(
                        context,
                        profileState.deleteAccountStatus.isLoading,
                      ),
                      backgroundColor: Colors.white,
                      textColor: AppColors.error,
                      isLoading: profileState.deleteAccountStatus.isLoading,
                    ),
                  ],
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
      title: 'Log Out',
      message: 'Are you sure you want to log out?',
      confirmText: 'Log Out',
      isLoading: isLoading,
      isDanger: true,
      onConfirm: () {
        context.read<ProfileCubit>().logout();
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context, bool isLoading) {
    CustomDialog.showActionDialog(
      context: context,
      title: 'Delete Account',
      message:
          'This action cannot be undone. Are you sure you want to delete your account?',
      confirmText: 'Delete Account',
      isLoading: isLoading,
      isDanger: true,
      onConfirm: () {
        context.read<ProfileCubit>().deleteAccount();
      },
    );
  }
}
