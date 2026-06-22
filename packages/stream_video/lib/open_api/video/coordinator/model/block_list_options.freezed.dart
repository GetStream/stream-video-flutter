// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_list_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BlockListOptions {

 BlockListOptionsBehavior get behavior; String get blocklist;
/// Create a copy of BlockListOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockListOptionsCopyWith<BlockListOptions> get copyWith => _$BlockListOptionsCopyWithImpl<BlockListOptions>(this as BlockListOptions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockListOptions&&(identical(other.behavior, behavior) || other.behavior == behavior)&&(identical(other.blocklist, blocklist) || other.blocklist == blocklist));
}


@override
int get hashCode => Object.hash(runtimeType,behavior,blocklist);

@override
String toString() {
  return 'BlockListOptions(behavior: $behavior, blocklist: $blocklist)';
}


}

/// @nodoc
abstract mixin class $BlockListOptionsCopyWith<$Res>  {
  factory $BlockListOptionsCopyWith(BlockListOptions value, $Res Function(BlockListOptions) _then) = _$BlockListOptionsCopyWithImpl;
@useResult
$Res call({
 BlockListOptionsBehavior behavior, String blocklist
});




}
/// @nodoc
class _$BlockListOptionsCopyWithImpl<$Res>
    implements $BlockListOptionsCopyWith<$Res> {
  _$BlockListOptionsCopyWithImpl(this._self, this._then);

  final BlockListOptions _self;
  final $Res Function(BlockListOptions) _then;

/// Create a copy of BlockListOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? behavior = null,Object? blocklist = null,}) {
  return _then(BlockListOptions(
behavior: null == behavior ? _self.behavior : behavior // ignore: cast_nullable_to_non_nullable
as BlockListOptionsBehavior,blocklist: null == blocklist ? _self.blocklist : blocklist // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BlockListOptions].
extension BlockListOptionsPatterns on BlockListOptions {
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
