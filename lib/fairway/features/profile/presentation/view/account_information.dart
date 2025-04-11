import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';

class AccountInformationScreen extends StatelessWidget {
  const AccountInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.updateProfile.isLoaded ?? false) {
          ToastHelper.showSuccessToast(
            'Profile updated successfully',
          );
        } else if (state.updateProfile.isFailure ?? false) {
          ToastHelper.showErrorToast(
            state.updateProfile.errorMessage ?? 'Failed to update profile',
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          forceMaterialTransparency: true,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final userProfile = state.userProfile;

            if (state.userProfile.isLoading) {
              return const Center(child: LoadingWidget());
            }

            if (state.userProfile.isFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Failed to load account information',
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

            if (userProfile.data == null) {
              return const EmptyStateWidget(
                image: AssetPaths.empty,
                text: 'No account information available',
              );
            }

            final nameController =
                TextEditingController(text: userProfile.data?.name);
            final emailController =
                TextEditingController(text: userProfile.data?.email);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Account Information',
                    textAlign: TextAlign.center,
                    style: context.h2.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Full Name',
                    style: context.b2.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyShade4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FairwayTextField(
                    controller: nameController,
                    hintText: 'Enter your full name',
                    readOnly: false,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Email Address',
                    style: context.b2.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyShade4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FairwayTextField(
                    controller: emailController,
                    hintText: 'Enter your email address',
                    readOnly: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return FairwayButton(
                        text: 'Change settings',
                        borderRadius: 8,
                        onPressed: () {
                          context.read<ProfileCubit>().updateUserProfile(
                                nameController.text,
                              );
                        },
                        isLoading: state.updateProfile.isLoading ?? false,
                        textColor: AppColors.white,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
