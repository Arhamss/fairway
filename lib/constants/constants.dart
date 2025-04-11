class AppConstants {
  factory AppConstants() {
    return _singleton;
  }

  AppConstants._internal();

  static final AppConstants _singleton = AppConstants._internal();

  static const placeholderUserAvatar =
      'https://fairways-backend.onrender.com/bunny.jpg';
  static const placeholderUserName = 'Unknown User';
  static const placeholderUserEmail = 'Unknown Email';
  static const restaurantPlaceHolder =
      'assets/images/placeholder_restaurant.png';
}
