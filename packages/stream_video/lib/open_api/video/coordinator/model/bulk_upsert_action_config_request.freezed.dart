// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_upsert_action_config_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BulkUpsertActionConfigRequest {

 List<UpsertActionConfigItem> get actionConfigs;
/// Create a copy of BulkUpsertActionConfigRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkUpsertActionConfigRequestCopyWith<BulkUpsertActionConfigRequest> get copyWith => _$BulkUpsertActionConfigRequestCopyWithImpl<BulkUpsertActionConfigRequest>(this as BulkUpsertActionConfigRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkUpsertActionConfigRequest&&const DeepCollectionEquality().equals(other.actionConfigs, actionConfigs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(actionConfigs));

@override
String toString() {
  return 'BulkUpsertActionConfigRequest(actionConfigs: $actionConfigs)';
}


}

/// @nodoc
abstract mixin class $BulkUpsertActionConfigRequestCopyWith<$Res>  {
  factory $BulkUpsertActionConfigRequestCopyWith(BulkUpsertActionConfigRequest value, $Res Function(BulkUpsertActionConfigRequest) _then) = _$BulkUpsertActionConfigRequestCopyWithImpl;
@useResult
$Res call({
 List<UpsertActionConfigItem> actionConfigs
});




}
/// @nodoc
class _$BulkUpsertActionConfigRequestCopyWithImpl<$Res>
    implements $BulkUpsertActionConfigRequestCopyWith<$Res> {
  _$BulkUpsertActionConfigRequestCopyWithImpl(this._self, this._then);

  final BulkUpsertActionConfigRequest _self;
  final $Res Function(BulkUpsertActionConfigRequest) _then;

/// Create a copy of BulkUpsertActionConfigRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actionConfigs = null,}) {
  return _then(BulkUpsertActionConfigRequest(
actionConfigs: null == actionConfigs ? _self.actionConfigs : actionConfigs // ignore: cast_nullable_to_non_nullable
as List<UpsertActionConfigItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkUpsertActionConfigRequest].
extension BulkUpsertActionConfigRequestPatterns on BulkUpsertActionConfigRequest {
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
