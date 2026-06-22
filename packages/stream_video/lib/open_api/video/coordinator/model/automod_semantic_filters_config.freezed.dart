// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'automod_semantic_filters_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AutomodSemanticFiltersConfig {

 bool? get async; bool get enabled; List<AutomodSemanticFiltersRule> get rules;
/// Create a copy of AutomodSemanticFiltersConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomodSemanticFiltersConfigCopyWith<AutomodSemanticFiltersConfig> get copyWith => _$AutomodSemanticFiltersConfigCopyWithImpl<AutomodSemanticFiltersConfig>(this as AutomodSemanticFiltersConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomodSemanticFiltersConfig&&(identical(other.async, async) || other.async == async)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.rules, rules));
}


@override
int get hashCode => Object.hash(runtimeType,async,enabled,const DeepCollectionEquality().hash(rules));

@override
String toString() {
  return 'AutomodSemanticFiltersConfig(async: $async, enabled: $enabled, rules: $rules)';
}


}

/// @nodoc
abstract mixin class $AutomodSemanticFiltersConfigCopyWith<$Res>  {
  factory $AutomodSemanticFiltersConfigCopyWith(AutomodSemanticFiltersConfig value, $Res Function(AutomodSemanticFiltersConfig) _then) = _$AutomodSemanticFiltersConfigCopyWithImpl;
@useResult
$Res call({
 bool? async, bool enabled, List<AutomodSemanticFiltersRule> rules
});




}
/// @nodoc
class _$AutomodSemanticFiltersConfigCopyWithImpl<$Res>
    implements $AutomodSemanticFiltersConfigCopyWith<$Res> {
  _$AutomodSemanticFiltersConfigCopyWithImpl(this._self, this._then);

  final AutomodSemanticFiltersConfig _self;
  final $Res Function(AutomodSemanticFiltersConfig) _then;

/// Create a copy of AutomodSemanticFiltersConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? async = freezed,Object? enabled = null,Object? rules = null,}) {
  return _then(AutomodSemanticFiltersConfig(
async: freezed == async ? _self.async : async // ignore: cast_nullable_to_non_nullable
as bool?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as List<AutomodSemanticFiltersRule>,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomodSemanticFiltersConfig].
extension AutomodSemanticFiltersConfigPatterns on AutomodSemanticFiltersConfig {
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
