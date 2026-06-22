// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'egress_rtmp_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EgressRTMPResponse {

 String get name; DateTime get startedAt; String? get streamKey; String? get streamUrl;
/// Create a copy of EgressRTMPResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EgressRTMPResponseCopyWith<EgressRTMPResponse> get copyWith => _$EgressRTMPResponseCopyWithImpl<EgressRTMPResponse>(this as EgressRTMPResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EgressRTMPResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.streamKey, streamKey) || other.streamKey == streamKey)&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl));
}


@override
int get hashCode => Object.hash(runtimeType,name,startedAt,streamKey,streamUrl);

@override
String toString() {
  return 'EgressRTMPResponse(name: $name, startedAt: $startedAt, streamKey: $streamKey, streamUrl: $streamUrl)';
}


}

/// @nodoc
abstract mixin class $EgressRTMPResponseCopyWith<$Res>  {
  factory $EgressRTMPResponseCopyWith(EgressRTMPResponse value, $Res Function(EgressRTMPResponse) _then) = _$EgressRTMPResponseCopyWithImpl;
@useResult
$Res call({
 String name, DateTime startedAt, String? streamKey, String? streamUrl
});




}
/// @nodoc
class _$EgressRTMPResponseCopyWithImpl<$Res>
    implements $EgressRTMPResponseCopyWith<$Res> {
  _$EgressRTMPResponseCopyWithImpl(this._self, this._then);

  final EgressRTMPResponse _self;
  final $Res Function(EgressRTMPResponse) _then;

/// Create a copy of EgressRTMPResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? startedAt = null,Object? streamKey = freezed,Object? streamUrl = freezed,}) {
  return _then(EgressRTMPResponse(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,streamKey: freezed == streamKey ? _self.streamKey : streamKey // ignore: cast_nullable_to_non_nullable
as String?,streamUrl: freezed == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EgressRTMPResponse].
extension EgressRTMPResponsePatterns on EgressRTMPResponse {
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
