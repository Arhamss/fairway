import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/profile/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/empty_state_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/retry_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/text_field.dart';

class AccountInformationSheet extends StatefulWidget {
  const AccountInformationSheet({super.key});

  @override
  State<AccountInformationSheet> createState() =>
      _AccountInformationSheetState();
}

class _AccountInformationSheetState extends State<AccountInformationSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();

    final userProfile = context.read<HomeCubit>().state.userProfile;
    nameController.text = userProfile.data?.name ?? '';
    emailController.text = userProfile.data?.email ?? '';

    nameController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);

    _updateButtonState();
  }

  @override
  void dispose() {
    nameController.removeListener(_updateButtonState);
    emailController.removeListener(_updateButtonState);
    nameController.dispose();
    emailController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    _isButtonEnabled.value =
        nameController.text.isNotEmpty && emailController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.updateProfile.isLoaded) {
          ToastHelper.showSuccessToast('Profile updated successfully');
          context.pop();
        } else if (state.updateProfile.isFailure) {
          ToastHelper.showErrorToast(
            state.updateProfile.errorMessage ?? 'Failed to update profile',
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
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final userProfile = state.userProfile;

                if (state.userProfile.isLoading) {
                  return const Center(child: LoadingWidget());
                }

                if (state.userProfile.isFailure) {
                  return RetryWidget(
                    message: 'Failed to load account information',
                    onRetry: () => context.read<HomeCubit>().loadUserProfile(),
                  );
                }

                if (userProfile.data == null) {
                  return const EmptyStateWidget(
                    image: AssetPaths.empty,
                    text: 'No account information available',
                  );
                }

                return Column(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Account Information',
                                    textAlign: TextAlign.center,
                                    style: context.h2.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            // Full-width divider
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      'Full Name',
                                      style: context.b2.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.greyShade6,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    FairwayTextField(
                                      textStyle: context.b1.copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      controller: nameController,
                                      hintText: 'Enter your full name',
                                      readOnly: false,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                      'Email Address',
                                      style: context.b2.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.greyShade6,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    FairwayTextField(
                                      showPrefixIcon: false,
                                      textStyle: context.b1.copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      controller: emailController,
                                      type: FairwayTextFieldType.email,
                                      hintText: 'Enter your email address',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                      child: BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: _isButtonEnabled,
                            builder: (context, isEnabled, _) {
                              return FairwayButton(
                                padding: const EdgeInsets.all(18),
                                text: 'Change settings',
                                fontWeight: FontWeight.w800,
                                borderRadius: 16,
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    FocusScope.of(context).unfocus();
                                    context
                                        .read<ProfileCubit>()
                                        .updateUserProfile(
                                          nameController.text,
                                        );
                                  }
                                },
                                isLoading:
                                    state.updateProfile.isLoading ?? false,
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
