import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
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
              _buildBulletPoint(
                'Your remaining tiket Points cannot be used anymore.',
              ),
              _buildBulletPoint(
                'Your tiket Elite Rewards benefits will not be available anymore.',
              ),
              _buildBulletPoint(
                'All your pending rewards will be deleted.',
              ),
              _buildBulletPoint(
                'All rewards from using credit card can no longer be obtained.',
              ),
              const SizedBox(height: 24),
              // Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: AppColors.error,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
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
              const Spacer(),
              // Delete Account Button
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, profileState) {
                  return FairwayButton(
                    text: 'Delete Account',
                    onPressed: () => isChecked == true
                        ? _showDeleteAccountDialog(
                            context,
                            profileState.deleteAccountStatus.isLoading,
                          )
                        : null,
                    backgroundColor: AppColors.error,
                    textColor: AppColors.white,
                    isLoading: profileState.deleteAccountStatus.isLoading,
                    borderRadius: 16,
                    fontWeight: FontWeight.w600,
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: context.b2.copyWith(color: AppColors.black),
            ),
          ),
        ],
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
