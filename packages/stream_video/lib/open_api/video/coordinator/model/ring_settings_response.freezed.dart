// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ring_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RingSettingsResponse {

 int get autoCancelTimeoutMs; int get incomingCallTimeoutMs; int get missedCallTimeoutMs;
/// Create a copy of RingSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RingSettingsResponseCopyWith<RingSettingsResponse> get copyWith => _$RingSettingsResponseCopyWithImpl<RingSettingsResponse>(this as RingSettingsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RingSettingsResponse&&(identical(other.autoCancelTimeoutMs, autoCancelTimeoutMs) || other.autoCancelTimeoutMs == autoCancelTimeoutMs)&&(identical(other.incomingCallTimeoutMs, incomingCallTimeoutMs) || other.incomingCallTimeoutMs == incomingCallTimeoutMs)&&(identical(other.missedCallTimeoutMs, missedCallTimeoutMs) || other.missedCallTimeoutMs == missedCallTimeoutMs));
}


@override
int get hashCode => Object.hash(runtimeType,autoCancelTimeoutMs,incomingCallTimeoutMs,missedCallTimeoutMs);

@override
String toString() {
  return 'RingSettingsResponse(autoCancelTimeoutMs: $autoCancelTimeoutMs, incomingCallTimeoutMs: $incomingCallTimeoutMs, missedCallTimeoutMs: $missedCallTimeoutMs)';
}


}

/// @nodoc
abstract mixin class $RingSettingsResponseCopyWith<$Res>  {
  factory $RingSettingsResponseCopyWith(RingSettingsResponse value, $Res Function(RingSettingsResponse) _then) = _$RingSettingsResponseCopyWithImpl;
@useResult
$Res call({
 int autoCancelTimeoutMs, int incomingCallTimeoutMs, int missedCallTimeoutMs
});




}
/// @nodoc
class _$RingSettingsResponseCopyWithImpl<$Res>
    implements $RingSettingsResponseCopyWith<$Res> {
  _$RingSettingsResponseCopyWithImpl(this._self, this._then);

  final RingSettingsResponse _self;
  final $Res Function(RingSettingsResponse) _then;

/// Create a copy of RingSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? autoCancelTimeoutMs = null,Object? incomingCallTimeoutMs = null,Object? missedCallTimeoutMs = null,}) {
  return _then(RingSettingsResponse(
autoCancelTimeoutMs: null == autoCancelTimeoutMs ? _self.autoCancelTimeoutMs : autoCancelTimeoutMs // ignore: cast_nullable_to_non_nullable
as int,incomingCallTimeoutMs: null == incomingCallTimeoutMs ? _self.incomingCallTimeoutMs : incomingCallTimeoutMs // ignore: cast_nullable_to_non_nullable
as int,missedCallTimeoutMs: null == missedCallTimeoutMs ? _self.missedCallTimeoutMs : missedCallTimeoutMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RingSettingsResponse].
extension RingSettingsResponsePatterns on RingSettingsResponse {
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
