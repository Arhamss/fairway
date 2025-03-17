import 'package:fairway/config/api_environment.dart';

class Endpoints {
  /// Base API URL & Version (Dynamically Selected)**
  Endpoints._();
  static String get baseUrl => ApiEnvironment.current.baseUrl;
  static String get apiVersion => ApiEnvironment.current.apiVersion;

  /// Authentication Endpoints
  static const String login = 'auth/login';
  static const String signup = 'auth/signup';
  static const String forgotPassword = 'auth/forgot-password';
  static const String resetPassword = 'auth/reset-password';
  static const String changePassword = 'auth/change-password';
  static const String profile = 'auth/profile';

  /// Concierge Endpoints
  static const String conciergeOrderHistory = 'concierge/orders/history';
  static const String conciergeActiveOrders = 'concierge/orders/active';

  /// Customer Endpoints
  static const String restaurants = 'customers/restaurant';
  static const String airports = 'customers/airports';
  static const String customerLocation = 'customers/location';
  static const String restaurantSearch = 'customers/restaurants/search';
  static const String customerOrderHistory = 'customers/orders/history';

  /// Order Endpoints
  static const String bookOrder = 'orders';
  static const String orderDetails = 'orders';
}
