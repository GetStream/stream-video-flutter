// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'start_transcription_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StartTranscriptionRequest {

 bool? get enableClosedCaptions; StartTranscriptionRequestLanguage? get language; String? get transcriptionExternalStorage;
/// Create a copy of StartTranscriptionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartTranscriptionRequestCopyWith<StartTranscriptionRequest> get copyWith => _$StartTranscriptionRequestCopyWithImpl<StartTranscriptionRequest>(this as StartTranscriptionRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartTranscriptionRequest&&(identical(other.enableClosedCaptions, enableClosedCaptions) || other.enableClosedCaptions == enableClosedCaptions)&&(identical(other.language, language) || other.language == language)&&(identical(other.transcriptionExternalStorage, transcriptionExternalStorage) || other.transcriptionExternalStorage == transcriptionExternalStorage));
}


@override
int get hashCode => Object.hash(runtimeType,enableClosedCaptions,language,transcriptionExternalStorage);

@override
String toString() {
  return 'StartTranscriptionRequest(enableClosedCaptions: $enableClosedCaptions, language: $language, transcriptionExternalStorage: $transcriptionExternalStorage)';
}


}

/// @nodoc
abstract mixin class $StartTranscriptionRequestCopyWith<$Res>  {
  factory $StartTranscriptionRequestCopyWith(StartTranscriptionRequest value, $Res Function(StartTranscriptionRequest) _then) = _$StartTranscriptionRequestCopyWithImpl;
@useResult
$Res call({
 bool? enableClosedCaptions, StartTranscriptionRequestLanguage? language, String? transcriptionExternalStorage
});




}
/// @nodoc
class _$StartTranscriptionRequestCopyWithImpl<$Res>
    implements $StartTranscriptionRequestCopyWith<$Res> {
  _$StartTranscriptionRequestCopyWithImpl(this._self, this._then);

  final StartTranscriptionRequest _self;
  final $Res Function(StartTranscriptionRequest) _then;

/// Create a copy of StartTranscriptionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enableClosedCaptions = freezed,Object? language = freezed,Object? transcriptionExternalStorage = freezed,}) {
  return _then(StartTranscriptionRequest(
enableClosedCaptions: freezed == enableClosedCaptions ? _self.enableClosedCaptions : enableClosedCaptions // ignore: cast_nullable_to_non_nullable
as bool?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as StartTranscriptionRequestLanguage?,transcriptionExternalStorage: freezed == transcriptionExternalStorage ? _self.transcriptionExternalStorage : transcriptionExternalStorage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StartTranscriptionRequest].
extension StartTranscriptionRequestPatterns on StartTranscriptionRequest {
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
