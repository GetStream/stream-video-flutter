// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coordinates_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoordinatesResponse {
  double get latitude;
  double get longitude;

  /// Create a copy of CoordinatesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CoordinatesResponseCopyWith<CoordinatesResponse> get copyWith =>
      _$CoordinatesResponseCopyWithImpl<CoordinatesResponse>(
        this as CoordinatesResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CoordinatesResponse &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude);

  @override
  String toString() {
    return 'CoordinatesResponse(latitude: $latitude, longitude: $longitude)';
  }
}

/// @nodoc
abstract mixin class $CoordinatesResponseCopyWith<$Res> {
  factory $CoordinatesResponseCopyWith(
    CoordinatesResponse value,
    $Res Function(CoordinatesResponse) _then,
  ) = _$CoordinatesResponseCopyWithImpl;
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class _$CoordinatesResponseCopyWithImpl<$Res>
    implements $CoordinatesResponseCopyWith<$Res> {
  _$CoordinatesResponseCopyWithImpl(this._self, this._then);

  final CoordinatesResponse _self;
  final $Res Function(CoordinatesResponse) _then;

  /// Create a copy of CoordinatesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? latitude = null, Object? longitude = null}) {
    return _then(
      CoordinatesResponse(
        latitude: null == latitude
            ? _self.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _self.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}
