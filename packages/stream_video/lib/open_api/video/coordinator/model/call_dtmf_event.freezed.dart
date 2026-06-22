// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_dtmf_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallDTMFEvent {

 String get callCid; DateTime get createdAt; String get digit; int get durationMs; int get seqNumber; DateTime get timestamp; String get type; UserResponse get user;
/// Create a copy of CallDTMFEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallDTMFEventCopyWith<CallDTMFEvent> get copyWith => _$CallDTMFEventCopyWithImpl<CallDTMFEvent>(this as CallDTMFEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallDTMFEvent&&(identical(other.callCid, callCid) || other.callCid == callCid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.digit, digit) || other.digit == digit)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.seqNumber, seqNumber) || other.seqNumber == seqNumber)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.type, type) || other.type == type)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,callCid,createdAt,digit,durationMs,seqNumber,timestamp,type,user);

@override
String toString() {
  return 'CallDTMFEvent(callCid: $callCid, createdAt: $createdAt, digit: $digit, durationMs: $durationMs, seqNumber: $seqNumber, timestamp: $timestamp, type: $type, user: $user)';
}


}

/// @nodoc
abstract mixin class $CallDTMFEventCopyWith<$Res>  {
  factory $CallDTMFEventCopyWith(CallDTMFEvent value, $Res Function(CallDTMFEvent) _then) = _$CallDTMFEventCopyWithImpl;
@useResult
$Res call({
 String callCid, DateTime createdAt, String digit, int durationMs, int seqNumber, DateTime timestamp, String type, UserResponse user
});




}
/// @nodoc
class _$CallDTMFEventCopyWithImpl<$Res>
    implements $CallDTMFEventCopyWith<$Res> {
  _$CallDTMFEventCopyWithImpl(this._self, this._then);

  final CallDTMFEvent _self;
  final $Res Function(CallDTMFEvent) _then;

/// Create a copy of CallDTMFEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callCid = null,Object? createdAt = null,Object? digit = null,Object? durationMs = null,Object? seqNumber = null,Object? timestamp = null,Object? type = null,Object? user = null,}) {
  return _then(CallDTMFEvent(
callCid: null == callCid ? _self.callCid : callCid // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,digit: null == digit ? _self.digit : digit // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,seqNumber: null == seqNumber ? _self.seqNumber : seqNumber // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserResponse,
  ));
}

}


/// Adds pattern-matching-related methods to [CallDTMFEvent].
extension CallDTMFEventPatterns on CallDTMFEvent {
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
