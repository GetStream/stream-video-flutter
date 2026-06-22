// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_stopped_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IngressStoppedEvent {

 String get callCid; DateTime get createdAt; String get ingressStreamId; String get type; String get userId;
/// Create a copy of IngressStoppedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngressStoppedEventCopyWith<IngressStoppedEvent> get copyWith => _$IngressStoppedEventCopyWithImpl<IngressStoppedEvent>(this as IngressStoppedEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngressStoppedEvent&&(identical(other.callCid, callCid) || other.callCid == callCid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ingressStreamId, ingressStreamId) || other.ingressStreamId == ingressStreamId)&&(identical(other.type, type) || other.type == type)&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,callCid,createdAt,ingressStreamId,type,userId);

@override
String toString() {
  return 'IngressStoppedEvent(callCid: $callCid, createdAt: $createdAt, ingressStreamId: $ingressStreamId, type: $type, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $IngressStoppedEventCopyWith<$Res>  {
  factory $IngressStoppedEventCopyWith(IngressStoppedEvent value, $Res Function(IngressStoppedEvent) _then) = _$IngressStoppedEventCopyWithImpl;
@useResult
$Res call({
 String callCid, DateTime createdAt, String ingressStreamId, String type, String userId
});




}
/// @nodoc
class _$IngressStoppedEventCopyWithImpl<$Res>
    implements $IngressStoppedEventCopyWith<$Res> {
  _$IngressStoppedEventCopyWithImpl(this._self, this._then);

  final IngressStoppedEvent _self;
  final $Res Function(IngressStoppedEvent) _then;

/// Create a copy of IngressStoppedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callCid = null,Object? createdAt = null,Object? ingressStreamId = null,Object? type = null,Object? userId = null,}) {
  return _then(IngressStoppedEvent(
callCid: null == callCid ? _self.callCid : callCid // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,ingressStreamId: null == ingressStreamId ? _self.ingressStreamId : ingressStreamId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IngressStoppedEvent].
extension IngressStoppedEventPatterns on IngressStoppedEvent {
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
