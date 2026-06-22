// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcription_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TranscriptionSettingsRequest {

 TranscriptionSettingsRequestClosedCaptionMode? get closedCaptionMode; TranscriptionSettingsRequestLanguage? get language; TranscriptionSettingsRequestMode? get mode; SpeechSegmentConfig? get speechSegmentConfig; TranslationSettings? get translation;
/// Create a copy of TranscriptionSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptionSettingsRequestCopyWith<TranscriptionSettingsRequest> get copyWith => _$TranscriptionSettingsRequestCopyWithImpl<TranscriptionSettingsRequest>(this as TranscriptionSettingsRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptionSettingsRequest&&(identical(other.closedCaptionMode, closedCaptionMode) || other.closedCaptionMode == closedCaptionMode)&&(identical(other.language, language) || other.language == language)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.speechSegmentConfig, speechSegmentConfig) || other.speechSegmentConfig == speechSegmentConfig)&&(identical(other.translation, translation) || other.translation == translation));
}


@override
int get hashCode => Object.hash(runtimeType,closedCaptionMode,language,mode,speechSegmentConfig,translation);

@override
String toString() {
  return 'TranscriptionSettingsRequest(closedCaptionMode: $closedCaptionMode, language: $language, mode: $mode, speechSegmentConfig: $speechSegmentConfig, translation: $translation)';
}


}

/// @nodoc
abstract mixin class $TranscriptionSettingsRequestCopyWith<$Res>  {
  factory $TranscriptionSettingsRequestCopyWith(TranscriptionSettingsRequest value, $Res Function(TranscriptionSettingsRequest) _then) = _$TranscriptionSettingsRequestCopyWithImpl;
@useResult
$Res call({
 TranscriptionSettingsRequestClosedCaptionMode? closedCaptionMode, TranscriptionSettingsRequestLanguage? language, TranscriptionSettingsRequestMode? mode, SpeechSegmentConfig? speechSegmentConfig, TranslationSettings? translation
});




}
/// @nodoc
class _$TranscriptionSettingsRequestCopyWithImpl<$Res>
    implements $TranscriptionSettingsRequestCopyWith<$Res> {
  _$TranscriptionSettingsRequestCopyWithImpl(this._self, this._then);

  final TranscriptionSettingsRequest _self;
  final $Res Function(TranscriptionSettingsRequest) _then;

/// Create a copy of TranscriptionSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? closedCaptionMode = freezed,Object? language = freezed,Object? mode = freezed,Object? speechSegmentConfig = freezed,Object? translation = freezed,}) {
  return _then(TranscriptionSettingsRequest(
closedCaptionMode: freezed == closedCaptionMode ? _self.closedCaptionMode : closedCaptionMode // ignore: cast_nullable_to_non_nullable
as TranscriptionSettingsRequestClosedCaptionMode?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as TranscriptionSettingsRequestLanguage?,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TranscriptionSettingsRequestMode?,speechSegmentConfig: freezed == speechSegmentConfig ? _self.speechSegmentConfig : speechSegmentConfig // ignore: cast_nullable_to_non_nullable
as SpeechSegmentConfig?,translation: freezed == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as TranslationSettings?,
  ));
}

}


/// Adds pattern-matching-related methods to [TranscriptionSettingsRequest].
extension TranscriptionSettingsRequestPatterns on TranscriptionSettingsRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
