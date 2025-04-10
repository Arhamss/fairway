import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/custom_dialog.dart';
import 'package:fairway/utils/widgets/core_widgets/bullet_point_item.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Delete account',
          style: context.h2.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.deleteAccountStatus.isLoaded) {
            context.goNamed(AppRouteNames.signIn);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'You are going to delete your account.',
                style: context.h1.copyWith(
                  color: AppColors.black,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'If you delete your account:',
                style: context.b1.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 16),
              // Bullet Points
              const BulletPointItem(
                text: 'Your remaining tiket Points cannot be used anymore.',
              ),
              const BulletPointItem(
                text:
                    'Your tiket Elite Rewards benefits will not be available anymore.',
              ),
              const BulletPointItem(
                text: 'All your pending rewards will be deleted.',
              ),
              const BulletPointItem(
                text:
                    'All rewards from using credit card can no longer be obtained.',
              ),
              const SizedBox(height: 24),
              // Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return Checkbox(
                        value: state.checkBoxChecked,
                        activeColor: AppColors.error,
                        onChanged: (value) {
                          context.read<ProfileCubit>().toggleCheckBox();
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'I understand and accept all the above risks regarding my account deletion.',
                      style: context.b2.copyWith(color: AppColors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: FairwayButton(
              text: 'Delete Account',
              onPressed: () => state.checkBoxChecked == true
                  ? _showDeleteAccountDialog(
                      context,
                      state.deleteAccountStatus.isLoading,
                    )
                  : null,
              backgroundColor: AppColors.error,
              textColor: AppColors.white,
              isLoading: state.deleteAccountStatus.isLoading,
              borderRadius: 16,
              disabled: !state.checkBoxChecked,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, bool isLoading) {
    CustomDialog.showActionDialog(
      context: context,
      title: 'Delete Account',
      message:
          'This action cannot be undone. Are you sure you want to delete your account?',
      confirmText: 'Yes',
      isLoading: isLoading,
      isDanger: true,
      onConfirm: () {
        context.read<ProfileCubit>().deleteAccount();
      },
    );
  }
}
