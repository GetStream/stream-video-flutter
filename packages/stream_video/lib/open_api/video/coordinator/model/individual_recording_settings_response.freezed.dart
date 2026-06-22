// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'individual_recording_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IndividualRecordingSettingsResponse {

 IndividualRecordingSettingsResponseMode get mode; List<String>? get outputTypes;
/// Create a copy of IndividualRecordingSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IndividualRecordingSettingsResponseCopyWith<IndividualRecordingSettingsResponse> get copyWith => _$IndividualRecordingSettingsResponseCopyWithImpl<IndividualRecordingSettingsResponse>(this as IndividualRecordingSettingsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IndividualRecordingSettingsResponse&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.outputTypes, outputTypes));
}


@override
int get hashCode => Object.hash(runtimeType,mode,const DeepCollectionEquality().hash(outputTypes));

@override
String toString() {
  return 'IndividualRecordingSettingsResponse(mode: $mode, outputTypes: $outputTypes)';
}


}

/// @nodoc
abstract mixin class $IndividualRecordingSettingsResponseCopyWith<$Res>  {
  factory $IndividualRecordingSettingsResponseCopyWith(IndividualRecordingSettingsResponse value, $Res Function(IndividualRecordingSettingsResponse) _then) = _$IndividualRecordingSettingsResponseCopyWithImpl;
@useResult
$Res call({
 IndividualRecordingSettingsResponseMode mode, List<String>? outputTypes
});




}
/// @nodoc
class _$IndividualRecordingSettingsResponseCopyWithImpl<$Res>
    implements $IndividualRecordingSettingsResponseCopyWith<$Res> {
  _$IndividualRecordingSettingsResponseCopyWithImpl(this._self, this._then);

  final IndividualRecordingSettingsResponse _self;
  final $Res Function(IndividualRecordingSettingsResponse) _then;

/// Create a copy of IndividualRecordingSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? outputTypes = freezed,}) {
  return _then(IndividualRecordingSettingsResponse(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as IndividualRecordingSettingsResponseMode,outputTypes: freezed == outputTypes ? _self.outputTypes : outputTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [IndividualRecordingSettingsResponse].
extension IndividualRecordingSettingsResponsePatterns on IndividualRecordingSettingsResponse {
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
