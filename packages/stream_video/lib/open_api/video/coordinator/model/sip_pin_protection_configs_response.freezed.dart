// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sip_pin_protection_configs_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SIPPinProtectionConfigsResponse {

 String? get defaultPin; bool get enabled; int? get maxAttempts; int? get requiredPinDigits;
/// Create a copy of SIPPinProtectionConfigsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SIPPinProtectionConfigsResponseCopyWith<SIPPinProtectionConfigsResponse> get copyWith => _$SIPPinProtectionConfigsResponseCopyWithImpl<SIPPinProtectionConfigsResponse>(this as SIPPinProtectionConfigsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SIPPinProtectionConfigsResponse&&(identical(other.defaultPin, defaultPin) || other.defaultPin == defaultPin)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.requiredPinDigits, requiredPinDigits) || other.requiredPinDigits == requiredPinDigits));
}


@override
int get hashCode => Object.hash(runtimeType,defaultPin,enabled,maxAttempts,requiredPinDigits);

@override
String toString() {
  return 'SIPPinProtectionConfigsResponse(defaultPin: $defaultPin, enabled: $enabled, maxAttempts: $maxAttempts, requiredPinDigits: $requiredPinDigits)';
}


}

/// @nodoc
abstract mixin class $SIPPinProtectionConfigsResponseCopyWith<$Res>  {
  factory $SIPPinProtectionConfigsResponseCopyWith(SIPPinProtectionConfigsResponse value, $Res Function(SIPPinProtectionConfigsResponse) _then) = _$SIPPinProtectionConfigsResponseCopyWithImpl;
@useResult
$Res call({
 String? defaultPin, bool enabled, int? maxAttempts, int? requiredPinDigits
});




}
/// @nodoc
class _$SIPPinProtectionConfigsResponseCopyWithImpl<$Res>
    implements $SIPPinProtectionConfigsResponseCopyWith<$Res> {
  _$SIPPinProtectionConfigsResponseCopyWithImpl(this._self, this._then);

  final SIPPinProtectionConfigsResponse _self;
  final $Res Function(SIPPinProtectionConfigsResponse) _then;

/// Create a copy of SIPPinProtectionConfigsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultPin = freezed,Object? enabled = null,Object? maxAttempts = freezed,Object? requiredPinDigits = freezed,}) {
  return _then(SIPPinProtectionConfigsResponse(
defaultPin: freezed == defaultPin ? _self.defaultPin : defaultPin // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,maxAttempts: freezed == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int?,requiredPinDigits: freezed == requiredPinDigits ? _self.requiredPinDigits : requiredPinDigits // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SIPPinProtectionConfigsResponse].
extension SIPPinProtectionConfigsResponsePatterns on SIPPinProtectionConfigsResponse {
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
