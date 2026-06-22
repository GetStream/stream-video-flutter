// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_feedback_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserFeedbackReport {

 Map<String, int> get countByRating; int get unreportedCount;
/// Create a copy of UserFeedbackReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserFeedbackReportCopyWith<UserFeedbackReport> get copyWith => _$UserFeedbackReportCopyWithImpl<UserFeedbackReport>(this as UserFeedbackReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserFeedbackReport&&const DeepCollectionEquality().equals(other.countByRating, countByRating)&&(identical(other.unreportedCount, unreportedCount) || other.unreportedCount == unreportedCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(countByRating),unreportedCount);

@override
String toString() {
  return 'UserFeedbackReport(countByRating: $countByRating, unreportedCount: $unreportedCount)';
}


}

/// @nodoc
abstract mixin class $UserFeedbackReportCopyWith<$Res>  {
  factory $UserFeedbackReportCopyWith(UserFeedbackReport value, $Res Function(UserFeedbackReport) _then) = _$UserFeedbackReportCopyWithImpl;
@useResult
$Res call({
 Map<String, int> countByRating, int unreportedCount
});




}
/// @nodoc
class _$UserFeedbackReportCopyWithImpl<$Res>
    implements $UserFeedbackReportCopyWith<$Res> {
  _$UserFeedbackReportCopyWithImpl(this._self, this._then);

  final UserFeedbackReport _self;
  final $Res Function(UserFeedbackReport) _then;

/// Create a copy of UserFeedbackReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countByRating = null,Object? unreportedCount = null,}) {
  return _then(UserFeedbackReport(
countByRating: null == countByRating ? _self.countByRating : countByRating // ignore: cast_nullable_to_non_nullable
as Map<String, int>,unreportedCount: null == unreportedCount ? _self.unreportedCount : unreportedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserFeedbackReport].
extension UserFeedbackReportPatterns on UserFeedbackReport {
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
