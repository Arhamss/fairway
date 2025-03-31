import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';

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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: BlocListener<OnboardingFlowCubit, OnboardingFlowState>(
          listener: (context, state) {
            if (state.signUp.isFailure) {
              ToastHelper.showErrorToast(
                state.signUp.errorMessage ?? 'Something went wrong',
              );
            } else if (state.signUp.isLoaded) {
              context.goNamed(AppRouteNames.selectLocation);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      AssetPaths.fairwaySignupLogo,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Text(
                      'Hello, create your account',
                      style: context.h3.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: context.b2.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.goNamed(AppRouteNames.signIn);
                          },
                          child: Text(
                            'Sign in',
                            style: context.b2.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
                      builder: (context, state) {
                        return FairwayButton(
                          textColor: AppColors.white,
                          borderRadius: 15,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
