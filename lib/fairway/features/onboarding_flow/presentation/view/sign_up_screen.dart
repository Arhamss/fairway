import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/constants/app_text_style.dart';
import 'package:fairway/constants/asset_paths.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _namecontroller = TextEditingController();
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
          if (state.signUp!.isFailure) {
            ToastHelper.showInfoToast(
              'Failed to Sign up User',
            );
          } else if (state.signUp!.isLoaded) {
            ToastHelper.showInfoToast(
              'Signed up User',
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
                      'Hello, Create Account',
                      style: context.h1.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: context.b2,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.goNamed(AppRouteNames.signIn);
                          },
                          child: Text(
                            ' Sign in',
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
                      hintText: 'Your Name',
                      labelText: 'Your Name',
                      controller: _namecontroller,
                    ),
                    const SizedBox(height: 16),
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
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 180),
        child: BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
          builder: (context, state) {
            return FairwayButton(
              textColor: AppColors.white,
              borderRadius: 15,
              backgroundColor: AppColors.primaryButton,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<OnboardingFlowCubit>().signUp(
                        _namecontroller.text,
                        _emailcontroller.text,
                        _passwordcontroller.text,
                      );
                } else {
                  ToastHelper.showInfoToast(
                    'Please fill in all fields',
                  );
                }
              },
              text: 'Sign up',
              isLoading: state.signUp!.isLoading,
            );
          },
        ),
      ),
    );
  }
}
