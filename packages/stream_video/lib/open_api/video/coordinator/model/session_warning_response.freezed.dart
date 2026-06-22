// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_warning_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionWarningResponse {

 String get code; DateTime? get time; String get warning;
/// Create a copy of SessionWarningResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionWarningResponseCopyWith<SessionWarningResponse> get copyWith => _$SessionWarningResponseCopyWithImpl<SessionWarningResponse>(this as SessionWarningResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionWarningResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.time, time) || other.time == time)&&(identical(other.warning, warning) || other.warning == warning));
}


@override
int get hashCode => Object.hash(runtimeType,code,time,warning);

@override
String toString() {
  return 'SessionWarningResponse(code: $code, time: $time, warning: $warning)';
}


}

/// @nodoc
abstract mixin class $SessionWarningResponseCopyWith<$Res>  {
  factory $SessionWarningResponseCopyWith(SessionWarningResponse value, $Res Function(SessionWarningResponse) _then) = _$SessionWarningResponseCopyWithImpl;
@useResult
$Res call({
 String code, DateTime? time, String warning
});




}
/// @nodoc
class _$SessionWarningResponseCopyWithImpl<$Res>
    implements $SessionWarningResponseCopyWith<$Res> {
  _$SessionWarningResponseCopyWithImpl(this._self, this._then);

  final SessionWarningResponse _self;
  final $Res Function(SessionWarningResponse) _then;

/// Create a copy of SessionWarningResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? time = freezed,Object? warning = null,}) {
  return _then(SessionWarningResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime?,warning: null == warning ? _self.warning : warning // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionWarningResponse].
extension SessionWarningResponsePatterns on SessionWarningResponse {
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
