// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_transcription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallTranscription {
  DateTime get endTime;
  String get filename;
  String get sessionId;
  DateTime get startTime;
  String get url;

  /// Create a copy of CallTranscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallTranscriptionCopyWith<CallTranscription> get copyWith =>
      _$CallTranscriptionCopyWithImpl<CallTranscription>(
        this as CallTranscription,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallTranscription &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.url, url) || other.url == url));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, endTime, filename, sessionId, startTime, url);

  @override
  String toString() {
    return 'CallTranscription(endTime: $endTime, filename: $filename, sessionId: $sessionId, startTime: $startTime, url: $url)';
  }
}

/// @nodoc
abstract mixin class $CallTranscriptionCopyWith<$Res> {
  factory $CallTranscriptionCopyWith(
    CallTranscription value,
    $Res Function(CallTranscription) _then,
  ) = _$CallTranscriptionCopyWithImpl;
  @useResult
  $Res call({
    DateTime endTime,
    String filename,
    String sessionId,
    DateTime startTime,
    String url,
  });
}

/// @nodoc
class _$CallTranscriptionCopyWithImpl<$Res>
    implements $CallTranscriptionCopyWith<$Res> {
  _$CallTranscriptionCopyWithImpl(this._self, this._then);

  final CallTranscription _self;
  final $Res Function(CallTranscription) _then;

  /// Create a copy of CallTranscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? endTime = null,
    Object? filename = null,
    Object? sessionId = null,
    Object? startTime = null,
    Object? url = null,
  }) {
    return _then(
      CallTranscription(
        endTime: null == endTime
            ? _self.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        filename: null == filename
            ? _self.filename
            : filename // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _self.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _self.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        url: null == url
            ? _self.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
