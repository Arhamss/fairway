import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/constants/app_text_style.dart';
import 'package:fairway/constants/asset_paths.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
      ),
      body: BlocListener<OnboardingFlowCubit, OnboardingFlowState>(
        listener: (context, state) {
          if (state.signIn!.isFailure) {
            ToastHelper.showInfoToast(
              'Failed to Sign in User',
            );
          } else if (state.signIn!.isLoaded) {
            ToastHelper.showInfoToast(
              'Signed in User',
            );
            context.goNamed(AppRouteNames.selectLocation);
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
                      'Welcome Back',
                      style: context.h1.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hello Jos, sign in to continue',
                      style: context.b2,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Or',
                          style: context.b2,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.goNamed(AppRouteNames.signUp);
                          },
                          child: Text(
                            ' Create new account',
                            style: context.b2.copyWith(
                              color: AppColors.greenPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    FairwayTextField(
                      type: FairwayTextFieldType.email,
                      hintText: 'Username Or Email',
                      labelText: 'Username Or Email',
                      controller: _emailcontroller,
                    ),
                    const SizedBox(height: 16),
                    FairwayTextField(
                      type: FairwayTextFieldType.password,
                      hintText: 'Password',
                      labelText: 'Password',
                      controller: _passwordcontroller,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
              builder: (context, state) {
                return FairwayButton(
                  textColor: AppColors.white,
                  borderRadius: 15,
                  backgroundColor: AppColors.primaryButton,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<OnboardingFlowCubit>().signIn(
                            _emailcontroller.text.trim(),
                            _passwordcontroller.text.trim(),
                          );
                    }
                  },
                  text: 'Sign in',
                  isLoading: state.signIn!.isLoading,
                );
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                context.goNamed(AppRouteNames.forgotPassword);
              },
              child: Text(
                'Forgot Password?',
                style: context.b2.copyWith(
                  color: AppColors.greenPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
