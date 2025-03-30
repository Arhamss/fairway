import 'package:fairway/export.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';

class PasswordRecoveredScreen extends StatelessWidget {
  const PasswordRecoveredScreen({super.key});

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
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.05),
                Image.asset(
                  AssetPaths.passwordRecovery,
                ),
                SizedBox(height: constraints.maxHeight * 0.1),
                Text(
                  'Password Reset Success',
                  style: context.h1.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You now have full access to your account. Redirecting you to the dashboard in a few seconds. Welcome back.',
                  style: context.b2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyShade2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: constraints.maxHeight * 0.05),
                FairwayButton(
                  textColor: AppColors.white,
                  borderRadius: 15,
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    context.goNamed(AppRouteNames.signIn);
                  },
                  text: 'Sign in',
                  isLoading: false,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
