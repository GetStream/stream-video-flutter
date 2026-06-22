// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screensharing_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScreensharingSettingsResponse {

 bool get accessRequestEnabled; bool get enabled; TargetResolution? get targetResolution;
/// Create a copy of ScreensharingSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreensharingSettingsResponseCopyWith<ScreensharingSettingsResponse> get copyWith => _$ScreensharingSettingsResponseCopyWithImpl<ScreensharingSettingsResponse>(this as ScreensharingSettingsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreensharingSettingsResponse&&(identical(other.accessRequestEnabled, accessRequestEnabled) || other.accessRequestEnabled == accessRequestEnabled)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.targetResolution, targetResolution) || other.targetResolution == targetResolution));
}


@override
int get hashCode => Object.hash(runtimeType,accessRequestEnabled,enabled,targetResolution);

@override
String toString() {
  return 'ScreensharingSettingsResponse(accessRequestEnabled: $accessRequestEnabled, enabled: $enabled, targetResolution: $targetResolution)';
}


}

/// @nodoc
abstract mixin class $ScreensharingSettingsResponseCopyWith<$Res>  {
  factory $ScreensharingSettingsResponseCopyWith(ScreensharingSettingsResponse value, $Res Function(ScreensharingSettingsResponse) _then) = _$ScreensharingSettingsResponseCopyWithImpl;
@useResult
$Res call({
 bool accessRequestEnabled, bool enabled, TargetResolution? targetResolution
});




}
/// @nodoc
class _$ScreensharingSettingsResponseCopyWithImpl<$Res>
    implements $ScreensharingSettingsResponseCopyWith<$Res> {
  _$ScreensharingSettingsResponseCopyWithImpl(this._self, this._then);

  final ScreensharingSettingsResponse _self;
  final $Res Function(ScreensharingSettingsResponse) _then;

/// Create a copy of ScreensharingSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessRequestEnabled = null,Object? enabled = null,Object? targetResolution = freezed,}) {
  return _then(ScreensharingSettingsResponse(
accessRequestEnabled: null == accessRequestEnabled ? _self.accessRequestEnabled : accessRequestEnabled // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,targetResolution: freezed == targetResolution ? _self.targetResolution : targetResolution // ignore: cast_nullable_to_non_nullable
as TargetResolution?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScreensharingSettingsResponse].
extension ScreensharingSettingsResponsePatterns on ScreensharingSettingsResponse {
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
