// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_started_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IngressStartedEvent {

 String get callCid; String? get clientIp; String? get clientName; DateTime get createdAt; String get ingressStreamId; String get publisherType; String get type; String get userId; String? get version;
/// Create a copy of IngressStartedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngressStartedEventCopyWith<IngressStartedEvent> get copyWith => _$IngressStartedEventCopyWithImpl<IngressStartedEvent>(this as IngressStartedEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngressStartedEvent&&(identical(other.callCid, callCid) || other.callCid == callCid)&&(identical(other.clientIp, clientIp) || other.clientIp == clientIp)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ingressStreamId, ingressStreamId) || other.ingressStreamId == ingressStreamId)&&(identical(other.publisherType, publisherType) || other.publisherType == publisherType)&&(identical(other.type, type) || other.type == type)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,callCid,clientIp,clientName,createdAt,ingressStreamId,publisherType,type,userId,version);

@override
String toString() {
  return 'IngressStartedEvent(callCid: $callCid, clientIp: $clientIp, clientName: $clientName, createdAt: $createdAt, ingressStreamId: $ingressStreamId, publisherType: $publisherType, type: $type, userId: $userId, version: $version)';
}


}

/// @nodoc
abstract mixin class $IngressStartedEventCopyWith<$Res>  {
  factory $IngressStartedEventCopyWith(IngressStartedEvent value, $Res Function(IngressStartedEvent) _then) = _$IngressStartedEventCopyWithImpl;
@useResult
$Res call({
 String callCid, String? clientIp, String? clientName, DateTime createdAt, String ingressStreamId, String publisherType, String type, String userId, String? version
});




}
/// @nodoc
class _$IngressStartedEventCopyWithImpl<$Res>
    implements $IngressStartedEventCopyWith<$Res> {
  _$IngressStartedEventCopyWithImpl(this._self, this._then);

  final IngressStartedEvent _self;
  final $Res Function(IngressStartedEvent) _then;

/// Create a copy of IngressStartedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callCid = null,Object? clientIp = freezed,Object? clientName = freezed,Object? createdAt = null,Object? ingressStreamId = null,Object? publisherType = null,Object? type = null,Object? userId = null,Object? version = freezed,}) {
  return _then(IngressStartedEvent(
callCid: null == callCid ? _self.callCid : callCid // ignore: cast_nullable_to_non_nullable
as String,clientIp: freezed == clientIp ? _self.clientIp : clientIp // ignore: cast_nullable_to_non_nullable
as String?,clientName: freezed == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,ingressStreamId: null == ingressStreamId ? _self.ingressStreamId : ingressStreamId // ignore: cast_nullable_to_non_nullable
as String,publisherType: null == publisherType ? _self.publisherType : publisherType // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [IngressStartedEvent].
extension IngressStartedEventPatterns on IngressStartedEvent {
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
