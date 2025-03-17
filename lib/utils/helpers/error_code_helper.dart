String getCustomErrorMessage(String errorCode) {
  switch (errorCode) {
    case 'user-not-found':
      return 'User was not found in the database.';
    case 'wrong-password':
      return 'The password you entered is incorrect.';
    case 'email-already-in-use':
      return 'The email address is already registered.';
    case 'invalid-email':
      return 'The email address is invalid.';
    case 'weak-password':
      return 'The password is too weak. Please choose a stronger one.';
    case 'network-request-failed':
      return 'Network error. Please check your internet connection.';
    default:
      return 'An unexpected error occurred. Please try again.';
  }
}
