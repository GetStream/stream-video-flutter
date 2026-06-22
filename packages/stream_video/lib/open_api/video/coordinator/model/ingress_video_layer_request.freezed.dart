// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_video_layer_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IngressVideoLayerRequest {

 int get bitrate; IngressVideoLayerRequestCodec get codec; int get frameRateLimit; int get maxDimension; int get minDimension;
/// Create a copy of IngressVideoLayerRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngressVideoLayerRequestCopyWith<IngressVideoLayerRequest> get copyWith => _$IngressVideoLayerRequestCopyWithImpl<IngressVideoLayerRequest>(this as IngressVideoLayerRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngressVideoLayerRequest&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.codec, codec) || other.codec == codec)&&(identical(other.frameRateLimit, frameRateLimit) || other.frameRateLimit == frameRateLimit)&&(identical(other.maxDimension, maxDimension) || other.maxDimension == maxDimension)&&(identical(other.minDimension, minDimension) || other.minDimension == minDimension));
}


@override
int get hashCode => Object.hash(runtimeType,bitrate,codec,frameRateLimit,maxDimension,minDimension);

@override
String toString() {
  return 'IngressVideoLayerRequest(bitrate: $bitrate, codec: $codec, frameRateLimit: $frameRateLimit, maxDimension: $maxDimension, minDimension: $minDimension)';
}


}

/// @nodoc
abstract mixin class $IngressVideoLayerRequestCopyWith<$Res>  {
  factory $IngressVideoLayerRequestCopyWith(IngressVideoLayerRequest value, $Res Function(IngressVideoLayerRequest) _then) = _$IngressVideoLayerRequestCopyWithImpl;
@useResult
$Res call({
 int bitrate, IngressVideoLayerRequestCodec codec, int frameRateLimit, int maxDimension, int minDimension
});




}
/// @nodoc
class _$IngressVideoLayerRequestCopyWithImpl<$Res>
    implements $IngressVideoLayerRequestCopyWith<$Res> {
  _$IngressVideoLayerRequestCopyWithImpl(this._self, this._then);

  final IngressVideoLayerRequest _self;
  final $Res Function(IngressVideoLayerRequest) _then;

/// Create a copy of IngressVideoLayerRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bitrate = null,Object? codec = null,Object? frameRateLimit = null,Object? maxDimension = null,Object? minDimension = null,}) {
  return _then(IngressVideoLayerRequest(
bitrate: null == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int,codec: null == codec ? _self.codec : codec // ignore: cast_nullable_to_non_nullable
as IngressVideoLayerRequestCodec,frameRateLimit: null == frameRateLimit ? _self.frameRateLimit : frameRateLimit // ignore: cast_nullable_to_non_nullable
as int,maxDimension: null == maxDimension ? _self.maxDimension : maxDimension // ignore: cast_nullable_to_non_nullable
as int,minDimension: null == minDimension ? _self.minDimension : minDimension // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [IngressVideoLayerRequest].
extension IngressVideoLayerRequestPatterns on IngressVideoLayerRequest {
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
