// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideoSettingsRequest {

 bool? get accessRequestEnabled; bool? get cameraDefaultOn; VideoSettingsRequestCameraFacing? get cameraFacing; bool? get enabled; TargetResolution? get targetResolution;
/// Create a copy of VideoSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoSettingsRequestCopyWith<VideoSettingsRequest> get copyWith => _$VideoSettingsRequestCopyWithImpl<VideoSettingsRequest>(this as VideoSettingsRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoSettingsRequest&&(identical(other.accessRequestEnabled, accessRequestEnabled) || other.accessRequestEnabled == accessRequestEnabled)&&(identical(other.cameraDefaultOn, cameraDefaultOn) || other.cameraDefaultOn == cameraDefaultOn)&&(identical(other.cameraFacing, cameraFacing) || other.cameraFacing == cameraFacing)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.targetResolution, targetResolution) || other.targetResolution == targetResolution));
}


@override
int get hashCode => Object.hash(runtimeType,accessRequestEnabled,cameraDefaultOn,cameraFacing,enabled,targetResolution);

@override
String toString() {
  return 'VideoSettingsRequest(accessRequestEnabled: $accessRequestEnabled, cameraDefaultOn: $cameraDefaultOn, cameraFacing: $cameraFacing, enabled: $enabled, targetResolution: $targetResolution)';
}


}

/// @nodoc
abstract mixin class $VideoSettingsRequestCopyWith<$Res>  {
  factory $VideoSettingsRequestCopyWith(VideoSettingsRequest value, $Res Function(VideoSettingsRequest) _then) = _$VideoSettingsRequestCopyWithImpl;
@useResult
$Res call({
 bool? accessRequestEnabled, bool? cameraDefaultOn, VideoSettingsRequestCameraFacing? cameraFacing, bool? enabled, TargetResolution? targetResolution
});




}
/// @nodoc
class _$VideoSettingsRequestCopyWithImpl<$Res>
    implements $VideoSettingsRequestCopyWith<$Res> {
  _$VideoSettingsRequestCopyWithImpl(this._self, this._then);

  final VideoSettingsRequest _self;
  final $Res Function(VideoSettingsRequest) _then;

/// Create a copy of VideoSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessRequestEnabled = freezed,Object? cameraDefaultOn = freezed,Object? cameraFacing = freezed,Object? enabled = freezed,Object? targetResolution = freezed,}) {
  return _then(VideoSettingsRequest(
accessRequestEnabled: freezed == accessRequestEnabled ? _self.accessRequestEnabled : accessRequestEnabled // ignore: cast_nullable_to_non_nullable
as bool?,cameraDefaultOn: freezed == cameraDefaultOn ? _self.cameraDefaultOn : cameraDefaultOn // ignore: cast_nullable_to_non_nullable
as bool?,cameraFacing: freezed == cameraFacing ? _self.cameraFacing : cameraFacing // ignore: cast_nullable_to_non_nullable
as VideoSettingsRequestCameraFacing?,enabled: freezed == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool?,targetResolution: freezed == targetResolution ? _self.targetResolution : targetResolution // ignore: cast_nullable_to_non_nullable
as TargetResolution?,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoSettingsRequest].
extension VideoSettingsRequestPatterns on VideoSettingsRequest {
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
