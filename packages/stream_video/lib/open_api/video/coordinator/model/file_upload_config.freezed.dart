// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_upload_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FileUploadConfig {

 List<String> get allowedFileExtensions; List<String> get allowedMimeTypes; List<String> get blockedFileExtensions; List<String> get blockedMimeTypes; int get sizeLimit;
/// Create a copy of FileUploadConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileUploadConfigCopyWith<FileUploadConfig> get copyWith => _$FileUploadConfigCopyWithImpl<FileUploadConfig>(this as FileUploadConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileUploadConfig&&const DeepCollectionEquality().equals(other.allowedFileExtensions, allowedFileExtensions)&&const DeepCollectionEquality().equals(other.allowedMimeTypes, allowedMimeTypes)&&const DeepCollectionEquality().equals(other.blockedFileExtensions, blockedFileExtensions)&&const DeepCollectionEquality().equals(other.blockedMimeTypes, blockedMimeTypes)&&(identical(other.sizeLimit, sizeLimit) || other.sizeLimit == sizeLimit));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(allowedFileExtensions),const DeepCollectionEquality().hash(allowedMimeTypes),const DeepCollectionEquality().hash(blockedFileExtensions),const DeepCollectionEquality().hash(blockedMimeTypes),sizeLimit);

@override
String toString() {
  return 'FileUploadConfig(allowedFileExtensions: $allowedFileExtensions, allowedMimeTypes: $allowedMimeTypes, blockedFileExtensions: $blockedFileExtensions, blockedMimeTypes: $blockedMimeTypes, sizeLimit: $sizeLimit)';
}


}

/// @nodoc
abstract mixin class $FileUploadConfigCopyWith<$Res>  {
  factory $FileUploadConfigCopyWith(FileUploadConfig value, $Res Function(FileUploadConfig) _then) = _$FileUploadConfigCopyWithImpl;
@useResult
$Res call({
 List<String> allowedFileExtensions, List<String> allowedMimeTypes, List<String> blockedFileExtensions, List<String> blockedMimeTypes, int sizeLimit
});




}
/// @nodoc
class _$FileUploadConfigCopyWithImpl<$Res>
    implements $FileUploadConfigCopyWith<$Res> {
  _$FileUploadConfigCopyWithImpl(this._self, this._then);

  final FileUploadConfig _self;
  final $Res Function(FileUploadConfig) _then;

/// Create a copy of FileUploadConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allowedFileExtensions = null,Object? allowedMimeTypes = null,Object? blockedFileExtensions = null,Object? blockedMimeTypes = null,Object? sizeLimit = null,}) {
  return _then(FileUploadConfig(
allowedFileExtensions: null == allowedFileExtensions ? _self.allowedFileExtensions : allowedFileExtensions // ignore: cast_nullable_to_non_nullable
as List<String>,allowedMimeTypes: null == allowedMimeTypes ? _self.allowedMimeTypes : allowedMimeTypes // ignore: cast_nullable_to_non_nullable
as List<String>,blockedFileExtensions: null == blockedFileExtensions ? _self.blockedFileExtensions : blockedFileExtensions // ignore: cast_nullable_to_non_nullable
as List<String>,blockedMimeTypes: null == blockedMimeTypes ? _self.blockedMimeTypes : blockedMimeTypes // ignore: cast_nullable_to_non_nullable
as List<String>,sizeLimit: null == sizeLimit ? _self.sizeLimit : sizeLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FileUploadConfig].
extension FileUploadConfigPatterns on FileUploadConfig {
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
