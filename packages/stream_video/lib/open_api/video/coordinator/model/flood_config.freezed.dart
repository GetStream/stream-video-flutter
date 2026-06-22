// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flood_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FloodConfig {

 FloodIdenticalConfig? get identical_; FloodSimilarConfig? get similar;
/// Create a copy of FloodConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloodConfigCopyWith<FloodConfig> get copyWith => _$FloodConfigCopyWithImpl<FloodConfig>(this as FloodConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloodConfig&&(identical(other.identical_, identical_) || other.identical_ == identical_)&&(identical(other.similar, similar) || other.similar == similar));
}


@override
int get hashCode => Object.hash(runtimeType,identical_,similar);

@override
String toString() {
  return 'FloodConfig(identical_: $identical_, similar: $similar)';
}


}

/// @nodoc
abstract mixin class $FloodConfigCopyWith<$Res>  {
  factory $FloodConfigCopyWith(FloodConfig value, $Res Function(FloodConfig) _then) = _$FloodConfigCopyWithImpl;
@useResult
$Res call({
 FloodIdenticalConfig? identical_, FloodSimilarConfig? similar
});




}
/// @nodoc
class _$FloodConfigCopyWithImpl<$Res>
    implements $FloodConfigCopyWith<$Res> {
  _$FloodConfigCopyWithImpl(this._self, this._then);

  final FloodConfig _self;
  final $Res Function(FloodConfig) _then;

/// Create a copy of FloodConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? identical_ = freezed,Object? similar = freezed,}) {
  return _then(FloodConfig(
identical_: freezed == identical_ ? _self.identical_ : identical_ // ignore: cast_nullable_to_non_nullable
as FloodIdenticalConfig?,similar: freezed == similar ? _self.similar : similar // ignore: cast_nullable_to_non_nullable
as FloodSimilarConfig?,
  ));
}

}


/// Adds pattern-matching-related methods to [FloodConfig].
extension FloodConfigPatterns on FloodConfig {
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
