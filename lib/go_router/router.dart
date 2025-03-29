part of 'exports.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  factory AppRouter() => _instance;

  AppRouter._internal();

  static final AppRouter _instance = AppRouter._internal();

  static BuildContext? get appContext =>
      AppRouter.router.routerDelegate.navigatorKey.currentContext;

  static String getCurrentLocation() {
    if (appContext == null) {
      throw Exception(
        'AppRouter.appContext is null. Ensure the appContext is initialized.',
      );
    }

    final router = GoRouter.of(appContext!);

    final configuration = router.routerDelegate.currentConfiguration;

    final lastMatch = configuration.last;
    final matchList =
        lastMatch is ImperativeRouteMatch ? lastMatch.matches : configuration;

    final currentLocation = matchList.uri.toString();
    return currentLocation;
  }

  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.introScreens,
        name: AppRouteNames.introScreens,
        builder: (context, state) => const IntroScreens(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        name: AppRouteNames.signIn,
        builder: (context, state) => const SignInScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.forgotPassword,
            name: AppRouteNames.forgotPassword,
            builder: (context, state) => const ForgotPasswordScreen(),
            routes: [
              GoRoute(
                path: AppRoutes.resetPasswordCode,
                name: AppRouteNames.resetPasswordCode,
                builder: (context, state) => const PasswordCode(),
                routes: [
                  GoRoute(
                    path: AppRoutes.resetPassword,
                    name: AppRouteNames.resetPassword,
                    builder: (context, state) => const ResetPasswordScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.passwordRecovered,
        name: AppRouteNames.passwordRecovered,
        builder: (context, state) => const PasswordRecoveredScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        name: AppRouteNames.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.selectLocation,
        name: AppRouteNames.selectLocation,
        builder: (context, state) => const SelectLocationScreen(),
      ),
      GoRoute(
        path: AppRoutes.homeScreen,
        name: AppRouteNames.homeScreen,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.searchScreen,
            name: AppRouteNames.searchScreen,
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: AppRoutes.profileScreen,
            name: AppRouteNames.profileScreen,
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: AppRoutes.accountInformation,
                name: AppRouteNames.accountInformation,
                builder: (context, state) => const AccountInformationScreen(),
              ),
              GoRoute(
                path: AppRoutes.changePassword,
                name: AppRouteNames.changePassword,
                builder: (context, state) => const ChangePasswordScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
