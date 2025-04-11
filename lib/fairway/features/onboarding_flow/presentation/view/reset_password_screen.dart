import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<OnboardingFlowCubit, OnboardingFlowState>(
        listener: (context, state) {
          if (state.resetPassword!.isLoaded) {
            ToastHelper.showSuccessToast('Password reset successful');
            context.goNamed(AppRouteNames.passwordRecovered);
          } else if (state.resetPassword!.isFailure) {
            ToastHelper.showErrorToast(
              state.resetPassword?.errorMessage ?? 'Failed to reset password',
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Image.asset(AssetPaths.logo, height: 160),
                const SizedBox(height: 40),
                Text(
                  'Reset Password',
                  style: context.h1.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'At least 8 characters including uppercase and lowercase letters',
                  style: context.b2.copyWith(
                    color: AppColors.greyShade2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                FairwayTextField(
                  type: FairwayTextFieldType.password,
                  hintText: 'New Password',
                  labelText: 'New Password',
                  controller: _passwordController,
                ),
                const SizedBox(height: 20),
                FairwayTextField(
                  type: FairwayTextFieldType.confirmPassword,
                  hintText: 'Confirm Password',
                  labelText: 'Confirm Password',
                  controller: _confirmPasswordController,
                  compareValueBuilder: () => _passwordController.text,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: 100,
        ),
        child: BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
          builder: (context, state) {
            return FairwayButton(
              textColor: AppColors.white,
              borderRadius: 15,
              backgroundColor: AppColors.primaryBlue,
              onPressed: state.resetPassword!.isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        await context.read<OnboardingFlowCubit>().resetPassword(
                              state.resetCode ?? '',
                              _passwordController.text.trim(),
                            );
                      }
                    },
              text: 'Reset Password',
              isLoading: state.resetPassword!.isLoading,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
