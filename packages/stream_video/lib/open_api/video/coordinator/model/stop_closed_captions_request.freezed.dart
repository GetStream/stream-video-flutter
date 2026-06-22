// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stop_closed_captions_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StopClosedCaptionsRequest {

 bool? get stopTranscription;
/// Create a copy of StopClosedCaptionsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopClosedCaptionsRequestCopyWith<StopClosedCaptionsRequest> get copyWith => _$StopClosedCaptionsRequestCopyWithImpl<StopClosedCaptionsRequest>(this as StopClosedCaptionsRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopClosedCaptionsRequest&&(identical(other.stopTranscription, stopTranscription) || other.stopTranscription == stopTranscription));
}


@override
int get hashCode => Object.hash(runtimeType,stopTranscription);

@override
String toString() {
  return 'StopClosedCaptionsRequest(stopTranscription: $stopTranscription)';
}


}

/// @nodoc
abstract mixin class $StopClosedCaptionsRequestCopyWith<$Res>  {
  factory $StopClosedCaptionsRequestCopyWith(StopClosedCaptionsRequest value, $Res Function(StopClosedCaptionsRequest) _then) = _$StopClosedCaptionsRequestCopyWithImpl;
@useResult
$Res call({
 bool? stopTranscription
});




}
/// @nodoc
class _$StopClosedCaptionsRequestCopyWithImpl<$Res>
    implements $StopClosedCaptionsRequestCopyWith<$Res> {
  _$StopClosedCaptionsRequestCopyWithImpl(this._self, this._then);

  final StopClosedCaptionsRequest _self;
  final $Res Function(StopClosedCaptionsRequest) _then;

/// Create a copy of StopClosedCaptionsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stopTranscription = freezed,}) {
  return _then(StopClosedCaptionsRequest(
stopTranscription: freezed == stopTranscription ? _self.stopTranscription : stopTranscription // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [StopClosedCaptionsRequest].
extension StopClosedCaptionsRequestPatterns on StopClosedCaptionsRequest {
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
