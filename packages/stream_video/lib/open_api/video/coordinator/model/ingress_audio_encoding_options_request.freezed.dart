// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_audio_encoding_options_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IngressAudioEncodingOptionsRequest {

 int get bitrate; IngressAudioEncodingOptionsRequestChannels get channels; bool? get enableDtx;
/// Create a copy of IngressAudioEncodingOptionsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngressAudioEncodingOptionsRequestCopyWith<IngressAudioEncodingOptionsRequest> get copyWith => _$IngressAudioEncodingOptionsRequestCopyWithImpl<IngressAudioEncodingOptionsRequest>(this as IngressAudioEncodingOptionsRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngressAudioEncodingOptionsRequest&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.enableDtx, enableDtx) || other.enableDtx == enableDtx));
}


@override
int get hashCode => Object.hash(runtimeType,bitrate,channels,enableDtx);

@override
String toString() {
  return 'IngressAudioEncodingOptionsRequest(bitrate: $bitrate, channels: $channels, enableDtx: $enableDtx)';
}


}

/// @nodoc
abstract mixin class $IngressAudioEncodingOptionsRequestCopyWith<$Res>  {
  factory $IngressAudioEncodingOptionsRequestCopyWith(IngressAudioEncodingOptionsRequest value, $Res Function(IngressAudioEncodingOptionsRequest) _then) = _$IngressAudioEncodingOptionsRequestCopyWithImpl;
@useResult
$Res call({
 int bitrate, IngressAudioEncodingOptionsRequestChannels channels, bool? enableDtx
});




}
/// @nodoc
class _$IngressAudioEncodingOptionsRequestCopyWithImpl<$Res>
    implements $IngressAudioEncodingOptionsRequestCopyWith<$Res> {
  _$IngressAudioEncodingOptionsRequestCopyWithImpl(this._self, this._then);

  final IngressAudioEncodingOptionsRequest _self;
  final $Res Function(IngressAudioEncodingOptionsRequest) _then;

/// Create a copy of IngressAudioEncodingOptionsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bitrate = null,Object? channels = null,Object? enableDtx = freezed,}) {
  return _then(IngressAudioEncodingOptionsRequest(
bitrate: null == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as IngressAudioEncodingOptionsRequestChannels,enableDtx: freezed == enableDtx ? _self.enableDtx : enableDtx // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [IngressAudioEncodingOptionsRequest].
extension IngressAudioEncodingOptionsRequestPatterns on IngressAudioEncodingOptionsRequest {
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
