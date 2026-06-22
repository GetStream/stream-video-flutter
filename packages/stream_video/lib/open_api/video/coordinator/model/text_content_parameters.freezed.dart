// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_content_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TextContentParameters {

 List<String>? get blocklistMatch; bool? get containsUrl; List<String>? get harmLabels; String? get labelOperator; Map<String, String>? get llmHarmLabels; String? get severity;
/// Create a copy of TextContentParameters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextContentParametersCopyWith<TextContentParameters> get copyWith => _$TextContentParametersCopyWithImpl<TextContentParameters>(this as TextContentParameters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextContentParameters&&const DeepCollectionEquality().equals(other.blocklistMatch, blocklistMatch)&&(identical(other.containsUrl, containsUrl) || other.containsUrl == containsUrl)&&const DeepCollectionEquality().equals(other.harmLabels, harmLabels)&&(identical(other.labelOperator, labelOperator) || other.labelOperator == labelOperator)&&const DeepCollectionEquality().equals(other.llmHarmLabels, llmHarmLabels)&&(identical(other.severity, severity) || other.severity == severity));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(blocklistMatch),containsUrl,const DeepCollectionEquality().hash(harmLabels),labelOperator,const DeepCollectionEquality().hash(llmHarmLabels),severity);

@override
String toString() {
  return 'TextContentParameters(blocklistMatch: $blocklistMatch, containsUrl: $containsUrl, harmLabels: $harmLabels, labelOperator: $labelOperator, llmHarmLabels: $llmHarmLabels, severity: $severity)';
}


}

/// @nodoc
abstract mixin class $TextContentParametersCopyWith<$Res>  {
  factory $TextContentParametersCopyWith(TextContentParameters value, $Res Function(TextContentParameters) _then) = _$TextContentParametersCopyWithImpl;
@useResult
$Res call({
 List<String>? blocklistMatch, bool? containsUrl, List<String>? harmLabels, String? labelOperator, Map<String, String>? llmHarmLabels, String? severity
});




}
/// @nodoc
class _$TextContentParametersCopyWithImpl<$Res>
    implements $TextContentParametersCopyWith<$Res> {
  _$TextContentParametersCopyWithImpl(this._self, this._then);

  final TextContentParameters _self;
  final $Res Function(TextContentParameters) _then;

/// Create a copy of TextContentParameters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? blocklistMatch = freezed,Object? containsUrl = freezed,Object? harmLabels = freezed,Object? labelOperator = freezed,Object? llmHarmLabels = freezed,Object? severity = freezed,}) {
  return _then(TextContentParameters(
blocklistMatch: freezed == blocklistMatch ? _self.blocklistMatch : blocklistMatch // ignore: cast_nullable_to_non_nullable
as List<String>?,containsUrl: freezed == containsUrl ? _self.containsUrl : containsUrl // ignore: cast_nullable_to_non_nullable
as bool?,harmLabels: freezed == harmLabels ? _self.harmLabels : harmLabels // ignore: cast_nullable_to_non_nullable
as List<String>?,labelOperator: freezed == labelOperator ? _self.labelOperator : labelOperator // ignore: cast_nullable_to_non_nullable
as String?,llmHarmLabels: freezed == llmHarmLabels ? _self.llmHarmLabels : llmHarmLabels // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TextContentParameters].
extension TextContentParametersPatterns on TextContentParameters {
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
