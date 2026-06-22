// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_device_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateDeviceRequest {

 String? get hardwareId; String get id; CreateDeviceRequestPushProvider get pushProvider; String? get pushProviderName; bool? get voipToken;
/// Create a copy of CreateDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateDeviceRequestCopyWith<CreateDeviceRequest> get copyWith => _$CreateDeviceRequestCopyWithImpl<CreateDeviceRequest>(this as CreateDeviceRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateDeviceRequest&&(identical(other.hardwareId, hardwareId) || other.hardwareId == hardwareId)&&(identical(other.id, id) || other.id == id)&&(identical(other.pushProvider, pushProvider) || other.pushProvider == pushProvider)&&(identical(other.pushProviderName, pushProviderName) || other.pushProviderName == pushProviderName)&&(identical(other.voipToken, voipToken) || other.voipToken == voipToken));
}


@override
int get hashCode => Object.hash(runtimeType,hardwareId,id,pushProvider,pushProviderName,voipToken);

@override
String toString() {
  return 'CreateDeviceRequest(hardwareId: $hardwareId, id: $id, pushProvider: $pushProvider, pushProviderName: $pushProviderName, voipToken: $voipToken)';
}


}

/// @nodoc
abstract mixin class $CreateDeviceRequestCopyWith<$Res>  {
  factory $CreateDeviceRequestCopyWith(CreateDeviceRequest value, $Res Function(CreateDeviceRequest) _then) = _$CreateDeviceRequestCopyWithImpl;
@useResult
$Res call({
 String? hardwareId, String id, CreateDeviceRequestPushProvider pushProvider, String? pushProviderName, bool? voipToken
});




}
/// @nodoc
class _$CreateDeviceRequestCopyWithImpl<$Res>
    implements $CreateDeviceRequestCopyWith<$Res> {
  _$CreateDeviceRequestCopyWithImpl(this._self, this._then);

  final CreateDeviceRequest _self;
  final $Res Function(CreateDeviceRequest) _then;

/// Create a copy of CreateDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hardwareId = freezed,Object? id = null,Object? pushProvider = null,Object? pushProviderName = freezed,Object? voipToken = freezed,}) {
  return _then(CreateDeviceRequest(
hardwareId: freezed == hardwareId ? _self.hardwareId : hardwareId // ignore: cast_nullable_to_non_nullable
as String?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pushProvider: null == pushProvider ? _self.pushProvider : pushProvider // ignore: cast_nullable_to_non_nullable
as CreateDeviceRequestPushProvider,pushProviderName: freezed == pushProviderName ? _self.pushProviderName : pushProviderName // ignore: cast_nullable_to_non_nullable
as String?,voipToken: freezed == voipToken ? _self.voipToken : voipToken // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateDeviceRequest].
extension CreateDeviceRequestPatterns on CreateDeviceRequest {
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
