// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocationResponse {
  String get continentCode;
  String get countryIsoCode;
  String get subdivisionIsoCode;

  /// Create a copy of LocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocationResponseCopyWith<LocationResponse> get copyWith =>
      _$LocationResponseCopyWithImpl<LocationResponse>(
        this as LocationResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocationResponse &&
            (identical(other.continentCode, continentCode) ||
                other.continentCode == continentCode) &&
            (identical(other.countryIsoCode, countryIsoCode) ||
                other.countryIsoCode == countryIsoCode) &&
            (identical(other.subdivisionIsoCode, subdivisionIsoCode) ||
                other.subdivisionIsoCode == subdivisionIsoCode));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    continentCode,
    countryIsoCode,
    subdivisionIsoCode,
  );

  @override
  String toString() {
    return 'LocationResponse(continentCode: $continentCode, countryIsoCode: $countryIsoCode, subdivisionIsoCode: $subdivisionIsoCode)';
  }
}

/// @nodoc
abstract mixin class $LocationResponseCopyWith<$Res> {
  factory $LocationResponseCopyWith(
    LocationResponse value,
    $Res Function(LocationResponse) _then,
  ) = _$LocationResponseCopyWithImpl;
  @useResult
  $Res call({
    String continentCode,
    String countryIsoCode,
    String subdivisionIsoCode,
  });
}

/// @nodoc
class _$LocationResponseCopyWithImpl<$Res>
    implements $LocationResponseCopyWith<$Res> {
  _$LocationResponseCopyWithImpl(this._self, this._then);

  final LocationResponse _self;
  final $Res Function(LocationResponse) _then;

  /// Create a copy of LocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? continentCode = null,
    Object? countryIsoCode = null,
    Object? subdivisionIsoCode = null,
  }) {
    return _then(
      LocationResponse(
        continentCode: null == continentCode
            ? _self.continentCode
            : continentCode // ignore: cast_nullable_to_non_nullable
                  as String,
        countryIsoCode: null == countryIsoCode
            ? _self.countryIsoCode
            : countryIsoCode // ignore: cast_nullable_to_non_nullable
                  as String,
        subdivisionIsoCode: null == subdivisionIsoCode
            ? _self.subdivisionIsoCode
            : subdivisionIsoCode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
