// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_recording.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallRecording {

 DateTime get endTime; String get filename; String get recordingType; String get sessionId; DateTime get startTime; String get url;
/// Create a copy of CallRecording
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallRecordingCopyWith<CallRecording> get copyWith => _$CallRecordingCopyWithImpl<CallRecording>(this as CallRecording, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallRecording&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.recordingType, recordingType) || other.recordingType == recordingType)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,endTime,filename,recordingType,sessionId,startTime,url);

@override
String toString() {
  return 'CallRecording(endTime: $endTime, filename: $filename, recordingType: $recordingType, sessionId: $sessionId, startTime: $startTime, url: $url)';
}


}

/// @nodoc
abstract mixin class $CallRecordingCopyWith<$Res>  {
  factory $CallRecordingCopyWith(CallRecording value, $Res Function(CallRecording) _then) = _$CallRecordingCopyWithImpl;
@useResult
$Res call({
 DateTime endTime, String filename, String recordingType, String sessionId, DateTime startTime, String url
});




}
/// @nodoc
class _$CallRecordingCopyWithImpl<$Res>
    implements $CallRecordingCopyWith<$Res> {
  _$CallRecordingCopyWithImpl(this._self, this._then);

  final CallRecording _self;
  final $Res Function(CallRecording) _then;

/// Create a copy of CallRecording
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? endTime = null,Object? filename = null,Object? recordingType = null,Object? sessionId = null,Object? startTime = null,Object? url = null,}) {
  return _then(CallRecording(
endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,recordingType: null == recordingType ? _self.recordingType : recordingType // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallRecording].
extension CallRecordingPatterns on CallRecording {
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
