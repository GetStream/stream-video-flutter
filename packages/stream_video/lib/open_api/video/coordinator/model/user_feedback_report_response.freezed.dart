// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_feedback_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserFeedbackReportResponse {

 List<DailyAggregateUserFeedbackReportResponse> get daily;
/// Create a copy of UserFeedbackReportResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserFeedbackReportResponseCopyWith<UserFeedbackReportResponse> get copyWith => _$UserFeedbackReportResponseCopyWithImpl<UserFeedbackReportResponse>(this as UserFeedbackReportResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserFeedbackReportResponse&&const DeepCollectionEquality().equals(other.daily, daily));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(daily));

@override
String toString() {
  return 'UserFeedbackReportResponse(daily: $daily)';
}


}

/// @nodoc
abstract mixin class $UserFeedbackReportResponseCopyWith<$Res>  {
  factory $UserFeedbackReportResponseCopyWith(UserFeedbackReportResponse value, $Res Function(UserFeedbackReportResponse) _then) = _$UserFeedbackReportResponseCopyWithImpl;
@useResult
$Res call({
 List<DailyAggregateUserFeedbackReportResponse> daily
});




}
/// @nodoc
class _$UserFeedbackReportResponseCopyWithImpl<$Res>
    implements $UserFeedbackReportResponseCopyWith<$Res> {
  _$UserFeedbackReportResponseCopyWithImpl(this._self, this._then);

  final UserFeedbackReportResponse _self;
  final $Res Function(UserFeedbackReportResponse) _then;

/// Create a copy of UserFeedbackReportResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? daily = null,}) {
  return _then(UserFeedbackReportResponse(
daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as List<DailyAggregateUserFeedbackReportResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserFeedbackReportResponse].
extension UserFeedbackReportResponsePatterns on UserFeedbackReportResponse {
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
