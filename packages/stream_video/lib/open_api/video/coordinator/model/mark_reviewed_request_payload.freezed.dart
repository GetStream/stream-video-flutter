// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mark_reviewed_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarkReviewedRequestPayload {

 int? get contentToMarkAsReviewedLimit; String? get decisionReason; bool? get disableMarkingContentAsReviewed;
/// Create a copy of MarkReviewedRequestPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarkReviewedRequestPayloadCopyWith<MarkReviewedRequestPayload> get copyWith => _$MarkReviewedRequestPayloadCopyWithImpl<MarkReviewedRequestPayload>(this as MarkReviewedRequestPayload, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarkReviewedRequestPayload&&(identical(other.contentToMarkAsReviewedLimit, contentToMarkAsReviewedLimit) || other.contentToMarkAsReviewedLimit == contentToMarkAsReviewedLimit)&&(identical(other.decisionReason, decisionReason) || other.decisionReason == decisionReason)&&(identical(other.disableMarkingContentAsReviewed, disableMarkingContentAsReviewed) || other.disableMarkingContentAsReviewed == disableMarkingContentAsReviewed));
}


@override
int get hashCode => Object.hash(runtimeType,contentToMarkAsReviewedLimit,decisionReason,disableMarkingContentAsReviewed);

@override
String toString() {
  return 'MarkReviewedRequestPayload(contentToMarkAsReviewedLimit: $contentToMarkAsReviewedLimit, decisionReason: $decisionReason, disableMarkingContentAsReviewed: $disableMarkingContentAsReviewed)';
}


}

/// @nodoc
abstract mixin class $MarkReviewedRequestPayloadCopyWith<$Res>  {
  factory $MarkReviewedRequestPayloadCopyWith(MarkReviewedRequestPayload value, $Res Function(MarkReviewedRequestPayload) _then) = _$MarkReviewedRequestPayloadCopyWithImpl;
@useResult
$Res call({
 int? contentToMarkAsReviewedLimit, String? decisionReason, bool? disableMarkingContentAsReviewed
});




}
/// @nodoc
class _$MarkReviewedRequestPayloadCopyWithImpl<$Res>
    implements $MarkReviewedRequestPayloadCopyWith<$Res> {
  _$MarkReviewedRequestPayloadCopyWithImpl(this._self, this._then);

  final MarkReviewedRequestPayload _self;
  final $Res Function(MarkReviewedRequestPayload) _then;

/// Create a copy of MarkReviewedRequestPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentToMarkAsReviewedLimit = freezed,Object? decisionReason = freezed,Object? disableMarkingContentAsReviewed = freezed,}) {
  return _then(MarkReviewedRequestPayload(
contentToMarkAsReviewedLimit: freezed == contentToMarkAsReviewedLimit ? _self.contentToMarkAsReviewedLimit : contentToMarkAsReviewedLimit // ignore: cast_nullable_to_non_nullable
as int?,decisionReason: freezed == decisionReason ? _self.decisionReason : decisionReason // ignore: cast_nullable_to_non_nullable
as String?,disableMarkingContentAsReviewed: freezed == disableMarkingContentAsReviewed ? _self.disableMarkingContentAsReviewed : disableMarkingContentAsReviewed // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MarkReviewedRequestPayload].
extension MarkReviewedRequestPayloadPatterns on MarkReviewedRequestPayload {
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
