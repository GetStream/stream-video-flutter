// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_video_encoding_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IngressVideoEncodingResponse {

 List<IngressVideoLayerResponse> get layers; IngressSourceResponse get source;
/// Create a copy of IngressVideoEncodingResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngressVideoEncodingResponseCopyWith<IngressVideoEncodingResponse> get copyWith => _$IngressVideoEncodingResponseCopyWithImpl<IngressVideoEncodingResponse>(this as IngressVideoEncodingResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngressVideoEncodingResponse&&const DeepCollectionEquality().equals(other.layers, layers)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(layers),source);

@override
String toString() {
  return 'IngressVideoEncodingResponse(layers: $layers, source: $source)';
}


}

/// @nodoc
abstract mixin class $IngressVideoEncodingResponseCopyWith<$Res>  {
  factory $IngressVideoEncodingResponseCopyWith(IngressVideoEncodingResponse value, $Res Function(IngressVideoEncodingResponse) _then) = _$IngressVideoEncodingResponseCopyWithImpl;
@useResult
$Res call({
 List<IngressVideoLayerResponse> layers, IngressSourceResponse source
});




}
/// @nodoc
class _$IngressVideoEncodingResponseCopyWithImpl<$Res>
    implements $IngressVideoEncodingResponseCopyWith<$Res> {
  _$IngressVideoEncodingResponseCopyWithImpl(this._self, this._then);

  final IngressVideoEncodingResponse _self;
  final $Res Function(IngressVideoEncodingResponse) _then;

/// Create a copy of IngressVideoEncodingResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? layers = null,Object? source = null,}) {
  return _then(IngressVideoEncodingResponse(
layers: null == layers ? _self.layers : layers // ignore: cast_nullable_to_non_nullable
as List<IngressVideoLayerResponse>,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as IngressSourceResponse,
  ));
}

}


/// Adds pattern-matching-related methods to [IngressVideoEncodingResponse].
extension IngressVideoEncodingResponsePatterns on IngressVideoEncodingResponse {
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
