// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sfu_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SFUResponse {
  String get edgeName;
  String get url;
  String get wsEndpoint;

  /// Create a copy of SFUResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SFUResponseCopyWith<SFUResponse> get copyWith =>
      _$SFUResponseCopyWithImpl<SFUResponse>(this as SFUResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SFUResponse &&
            (identical(other.edgeName, edgeName) ||
                other.edgeName == edgeName) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.wsEndpoint, wsEndpoint) ||
                other.wsEndpoint == wsEndpoint));
  }

  @override
  int get hashCode => Object.hash(runtimeType, edgeName, url, wsEndpoint);

  @override
  String toString() {
    return 'SFUResponse(edgeName: $edgeName, url: $url, wsEndpoint: $wsEndpoint)';
  }
}

/// @nodoc
abstract mixin class $SFUResponseCopyWith<$Res> {
  factory $SFUResponseCopyWith(
    SFUResponse value,
    $Res Function(SFUResponse) _then,
  ) = _$SFUResponseCopyWithImpl;
  @useResult
  $Res call({String edgeName, String url, String wsEndpoint});
}

/// @nodoc
class _$SFUResponseCopyWithImpl<$Res> implements $SFUResponseCopyWith<$Res> {
  _$SFUResponseCopyWithImpl(this._self, this._then);

  final SFUResponse _self;
  final $Res Function(SFUResponse) _then;

  /// Create a copy of SFUResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? edgeName = null,
    Object? url = null,
    Object? wsEndpoint = null,
  }) {
    return _then(
      SFUResponse(
        edgeName: null == edgeName
            ? _self.edgeName
            : edgeName // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _self.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        wsEndpoint: null == wsEndpoint
            ? _self.wsEndpoint
            : wsEndpoint // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
