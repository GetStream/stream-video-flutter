import 'package:equatable/equatable.dart';

class SfuError with EquatableMixin {
  SfuError({
    required this.message,
    required this.code,
    required this.shouldRetry,
  });

  final String message;
  final SfuErrorCode code;
  final bool shouldRetry;

  @override
  String toString() {
    return 'SfuError{code: $code, message: $message, '
        'shouldRetry: $shouldRetry}';
  }

  @override
  List<Object> get props => [message, code, shouldRetry];
}

enum SfuErrorCode {
  unspecified,
  publishTrackNotFound,
  publishTracksMismatch,
  publishTrackOutOfOrder,
  publishTrackVideoLayerNotFound,
  participantNotFound,
  callNotFound,
  requestValidationFailed,
  unauthenticated,
  permissionDenied,
  tooManyRequests,
  internalServerError;

  @override
  String toString() => name;
}
