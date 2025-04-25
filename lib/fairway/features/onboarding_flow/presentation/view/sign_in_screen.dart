import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/core/di/injector.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/widgets/social_button.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final cache = Injector.resolve<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          forceMaterialTransparency: true,
        ),
        body: BlocListener<OnboardingFlowCubit, OnboardingFlowState>(
          listener: (context, state) {
            if (state.signIn.isFailure 
                // state.signInWithApple.isFailure ||
                // state.signInWithGoogle.isFailure
                ) {
              ToastHelper.showInfoToast(
                state.signIn.errorMessage ?? 'Failed to sign in user',
              );
            } else if (state.signIn.isLoaded 
                // state.signInWithApple.isLoaded ||
                // state.signInWithGoogle.isLoaded
                ) {
              context.goNamed(AppRouteNames.homeScreen);
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24,
                  0,
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
                          const SizedBox(height: 32),
                          SvgPicture.asset(AssetPaths.fairwaySignupLogo),
                          const SizedBox(height: 32),
                          Text(
                            'Welcome Back',
                            style: context.h1
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cache.getUserModel()?.name != null
                                ? 'Hello ${cache.getUserModel()!.name}, sign in to continue'
                                : 'Hi there, sign in to continue',
                            style: context.b2,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('or create a ', style: context.b2),
                              GestureDetector(
                                onTap: () =>
                                    context.goNamed(AppRouteNames.signUp),
                                child: Text(
                                  'new account',
                                  style: context.b2.copyWith(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
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
                          BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
                            builder: (context, state) {
                              return FairwayButton(
                                textColor: AppColors.white,
                                borderRadius: 16,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<OnboardingFlowCubit>().signIn(
                                          emailController.text.trim(),
                                          passwordController.text.trim(),
                                        );
                                  }
                                },
                                text: 'Sign in',
                                isLoading: state.signIn.isLoading,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () =>
                                context.goNamed(AppRouteNames.forgotPassword),
                            child: Text(
                              'Forgot Password?',
                              style: context.b2.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
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
                          const SizedBox(height: 16),
                          BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
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
                          BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
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
    );
  }
}
