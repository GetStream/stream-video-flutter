// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thresholds.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Thresholds {

 LabelThresholds? get explicit; LabelThresholds? get spam; LabelThresholds? get toxic;
/// Create a copy of Thresholds
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThresholdsCopyWith<Thresholds> get copyWith => _$ThresholdsCopyWithImpl<Thresholds>(this as Thresholds, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Thresholds&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.spam, spam) || other.spam == spam)&&(identical(other.toxic, toxic) || other.toxic == toxic));
}


@override
int get hashCode => Object.hash(runtimeType,explicit,spam,toxic);

@override
String toString() {
  return 'Thresholds(explicit: $explicit, spam: $spam, toxic: $toxic)';
}


}

/// @nodoc
abstract mixin class $ThresholdsCopyWith<$Res>  {
  factory $ThresholdsCopyWith(Thresholds value, $Res Function(Thresholds) _then) = _$ThresholdsCopyWithImpl;
@useResult
$Res call({
 LabelThresholds? explicit, LabelThresholds? spam, LabelThresholds? toxic
});




}
/// @nodoc
class _$ThresholdsCopyWithImpl<$Res>
    implements $ThresholdsCopyWith<$Res> {
  _$ThresholdsCopyWithImpl(this._self, this._then);

  final Thresholds _self;
  final $Res Function(Thresholds) _then;

/// Create a copy of Thresholds
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? explicit = freezed,Object? spam = freezed,Object? toxic = freezed,}) {
  return _then(Thresholds(
explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as LabelThresholds?,spam: freezed == spam ? _self.spam : spam // ignore: cast_nullable_to_non_nullable
as LabelThresholds?,toxic: freezed == toxic ? _self.toxic : toxic // ignore: cast_nullable_to_non_nullable
as LabelThresholds?,
  ));
}

}


/// Adds pattern-matching-related methods to [Thresholds].
extension ThresholdsPatterns on Thresholds {
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
