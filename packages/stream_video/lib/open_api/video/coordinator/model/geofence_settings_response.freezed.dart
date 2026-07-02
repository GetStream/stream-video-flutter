// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeofenceSettingsResponse {
  List<String> get names;

  /// Create a copy of GeofenceSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GeofenceSettingsResponseCopyWith<GeofenceSettingsResponse> get copyWith =>
      _$GeofenceSettingsResponseCopyWithImpl<GeofenceSettingsResponse>(
        this as GeofenceSettingsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GeofenceSettingsResponse &&
            const DeepCollectionEquality().equals(other.names, names));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(names));

  @override
  String toString() {
    return 'GeofenceSettingsResponse(names: $names)';
  }
}

/// @nodoc
abstract mixin class $GeofenceSettingsResponseCopyWith<$Res> {
  factory $GeofenceSettingsResponseCopyWith(
    GeofenceSettingsResponse value,
    $Res Function(GeofenceSettingsResponse) _then,
  ) = _$GeofenceSettingsResponseCopyWithImpl;
  @useResult
  $Res call({List<String> names});
}

/// @nodoc
class _$GeofenceSettingsResponseCopyWithImpl<$Res>
    implements $GeofenceSettingsResponseCopyWith<$Res> {
  _$GeofenceSettingsResponseCopyWithImpl(this._self, this._then);

  final GeofenceSettingsResponse _self;
  final $Res Function(GeofenceSettingsResponse) _then;

  /// Create a copy of GeofenceSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? names = null}) {
    return _then(
      GeofenceSettingsResponse(
        names: null == names
            ? _self.names
            : names // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}
