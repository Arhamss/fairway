class AppConstants {
  factory AppConstants() {
    return _singleton;
  }

  AppConstants._internal();

  static final AppConstants _singleton = AppConstants._internal();

  static const placeholderUserAvatar =
      'https://static.wikia.nocookie.net/villains/images/2/2b/Cmtspb.jpg/revision/latest?cb=20210513195220';
  static const placeholderUserName = 'Unknown User';
  static const placeholderUserEmail = 'Unknown Email';
}
