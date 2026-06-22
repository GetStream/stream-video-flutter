// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_rtmp_broadcast_failed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallRtmpBroadcastFailedEvent {

 String get callCid; DateTime get createdAt; String get name; String get type;
/// Create a copy of CallRtmpBroadcastFailedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallRtmpBroadcastFailedEventCopyWith<CallRtmpBroadcastFailedEvent> get copyWith => _$CallRtmpBroadcastFailedEventCopyWithImpl<CallRtmpBroadcastFailedEvent>(this as CallRtmpBroadcastFailedEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallRtmpBroadcastFailedEvent&&(identical(other.callCid, callCid) || other.callCid == callCid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,callCid,createdAt,name,type);

@override
String toString() {
  return 'CallRtmpBroadcastFailedEvent(callCid: $callCid, createdAt: $createdAt, name: $name, type: $type)';
}


}

/// @nodoc
abstract mixin class $CallRtmpBroadcastFailedEventCopyWith<$Res>  {
  factory $CallRtmpBroadcastFailedEventCopyWith(CallRtmpBroadcastFailedEvent value, $Res Function(CallRtmpBroadcastFailedEvent) _then) = _$CallRtmpBroadcastFailedEventCopyWithImpl;
@useResult
$Res call({
 String callCid, DateTime createdAt, String name, String type
});




}
/// @nodoc
class _$CallRtmpBroadcastFailedEventCopyWithImpl<$Res>
    implements $CallRtmpBroadcastFailedEventCopyWith<$Res> {
  _$CallRtmpBroadcastFailedEventCopyWithImpl(this._self, this._then);

  final CallRtmpBroadcastFailedEvent _self;
  final $Res Function(CallRtmpBroadcastFailedEvent) _then;

/// Create a copy of CallRtmpBroadcastFailedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callCid = null,Object? createdAt = null,Object? name = null,Object? type = null,}) {
  return _then(CallRtmpBroadcastFailedEvent(
callCid: null == callCid ? _self.callCid : callCid // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallRtmpBroadcastFailedEvent].
extension CallRtmpBroadcastFailedEventPatterns on CallRtmpBroadcastFailedEvent {
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
