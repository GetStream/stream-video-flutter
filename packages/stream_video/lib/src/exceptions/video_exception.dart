class VideoException implements Exception {
  factory VideoException(String message) {
    return VideoException._(message);
  }

  const VideoException._(this.message);

  final String message;

  @override
  String toString() {
    return 'VideoException{message: $message}';
  }
}
