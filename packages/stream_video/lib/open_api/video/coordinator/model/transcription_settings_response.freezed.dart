// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcription_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TranscriptionSettingsResponse {
  TranscriptionSettingsResponseClosedCaptionMode get closedCaptionMode;
  TranscriptionSettingsResponseLanguage get language;
  TranscriptionSettingsResponseMode get mode;
  SpeechSegmentConfig? get speechSegmentConfig;
  TranslationSettings? get translation;

  /// Create a copy of TranscriptionSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TranscriptionSettingsResponseCopyWith<TranscriptionSettingsResponse>
  get copyWith =>
      _$TranscriptionSettingsResponseCopyWithImpl<
        TranscriptionSettingsResponse
      >(this as TranscriptionSettingsResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TranscriptionSettingsResponse &&
            (identical(other.closedCaptionMode, closedCaptionMode) ||
                other.closedCaptionMode == closedCaptionMode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.speechSegmentConfig, speechSegmentConfig) ||
                other.speechSegmentConfig == speechSegmentConfig) &&
            (identical(other.translation, translation) ||
                other.translation == translation));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    closedCaptionMode,
    language,
    mode,
    speechSegmentConfig,
    translation,
  );

  @override
  String toString() {
    return 'TranscriptionSettingsResponse(closedCaptionMode: $closedCaptionMode, language: $language, mode: $mode, speechSegmentConfig: $speechSegmentConfig, translation: $translation)';
  }
}

/// @nodoc
abstract mixin class $TranscriptionSettingsResponseCopyWith<$Res> {
  factory $TranscriptionSettingsResponseCopyWith(
    TranscriptionSettingsResponse value,
    $Res Function(TranscriptionSettingsResponse) _then,
  ) = _$TranscriptionSettingsResponseCopyWithImpl;
  @useResult
  $Res call({
    TranscriptionSettingsResponseClosedCaptionMode closedCaptionMode,
    TranscriptionSettingsResponseLanguage language,
    TranscriptionSettingsResponseMode mode,
    SpeechSegmentConfig? speechSegmentConfig,
    TranslationSettings? translation,
  });
}

/// @nodoc
class _$TranscriptionSettingsResponseCopyWithImpl<$Res>
    implements $TranscriptionSettingsResponseCopyWith<$Res> {
  _$TranscriptionSettingsResponseCopyWithImpl(this._self, this._then);

  final TranscriptionSettingsResponse _self;
  final $Res Function(TranscriptionSettingsResponse) _then;

  /// Create a copy of TranscriptionSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? closedCaptionMode = null,
    Object? language = null,
    Object? mode = null,
    Object? speechSegmentConfig = freezed,
    Object? translation = freezed,
  }) {
    return _then(
      TranscriptionSettingsResponse(
        closedCaptionMode: null == closedCaptionMode
            ? _self.closedCaptionMode
            : closedCaptionMode // ignore: cast_nullable_to_non_nullable
                  as TranscriptionSettingsResponseClosedCaptionMode,
        language: null == language
            ? _self.language
            : language // ignore: cast_nullable_to_non_nullable
                  as TranscriptionSettingsResponseLanguage,
        mode: null == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as TranscriptionSettingsResponseMode,
        speechSegmentConfig: freezed == speechSegmentConfig
            ? _self.speechSegmentConfig
            : speechSegmentConfig // ignore: cast_nullable_to_non_nullable
                  as SpeechSegmentConfig?,
        translation: freezed == translation
            ? _self.translation
            : translation // ignore: cast_nullable_to_non_nullable
                  as TranslationSettings?,
      ),
    );
  }
}
