import 'package:fairway/app/view/app_page.dart';
import 'package:fairway/core/app_preferences/app_preferences.dart';
import 'package:fairway/export.dart';
import 'package:fairway/core/di/injector.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;

      final token = Injector.resolve<AppPreferences>().getToken();

      if (token != null) {
        context.goNamed(AppRouteNames.homeScreen);
      } else {
        context.goNamed(AppRouteNames.signUp);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Image.asset(
            AssetPaths.logo,
          ),
        ),
      ),
    );
  }
}
