// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_sequence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActionSequence {

 String get action; bool get blur; int get cooldownPeriod; int get threshold; int get timeWindow; bool get warning; String get warningText;
/// Create a copy of ActionSequence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionSequenceCopyWith<ActionSequence> get copyWith => _$ActionSequenceCopyWithImpl<ActionSequence>(this as ActionSequence, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionSequence&&(identical(other.action, action) || other.action == action)&&(identical(other.blur, blur) || other.blur == blur)&&(identical(other.cooldownPeriod, cooldownPeriod) || other.cooldownPeriod == cooldownPeriod)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow)&&(identical(other.warning, warning) || other.warning == warning)&&(identical(other.warningText, warningText) || other.warningText == warningText));
}


@override
int get hashCode => Object.hash(runtimeType,action,blur,cooldownPeriod,threshold,timeWindow,warning,warningText);

@override
String toString() {
  return 'ActionSequence(action: $action, blur: $blur, cooldownPeriod: $cooldownPeriod, threshold: $threshold, timeWindow: $timeWindow, warning: $warning, warningText: $warningText)';
}


}

/// @nodoc
abstract mixin class $ActionSequenceCopyWith<$Res>  {
  factory $ActionSequenceCopyWith(ActionSequence value, $Res Function(ActionSequence) _then) = _$ActionSequenceCopyWithImpl;
@useResult
$Res call({
 String action, bool blur, int cooldownPeriod, int threshold, int timeWindow, bool warning, String warningText
});




}
/// @nodoc
class _$ActionSequenceCopyWithImpl<$Res>
    implements $ActionSequenceCopyWith<$Res> {
  _$ActionSequenceCopyWithImpl(this._self, this._then);

  final ActionSequence _self;
  final $Res Function(ActionSequence) _then;

/// Create a copy of ActionSequence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? blur = null,Object? cooldownPeriod = null,Object? threshold = null,Object? timeWindow = null,Object? warning = null,Object? warningText = null,}) {
  return _then(ActionSequence(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,blur: null == blur ? _self.blur : blur // ignore: cast_nullable_to_non_nullable
as bool,cooldownPeriod: null == cooldownPeriod ? _self.cooldownPeriod : cooldownPeriod // ignore: cast_nullable_to_non_nullable
as int,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,timeWindow: null == timeWindow ? _self.timeWindow : timeWindow // ignore: cast_nullable_to_non_nullable
as int,warning: null == warning ? _self.warning : warning // ignore: cast_nullable_to_non_nullable
as bool,warningText: null == warningText ? _self.warningText : warningText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionSequence].
extension ActionSequencePatterns on ActionSequence {
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
