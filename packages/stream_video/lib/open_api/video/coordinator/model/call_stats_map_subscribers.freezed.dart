// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_map_subscribers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallStatsMapSubscribers {

 List<CallStatsMapLocation> get locations; List<CallStatsMapSubscriber>? get participants;
/// Create a copy of CallStatsMapSubscribers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallStatsMapSubscribersCopyWith<CallStatsMapSubscribers> get copyWith => _$CallStatsMapSubscribersCopyWithImpl<CallStatsMapSubscribers>(this as CallStatsMapSubscribers, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallStatsMapSubscribers&&const DeepCollectionEquality().equals(other.locations, locations)&&const DeepCollectionEquality().equals(other.participants, participants));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(locations),const DeepCollectionEquality().hash(participants));

@override
String toString() {
  return 'CallStatsMapSubscribers(locations: $locations, participants: $participants)';
}


}

/// @nodoc
abstract mixin class $CallStatsMapSubscribersCopyWith<$Res>  {
  factory $CallStatsMapSubscribersCopyWith(CallStatsMapSubscribers value, $Res Function(CallStatsMapSubscribers) _then) = _$CallStatsMapSubscribersCopyWithImpl;
@useResult
$Res call({
 List<CallStatsMapLocation> locations, List<CallStatsMapSubscriber>? participants
});




}
/// @nodoc
class _$CallStatsMapSubscribersCopyWithImpl<$Res>
    implements $CallStatsMapSubscribersCopyWith<$Res> {
  _$CallStatsMapSubscribersCopyWithImpl(this._self, this._then);

  final CallStatsMapSubscribers _self;
  final $Res Function(CallStatsMapSubscribers) _then;

/// Create a copy of CallStatsMapSubscribers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locations = null,Object? participants = freezed,}) {
  return _then(CallStatsMapSubscribers(
locations: null == locations ? _self.locations : locations // ignore: cast_nullable_to_non_nullable
as List<CallStatsMapLocation>,participants: freezed == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<CallStatsMapSubscriber>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallStatsMapSubscribers].
extension CallStatsMapSubscribersPatterns on CallStatsMapSubscribers {
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
