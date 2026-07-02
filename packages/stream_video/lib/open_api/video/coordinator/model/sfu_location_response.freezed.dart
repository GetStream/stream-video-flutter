// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sfu_location_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SFULocationResponse {
  CoordinatesResponse get coordinates;
  int? get count;
  String get datacenter;
  String get id;
  LocationResponse get location;

  /// Create a copy of SFULocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SFULocationResponseCopyWith<SFULocationResponse> get copyWith =>
      _$SFULocationResponseCopyWithImpl<SFULocationResponse>(
        this as SFULocationResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SFULocationResponse &&
            (identical(other.coordinates, coordinates) ||
                other.coordinates == coordinates) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.datacenter, datacenter) ||
                other.datacenter == datacenter) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, coordinates, count, datacenter, id, location);

  @override
  String toString() {
    return 'SFULocationResponse(coordinates: $coordinates, count: $count, datacenter: $datacenter, id: $id, location: $location)';
  }
}

/// @nodoc
abstract mixin class $SFULocationResponseCopyWith<$Res> {
  factory $SFULocationResponseCopyWith(
    SFULocationResponse value,
    $Res Function(SFULocationResponse) _then,
  ) = _$SFULocationResponseCopyWithImpl;
  @useResult
  $Res call({
    CoordinatesResponse coordinates,
    int? count,
    String datacenter,
    String id,
    LocationResponse location,
  });
}

/// @nodoc
class _$SFULocationResponseCopyWithImpl<$Res>
    implements $SFULocationResponseCopyWith<$Res> {
  _$SFULocationResponseCopyWithImpl(this._self, this._then);

  final SFULocationResponse _self;
  final $Res Function(SFULocationResponse) _then;

  /// Create a copy of SFULocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinates = null,
    Object? count = freezed,
    Object? datacenter = null,
    Object? id = null,
    Object? location = null,
  }) {
    return _then(
      SFULocationResponse(
        coordinates: null == coordinates
            ? _self.coordinates
            : coordinates // ignore: cast_nullable_to_non_nullable
                  as CoordinatesResponse,
        count: freezed == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int?,
        datacenter: null == datacenter
            ? _self.datacenter
            : datacenter // ignore: cast_nullable_to_non_nullable
                  as String,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _self.location
            : location // ignore: cast_nullable_to_non_nullable
                  as LocationResponse,
      ),
    );
  }
}
