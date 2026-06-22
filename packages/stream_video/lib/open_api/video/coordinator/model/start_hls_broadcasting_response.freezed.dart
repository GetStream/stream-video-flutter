// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'start_hls_broadcasting_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StartHLSBroadcastingResponse {

 String get duration; String get playlistUrl;
/// Create a copy of StartHLSBroadcastingResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartHLSBroadcastingResponseCopyWith<StartHLSBroadcastingResponse> get copyWith => _$StartHLSBroadcastingResponseCopyWithImpl<StartHLSBroadcastingResponse>(this as StartHLSBroadcastingResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartHLSBroadcastingResponse&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.playlistUrl, playlistUrl) || other.playlistUrl == playlistUrl));
}


@override
int get hashCode => Object.hash(runtimeType,duration,playlistUrl);

@override
String toString() {
  return 'StartHLSBroadcastingResponse(duration: $duration, playlistUrl: $playlistUrl)';
}


}

/// @nodoc
abstract mixin class $StartHLSBroadcastingResponseCopyWith<$Res>  {
  factory $StartHLSBroadcastingResponseCopyWith(StartHLSBroadcastingResponse value, $Res Function(StartHLSBroadcastingResponse) _then) = _$StartHLSBroadcastingResponseCopyWithImpl;
@useResult
$Res call({
 String duration, String playlistUrl
});




}
/// @nodoc
class _$StartHLSBroadcastingResponseCopyWithImpl<$Res>
    implements $StartHLSBroadcastingResponseCopyWith<$Res> {
  _$StartHLSBroadcastingResponseCopyWithImpl(this._self, this._then);

  final StartHLSBroadcastingResponse _self;
  final $Res Function(StartHLSBroadcastingResponse) _then;

/// Create a copy of StartHLSBroadcastingResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? duration = null,Object? playlistUrl = null,}) {
  return _then(StartHLSBroadcastingResponse(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,playlistUrl: null == playlistUrl ? _self.playlistUrl : playlistUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StartHLSBroadcastingResponse].
extension StartHLSBroadcastingResponsePatterns on StartHLSBroadcastingResponse {
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
