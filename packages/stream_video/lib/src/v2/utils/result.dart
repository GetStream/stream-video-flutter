import 'package:equatable/equatable.dart';

import '../errors/video_error.dart';

///  A class which encapsulates a successful outcome with a value of type [T]
///  or a failure with [VideoError].
abstract class Result<T> extends Equatable {
  const Result();

  factory Result.success(T value) => Success(value);
  factory Result.failure(VideoError error) => Failure(error);

  /// Checks if the result is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Check if the result is a [Failure].
  bool get isFailure => this is Failure;
}

/// Represents successful result.
class Success<T> extends Result<T> {
  const Success(this.data);

  /// The [T] data associated with the result.
  final T data;

  @override
  List<Object?> get props => [data];

  @override
  String toString() {
    return 'Result.Success{data: $data}';
  }
}

/// Represents failed result.
class Failure extends Result<Never> {
  const Failure(this.error);

  /// The [VideoError] associated with the result.
  final VideoError error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() {
    return 'Result.Failure{error: $error}';
  }
}
