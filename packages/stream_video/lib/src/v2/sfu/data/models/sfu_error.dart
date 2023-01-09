class SfuError {
  SfuError({
    required this.message,
    required this.code,
  });

  final String message;
  final SfuErrorCode code;

  @override
  String toString() {
    return 'SfuError{code: $code, message: $message}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

enum SfuErrorCode {
  unspecified,
  publishTrackNotFound,
  publishTracksMismatch,
  publishTrackOutOfOrder,
  publishTrackVideoLayerNotFound,
  participantNotFound,
  callNotFound,
  internalServerError,
}
