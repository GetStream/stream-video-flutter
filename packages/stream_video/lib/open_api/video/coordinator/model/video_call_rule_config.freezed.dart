// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_call_rule_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideoCallRuleConfig {

 bool get flagAllLabels; List<String> get flaggedLabels; List<HarmConfig> get rules;
/// Create a copy of VideoCallRuleConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoCallRuleConfigCopyWith<VideoCallRuleConfig> get copyWith => _$VideoCallRuleConfigCopyWithImpl<VideoCallRuleConfig>(this as VideoCallRuleConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoCallRuleConfig&&(identical(other.flagAllLabels, flagAllLabels) || other.flagAllLabels == flagAllLabels)&&const DeepCollectionEquality().equals(other.flaggedLabels, flaggedLabels)&&const DeepCollectionEquality().equals(other.rules, rules));
}


@override
int get hashCode => Object.hash(runtimeType,flagAllLabels,const DeepCollectionEquality().hash(flaggedLabels),const DeepCollectionEquality().hash(rules));

@override
String toString() {
  return 'VideoCallRuleConfig(flagAllLabels: $flagAllLabels, flaggedLabels: $flaggedLabels, rules: $rules)';
}


}

/// @nodoc
abstract mixin class $VideoCallRuleConfigCopyWith<$Res>  {
  factory $VideoCallRuleConfigCopyWith(VideoCallRuleConfig value, $Res Function(VideoCallRuleConfig) _then) = _$VideoCallRuleConfigCopyWithImpl;
@useResult
$Res call({
 bool flagAllLabels, List<String> flaggedLabels, List<HarmConfig> rules
});




}
/// @nodoc
class _$VideoCallRuleConfigCopyWithImpl<$Res>
    implements $VideoCallRuleConfigCopyWith<$Res> {
  _$VideoCallRuleConfigCopyWithImpl(this._self, this._then);

  final VideoCallRuleConfig _self;
  final $Res Function(VideoCallRuleConfig) _then;

/// Create a copy of VideoCallRuleConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flagAllLabels = null,Object? flaggedLabels = null,Object? rules = null,}) {
  return _then(VideoCallRuleConfig(
flagAllLabels: null == flagAllLabels ? _self.flagAllLabels : flagAllLabels // ignore: cast_nullable_to_non_nullable
as bool,flaggedLabels: null == flaggedLabels ? _self.flaggedLabels : flaggedLabels // ignore: cast_nullable_to_non_nullable
as List<String>,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as List<HarmConfig>,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoCallRuleConfig].
extension VideoCallRuleConfigPatterns on VideoCallRuleConfig {
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
