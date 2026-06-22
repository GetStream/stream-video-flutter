// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_updated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppUpdatedEvent {

 AppEventResponse get app; DateTime get createdAt; Map<String, Object?> get custom; DateTime? get receivedAt; String get type;
/// Create a copy of AppUpdatedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUpdatedEventCopyWith<AppUpdatedEvent> get copyWith => _$AppUpdatedEventCopyWithImpl<AppUpdatedEvent>(this as AppUpdatedEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdatedEvent&&(identical(other.app, app) || other.app == app)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.custom, custom)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,app,createdAt,const DeepCollectionEquality().hash(custom),receivedAt,type);

@override
String toString() {
  return 'AppUpdatedEvent(app: $app, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type)';
}


}

/// @nodoc
abstract mixin class $AppUpdatedEventCopyWith<$Res>  {
  factory $AppUpdatedEventCopyWith(AppUpdatedEvent value, $Res Function(AppUpdatedEvent) _then) = _$AppUpdatedEventCopyWithImpl;
@useResult
$Res call({
 AppEventResponse app, DateTime createdAt, Map<String, Object?> custom, DateTime? receivedAt, String type
});




}
/// @nodoc
class _$AppUpdatedEventCopyWithImpl<$Res>
    implements $AppUpdatedEventCopyWith<$Res> {
  _$AppUpdatedEventCopyWithImpl(this._self, this._then);

  final AppUpdatedEvent _self;
  final $Res Function(AppUpdatedEvent) _then;

/// Create a copy of AppUpdatedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? app = null,Object? createdAt = null,Object? custom = null,Object? receivedAt = freezed,Object? type = null,}) {
  return _then(AppUpdatedEvent(
app: null == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as AppEventResponse,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,custom: null == custom ? _self.custom : custom // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUpdatedEvent].
extension AppUpdatedEventPatterns on AppUpdatedEvent {
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
