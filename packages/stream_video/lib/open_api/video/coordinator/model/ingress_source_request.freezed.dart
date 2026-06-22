// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_source_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IngressSourceRequest {

 IngressSourceRequestFps get fps; int get height; int get width;
/// Create a copy of IngressSourceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngressSourceRequestCopyWith<IngressSourceRequest> get copyWith => _$IngressSourceRequestCopyWithImpl<IngressSourceRequest>(this as IngressSourceRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngressSourceRequest&&(identical(other.fps, fps) || other.fps == fps)&&(identical(other.height, height) || other.height == height)&&(identical(other.width, width) || other.width == width));
}


@override
int get hashCode => Object.hash(runtimeType,fps,height,width);

@override
String toString() {
  return 'IngressSourceRequest(fps: $fps, height: $height, width: $width)';
}


}

/// @nodoc
abstract mixin class $IngressSourceRequestCopyWith<$Res>  {
  factory $IngressSourceRequestCopyWith(IngressSourceRequest value, $Res Function(IngressSourceRequest) _then) = _$IngressSourceRequestCopyWithImpl;
@useResult
$Res call({
 IngressSourceRequestFps fps, int height, int width
});




}
/// @nodoc
class _$IngressSourceRequestCopyWithImpl<$Res>
    implements $IngressSourceRequestCopyWith<$Res> {
  _$IngressSourceRequestCopyWithImpl(this._self, this._then);

  final IngressSourceRequest _self;
  final $Res Function(IngressSourceRequest) _then;

/// Create a copy of IngressSourceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fps = null,Object? height = null,Object? width = null,}) {
  return _then(IngressSourceRequest(
fps: null == fps ? _self.fps : fps // ignore: cast_nullable_to_non_nullable
as IngressSourceRequestFps,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [IngressSourceRequest].
extension IngressSourceRequestPatterns on IngressSourceRequest {
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
