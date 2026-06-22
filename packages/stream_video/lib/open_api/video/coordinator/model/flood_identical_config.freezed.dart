// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flood_identical_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FloodIdenticalConfig {

 String get action; bool get enabled; int get threshold; String get timeWindow;
/// Create a copy of FloodIdenticalConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloodIdenticalConfigCopyWith<FloodIdenticalConfig> get copyWith => _$FloodIdenticalConfigCopyWithImpl<FloodIdenticalConfig>(this as FloodIdenticalConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloodIdenticalConfig&&(identical(other.action, action) || other.action == action)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow));
}


@override
int get hashCode => Object.hash(runtimeType,action,enabled,threshold,timeWindow);

@override
String toString() {
  return 'FloodIdenticalConfig(action: $action, enabled: $enabled, threshold: $threshold, timeWindow: $timeWindow)';
}


}

/// @nodoc
abstract mixin class $FloodIdenticalConfigCopyWith<$Res>  {
  factory $FloodIdenticalConfigCopyWith(FloodIdenticalConfig value, $Res Function(FloodIdenticalConfig) _then) = _$FloodIdenticalConfigCopyWithImpl;
@useResult
$Res call({
 String action, bool enabled, int threshold, String timeWindow
});




}
/// @nodoc
class _$FloodIdenticalConfigCopyWithImpl<$Res>
    implements $FloodIdenticalConfigCopyWith<$Res> {
  _$FloodIdenticalConfigCopyWithImpl(this._self, this._then);

  final FloodIdenticalConfig _self;
  final $Res Function(FloodIdenticalConfig) _then;

/// Create a copy of FloodIdenticalConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? enabled = null,Object? threshold = null,Object? timeWindow = null,}) {
  return _then(FloodIdenticalConfig(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,timeWindow: null == timeWindow ? _self.timeWindow : timeWindow // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FloodIdenticalConfig].
extension FloodIdenticalConfigPatterns on FloodIdenticalConfig {
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
