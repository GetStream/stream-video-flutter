// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_closed_caption.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallClosedCaption {

 DateTime get endTime; String get id; String get language; String? get service; String get speakerId; DateTime get startTime; String get text; bool get translated; UserResponse get user;
/// Create a copy of CallClosedCaption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallClosedCaptionCopyWith<CallClosedCaption> get copyWith => _$CallClosedCaptionCopyWithImpl<CallClosedCaption>(this as CallClosedCaption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallClosedCaption&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.id, id) || other.id == id)&&(identical(other.language, language) || other.language == language)&&(identical(other.service, service) || other.service == service)&&(identical(other.speakerId, speakerId) || other.speakerId == speakerId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.text, text) || other.text == text)&&(identical(other.translated, translated) || other.translated == translated)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,endTime,id,language,service,speakerId,startTime,text,translated,user);

@override
String toString() {
  return 'CallClosedCaption(endTime: $endTime, id: $id, language: $language, service: $service, speakerId: $speakerId, startTime: $startTime, text: $text, translated: $translated, user: $user)';
}


}

/// @nodoc
abstract mixin class $CallClosedCaptionCopyWith<$Res>  {
  factory $CallClosedCaptionCopyWith(CallClosedCaption value, $Res Function(CallClosedCaption) _then) = _$CallClosedCaptionCopyWithImpl;
@useResult
$Res call({
 DateTime endTime, String id, String language, String? service, String speakerId, DateTime startTime, String text, bool translated, UserResponse user
});




}
/// @nodoc
class _$CallClosedCaptionCopyWithImpl<$Res>
    implements $CallClosedCaptionCopyWith<$Res> {
  _$CallClosedCaptionCopyWithImpl(this._self, this._then);

  final CallClosedCaption _self;
  final $Res Function(CallClosedCaption) _then;

/// Create a copy of CallClosedCaption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? endTime = null,Object? id = null,Object? language = null,Object? service = freezed,Object? speakerId = null,Object? startTime = null,Object? text = null,Object? translated = null,Object? user = null,}) {
  return _then(CallClosedCaption(
endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String?,speakerId: null == speakerId ? _self.speakerId : speakerId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,translated: null == translated ? _self.translated : translated // ignore: cast_nullable_to_non_nullable
as bool,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserResponse,
  ));
}

}


/// Adds pattern-matching-related methods to [CallClosedCaption].
extension CallClosedCaptionPatterns on CallClosedCaption {
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
