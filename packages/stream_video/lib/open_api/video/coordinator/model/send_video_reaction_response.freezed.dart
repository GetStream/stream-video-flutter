// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_video_reaction_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SendVideoReactionResponse {

 String get duration; VideoReactionResponse get reaction;
/// Create a copy of SendVideoReactionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendVideoReactionResponseCopyWith<SendVideoReactionResponse> get copyWith => _$SendVideoReactionResponseCopyWithImpl<SendVideoReactionResponse>(this as SendVideoReactionResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendVideoReactionResponse&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.reaction, reaction) || other.reaction == reaction));
}


@override
int get hashCode => Object.hash(runtimeType,duration,reaction);

@override
String toString() {
  return 'SendVideoReactionResponse(duration: $duration, reaction: $reaction)';
}


}

/// @nodoc
abstract mixin class $SendVideoReactionResponseCopyWith<$Res>  {
  factory $SendVideoReactionResponseCopyWith(SendVideoReactionResponse value, $Res Function(SendVideoReactionResponse) _then) = _$SendVideoReactionResponseCopyWithImpl;
@useResult
$Res call({
 String duration, VideoReactionResponse reaction
});




}
/// @nodoc
class _$SendVideoReactionResponseCopyWithImpl<$Res>
    implements $SendVideoReactionResponseCopyWith<$Res> {
  _$SendVideoReactionResponseCopyWithImpl(this._self, this._then);

  final SendVideoReactionResponse _self;
  final $Res Function(SendVideoReactionResponse) _then;

/// Create a copy of SendVideoReactionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? duration = null,Object? reaction = null,}) {
  return _then(SendVideoReactionResponse(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,reaction: null == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as VideoReactionResponse,
  ));
}

}


/// Adds pattern-matching-related methods to [SendVideoReactionResponse].
extension SendVideoReactionResponsePatterns on SendVideoReactionResponse {
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
