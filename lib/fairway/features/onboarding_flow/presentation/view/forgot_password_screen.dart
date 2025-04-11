import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/cubit/state.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';

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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
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
            if (state.forgotPassword.isFailure) {
              ToastHelper.showErrorToast(
                state.forgotPassword.errorMessage ??
                    'Failed to send password recovery email',
              );
            } else if (state.forgotPassword.isLoaded) {
              context.goNamed(AppRouteNames.resetPasswordCode);
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 40,
                  right: 40,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
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
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                          SvgPicture.asset(AssetPaths.fairwaySignupLogo),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Text(
                            'Password Recovery',
                            style: context.h3
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your email to recover your password',
                            style:
                                context.b2.copyWith(color: AppColors.textGrey),
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
                                borderRadius: 16,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<OnboardingFlowCubit>()
                                        .forgotPassword(
                                          _emailController.text.trim(),
                                        );
                                  }
                                },
                                text: 'Recover Password',
                                isLoading: state.forgotPassword.isLoading,
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
