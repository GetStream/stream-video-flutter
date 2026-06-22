// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'go_live_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoLiveRequest {

 String? get recordingStorageName; bool? get startClosedCaption; bool? get startCompositeRecording; bool? get startHls; bool? get startIndividualRecording; bool? get startRawRecording; bool? get startRecording; bool? get startTranscription; String? get transcriptionStorageName;
/// Create a copy of GoLiveRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoLiveRequestCopyWith<GoLiveRequest> get copyWith => _$GoLiveRequestCopyWithImpl<GoLiveRequest>(this as GoLiveRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoLiveRequest&&(identical(other.recordingStorageName, recordingStorageName) || other.recordingStorageName == recordingStorageName)&&(identical(other.startClosedCaption, startClosedCaption) || other.startClosedCaption == startClosedCaption)&&(identical(other.startCompositeRecording, startCompositeRecording) || other.startCompositeRecording == startCompositeRecording)&&(identical(other.startHls, startHls) || other.startHls == startHls)&&(identical(other.startIndividualRecording, startIndividualRecording) || other.startIndividualRecording == startIndividualRecording)&&(identical(other.startRawRecording, startRawRecording) || other.startRawRecording == startRawRecording)&&(identical(other.startRecording, startRecording) || other.startRecording == startRecording)&&(identical(other.startTranscription, startTranscription) || other.startTranscription == startTranscription)&&(identical(other.transcriptionStorageName, transcriptionStorageName) || other.transcriptionStorageName == transcriptionStorageName));
}


@override
int get hashCode => Object.hash(runtimeType,recordingStorageName,startClosedCaption,startCompositeRecording,startHls,startIndividualRecording,startRawRecording,startRecording,startTranscription,transcriptionStorageName);

@override
String toString() {
  return 'GoLiveRequest(recordingStorageName: $recordingStorageName, startClosedCaption: $startClosedCaption, startCompositeRecording: $startCompositeRecording, startHls: $startHls, startIndividualRecording: $startIndividualRecording, startRawRecording: $startRawRecording, startRecording: $startRecording, startTranscription: $startTranscription, transcriptionStorageName: $transcriptionStorageName)';
}


}

/// @nodoc
abstract mixin class $GoLiveRequestCopyWith<$Res>  {
  factory $GoLiveRequestCopyWith(GoLiveRequest value, $Res Function(GoLiveRequest) _then) = _$GoLiveRequestCopyWithImpl;
@useResult
$Res call({
 String? recordingStorageName, bool? startClosedCaption, bool? startCompositeRecording, bool? startHls, bool? startIndividualRecording, bool? startRawRecording, bool? startRecording, bool? startTranscription, String? transcriptionStorageName
});




}
/// @nodoc
class _$GoLiveRequestCopyWithImpl<$Res>
    implements $GoLiveRequestCopyWith<$Res> {
  _$GoLiveRequestCopyWithImpl(this._self, this._then);

  final GoLiveRequest _self;
  final $Res Function(GoLiveRequest) _then;

/// Create a copy of GoLiveRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recordingStorageName = freezed,Object? startClosedCaption = freezed,Object? startCompositeRecording = freezed,Object? startHls = freezed,Object? startIndividualRecording = freezed,Object? startRawRecording = freezed,Object? startRecording = freezed,Object? startTranscription = freezed,Object? transcriptionStorageName = freezed,}) {
  return _then(GoLiveRequest(
recordingStorageName: freezed == recordingStorageName ? _self.recordingStorageName : recordingStorageName // ignore: cast_nullable_to_non_nullable
as String?,startClosedCaption: freezed == startClosedCaption ? _self.startClosedCaption : startClosedCaption // ignore: cast_nullable_to_non_nullable
as bool?,startCompositeRecording: freezed == startCompositeRecording ? _self.startCompositeRecording : startCompositeRecording // ignore: cast_nullable_to_non_nullable
as bool?,startHls: freezed == startHls ? _self.startHls : startHls // ignore: cast_nullable_to_non_nullable
as bool?,startIndividualRecording: freezed == startIndividualRecording ? _self.startIndividualRecording : startIndividualRecording // ignore: cast_nullable_to_non_nullable
as bool?,startRawRecording: freezed == startRawRecording ? _self.startRawRecording : startRawRecording // ignore: cast_nullable_to_non_nullable
as bool?,startRecording: freezed == startRecording ? _self.startRecording : startRecording // ignore: cast_nullable_to_non_nullable
as bool?,startTranscription: freezed == startTranscription ? _self.startTranscription : startTranscription // ignore: cast_nullable_to_non_nullable
as bool?,transcriptionStorageName: freezed == transcriptionStorageName ? _self.transcriptionStorageName : transcriptionStorageName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoLiveRequest].
extension GoLiveRequestPatterns on GoLiveRequest {
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
