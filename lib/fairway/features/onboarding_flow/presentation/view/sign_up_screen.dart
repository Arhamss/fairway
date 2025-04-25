import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/widgets/social_button.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          forceMaterialTransparency: true,
        ),
        body: SafeArea(
          child: BlocListener<OnboardingFlowCubit, OnboardingFlowState>(
            listener: (context, state) {
              if (state.signUp.isFailure) {
                ToastHelper.showInfoToast(
                  state.signUp.errorMessage ?? 'Failed to sign in user',
                );
              } else if (state.signInWithGoogle.isLoaded) {
                ToastHelper.showInfoToast(
                  'Successfully signed in with Google',
                );
                context.goNamed(AppRouteNames.selectLocation);
              } else if (state.signInWithGoogle.isFailure) {
                ToastHelper.showInfoToast(
                  state.signInWithGoogle.errorMessage ??
                      'Failed to sign in with Google',
                );
              } else if (state.signUp.isLoaded) {
                context.goNamed(AppRouteNames.selectLocation);
              }
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    24,
                    24,
                    MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SvgPicture.asset(AssetPaths.fairwaySignupLogo),
                            const SizedBox(height: 32),
                            Text(
                              'Hello, create your account',
                              style: context.h3
                                  .copyWith(fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: context.b2
                                      .copyWith(color: AppColors.textGrey),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      context.goNamed(AppRouteNames.signIn),
                                  child: Text(
                                    'Sign in',
                                    style: context.b2.copyWith(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            FairwayTextField(
                              hintText: 'Your Name',
                              labelText: 'Your Name',
                              controller: nameController,
                            ),
                            const SizedBox(height: 16),
                            FairwayTextField(
                              type: FairwayTextFieldType.email,
                              hintText: 'Email',
                              labelText: 'Email',
                              controller: emailController,
                            ),
                            const SizedBox(height: 16),
                            FairwayTextField(
                              type: FairwayTextFieldType.password,
                              hintText: 'Password',
                              labelText: 'Password',
                              controller: passwordController,
                            ),
                            const SizedBox(height: 32),
                            BlocBuilder<OnboardingFlowCubit,
                                OnboardingFlowState>(
                              builder: (context, state) {
                                return FairwayButton(
                                  textColor: AppColors.white,
                                  borderRadius: 16,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context
                                          .read<OnboardingFlowCubit>()
                                          .signUp(
                                            nameController.text.trim(),
                                            emailController.text
                                                .trim()
                                                .toLowerCase(),
                                            passwordController.text.trim(),
                                          );
                                    } else {
                                      ToastHelper.showInfoToast(
                                        'Please fill in all fields',
                                      );
                                    }
                                  },
                                  text: 'Sign up',
                                  isLoading: state.signUp.isLoading,
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                            Text(
                              'OR',
                              style: context.b2.copyWith(
                                color: AppColors.greyShade7,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 32),
                            BlocBuilder<OnboardingFlowCubit,
                                OnboardingFlowState>(
                              builder: (context, state) {
                                return SocialButton(
                                  onPressed: () {
                                    context
                                        .read<OnboardingFlowCubit>()
                                        .signInWithGoogle();
                                  },
                                  text: 'Connect with Google',
                                  svgPath: AssetPaths.googleIcon,
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<OnboardingFlowCubit,
                                OnboardingFlowState>(
                              builder: (context, state) {
                                return SocialButton(
                                  onPressed: () {
                                    context
                                        .read<OnboardingFlowCubit>()
                                        .signInWithApple();
                                  },
                                  text: 'Connect with Apple',
                                  svgPath: AssetPaths.appleIcon,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
