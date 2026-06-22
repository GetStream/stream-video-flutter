// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_hls_broadcasting_started_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallHLSBroadcastingStartedEvent {

 CallResponse get call; String get callCid; DateTime get createdAt; String get hlsPlaylistUrl; String get type;
/// Create a copy of CallHLSBroadcastingStartedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallHLSBroadcastingStartedEventCopyWith<CallHLSBroadcastingStartedEvent> get copyWith => _$CallHLSBroadcastingStartedEventCopyWithImpl<CallHLSBroadcastingStartedEvent>(this as CallHLSBroadcastingStartedEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallHLSBroadcastingStartedEvent&&(identical(other.call, call) || other.call == call)&&(identical(other.callCid, callCid) || other.callCid == callCid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.hlsPlaylistUrl, hlsPlaylistUrl) || other.hlsPlaylistUrl == hlsPlaylistUrl)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,call,callCid,createdAt,hlsPlaylistUrl,type);

@override
String toString() {
  return 'CallHLSBroadcastingStartedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, hlsPlaylistUrl: $hlsPlaylistUrl, type: $type)';
}


}

/// @nodoc
abstract mixin class $CallHLSBroadcastingStartedEventCopyWith<$Res>  {
  factory $CallHLSBroadcastingStartedEventCopyWith(CallHLSBroadcastingStartedEvent value, $Res Function(CallHLSBroadcastingStartedEvent) _then) = _$CallHLSBroadcastingStartedEventCopyWithImpl;
@useResult
$Res call({
 CallResponse call, String callCid, DateTime createdAt, String hlsPlaylistUrl, String type
});




}
/// @nodoc
class _$CallHLSBroadcastingStartedEventCopyWithImpl<$Res>
    implements $CallHLSBroadcastingStartedEventCopyWith<$Res> {
  _$CallHLSBroadcastingStartedEventCopyWithImpl(this._self, this._then);

  final CallHLSBroadcastingStartedEvent _self;
  final $Res Function(CallHLSBroadcastingStartedEvent) _then;

/// Create a copy of CallHLSBroadcastingStartedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? call = null,Object? callCid = null,Object? createdAt = null,Object? hlsPlaylistUrl = null,Object? type = null,}) {
  return _then(CallHLSBroadcastingStartedEvent(
call: null == call ? _self.call : call // ignore: cast_nullable_to_non_nullable
as CallResponse,callCid: null == callCid ? _self.callCid : callCid // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,hlsPlaylistUrl: null == hlsPlaylistUrl ? _self.hlsPlaylistUrl : hlsPlaylistUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallHLSBroadcastingStartedEvent].
extension CallHLSBroadcastingStartedEventPatterns on CallHLSBroadcastingStartedEvent {
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
