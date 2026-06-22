// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bodyguard_severity_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BodyguardSeverityRule {

 BodyguardSeverityRuleAction get action; BodyguardSeverityRuleSeverity get severity;
/// Create a copy of BodyguardSeverityRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BodyguardSeverityRuleCopyWith<BodyguardSeverityRule> get copyWith => _$BodyguardSeverityRuleCopyWithImpl<BodyguardSeverityRule>(this as BodyguardSeverityRule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BodyguardSeverityRule&&(identical(other.action, action) || other.action == action)&&(identical(other.severity, severity) || other.severity == severity));
}


@override
int get hashCode => Object.hash(runtimeType,action,severity);

@override
String toString() {
  return 'BodyguardSeverityRule(action: $action, severity: $severity)';
}


}

/// @nodoc
abstract mixin class $BodyguardSeverityRuleCopyWith<$Res>  {
  factory $BodyguardSeverityRuleCopyWith(BodyguardSeverityRule value, $Res Function(BodyguardSeverityRule) _then) = _$BodyguardSeverityRuleCopyWithImpl;
@useResult
$Res call({
 BodyguardSeverityRuleAction action, BodyguardSeverityRuleSeverity severity
});




}
/// @nodoc
class _$BodyguardSeverityRuleCopyWithImpl<$Res>
    implements $BodyguardSeverityRuleCopyWith<$Res> {
  _$BodyguardSeverityRuleCopyWithImpl(this._self, this._then);

  final BodyguardSeverityRule _self;
  final $Res Function(BodyguardSeverityRule) _then;

/// Create a copy of BodyguardSeverityRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? severity = null,}) {
  return _then(BodyguardSeverityRule(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BodyguardSeverityRuleAction,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as BodyguardSeverityRuleSeverity,
  ));
}

}


/// Adds pattern-matching-related methods to [BodyguardSeverityRule].
extension BodyguardSeverityRulePatterns on BodyguardSeverityRule {
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
