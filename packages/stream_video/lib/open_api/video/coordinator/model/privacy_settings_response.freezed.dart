// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivacySettingsResponse {

 DeliveryReceiptsResponse? get deliveryReceipts; ReadReceiptsResponse? get readReceipts; TypingIndicatorsResponse? get typingIndicators;
/// Create a copy of PrivacySettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivacySettingsResponseCopyWith<PrivacySettingsResponse> get copyWith => _$PrivacySettingsResponseCopyWithImpl<PrivacySettingsResponse>(this as PrivacySettingsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivacySettingsResponse&&(identical(other.deliveryReceipts, deliveryReceipts) || other.deliveryReceipts == deliveryReceipts)&&(identical(other.readReceipts, readReceipts) || other.readReceipts == readReceipts)&&(identical(other.typingIndicators, typingIndicators) || other.typingIndicators == typingIndicators));
}


@override
int get hashCode => Object.hash(runtimeType,deliveryReceipts,readReceipts,typingIndicators);

@override
String toString() {
  return 'PrivacySettingsResponse(deliveryReceipts: $deliveryReceipts, readReceipts: $readReceipts, typingIndicators: $typingIndicators)';
}


}

/// @nodoc
abstract mixin class $PrivacySettingsResponseCopyWith<$Res>  {
  factory $PrivacySettingsResponseCopyWith(PrivacySettingsResponse value, $Res Function(PrivacySettingsResponse) _then) = _$PrivacySettingsResponseCopyWithImpl;
@useResult
$Res call({
 DeliveryReceiptsResponse? deliveryReceipts, ReadReceiptsResponse? readReceipts, TypingIndicatorsResponse? typingIndicators
});




}
/// @nodoc
class _$PrivacySettingsResponseCopyWithImpl<$Res>
    implements $PrivacySettingsResponseCopyWith<$Res> {
  _$PrivacySettingsResponseCopyWithImpl(this._self, this._then);

  final PrivacySettingsResponse _self;
  final $Res Function(PrivacySettingsResponse) _then;

/// Create a copy of PrivacySettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deliveryReceipts = freezed,Object? readReceipts = freezed,Object? typingIndicators = freezed,}) {
  return _then(PrivacySettingsResponse(
deliveryReceipts: freezed == deliveryReceipts ? _self.deliveryReceipts : deliveryReceipts // ignore: cast_nullable_to_non_nullable
as DeliveryReceiptsResponse?,readReceipts: freezed == readReceipts ? _self.readReceipts : readReceipts // ignore: cast_nullable_to_non_nullable
as ReadReceiptsResponse?,typingIndicators: freezed == typingIndicators ? _self.typingIndicators : typingIndicators // ignore: cast_nullable_to_non_nullable
as TypingIndicatorsResponse?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivacySettingsResponse].
extension PrivacySettingsResponsePatterns on PrivacySettingsResponse {
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
