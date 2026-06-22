// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'layout_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LayoutSettingsRequest {

 bool? get detectOrientation; String? get externalAppUrl; String? get externalCssUrl; LayoutSettingsRequestName get name; Map<String, Object?>? get options;
/// Create a copy of LayoutSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayoutSettingsRequestCopyWith<LayoutSettingsRequest> get copyWith => _$LayoutSettingsRequestCopyWithImpl<LayoutSettingsRequest>(this as LayoutSettingsRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayoutSettingsRequest&&(identical(other.detectOrientation, detectOrientation) || other.detectOrientation == detectOrientation)&&(identical(other.externalAppUrl, externalAppUrl) || other.externalAppUrl == externalAppUrl)&&(identical(other.externalCssUrl, externalCssUrl) || other.externalCssUrl == externalCssUrl)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.options, options));
}


@override
int get hashCode => Object.hash(runtimeType,detectOrientation,externalAppUrl,externalCssUrl,name,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'LayoutSettingsRequest(detectOrientation: $detectOrientation, externalAppUrl: $externalAppUrl, externalCssUrl: $externalCssUrl, name: $name, options: $options)';
}


}

/// @nodoc
abstract mixin class $LayoutSettingsRequestCopyWith<$Res>  {
  factory $LayoutSettingsRequestCopyWith(LayoutSettingsRequest value, $Res Function(LayoutSettingsRequest) _then) = _$LayoutSettingsRequestCopyWithImpl;
@useResult
$Res call({
 bool? detectOrientation, String? externalAppUrl, String? externalCssUrl, LayoutSettingsRequestName name, Map<String, Object?>? options
});




}
/// @nodoc
class _$LayoutSettingsRequestCopyWithImpl<$Res>
    implements $LayoutSettingsRequestCopyWith<$Res> {
  _$LayoutSettingsRequestCopyWithImpl(this._self, this._then);

  final LayoutSettingsRequest _self;
  final $Res Function(LayoutSettingsRequest) _then;

/// Create a copy of LayoutSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? detectOrientation = freezed,Object? externalAppUrl = freezed,Object? externalCssUrl = freezed,Object? name = null,Object? options = freezed,}) {
  return _then(LayoutSettingsRequest(
detectOrientation: freezed == detectOrientation ? _self.detectOrientation : detectOrientation // ignore: cast_nullable_to_non_nullable
as bool?,externalAppUrl: freezed == externalAppUrl ? _self.externalAppUrl : externalAppUrl // ignore: cast_nullable_to_non_nullable
as String?,externalCssUrl: freezed == externalCssUrl ? _self.externalCssUrl : externalCssUrl // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LayoutSettingsRequestName,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}

}


/// Adds pattern-matching-related methods to [LayoutSettingsRequest].
extension LayoutSettingsRequestPatterns on LayoutSettingsRequest {
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
