// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_segment_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpeechSegmentConfig {
  int? get maxSpeechCaptionMs;
  int? get silenceDurationMs;

  /// Create a copy of SpeechSegmentConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SpeechSegmentConfigCopyWith<SpeechSegmentConfig> get copyWith =>
      _$SpeechSegmentConfigCopyWithImpl<SpeechSegmentConfig>(
        this as SpeechSegmentConfig,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SpeechSegmentConfig &&
            (identical(other.maxSpeechCaptionMs, maxSpeechCaptionMs) ||
                other.maxSpeechCaptionMs == maxSpeechCaptionMs) &&
            (identical(other.silenceDurationMs, silenceDurationMs) ||
                other.silenceDurationMs == silenceDurationMs));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, maxSpeechCaptionMs, silenceDurationMs);

  @override
  String toString() {
    return 'SpeechSegmentConfig(maxSpeechCaptionMs: $maxSpeechCaptionMs, silenceDurationMs: $silenceDurationMs)';
  }
}

/// @nodoc
abstract mixin class $SpeechSegmentConfigCopyWith<$Res> {
  factory $SpeechSegmentConfigCopyWith(
    SpeechSegmentConfig value,
    $Res Function(SpeechSegmentConfig) _then,
  ) = _$SpeechSegmentConfigCopyWithImpl;
  @useResult
  $Res call({int? maxSpeechCaptionMs, int? silenceDurationMs});
}

/// @nodoc
class _$SpeechSegmentConfigCopyWithImpl<$Res>
    implements $SpeechSegmentConfigCopyWith<$Res> {
  _$SpeechSegmentConfigCopyWithImpl(this._self, this._then);

  final SpeechSegmentConfig _self;
  final $Res Function(SpeechSegmentConfig) _then;

  /// Create a copy of SpeechSegmentConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxSpeechCaptionMs = freezed,
    Object? silenceDurationMs = freezed,
  }) {
    return _then(
      SpeechSegmentConfig(
        maxSpeechCaptionMs: freezed == maxSpeechCaptionMs
            ? _self.maxSpeechCaptionMs
            : maxSpeechCaptionMs // ignore: cast_nullable_to_non_nullable
                  as int?,
        silenceDurationMs: freezed == silenceDurationMs
            ? _self.silenceDurationMs
            : silenceDurationMs // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
