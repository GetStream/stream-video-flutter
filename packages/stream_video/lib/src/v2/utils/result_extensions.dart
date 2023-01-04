import 'package:stream_video/src/v2/errors/video_error.dart';
import 'package:stream_video/src/v2/utils/result.dart';

/// Extensions for [Result] class.
extension ResultExtensions<T> on Result<T> {
  /// Runs the [successSideEffect] lambda function if the [Result] contains
  /// a successful data payload.
  ///
  /// Returns the original instance of the [Result].
  Result<T> onSuccess<K>(Function(T) successSideEffect) {
    if (this is Success) {
      final success = this as Success<T>;
      successSideEffect.call(success.data);
    }
    return this;
  }

  /// Runs the [successSideEffect] lambda function if the [Result] contains
  /// a successful data payload.
  ///
  /// Returns the original instance of the [Result].
  Future<Result<T>> onSuccessAsync<K>(
    Future<void> Function(T) successSideEffect,
  ) async {
    if (this is Success) {
      final success = this as Success<T>;
      await successSideEffect.call(success.data);
    }
    return this;
  }

  /// Runs the [errorSideEffect] lambda function if the [Result] contains
  /// an error payload.
  ///
  /// Returns the original instance of the [Result].
  Result<T> onFailure<K>(Function(VideoError) errorSideEffect) {
    if (this is Failure) {
      final failure = this as Failure<T>;
      errorSideEffect.call(failure.error);
    }
    return this;
  }

  /// Runs the [errorSideEffect] lambda function if the [Result] contains
  /// an error payload.
  ///
  /// Returns the original instance of the [Result].
  Future<Result<T>> onFailureAsync<K>(
    Future<void> Function(VideoError) errorSideEffect,
  ) async {
    if (this is Failure) {
      final failure = this as Failure<T>;
      await errorSideEffect.call(failure.error);
    }
    return this;
  }

  /// Returns a transformed [Result] of applying the given [mapper] function
  /// if the [Result] contains a successful data payload.
  ///
  /// Returns a transformed instance of the [Result].
  Result<K> map<K>(K Function(T) mapper) {
    return flatMap((it) => Success(mapper.call(it)));
  }

  /// Returns a transformed [Result] of applying the given [mapper] function
  /// if the [Result] contains a successful data payload.
  ///
  /// Returns a transformed instance of the [Result].
  Future<Result<K>> mapAsync<K>(
    Future<K> Function(T) mapper,
  ) async {
    if (this is Success) {
      final success = this as Success<T>;
      return Success(await mapper.call(success.data));
    } else if (this is Failure) {
      final failure = this as Failure<T>;
      return Failure<K>(failure.error);
    } else {
      throw ArgumentError('unexpected result type: $this');
    }
  }

  /// Returns a transformed [Result] of applying the given [mapper] function
  /// if the [Result] contains a successful data payload.
  ///
  /// Returns a transformed instance of the [Result].
  Result<K> flatMap<K>(Result<K> Function(T) mapper) {
    if (this is Success) {
      final success = this as Success<T>;
      return mapper.call(success.data);
    } else if (this is Failure) {
      final failure = this as Failure<T>;
      return Failure<K>(failure.error);
    } else {
      throw ArgumentError('unexpected result type: $this');
    }
  }

  /// Returns a transformed [Result] of applying the given [mapper] function
  /// if the [Result] contains a successful data payload.
  ///
  /// Returns a transformed instance of the [Result].
  Future<Result<K>> flatMapAsync<K>(
    Future<Result<K>> Function(T) mapper,
  ) async {
    if (this is Success) {
      final success = this as Success<T>;
      return mapper.call(success.data);
    } else if (this is Failure) {
      final failure = this as Failure<T>;
      return Failure<K>(failure.error);
    } else {
      throw ArgumentError('unexpected result type: $this');
    }
  }
}
