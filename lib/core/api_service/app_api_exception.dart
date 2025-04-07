class AppApiException implements Exception {
  final String message;
  final int? statusCode;

  AppApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

String extractApiErrorMessage(Object e, String fallback) {
  return e is AppApiException ? e.message : fallback;
}
