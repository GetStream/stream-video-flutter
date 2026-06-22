// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backstage_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackstageSettingsResponse {

 bool get enabled; int? get joinAheadTimeSeconds;
/// Create a copy of BackstageSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackstageSettingsResponseCopyWith<BackstageSettingsResponse> get copyWith => _$BackstageSettingsResponseCopyWithImpl<BackstageSettingsResponse>(this as BackstageSettingsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackstageSettingsResponse&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.joinAheadTimeSeconds, joinAheadTimeSeconds) || other.joinAheadTimeSeconds == joinAheadTimeSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,joinAheadTimeSeconds);

@override
String toString() {
  return 'BackstageSettingsResponse(enabled: $enabled, joinAheadTimeSeconds: $joinAheadTimeSeconds)';
}


}

/// @nodoc
abstract mixin class $BackstageSettingsResponseCopyWith<$Res>  {
  factory $BackstageSettingsResponseCopyWith(BackstageSettingsResponse value, $Res Function(BackstageSettingsResponse) _then) = _$BackstageSettingsResponseCopyWithImpl;
@useResult
$Res call({
 bool enabled, int? joinAheadTimeSeconds
});




}
/// @nodoc
class _$BackstageSettingsResponseCopyWithImpl<$Res>
    implements $BackstageSettingsResponseCopyWith<$Res> {
  _$BackstageSettingsResponseCopyWithImpl(this._self, this._then);

  final BackstageSettingsResponse _self;
  final $Res Function(BackstageSettingsResponse) _then;

/// Create a copy of BackstageSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? joinAheadTimeSeconds = freezed,}) {
  return _then(BackstageSettingsResponse(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,joinAheadTimeSeconds: freezed == joinAheadTimeSeconds ? _self.joinAheadTimeSeconds : joinAheadTimeSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BackstageSettingsResponse].
extension BackstageSettingsResponsePatterns on BackstageSettingsResponse {
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
