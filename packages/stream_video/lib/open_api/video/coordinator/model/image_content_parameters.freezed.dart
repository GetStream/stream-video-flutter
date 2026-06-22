// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_content_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImageContentParameters {

 List<String>? get harmLabels; String? get labelOperator; double? get minConfidence;
/// Create a copy of ImageContentParameters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageContentParametersCopyWith<ImageContentParameters> get copyWith => _$ImageContentParametersCopyWithImpl<ImageContentParameters>(this as ImageContentParameters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageContentParameters&&const DeepCollectionEquality().equals(other.harmLabels, harmLabels)&&(identical(other.labelOperator, labelOperator) || other.labelOperator == labelOperator)&&(identical(other.minConfidence, minConfidence) || other.minConfidence == minConfidence));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(harmLabels),labelOperator,minConfidence);

@override
String toString() {
  return 'ImageContentParameters(harmLabels: $harmLabels, labelOperator: $labelOperator, minConfidence: $minConfidence)';
}


}

/// @nodoc
abstract mixin class $ImageContentParametersCopyWith<$Res>  {
  factory $ImageContentParametersCopyWith(ImageContentParameters value, $Res Function(ImageContentParameters) _then) = _$ImageContentParametersCopyWithImpl;
@useResult
$Res call({
 List<String>? harmLabels, String? labelOperator, double? minConfidence
});




}
/// @nodoc
class _$ImageContentParametersCopyWithImpl<$Res>
    implements $ImageContentParametersCopyWith<$Res> {
  _$ImageContentParametersCopyWithImpl(this._self, this._then);

  final ImageContentParameters _self;
  final $Res Function(ImageContentParameters) _then;

/// Create a copy of ImageContentParameters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? harmLabels = freezed,Object? labelOperator = freezed,Object? minConfidence = freezed,}) {
  return _then(ImageContentParameters(
harmLabels: freezed == harmLabels ? _self.harmLabels : harmLabels // ignore: cast_nullable_to_non_nullable
as List<String>?,labelOperator: freezed == labelOperator ? _self.labelOperator : labelOperator // ignore: cast_nullable_to_non_nullable
as String?,minConfidence: freezed == minConfidence ? _self.minConfidence : minConfidence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageContentParameters].
extension ImageContentParametersPatterns on ImageContentParameters {
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
