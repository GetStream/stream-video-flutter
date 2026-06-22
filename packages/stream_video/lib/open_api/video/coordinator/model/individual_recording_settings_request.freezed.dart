// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'individual_recording_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IndividualRecordingSettingsRequest {

 IndividualRecordingSettingsRequestMode get mode; List<IndividualRecordingSettingsRequestOutputTypes>? get outputTypes;
/// Create a copy of IndividualRecordingSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IndividualRecordingSettingsRequestCopyWith<IndividualRecordingSettingsRequest> get copyWith => _$IndividualRecordingSettingsRequestCopyWithImpl<IndividualRecordingSettingsRequest>(this as IndividualRecordingSettingsRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IndividualRecordingSettingsRequest&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.outputTypes, outputTypes));
}


@override
int get hashCode => Object.hash(runtimeType,mode,const DeepCollectionEquality().hash(outputTypes));

@override
String toString() {
  return 'IndividualRecordingSettingsRequest(mode: $mode, outputTypes: $outputTypes)';
}


}

/// @nodoc
abstract mixin class $IndividualRecordingSettingsRequestCopyWith<$Res>  {
  factory $IndividualRecordingSettingsRequestCopyWith(IndividualRecordingSettingsRequest value, $Res Function(IndividualRecordingSettingsRequest) _then) = _$IndividualRecordingSettingsRequestCopyWithImpl;
@useResult
$Res call({
 IndividualRecordingSettingsRequestMode mode, List<IndividualRecordingSettingsRequestOutputTypes>? outputTypes
});




}
/// @nodoc
class _$IndividualRecordingSettingsRequestCopyWithImpl<$Res>
    implements $IndividualRecordingSettingsRequestCopyWith<$Res> {
  _$IndividualRecordingSettingsRequestCopyWithImpl(this._self, this._then);

  final IndividualRecordingSettingsRequest _self;
  final $Res Function(IndividualRecordingSettingsRequest) _then;

/// Create a copy of IndividualRecordingSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? outputTypes = freezed,}) {
  return _then(IndividualRecordingSettingsRequest(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as IndividualRecordingSettingsRequestMode,outputTypes: freezed == outputTypes ? _self.outputTypes : outputTypes // ignore: cast_nullable_to_non_nullable
as List<IndividualRecordingSettingsRequestOutputTypes>?,
  ));
}

}


/// Adds pattern-matching-related methods to [IndividualRecordingSettingsRequest].
extension IndividualRecordingSettingsRequestPatterns on IndividualRecordingSettingsRequest {
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
