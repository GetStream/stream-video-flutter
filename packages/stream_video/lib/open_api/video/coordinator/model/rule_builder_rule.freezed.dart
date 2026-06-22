// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rule_builder_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RuleBuilderRule {

 RuleBuilderAction? get action; List<CallRuleActionSequence>? get actionSequences; List<RuleBuilderCondition>? get conditions; String? get cooldownPeriod; List<RuleBuilderConditionGroup>? get groups; String? get id; String? get logic; String get ruleType;
/// Create a copy of RuleBuilderRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RuleBuilderRuleCopyWith<RuleBuilderRule> get copyWith => _$RuleBuilderRuleCopyWithImpl<RuleBuilderRule>(this as RuleBuilderRule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RuleBuilderRule&&(identical(other.action, action) || other.action == action)&&const DeepCollectionEquality().equals(other.actionSequences, actionSequences)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&(identical(other.cooldownPeriod, cooldownPeriod) || other.cooldownPeriod == cooldownPeriod)&&const DeepCollectionEquality().equals(other.groups, groups)&&(identical(other.id, id) || other.id == id)&&(identical(other.logic, logic) || other.logic == logic)&&(identical(other.ruleType, ruleType) || other.ruleType == ruleType));
}


@override
int get hashCode => Object.hash(runtimeType,action,const DeepCollectionEquality().hash(actionSequences),const DeepCollectionEquality().hash(conditions),cooldownPeriod,const DeepCollectionEquality().hash(groups),id,logic,ruleType);

@override
String toString() {
  return 'RuleBuilderRule(action: $action, actionSequences: $actionSequences, conditions: $conditions, cooldownPeriod: $cooldownPeriod, groups: $groups, id: $id, logic: $logic, ruleType: $ruleType)';
}


}

/// @nodoc
abstract mixin class $RuleBuilderRuleCopyWith<$Res>  {
  factory $RuleBuilderRuleCopyWith(RuleBuilderRule value, $Res Function(RuleBuilderRule) _then) = _$RuleBuilderRuleCopyWithImpl;
@useResult
$Res call({
 RuleBuilderAction? action, List<CallRuleActionSequence>? actionSequences, List<RuleBuilderCondition>? conditions, String? cooldownPeriod, List<RuleBuilderConditionGroup>? groups, String? id, String? logic, String ruleType
});




}
/// @nodoc
class _$RuleBuilderRuleCopyWithImpl<$Res>
    implements $RuleBuilderRuleCopyWith<$Res> {
  _$RuleBuilderRuleCopyWithImpl(this._self, this._then);

  final RuleBuilderRule _self;
  final $Res Function(RuleBuilderRule) _then;

/// Create a copy of RuleBuilderRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = freezed,Object? actionSequences = freezed,Object? conditions = freezed,Object? cooldownPeriod = freezed,Object? groups = freezed,Object? id = freezed,Object? logic = freezed,Object? ruleType = null,}) {
  return _then(RuleBuilderRule(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as RuleBuilderAction?,actionSequences: freezed == actionSequences ? _self.actionSequences : actionSequences // ignore: cast_nullable_to_non_nullable
as List<CallRuleActionSequence>?,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<RuleBuilderCondition>?,cooldownPeriod: freezed == cooldownPeriod ? _self.cooldownPeriod : cooldownPeriod // ignore: cast_nullable_to_non_nullable
as String?,groups: freezed == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<RuleBuilderConditionGroup>?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,logic: freezed == logic ? _self.logic : logic // ignore: cast_nullable_to_non_nullable
as String?,ruleType: null == ruleType ? _self.ruleType : ruleType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RuleBuilderRule].
extension RuleBuilderRulePatterns on RuleBuilderRule {
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
