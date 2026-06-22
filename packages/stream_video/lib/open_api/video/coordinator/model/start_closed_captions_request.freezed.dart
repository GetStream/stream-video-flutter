// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'start_closed_captions_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StartClosedCaptionsRequest {

 bool? get enableTranscription; String? get externalStorage; StartClosedCaptionsRequestLanguage? get language; SpeechSegmentConfig? get speechSegmentConfig;
/// Create a copy of StartClosedCaptionsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartClosedCaptionsRequestCopyWith<StartClosedCaptionsRequest> get copyWith => _$StartClosedCaptionsRequestCopyWithImpl<StartClosedCaptionsRequest>(this as StartClosedCaptionsRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartClosedCaptionsRequest&&(identical(other.enableTranscription, enableTranscription) || other.enableTranscription == enableTranscription)&&(identical(other.externalStorage, externalStorage) || other.externalStorage == externalStorage)&&(identical(other.language, language) || other.language == language)&&(identical(other.speechSegmentConfig, speechSegmentConfig) || other.speechSegmentConfig == speechSegmentConfig));
}


@override
int get hashCode => Object.hash(runtimeType,enableTranscription,externalStorage,language,speechSegmentConfig);

@override
String toString() {
  return 'StartClosedCaptionsRequest(enableTranscription: $enableTranscription, externalStorage: $externalStorage, language: $language, speechSegmentConfig: $speechSegmentConfig)';
}


}

/// @nodoc
abstract mixin class $StartClosedCaptionsRequestCopyWith<$Res>  {
  factory $StartClosedCaptionsRequestCopyWith(StartClosedCaptionsRequest value, $Res Function(StartClosedCaptionsRequest) _then) = _$StartClosedCaptionsRequestCopyWithImpl;
@useResult
$Res call({
 bool? enableTranscription, String? externalStorage, StartClosedCaptionsRequestLanguage? language, SpeechSegmentConfig? speechSegmentConfig
});




}
/// @nodoc
class _$StartClosedCaptionsRequestCopyWithImpl<$Res>
    implements $StartClosedCaptionsRequestCopyWith<$Res> {
  _$StartClosedCaptionsRequestCopyWithImpl(this._self, this._then);

  final StartClosedCaptionsRequest _self;
  final $Res Function(StartClosedCaptionsRequest) _then;

/// Create a copy of StartClosedCaptionsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enableTranscription = freezed,Object? externalStorage = freezed,Object? language = freezed,Object? speechSegmentConfig = freezed,}) {
  return _then(StartClosedCaptionsRequest(
enableTranscription: freezed == enableTranscription ? _self.enableTranscription : enableTranscription // ignore: cast_nullable_to_non_nullable
as bool?,externalStorage: freezed == externalStorage ? _self.externalStorage : externalStorage // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as StartClosedCaptionsRequestLanguage?,speechSegmentConfig: freezed == speechSegmentConfig ? _self.speechSegmentConfig : speechSegmentConfig // ignore: cast_nullable_to_non_nullable
as SpeechSegmentConfig?,
  ));
}

}


/// Adds pattern-matching-related methods to [StartClosedCaptionsRequest].
extension StartClosedCaptionsRequestPatterns on StartClosedCaptionsRequest {
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
