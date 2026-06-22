// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_call_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JoinCallRequest {

 bool? get create; CallRequest? get data; bool? get hintHighScaleLivestreamPublisher; String get location; int? get membersLimit; String? get migratingFrom; List<String>? get migratingFromList; bool? get notify; bool? get ring; bool? get video;
/// Create a copy of JoinCallRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinCallRequestCopyWith<JoinCallRequest> get copyWith => _$JoinCallRequestCopyWithImpl<JoinCallRequest>(this as JoinCallRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinCallRequest&&(identical(other.create, create) || other.create == create)&&(identical(other.data, data) || other.data == data)&&(identical(other.hintHighScaleLivestreamPublisher, hintHighScaleLivestreamPublisher) || other.hintHighScaleLivestreamPublisher == hintHighScaleLivestreamPublisher)&&(identical(other.location, location) || other.location == location)&&(identical(other.membersLimit, membersLimit) || other.membersLimit == membersLimit)&&(identical(other.migratingFrom, migratingFrom) || other.migratingFrom == migratingFrom)&&const DeepCollectionEquality().equals(other.migratingFromList, migratingFromList)&&(identical(other.notify, notify) || other.notify == notify)&&(identical(other.ring, ring) || other.ring == ring)&&(identical(other.video, video) || other.video == video));
}


@override
int get hashCode => Object.hash(runtimeType,create,data,hintHighScaleLivestreamPublisher,location,membersLimit,migratingFrom,const DeepCollectionEquality().hash(migratingFromList),notify,ring,video);

@override
String toString() {
  return 'JoinCallRequest(create: $create, data: $data, hintHighScaleLivestreamPublisher: $hintHighScaleLivestreamPublisher, location: $location, membersLimit: $membersLimit, migratingFrom: $migratingFrom, migratingFromList: $migratingFromList, notify: $notify, ring: $ring, video: $video)';
}


}

/// @nodoc
abstract mixin class $JoinCallRequestCopyWith<$Res>  {
  factory $JoinCallRequestCopyWith(JoinCallRequest value, $Res Function(JoinCallRequest) _then) = _$JoinCallRequestCopyWithImpl;
@useResult
$Res call({
 bool? create, CallRequest? data, bool? hintHighScaleLivestreamPublisher, String location, int? membersLimit, String? migratingFrom, List<String>? migratingFromList, bool? notify, bool? ring, bool? video
});




}
/// @nodoc
class _$JoinCallRequestCopyWithImpl<$Res>
    implements $JoinCallRequestCopyWith<$Res> {
  _$JoinCallRequestCopyWithImpl(this._self, this._then);

  final JoinCallRequest _self;
  final $Res Function(JoinCallRequest) _then;

/// Create a copy of JoinCallRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? create = freezed,Object? data = freezed,Object? hintHighScaleLivestreamPublisher = freezed,Object? location = null,Object? membersLimit = freezed,Object? migratingFrom = freezed,Object? migratingFromList = freezed,Object? notify = freezed,Object? ring = freezed,Object? video = freezed,}) {
  return _then(JoinCallRequest(
create: freezed == create ? _self.create : create // ignore: cast_nullable_to_non_nullable
as bool?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CallRequest?,hintHighScaleLivestreamPublisher: freezed == hintHighScaleLivestreamPublisher ? _self.hintHighScaleLivestreamPublisher : hintHighScaleLivestreamPublisher // ignore: cast_nullable_to_non_nullable
as bool?,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,membersLimit: freezed == membersLimit ? _self.membersLimit : membersLimit // ignore: cast_nullable_to_non_nullable
as int?,migratingFrom: freezed == migratingFrom ? _self.migratingFrom : migratingFrom // ignore: cast_nullable_to_non_nullable
as String?,migratingFromList: freezed == migratingFromList ? _self.migratingFromList : migratingFromList // ignore: cast_nullable_to_non_nullable
as List<String>?,notify: freezed == notify ? _self.notify : notify // ignore: cast_nullable_to_non_nullable
as bool?,ring: freezed == ring ? _self.ring : ring // ignore: cast_nullable_to_non_nullable
as bool?,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [JoinCallRequest].
extension JoinCallRequestPatterns on JoinCallRequest {
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
