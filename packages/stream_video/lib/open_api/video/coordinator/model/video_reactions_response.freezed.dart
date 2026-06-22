// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_reactions_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideoReactionsResponse {

 VideoReactionOverTimeResponse? get countOverTime; String get reaction;
/// Create a copy of VideoReactionsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoReactionsResponseCopyWith<VideoReactionsResponse> get copyWith => _$VideoReactionsResponseCopyWithImpl<VideoReactionsResponse>(this as VideoReactionsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoReactionsResponse&&(identical(other.countOverTime, countOverTime) || other.countOverTime == countOverTime)&&(identical(other.reaction, reaction) || other.reaction == reaction));
}


@override
int get hashCode => Object.hash(runtimeType,countOverTime,reaction);

@override
String toString() {
  return 'VideoReactionsResponse(countOverTime: $countOverTime, reaction: $reaction)';
}


}

/// @nodoc
abstract mixin class $VideoReactionsResponseCopyWith<$Res>  {
  factory $VideoReactionsResponseCopyWith(VideoReactionsResponse value, $Res Function(VideoReactionsResponse) _then) = _$VideoReactionsResponseCopyWithImpl;
@useResult
$Res call({
 VideoReactionOverTimeResponse? countOverTime, String reaction
});




}
/// @nodoc
class _$VideoReactionsResponseCopyWithImpl<$Res>
    implements $VideoReactionsResponseCopyWith<$Res> {
  _$VideoReactionsResponseCopyWithImpl(this._self, this._then);

  final VideoReactionsResponse _self;
  final $Res Function(VideoReactionsResponse) _then;

/// Create a copy of VideoReactionsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countOverTime = freezed,Object? reaction = null,}) {
  return _then(VideoReactionsResponse(
countOverTime: freezed == countOverTime ? _self.countOverTime : countOverTime // ignore: cast_nullable_to_non_nullable
as VideoReactionOverTimeResponse?,reaction: null == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoReactionsResponse].
extension VideoReactionsResponsePatterns on VideoReactionsResponse {
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
