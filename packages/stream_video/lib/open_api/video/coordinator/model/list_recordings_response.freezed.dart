// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_recordings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListRecordingsResponse {

 String get duration; List<CallRecording> get recordings;
/// Create a copy of ListRecordingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListRecordingsResponseCopyWith<ListRecordingsResponse> get copyWith => _$ListRecordingsResponseCopyWithImpl<ListRecordingsResponse>(this as ListRecordingsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListRecordingsResponse&&(identical(other.duration, duration) || other.duration == duration)&&const DeepCollectionEquality().equals(other.recordings, recordings));
}


@override
int get hashCode => Object.hash(runtimeType,duration,const DeepCollectionEquality().hash(recordings));

@override
String toString() {
  return 'ListRecordingsResponse(duration: $duration, recordings: $recordings)';
}


}

/// @nodoc
abstract mixin class $ListRecordingsResponseCopyWith<$Res>  {
  factory $ListRecordingsResponseCopyWith(ListRecordingsResponse value, $Res Function(ListRecordingsResponse) _then) = _$ListRecordingsResponseCopyWithImpl;
@useResult
$Res call({
 String duration, List<CallRecording> recordings
});




}
/// @nodoc
class _$ListRecordingsResponseCopyWithImpl<$Res>
    implements $ListRecordingsResponseCopyWith<$Res> {
  _$ListRecordingsResponseCopyWithImpl(this._self, this._then);

  final ListRecordingsResponse _self;
  final $Res Function(ListRecordingsResponse) _then;

/// Create a copy of ListRecordingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? duration = null,Object? recordings = null,}) {
  return _then(ListRecordingsResponse(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,recordings: null == recordings ? _self.recordings : recordings // ignore: cast_nullable_to_non_nullable
as List<CallRecording>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListRecordingsResponse].
extension ListRecordingsResponsePatterns on ListRecordingsResponse {
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
