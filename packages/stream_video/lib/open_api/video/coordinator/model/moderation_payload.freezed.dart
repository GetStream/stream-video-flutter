// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModerationPayload {

 Map<String, Object?>? get custom; List<String>? get images; List<String>? get texts; List<String>? get videos;
/// Create a copy of ModerationPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModerationPayloadCopyWith<ModerationPayload> get copyWith => _$ModerationPayloadCopyWithImpl<ModerationPayload>(this as ModerationPayload, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModerationPayload&&const DeepCollectionEquality().equals(other.custom, custom)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.texts, texts)&&const DeepCollectionEquality().equals(other.videos, videos));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(custom),const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(texts),const DeepCollectionEquality().hash(videos));

@override
String toString() {
  return 'ModerationPayload(custom: $custom, images: $images, texts: $texts, videos: $videos)';
}


}

/// @nodoc
abstract mixin class $ModerationPayloadCopyWith<$Res>  {
  factory $ModerationPayloadCopyWith(ModerationPayload value, $Res Function(ModerationPayload) _then) = _$ModerationPayloadCopyWithImpl;
@useResult
$Res call({
 Map<String, Object?>? custom, List<String>? images, List<String>? texts, List<String>? videos
});




}
/// @nodoc
class _$ModerationPayloadCopyWithImpl<$Res>
    implements $ModerationPayloadCopyWith<$Res> {
  _$ModerationPayloadCopyWithImpl(this._self, this._then);

  final ModerationPayload _self;
  final $Res Function(ModerationPayload) _then;

/// Create a copy of ModerationPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? custom = freezed,Object? images = freezed,Object? texts = freezed,Object? videos = freezed,}) {
  return _then(ModerationPayload(
custom: freezed == custom ? _self.custom : custom // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,texts: freezed == texts ? _self.texts : texts // ignore: cast_nullable_to_non_nullable
as List<String>?,videos: freezed == videos ? _self.videos : videos // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModerationPayload].
extension ModerationPayloadPatterns on ModerationPayload {
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
