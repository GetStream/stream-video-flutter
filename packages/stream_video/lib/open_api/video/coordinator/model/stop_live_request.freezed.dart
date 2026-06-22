// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stop_live_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StopLiveRequest {

 bool? get continueClosedCaption; bool? get continueCompositeRecording; bool? get continueHls; bool? get continueIndividualRecording; bool? get continueRawRecording; bool? get continueRecording; bool? get continueRtmpBroadcasts; bool? get continueTranscription;
/// Create a copy of StopLiveRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopLiveRequestCopyWith<StopLiveRequest> get copyWith => _$StopLiveRequestCopyWithImpl<StopLiveRequest>(this as StopLiveRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopLiveRequest&&(identical(other.continueClosedCaption, continueClosedCaption) || other.continueClosedCaption == continueClosedCaption)&&(identical(other.continueCompositeRecording, continueCompositeRecording) || other.continueCompositeRecording == continueCompositeRecording)&&(identical(other.continueHls, continueHls) || other.continueHls == continueHls)&&(identical(other.continueIndividualRecording, continueIndividualRecording) || other.continueIndividualRecording == continueIndividualRecording)&&(identical(other.continueRawRecording, continueRawRecording) || other.continueRawRecording == continueRawRecording)&&(identical(other.continueRecording, continueRecording) || other.continueRecording == continueRecording)&&(identical(other.continueRtmpBroadcasts, continueRtmpBroadcasts) || other.continueRtmpBroadcasts == continueRtmpBroadcasts)&&(identical(other.continueTranscription, continueTranscription) || other.continueTranscription == continueTranscription));
}


@override
int get hashCode => Object.hash(runtimeType,continueClosedCaption,continueCompositeRecording,continueHls,continueIndividualRecording,continueRawRecording,continueRecording,continueRtmpBroadcasts,continueTranscription);

@override
String toString() {
  return 'StopLiveRequest(continueClosedCaption: $continueClosedCaption, continueCompositeRecording: $continueCompositeRecording, continueHls: $continueHls, continueIndividualRecording: $continueIndividualRecording, continueRawRecording: $continueRawRecording, continueRecording: $continueRecording, continueRtmpBroadcasts: $continueRtmpBroadcasts, continueTranscription: $continueTranscription)';
}


}

/// @nodoc
abstract mixin class $StopLiveRequestCopyWith<$Res>  {
  factory $StopLiveRequestCopyWith(StopLiveRequest value, $Res Function(StopLiveRequest) _then) = _$StopLiveRequestCopyWithImpl;
@useResult
$Res call({
 bool? continueClosedCaption, bool? continueCompositeRecording, bool? continueHls, bool? continueIndividualRecording, bool? continueRawRecording, bool? continueRecording, bool? continueRtmpBroadcasts, bool? continueTranscription
});




}
/// @nodoc
class _$StopLiveRequestCopyWithImpl<$Res>
    implements $StopLiveRequestCopyWith<$Res> {
  _$StopLiveRequestCopyWithImpl(this._self, this._then);

  final StopLiveRequest _self;
  final $Res Function(StopLiveRequest) _then;

/// Create a copy of StopLiveRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? continueClosedCaption = freezed,Object? continueCompositeRecording = freezed,Object? continueHls = freezed,Object? continueIndividualRecording = freezed,Object? continueRawRecording = freezed,Object? continueRecording = freezed,Object? continueRtmpBroadcasts = freezed,Object? continueTranscription = freezed,}) {
  return _then(StopLiveRequest(
continueClosedCaption: freezed == continueClosedCaption ? _self.continueClosedCaption : continueClosedCaption // ignore: cast_nullable_to_non_nullable
as bool?,continueCompositeRecording: freezed == continueCompositeRecording ? _self.continueCompositeRecording : continueCompositeRecording // ignore: cast_nullable_to_non_nullable
as bool?,continueHls: freezed == continueHls ? _self.continueHls : continueHls // ignore: cast_nullable_to_non_nullable
as bool?,continueIndividualRecording: freezed == continueIndividualRecording ? _self.continueIndividualRecording : continueIndividualRecording // ignore: cast_nullable_to_non_nullable
as bool?,continueRawRecording: freezed == continueRawRecording ? _self.continueRawRecording : continueRawRecording // ignore: cast_nullable_to_non_nullable
as bool?,continueRecording: freezed == continueRecording ? _self.continueRecording : continueRecording // ignore: cast_nullable_to_non_nullable
as bool?,continueRtmpBroadcasts: freezed == continueRtmpBroadcasts ? _self.continueRtmpBroadcasts : continueRtmpBroadcasts // ignore: cast_nullable_to_non_nullable
as bool?,continueTranscription: freezed == continueTranscription ? _self.continueTranscription : continueTranscription // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [StopLiveRequest].
extension StopLiveRequestPatterns on StopLiveRequest {
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
