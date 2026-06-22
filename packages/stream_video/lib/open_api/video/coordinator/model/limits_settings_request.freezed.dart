// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'limits_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LimitsSettingsRequest {

 int? get maxDurationSeconds; int? get maxParticipants; bool? get maxParticipantsExcludeOwner; List<String>? get maxParticipantsExcludeRoles;
/// Create a copy of LimitsSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LimitsSettingsRequestCopyWith<LimitsSettingsRequest> get copyWith => _$LimitsSettingsRequestCopyWithImpl<LimitsSettingsRequest>(this as LimitsSettingsRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitsSettingsRequest&&(identical(other.maxDurationSeconds, maxDurationSeconds) || other.maxDurationSeconds == maxDurationSeconds)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.maxParticipantsExcludeOwner, maxParticipantsExcludeOwner) || other.maxParticipantsExcludeOwner == maxParticipantsExcludeOwner)&&const DeepCollectionEquality().equals(other.maxParticipantsExcludeRoles, maxParticipantsExcludeRoles));
}


@override
int get hashCode => Object.hash(runtimeType,maxDurationSeconds,maxParticipants,maxParticipantsExcludeOwner,const DeepCollectionEquality().hash(maxParticipantsExcludeRoles));

@override
String toString() {
  return 'LimitsSettingsRequest(maxDurationSeconds: $maxDurationSeconds, maxParticipants: $maxParticipants, maxParticipantsExcludeOwner: $maxParticipantsExcludeOwner, maxParticipantsExcludeRoles: $maxParticipantsExcludeRoles)';
}


}

/// @nodoc
abstract mixin class $LimitsSettingsRequestCopyWith<$Res>  {
  factory $LimitsSettingsRequestCopyWith(LimitsSettingsRequest value, $Res Function(LimitsSettingsRequest) _then) = _$LimitsSettingsRequestCopyWithImpl;
@useResult
$Res call({
 int? maxDurationSeconds, int? maxParticipants, bool? maxParticipantsExcludeOwner, List<String>? maxParticipantsExcludeRoles
});




}
/// @nodoc
class _$LimitsSettingsRequestCopyWithImpl<$Res>
    implements $LimitsSettingsRequestCopyWith<$Res> {
  _$LimitsSettingsRequestCopyWithImpl(this._self, this._then);

  final LimitsSettingsRequest _self;
  final $Res Function(LimitsSettingsRequest) _then;

/// Create a copy of LimitsSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maxDurationSeconds = freezed,Object? maxParticipants = freezed,Object? maxParticipantsExcludeOwner = freezed,Object? maxParticipantsExcludeRoles = freezed,}) {
  return _then(LimitsSettingsRequest(
maxDurationSeconds: freezed == maxDurationSeconds ? _self.maxDurationSeconds : maxDurationSeconds // ignore: cast_nullable_to_non_nullable
as int?,maxParticipants: freezed == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int?,maxParticipantsExcludeOwner: freezed == maxParticipantsExcludeOwner ? _self.maxParticipantsExcludeOwner : maxParticipantsExcludeOwner // ignore: cast_nullable_to_non_nullable
as bool?,maxParticipantsExcludeRoles: freezed == maxParticipantsExcludeRoles ? _self.maxParticipantsExcludeRoles : maxParticipantsExcludeRoles // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [LimitsSettingsRequest].
extension LimitsSettingsRequestPatterns on LimitsSettingsRequest {
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
