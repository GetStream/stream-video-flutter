import 'package:stream_video/src/v2/errors/video_error.dart';

///  A class which encapsulates a successful outcome with a value of type [T]
///  or a failure with [VideoError].
abstract class Result<T> {
  /// Checks if the result is a [Success].
  bool get isSuccess => this is Success;

  /// Check if the result is a [Failure].
  bool get isFailure => this is Failure;
}

/// Represents successful result.
class Success<T> extends Result<T> {
  Success(this.data);

  /// The [T] data associated with the result.
  final T data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() {
    return 'Result.Success{data: $data}';
  }
}

/// Represents failed result.
class Failure extends Result<Never> {
  Failure(this.error);

  /// The [VideoError] associated with the result.
  final VideoError error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() {
    return 'Result.Failure{error: $error}';
  }
}
