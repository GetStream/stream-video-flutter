// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_block_list_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateBlockListRequest {

 bool? get isLeetCheckEnabled; bool? get isPluralCheckEnabled; String get name; String? get team; CreateBlockListRequestType? get type; List<String> get words;
/// Create a copy of CreateBlockListRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateBlockListRequestCopyWith<CreateBlockListRequest> get copyWith => _$CreateBlockListRequestCopyWithImpl<CreateBlockListRequest>(this as CreateBlockListRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateBlockListRequest&&(identical(other.isLeetCheckEnabled, isLeetCheckEnabled) || other.isLeetCheckEnabled == isLeetCheckEnabled)&&(identical(other.isPluralCheckEnabled, isPluralCheckEnabled) || other.isPluralCheckEnabled == isPluralCheckEnabled)&&(identical(other.name, name) || other.name == name)&&(identical(other.team, team) || other.team == team)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.words, words));
}


@override
int get hashCode => Object.hash(runtimeType,isLeetCheckEnabled,isPluralCheckEnabled,name,team,type,const DeepCollectionEquality().hash(words));

@override
String toString() {
  return 'CreateBlockListRequest(isLeetCheckEnabled: $isLeetCheckEnabled, isPluralCheckEnabled: $isPluralCheckEnabled, name: $name, team: $team, type: $type, words: $words)';
}


}

/// @nodoc
abstract mixin class $CreateBlockListRequestCopyWith<$Res>  {
  factory $CreateBlockListRequestCopyWith(CreateBlockListRequest value, $Res Function(CreateBlockListRequest) _then) = _$CreateBlockListRequestCopyWithImpl;
@useResult
$Res call({
 bool? isLeetCheckEnabled, bool? isPluralCheckEnabled, String name, String? team, CreateBlockListRequestType? type, List<String> words
});




}
/// @nodoc
class _$CreateBlockListRequestCopyWithImpl<$Res>
    implements $CreateBlockListRequestCopyWith<$Res> {
  _$CreateBlockListRequestCopyWithImpl(this._self, this._then);

  final CreateBlockListRequest _self;
  final $Res Function(CreateBlockListRequest) _then;

/// Create a copy of CreateBlockListRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLeetCheckEnabled = freezed,Object? isPluralCheckEnabled = freezed,Object? name = null,Object? team = freezed,Object? type = freezed,Object? words = null,}) {
  return _then(CreateBlockListRequest(
isLeetCheckEnabled: freezed == isLeetCheckEnabled ? _self.isLeetCheckEnabled : isLeetCheckEnabled // ignore: cast_nullable_to_non_nullable
as bool?,isPluralCheckEnabled: freezed == isPluralCheckEnabled ? _self.isPluralCheckEnabled : isPluralCheckEnabled // ignore: cast_nullable_to_non_nullable
as bool?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,team: freezed == team ? _self.team : team // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CreateBlockListRequestType?,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateBlockListRequest].
extension CreateBlockListRequestPatterns on CreateBlockListRequest {
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
