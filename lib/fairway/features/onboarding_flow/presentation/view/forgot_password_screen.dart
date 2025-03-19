import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/constants/app_text_style.dart';
import 'package:fairway/constants/asset_paths.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
      ),
      body: BlocListener<OnboardingFlowCubit, OnboardingFlowState>(
        listener: (context, state) {
          if (state.forgotPassword!.isFailure) {
            ToastHelper.showInfoToast(
              'Failed to send password recovery email',
            );
          } else if (state.forgotPassword!.isLoaded) {
            ToastHelper.showInfoToast(
              'Password recovery email sent',
            );
            context.goNamed(
              AppRouteNames.passwordRecovered,
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Image.asset(AssetPaths.logo, height: 160),
                    SizedBox(height: constraints.maxHeight * 0.08),
                    Text(
                      'Password Recovery',
                      style: context.h1.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your email to recover your password',
                      style: context.b2.copyWith(
                        color: AppColors.greyShade2,
                      ),
                    ),
                    const SizedBox(height: 30),
                    FairwayTextField(
                      type: FairwayTextFieldType.email,
                      hintText: 'Email',
                      labelText: 'Email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 40),
                    BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
                      builder: (context, state) {
                        return FairwayButton(
                          textColor: AppColors.white,
                          borderRadius: 15,
                          backgroundColor: AppColors.primaryButton,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<OnboardingFlowCubit>()
                                  .forgotPassword(
                                    _emailController.text.trim(),
                                  );
                            }
                          },
                          text: 'Receive Password',
                          isLoading: state.forgotPassword!.isLoading,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
