// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeds_notification_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedsNotificationContext {

 FeedsNotificationTarget? get target; FeedsNotificationTrigger? get trigger;
/// Create a copy of FeedsNotificationContext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedsNotificationContextCopyWith<FeedsNotificationContext> get copyWith => _$FeedsNotificationContextCopyWithImpl<FeedsNotificationContext>(this as FeedsNotificationContext, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedsNotificationContext&&(identical(other.target, target) || other.target == target)&&(identical(other.trigger, trigger) || other.trigger == trigger));
}


@override
int get hashCode => Object.hash(runtimeType,target,trigger);

@override
String toString() {
  return 'FeedsNotificationContext(target: $target, trigger: $trigger)';
}


}

/// @nodoc
abstract mixin class $FeedsNotificationContextCopyWith<$Res>  {
  factory $FeedsNotificationContextCopyWith(FeedsNotificationContext value, $Res Function(FeedsNotificationContext) _then) = _$FeedsNotificationContextCopyWithImpl;
@useResult
$Res call({
 FeedsNotificationTarget? target, FeedsNotificationTrigger? trigger
});




}
/// @nodoc
class _$FeedsNotificationContextCopyWithImpl<$Res>
    implements $FeedsNotificationContextCopyWith<$Res> {
  _$FeedsNotificationContextCopyWithImpl(this._self, this._then);

  final FeedsNotificationContext _self;
  final $Res Function(FeedsNotificationContext) _then;

/// Create a copy of FeedsNotificationContext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? target = freezed,Object? trigger = freezed,}) {
  return _then(FeedsNotificationContext(
target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as FeedsNotificationTarget?,trigger: freezed == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as FeedsNotificationTrigger?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedsNotificationContext].
extension FeedsNotificationContextPatterns on FeedsNotificationContext {
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
