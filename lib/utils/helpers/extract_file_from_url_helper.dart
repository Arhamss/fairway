String extractTitleFromUrl(String url) {
  final decodedUrl = Uri.decodeFull(url);

  final regex = RegExp(r'\/([^\/?]+)\?');
  final match = regex.firstMatch(decodedUrl);

  if (match != null && match.groupCount >= 1) {
    final fileNameWithExtension = match.group(1)!;
    return fileNameWithExtension;
  }

  return 'Unknown Document';
}
