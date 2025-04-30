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
  static const String deleteAccount = 'auth/delete-account';
  static const String signinWithGoogle = 'auth/google-signin';
  static const String signinWithApple = 'auth/apple-signin';

  /// Concierge Endpoints
  static const String conciergeOrderHistory = 'concierge/orders/history';
  static const String conciergeActiveOrders = 'concierge/orders/active';

  /// Customer Endpoints
  static const String restaurants = 'customers/restaurants';
  static const String bestPartnerRestaurants =
      'customers/restaurants/best-partners';
  static const String searchRestaurants = 'customers/restaurants/search';
  static const String searchSuggestions =
      'customers/restaurants/search-suggestions';
  static const String recentSearches = 'customers/recent-searchs';
  static const String getSubscriptionStatus = 'customers/get-subscription';
  static const String updateSubscription = 'customers/set-subscription';

  static const String deleteRecentSearches = 'customers/recent-searches';
  static const String airports = 'customers/airports';
  static const String customerLocation = 'customers/my-locations';
  static const String setCurrentLocation = 'customers/set-current-location';
  static const String getCurrentLocation = 'customers/current-location';
  static const String restaurantSearch = 'customers/restaurants/search';
  static const String customerOrderHistory = 'customers/orders/history';
  static const String customerAirportSearch = 'customers/airport/search';
  static const String customerProfile = 'customers/profile';
  static const String updateNotificationPreference =
      'customers/notification-preference';
  static const String orderTypes = 'customers/order-type';
  static const String fcmToken = 'common/fcm-token';

  /// Order Endpoints
  static const String bookOrder = 'orders';
  static const String orderDetails = 'orders';
  static const String orderHistory = 'orders/my-orders';
  static const String orderStatus = 'orders//customer/status';

  

  /// Notification Endpoints
  static const String notifications = 'notifications';
  static const String markAsRead = 'notifications/read-all';
}
