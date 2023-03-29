import 'package:equatable/equatable.dart';

import '../errors/video_error.dart';

enum _ResultType { success, failure }

///  A class which encapsulates a successful outcome with a value of type [T]
///  or a failure with [VideoError].
abstract class Result<T> extends Equatable {
  const Result._(this._type);

  const factory Result.success(T value) = Success._;

  const factory Result.failure(VideoError error) = Failure._;

  factory Result.error(
    String message, [
    StackTrace? stackTrace,
  ]) = Failure._fromError;

  factory Result.errorWithCause(
    String message,
    Object cause, [
    StackTrace? stackTrace,
  ]) = Failure._fromErrorWithCause;

  final _ResultType _type;

  /// Checks if the result is a [Success].
  bool get isSuccess => _type == _ResultType.success;

  /// Check if the result is a [Failure].
  bool get isFailure => _type == _ResultType.failure;
}

/// Represents successful result.
class Success<T> extends Result<T> {
  const Success._(this.data) : super._(_ResultType.success);

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
  const Failure._(this.error) : super._(_ResultType.failure);

  factory Failure._fromError(String message, [StackTrace? stackTrace]) {
    final error = VideoError(message: message, stackTrace: stackTrace);
    return Failure._(error);
  }

  factory Failure._fromErrorWithCause(
    String message,
    Object cause, [
    StackTrace? stackTrace,
  ]) {
    final error = VideoErrorWithCause(
      message: message,
      cause: cause,
      stackTrace: stackTrace,
    );
    return Failure._(error);
  }

  /// The [VideoError] associated with the result.
  final VideoError error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() {
    return 'Result.Failure{error: $error}';
  }
}

extension PatternMatching<T> on Result<T> {
  /// The [when] method is the equivalent to pattern matching.
  /// Its prototype depends on the _Result [_type]s defined.
  R when<R extends Object?>({
    required R Function(T data) success,
    required R Function(VideoError error) failure,
  }) {
    switch (_type) {
      case _ResultType.success:
        return success((this as Success<T>).data);
      case _ResultType.failure:
        return failure((this as Failure).error);
    }
  }

  /// The [whenOrElse] method is equivalent to [when], but doesn't require
  /// all callbacks to be specified.
  ///
  /// On the other hand, it adds an extra orElse required parameter,
  /// for fallback behavior.
  R whenOrElse<R extends Object>({
    R Function(T data)? success,
    R Function(VideoError error)? failure,
    required R Function(Result<T>) orElse,
  }) {
    switch (_type) {
      case _ResultType.success:
        return success?.call((this as Success<T>).data) ?? orElse(this);
      case _ResultType.failure:
        return failure?.call((this as Failure).error) ?? orElse(this);
    }
  }

  /// The [whenOrNull] method is equivalent to [whenOrElse],
  /// but non-exhaustive.
  R? whenOrNull<R extends Object?>({
    R Function(T data)? success,
    R Function(VideoError error)? failure,
  }) {
    switch (_type) {
      case _ResultType.success:
        return success?.call((this as Success<T>).data);
      case _ResultType.failure:
        return failure?.call((this as Failure).error);
    }
  }

  /// The [map] method is the equivalent to pattern matching.
  /// Its prototype depends on the _Result [_type]s defined.
  Result<R> map<R>(R Function(T data) convert) {
    switch (_type) {
      case _ResultType.success:
        final origin = this as Success<T>;
        return Result.success(convert(origin.data));
      case _ResultType.failure:
        return this as Failure;
    }
  }

  /// The [fold] method is the equivalent to pattern matching.
  /// Its prototype depends on the _Result [_type]s defined.
  R fold<R extends Object?>({
    required R Function(Success<T> success) success,
    required R Function(Failure failure) failure,
  }) {
    switch (_type) {
      case _ResultType.success:
        return success(this as Success<T>);
      case _ResultType.failure:
        return failure(this as Failure);
    }
  }

  /// The [foldOrElse] method is equivalent to [fold], but doesn't require
  /// all callbacks to be specified.
  ///
  /// On the other hand, it adds an extra orElse required parameter,
  /// for fallback behavior.
  R foldOrElse<R extends Object>({
    R Function(Success<T> success)? success,
    R Function(Failure failure)? failure,
    required R Function(Result<T>) orElse,
  }) {
    switch (_type) {
      case _ResultType.success:
        return success?.call(this as Success<T>) ?? orElse(this);
      case _ResultType.failure:
        return failure?.call(this as Failure) ?? orElse(this);
    }
  }

  /// The [foldOrNull] method is equivalent to [whenOrElse],
  /// but non-exhaustive.
  R? foldOrNull<R extends Object?>({
    R Function(Success<T> success)? success,
    R Function(Failure failure)? failure,
  }) {
    switch (_type) {
      case _ResultType.success:
        return success?.call(this as Success<T>);
      case _ResultType.failure:
        return failure?.call(this as Failure);
    }
  }

  /// Returns the encapsulated value if this instance represents success
  /// or null of it is failure.
  T? getDataOrNull() => whenOrNull(success: _identity);

  VideoError? getErrorOrNull() => whenOrNull(failure: _identity);
}

T _identity<T>(T x) => x;
