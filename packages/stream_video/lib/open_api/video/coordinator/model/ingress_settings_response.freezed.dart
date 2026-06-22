// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IngressSettingsResponse {

 IngressAudioEncodingResponse? get audioEncodingOptions; bool get enabled; Map<String, IngressVideoEncodingResponse>? get videoEncodingOptions;
/// Create a copy of IngressSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngressSettingsResponseCopyWith<IngressSettingsResponse> get copyWith => _$IngressSettingsResponseCopyWithImpl<IngressSettingsResponse>(this as IngressSettingsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngressSettingsResponse&&(identical(other.audioEncodingOptions, audioEncodingOptions) || other.audioEncodingOptions == audioEncodingOptions)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.videoEncodingOptions, videoEncodingOptions));
}


@override
int get hashCode => Object.hash(runtimeType,audioEncodingOptions,enabled,const DeepCollectionEquality().hash(videoEncodingOptions));

@override
String toString() {
  return 'IngressSettingsResponse(audioEncodingOptions: $audioEncodingOptions, enabled: $enabled, videoEncodingOptions: $videoEncodingOptions)';
}


}

/// @nodoc
abstract mixin class $IngressSettingsResponseCopyWith<$Res>  {
  factory $IngressSettingsResponseCopyWith(IngressSettingsResponse value, $Res Function(IngressSettingsResponse) _then) = _$IngressSettingsResponseCopyWithImpl;
@useResult
$Res call({
 IngressAudioEncodingResponse? audioEncodingOptions, bool enabled, Map<String, IngressVideoEncodingResponse>? videoEncodingOptions
});




}
/// @nodoc
class _$IngressSettingsResponseCopyWithImpl<$Res>
    implements $IngressSettingsResponseCopyWith<$Res> {
  _$IngressSettingsResponseCopyWithImpl(this._self, this._then);

  final IngressSettingsResponse _self;
  final $Res Function(IngressSettingsResponse) _then;

/// Create a copy of IngressSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? audioEncodingOptions = freezed,Object? enabled = null,Object? videoEncodingOptions = freezed,}) {
  return _then(IngressSettingsResponse(
audioEncodingOptions: freezed == audioEncodingOptions ? _self.audioEncodingOptions : audioEncodingOptions // ignore: cast_nullable_to_non_nullable
as IngressAudioEncodingResponse?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,videoEncodingOptions: freezed == videoEncodingOptions ? _self.videoEncodingOptions : videoEncodingOptions // ignore: cast_nullable_to_non_nullable
as Map<String, IngressVideoEncodingResponse>?,
  ));
}

}


/// Adds pattern-matching-related methods to [IngressSettingsResponse].
extension IngressSettingsResponsePatterns on IngressSettingsResponse {
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
