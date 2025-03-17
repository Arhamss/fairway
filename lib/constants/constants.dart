class AppConstants {
  factory AppConstants() {
    return _singleton;
  }

  AppConstants._internal();

  static final AppConstants _singleton = AppConstants._internal();
}
