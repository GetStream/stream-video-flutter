// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolve_sip_auth_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResolveSipAuthRequest {

 String? get fromHost; String get sipCallerNumber; String get sipTrunkNumber; String? get sourceIp;
/// Create a copy of ResolveSipAuthRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolveSipAuthRequestCopyWith<ResolveSipAuthRequest> get copyWith => _$ResolveSipAuthRequestCopyWithImpl<ResolveSipAuthRequest>(this as ResolveSipAuthRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolveSipAuthRequest&&(identical(other.fromHost, fromHost) || other.fromHost == fromHost)&&(identical(other.sipCallerNumber, sipCallerNumber) || other.sipCallerNumber == sipCallerNumber)&&(identical(other.sipTrunkNumber, sipTrunkNumber) || other.sipTrunkNumber == sipTrunkNumber)&&(identical(other.sourceIp, sourceIp) || other.sourceIp == sourceIp));
}


@override
int get hashCode => Object.hash(runtimeType,fromHost,sipCallerNumber,sipTrunkNumber,sourceIp);

@override
String toString() {
  return 'ResolveSipAuthRequest(fromHost: $fromHost, sipCallerNumber: $sipCallerNumber, sipTrunkNumber: $sipTrunkNumber, sourceIp: $sourceIp)';
}


}

/// @nodoc
abstract mixin class $ResolveSipAuthRequestCopyWith<$Res>  {
  factory $ResolveSipAuthRequestCopyWith(ResolveSipAuthRequest value, $Res Function(ResolveSipAuthRequest) _then) = _$ResolveSipAuthRequestCopyWithImpl;
@useResult
$Res call({
 String? fromHost, String sipCallerNumber, String sipTrunkNumber, String? sourceIp
});




}
/// @nodoc
class _$ResolveSipAuthRequestCopyWithImpl<$Res>
    implements $ResolveSipAuthRequestCopyWith<$Res> {
  _$ResolveSipAuthRequestCopyWithImpl(this._self, this._then);

  final ResolveSipAuthRequest _self;
  final $Res Function(ResolveSipAuthRequest) _then;

/// Create a copy of ResolveSipAuthRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromHost = freezed,Object? sipCallerNumber = null,Object? sipTrunkNumber = null,Object? sourceIp = freezed,}) {
  return _then(ResolveSipAuthRequest(
fromHost: freezed == fromHost ? _self.fromHost : fromHost // ignore: cast_nullable_to_non_nullable
as String?,sipCallerNumber: null == sipCallerNumber ? _self.sipCallerNumber : sipCallerNumber // ignore: cast_nullable_to_non_nullable
as String,sipTrunkNumber: null == sipTrunkNumber ? _self.sipTrunkNumber : sipTrunkNumber // ignore: cast_nullable_to_non_nullable
as String,sourceIp: freezed == sourceIp ? _self.sourceIp : sourceIp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResolveSipAuthRequest].
extension ResolveSipAuthRequestPatterns on ResolveSipAuthRequest {
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
