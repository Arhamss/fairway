class AppConstants {
  factory AppConstants() {
    return _singleton;
  }

  AppConstants._internal();

  static final AppConstants _singleton = AppConstants._internal();

  static const placeholderUserAvatar = 'assets/images/user_avatar.png';
  static const placeholderUserName = 'Unknown User';
  static const placeholderUserEmail = 'Unknown Email';
  static const restaurantPlaceHolder =
      'assets/images/placeholder_restaurant.png';
  static const paginationPageLimit = 5;
}
