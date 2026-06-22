// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'frame_recording_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FrameRecordingSettingsResponse {

 int get captureIntervalInSeconds; FrameRecordingSettingsResponseMode get mode; String? get quality;
/// Create a copy of FrameRecordingSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FrameRecordingSettingsResponseCopyWith<FrameRecordingSettingsResponse> get copyWith => _$FrameRecordingSettingsResponseCopyWithImpl<FrameRecordingSettingsResponse>(this as FrameRecordingSettingsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FrameRecordingSettingsResponse&&(identical(other.captureIntervalInSeconds, captureIntervalInSeconds) || other.captureIntervalInSeconds == captureIntervalInSeconds)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.quality, quality) || other.quality == quality));
}


@override
int get hashCode => Object.hash(runtimeType,captureIntervalInSeconds,mode,quality);

@override
String toString() {
  return 'FrameRecordingSettingsResponse(captureIntervalInSeconds: $captureIntervalInSeconds, mode: $mode, quality: $quality)';
}


}

/// @nodoc
abstract mixin class $FrameRecordingSettingsResponseCopyWith<$Res>  {
  factory $FrameRecordingSettingsResponseCopyWith(FrameRecordingSettingsResponse value, $Res Function(FrameRecordingSettingsResponse) _then) = _$FrameRecordingSettingsResponseCopyWithImpl;
@useResult
$Res call({
 int captureIntervalInSeconds, FrameRecordingSettingsResponseMode mode, String? quality
});




}
/// @nodoc
class _$FrameRecordingSettingsResponseCopyWithImpl<$Res>
    implements $FrameRecordingSettingsResponseCopyWith<$Res> {
  _$FrameRecordingSettingsResponseCopyWithImpl(this._self, this._then);

  final FrameRecordingSettingsResponse _self;
  final $Res Function(FrameRecordingSettingsResponse) _then;

/// Create a copy of FrameRecordingSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? captureIntervalInSeconds = null,Object? mode = null,Object? quality = freezed,}) {
  return _then(FrameRecordingSettingsResponse(
captureIntervalInSeconds: null == captureIntervalInSeconds ? _self.captureIntervalInSeconds : captureIntervalInSeconds // ignore: cast_nullable_to_non_nullable
as int,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as FrameRecordingSettingsResponseMode,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FrameRecordingSettingsResponse].
extension FrameRecordingSettingsResponsePatterns on FrameRecordingSettingsResponse {
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
