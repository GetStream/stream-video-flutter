// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeofenceSettingsRequest {
  List<String>? get names;

  /// Create a copy of GeofenceSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GeofenceSettingsRequestCopyWith<GeofenceSettingsRequest> get copyWith =>
      _$GeofenceSettingsRequestCopyWithImpl<GeofenceSettingsRequest>(
        this as GeofenceSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GeofenceSettingsRequest &&
            const DeepCollectionEquality().equals(other.names, names));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(names));

  @override
  String toString() {
    return 'GeofenceSettingsRequest(names: $names)';
  }
}

/// @nodoc
abstract mixin class $GeofenceSettingsRequestCopyWith<$Res> {
  factory $GeofenceSettingsRequestCopyWith(
    GeofenceSettingsRequest value,
    $Res Function(GeofenceSettingsRequest) _then,
  ) = _$GeofenceSettingsRequestCopyWithImpl;
  @useResult
  $Res call({List<String>? names});
}

/// @nodoc
class _$GeofenceSettingsRequestCopyWithImpl<$Res>
    implements $GeofenceSettingsRequestCopyWith<$Res> {
  _$GeofenceSettingsRequestCopyWithImpl(this._self, this._then);

  final GeofenceSettingsRequest _self;
  final $Res Function(GeofenceSettingsRequest) _then;

  /// Create a copy of GeofenceSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? names = freezed}) {
    return _then(
      GeofenceSettingsRequest(
        names: freezed == names
            ? _self.names
            : names // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}
