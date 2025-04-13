import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/text_field.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController passController;
  late final TextEditingController newpassController;
  late final TextEditingController confirmNewpassController;
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    passController = TextEditingController();
    newpassController = TextEditingController();
    confirmNewpassController = TextEditingController();

    passController.addListener(_updateButtonState);
    newpassController.addListener(_updateButtonState);
    confirmNewpassController.addListener(_updateButtonState);

    _updateButtonState();
  }

  @override
  void dispose() {
    passController.removeListener(_updateButtonState);
    newpassController.removeListener(_updateButtonState);
    confirmNewpassController.removeListener(_updateButtonState);

    passController.dispose();
    newpassController.dispose();
    confirmNewpassController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    _isButtonEnabled.value = passController.text.isNotEmpty &&
        newpassController.text.isNotEmpty &&
        confirmNewpassController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.updatePassword.isLoaded) {
          ToastHelper.showSuccessToast('Password updated successfully');
          context.pop();
        } else if (state.updatePassword.isFailure) {
          ToastHelper.showErrorToast(
            state.updatePassword.errorMessage ?? 'Failed to update profile',
          );
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.95,
        builder: (_, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.greyShade3,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Change Password',
                            textAlign: TextAlign.center,
                            style: context.h2.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Container(
                          color: AppColors.dividerColor,
                          height: 1,
                          width: double.infinity,
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Password',
                                  style: context.b2.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.greyShade6,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                FairwayTextField(
                                  showPrefixIcon: false,
                                  controller: passController,
                                  hintText: 'Enter your current password',
                                  type: FairwayTextFieldType.password,
                                  textStyle: context.b1.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  color: AppColors.dividerColor,
                                  height: 1,
                                  width: double.infinity,
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  'New Password',
                                  style: context.b2.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.greyShade6,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                FairwayTextField(
                                  showPrefixIcon: false,
                                  controller: newpassController,
                                  type: FairwayTextFieldType.password,
                                  hintText: 'Enter your new password',
                                  textStyle: context.b1.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  color: AppColors.dividerColor,
                                  height: 1,
                                  width: double.infinity,
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  'Confirm New Password',
                                  style: context.b2.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.greyShade6,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                FairwayTextField(
                                  showPrefixIcon: false,
                                  controller: confirmNewpassController,
                                  type: FairwayTextFieldType.confirmPassword,
                                  hintText: 'Confirm your new password',
                                  textStyle: context.b1.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  compareValueBuilder: () =>
                                      newpassController.text,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isButtonEnabled,
                    builder: (context, isEnabled, _) {
                      return BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          return FairwayButton(
                            padding: const EdgeInsets.all(18),
                            text: 'Change password',
                            fontWeight: FontWeight.w800,
                            borderRadius: 16,
                            onPressed: isEnabled
                                ? () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      FocusScope.of(context).unfocus();
                                      context
                                          .read<ProfileCubit>()
                                          .updateUserPassword(
                                            passController.text,
                                            newpassController.text,
                                          );
                                    }
                                  }
                                : null,
                            isLoading: state.updatePassword.isLoading ?? false,
                            textColor: AppColors.white,
                            disabled: !isEnabled,
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
