import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/constants/app_text_style.dart';
import 'package:fairway/constants/asset_paths.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';
import 'package:flutter/material.dart';

class PasswordCode extends StatefulWidget {
  const PasswordCode({super.key});

  @override
  State<PasswordCode> createState() => _PasswordCodeState();
}

class _PasswordCodeState extends State<PasswordCode> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
      ),
      body: LayoutBuilder(
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
                    'Verification Code',
                    style: context.h1.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the verification code, sent on the email you entered.',
                    style: context.b2.copyWith(
                      color: AppColors.greyShade2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  FairwayTextField(
                    hintText: 'Code',
                    labelText: 'Code',
                    controller: _codeController,
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
                    builder: (context, state) {
                      return FairwayButton(
                        textColor: AppColors.white,
                        borderRadius: 15,
                        backgroundColor: AppColors.primaryButton,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await context.read<OnboardingFlowCubit>().setResetCode(
                                  _codeController.text,
                                );

                            context.goNamed(AppRouteNames.resetPassword);
                          } else {
                            ToastHelper.showInfoToast(
                              'Please enter a valid code',
                            );
                          }
                        },
                        text: 'Change Password',
                        isLoading: false,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
