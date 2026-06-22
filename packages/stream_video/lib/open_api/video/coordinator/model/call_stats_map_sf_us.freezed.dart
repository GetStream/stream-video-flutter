// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_map_sf_us.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallStatsMapSFUs {

 List<SFULocationResponse> get locations;
/// Create a copy of CallStatsMapSFUs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallStatsMapSFUsCopyWith<CallStatsMapSFUs> get copyWith => _$CallStatsMapSFUsCopyWithImpl<CallStatsMapSFUs>(this as CallStatsMapSFUs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallStatsMapSFUs&&const DeepCollectionEquality().equals(other.locations, locations));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(locations));

@override
String toString() {
  return 'CallStatsMapSFUs(locations: $locations)';
}


}

/// @nodoc
abstract mixin class $CallStatsMapSFUsCopyWith<$Res>  {
  factory $CallStatsMapSFUsCopyWith(CallStatsMapSFUs value, $Res Function(CallStatsMapSFUs) _then) = _$CallStatsMapSFUsCopyWithImpl;
@useResult
$Res call({
 List<SFULocationResponse> locations
});




}
/// @nodoc
class _$CallStatsMapSFUsCopyWithImpl<$Res>
    implements $CallStatsMapSFUsCopyWith<$Res> {
  _$CallStatsMapSFUsCopyWithImpl(this._self, this._then);

  final CallStatsMapSFUs _self;
  final $Res Function(CallStatsMapSFUs) _then;

/// Create a copy of CallStatsMapSFUs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locations = null,}) {
  return _then(CallStatsMapSFUs(
locations: null == locations ? _self.locations : locations // ignore: cast_nullable_to_non_nullable
as List<SFULocationResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [CallStatsMapSFUs].
extension CallStatsMapSFUsPatterns on CallStatsMapSFUs {
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
