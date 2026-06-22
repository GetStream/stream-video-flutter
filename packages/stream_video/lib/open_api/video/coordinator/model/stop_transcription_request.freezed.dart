// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stop_transcription_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StopTranscriptionRequest {

 bool? get stopClosedCaptions;
/// Create a copy of StopTranscriptionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopTranscriptionRequestCopyWith<StopTranscriptionRequest> get copyWith => _$StopTranscriptionRequestCopyWithImpl<StopTranscriptionRequest>(this as StopTranscriptionRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopTranscriptionRequest&&(identical(other.stopClosedCaptions, stopClosedCaptions) || other.stopClosedCaptions == stopClosedCaptions));
}


@override
int get hashCode => Object.hash(runtimeType,stopClosedCaptions);

@override
String toString() {
  return 'StopTranscriptionRequest(stopClosedCaptions: $stopClosedCaptions)';
}


}

/// @nodoc
abstract mixin class $StopTranscriptionRequestCopyWith<$Res>  {
  factory $StopTranscriptionRequestCopyWith(StopTranscriptionRequest value, $Res Function(StopTranscriptionRequest) _then) = _$StopTranscriptionRequestCopyWithImpl;
@useResult
$Res call({
 bool? stopClosedCaptions
});




}
/// @nodoc
class _$StopTranscriptionRequestCopyWithImpl<$Res>
    implements $StopTranscriptionRequestCopyWith<$Res> {
  _$StopTranscriptionRequestCopyWithImpl(this._self, this._then);

  final StopTranscriptionRequest _self;
  final $Res Function(StopTranscriptionRequest) _then;

/// Create a copy of StopTranscriptionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stopClosedCaptions = freezed,}) {
  return _then(StopTranscriptionRequest(
stopClosedCaptions: freezed == stopClosedCaptions ? _self.stopClosedCaptions : stopClosedCaptions // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [StopTranscriptionRequest].
extension StopTranscriptionRequestPatterns on StopTranscriptionRequest {
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
