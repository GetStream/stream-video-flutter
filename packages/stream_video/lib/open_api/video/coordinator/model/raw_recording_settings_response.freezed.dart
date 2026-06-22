// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_recording_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RawRecordingSettingsResponse {

 bool? get audioOnly; RawRecordingSettingsResponseMode get mode;
/// Create a copy of RawRecordingSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawRecordingSettingsResponseCopyWith<RawRecordingSettingsResponse> get copyWith => _$RawRecordingSettingsResponseCopyWithImpl<RawRecordingSettingsResponse>(this as RawRecordingSettingsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawRecordingSettingsResponse&&(identical(other.audioOnly, audioOnly) || other.audioOnly == audioOnly)&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,audioOnly,mode);

@override
String toString() {
  return 'RawRecordingSettingsResponse(audioOnly: $audioOnly, mode: $mode)';
}


}

/// @nodoc
abstract mixin class $RawRecordingSettingsResponseCopyWith<$Res>  {
  factory $RawRecordingSettingsResponseCopyWith(RawRecordingSettingsResponse value, $Res Function(RawRecordingSettingsResponse) _then) = _$RawRecordingSettingsResponseCopyWithImpl;
@useResult
$Res call({
 bool? audioOnly, RawRecordingSettingsResponseMode mode
});




}
/// @nodoc
class _$RawRecordingSettingsResponseCopyWithImpl<$Res>
    implements $RawRecordingSettingsResponseCopyWith<$Res> {
  _$RawRecordingSettingsResponseCopyWithImpl(this._self, this._then);

  final RawRecordingSettingsResponse _self;
  final $Res Function(RawRecordingSettingsResponse) _then;

/// Create a copy of RawRecordingSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? audioOnly = freezed,Object? mode = null,}) {
  return _then(RawRecordingSettingsResponse(
audioOnly: freezed == audioOnly ? _self.audioOnly : audioOnly // ignore: cast_nullable_to_non_nullable
as bool?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as RawRecordingSettingsResponseMode,
  ));
}

}


/// Adds pattern-matching-related methods to [RawRecordingSettingsResponse].
extension RawRecordingSettingsResponsePatterns on RawRecordingSettingsResponse {
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
