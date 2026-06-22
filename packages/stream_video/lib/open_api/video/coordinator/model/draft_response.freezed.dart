// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DraftResponse {

 ChannelResponse? get channel; String get channelCid; DateTime get createdAt; DraftPayloadResponse get message; String? get parentId; MessageResponse? get parentMessage; MessageResponse? get quotedMessage;
/// Create a copy of DraftResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftResponseCopyWith<DraftResponse> get copyWith => _$DraftResponseCopyWithImpl<DraftResponse>(this as DraftResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftResponse&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.channelCid, channelCid) || other.channelCid == channelCid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.message, message) || other.message == message)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.parentMessage, parentMessage) || other.parentMessage == parentMessage)&&(identical(other.quotedMessage, quotedMessage) || other.quotedMessage == quotedMessage));
}


@override
int get hashCode => Object.hash(runtimeType,channel,channelCid,createdAt,message,parentId,parentMessage,quotedMessage);

@override
String toString() {
  return 'DraftResponse(channel: $channel, channelCid: $channelCid, createdAt: $createdAt, message: $message, parentId: $parentId, parentMessage: $parentMessage, quotedMessage: $quotedMessage)';
}


}

/// @nodoc
abstract mixin class $DraftResponseCopyWith<$Res>  {
  factory $DraftResponseCopyWith(DraftResponse value, $Res Function(DraftResponse) _then) = _$DraftResponseCopyWithImpl;
@useResult
$Res call({
 ChannelResponse? channel, String channelCid, DateTime createdAt, DraftPayloadResponse message, String? parentId, MessageResponse? parentMessage, MessageResponse? quotedMessage
});




}
/// @nodoc
class _$DraftResponseCopyWithImpl<$Res>
    implements $DraftResponseCopyWith<$Res> {
  _$DraftResponseCopyWithImpl(this._self, this._then);

  final DraftResponse _self;
  final $Res Function(DraftResponse) _then;

/// Create a copy of DraftResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channel = freezed,Object? channelCid = null,Object? createdAt = null,Object? message = null,Object? parentId = freezed,Object? parentMessage = freezed,Object? quotedMessage = freezed,}) {
  return _then(DraftResponse(
channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as ChannelResponse?,channelCid: null == channelCid ? _self.channelCid : channelCid // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as DraftPayloadResponse,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,parentMessage: freezed == parentMessage ? _self.parentMessage : parentMessage // ignore: cast_nullable_to_non_nullable
as MessageResponse?,quotedMessage: freezed == quotedMessage ? _self.quotedMessage : quotedMessage // ignore: cast_nullable_to_non_nullable
as MessageResponse?,
  ));
}

}


/// Adds pattern-matching-related methods to [DraftResponse].
extension DraftResponsePatterns on DraftResponse {
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
