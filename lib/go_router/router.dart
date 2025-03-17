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
      )
    ],
  );
}
