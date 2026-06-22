// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolve_sip_inbound_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResolveSipInboundResponse {

 SipInboundCredentials get credentials; String get duration; SIPInboundRoutingRuleResponse? get sipRoutingRule; SIPTrunkResponse? get sipTrunk;
/// Create a copy of ResolveSipInboundResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolveSipInboundResponseCopyWith<ResolveSipInboundResponse> get copyWith => _$ResolveSipInboundResponseCopyWithImpl<ResolveSipInboundResponse>(this as ResolveSipInboundResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolveSipInboundResponse&&(identical(other.credentials, credentials) || other.credentials == credentials)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.sipRoutingRule, sipRoutingRule) || other.sipRoutingRule == sipRoutingRule)&&(identical(other.sipTrunk, sipTrunk) || other.sipTrunk == sipTrunk));
}


@override
int get hashCode => Object.hash(runtimeType,credentials,duration,sipRoutingRule,sipTrunk);

@override
String toString() {
  return 'ResolveSipInboundResponse(credentials: $credentials, duration: $duration, sipRoutingRule: $sipRoutingRule, sipTrunk: $sipTrunk)';
}


}

/// @nodoc
abstract mixin class $ResolveSipInboundResponseCopyWith<$Res>  {
  factory $ResolveSipInboundResponseCopyWith(ResolveSipInboundResponse value, $Res Function(ResolveSipInboundResponse) _then) = _$ResolveSipInboundResponseCopyWithImpl;
@useResult
$Res call({
 SipInboundCredentials credentials, String duration, SIPInboundRoutingRuleResponse? sipRoutingRule, SIPTrunkResponse? sipTrunk
});




}
/// @nodoc
class _$ResolveSipInboundResponseCopyWithImpl<$Res>
    implements $ResolveSipInboundResponseCopyWith<$Res> {
  _$ResolveSipInboundResponseCopyWithImpl(this._self, this._then);

  final ResolveSipInboundResponse _self;
  final $Res Function(ResolveSipInboundResponse) _then;

/// Create a copy of ResolveSipInboundResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? credentials = null,Object? duration = null,Object? sipRoutingRule = freezed,Object? sipTrunk = freezed,}) {
  return _then(ResolveSipInboundResponse(
credentials: null == credentials ? _self.credentials : credentials // ignore: cast_nullable_to_non_nullable
as SipInboundCredentials,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,sipRoutingRule: freezed == sipRoutingRule ? _self.sipRoutingRule : sipRoutingRule // ignore: cast_nullable_to_non_nullable
as SIPInboundRoutingRuleResponse?,sipTrunk: freezed == sipTrunk ? _self.sipTrunk : sipTrunk // ignore: cast_nullable_to_non_nullable
as SIPTrunkResponse?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResolveSipInboundResponse].
extension ResolveSipInboundResponsePatterns on ResolveSipInboundResponse {
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
