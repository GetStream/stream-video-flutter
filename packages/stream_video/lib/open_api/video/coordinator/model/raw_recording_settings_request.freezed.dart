// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_recording_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RawRecordingSettingsRequest {

 bool? get audioOnly; RawRecordingSettingsRequestMode get mode;
/// Create a copy of RawRecordingSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawRecordingSettingsRequestCopyWith<RawRecordingSettingsRequest> get copyWith => _$RawRecordingSettingsRequestCopyWithImpl<RawRecordingSettingsRequest>(this as RawRecordingSettingsRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawRecordingSettingsRequest&&(identical(other.audioOnly, audioOnly) || other.audioOnly == audioOnly)&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,audioOnly,mode);

@override
String toString() {
  return 'RawRecordingSettingsRequest(audioOnly: $audioOnly, mode: $mode)';
}


}

/// @nodoc
abstract mixin class $RawRecordingSettingsRequestCopyWith<$Res>  {
  factory $RawRecordingSettingsRequestCopyWith(RawRecordingSettingsRequest value, $Res Function(RawRecordingSettingsRequest) _then) = _$RawRecordingSettingsRequestCopyWithImpl;
@useResult
$Res call({
 bool? audioOnly, RawRecordingSettingsRequestMode mode
});




}
/// @nodoc
class _$RawRecordingSettingsRequestCopyWithImpl<$Res>
    implements $RawRecordingSettingsRequestCopyWith<$Res> {
  _$RawRecordingSettingsRequestCopyWithImpl(this._self, this._then);

  final RawRecordingSettingsRequest _self;
  final $Res Function(RawRecordingSettingsRequest) _then;

/// Create a copy of RawRecordingSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? audioOnly = freezed,Object? mode = null,}) {
  return _then(RawRecordingSettingsRequest(
audioOnly: freezed == audioOnly ? _self.audioOnly : audioOnly // ignore: cast_nullable_to_non_nullable
as bool?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as RawRecordingSettingsRequestMode,
  ));
}

}


/// Adds pattern-matching-related methods to [RawRecordingSettingsRequest].
extension RawRecordingSettingsRequestPatterns on RawRecordingSettingsRequest {
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
