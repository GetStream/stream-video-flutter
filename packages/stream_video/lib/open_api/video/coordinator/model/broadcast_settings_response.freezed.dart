// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'broadcast_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BroadcastSettingsResponse {
  bool get enabled;
  HLSSettingsResponse get hls;
  RTMPSettingsResponse get rtmp;

  /// Create a copy of BroadcastSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BroadcastSettingsResponseCopyWith<BroadcastSettingsResponse> get copyWith =>
      _$BroadcastSettingsResponseCopyWithImpl<BroadcastSettingsResponse>(
        this as BroadcastSettingsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BroadcastSettingsResponse &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.hls, hls) || other.hls == hls) &&
            (identical(other.rtmp, rtmp) || other.rtmp == rtmp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enabled, hls, rtmp);

  @override
  String toString() {
    return 'BroadcastSettingsResponse(enabled: $enabled, hls: $hls, rtmp: $rtmp)';
  }
}

/// @nodoc
abstract mixin class $BroadcastSettingsResponseCopyWith<$Res> {
  factory $BroadcastSettingsResponseCopyWith(
    BroadcastSettingsResponse value,
    $Res Function(BroadcastSettingsResponse) _then,
  ) = _$BroadcastSettingsResponseCopyWithImpl;
  @useResult
  $Res call({bool enabled, HLSSettingsResponse hls, RTMPSettingsResponse rtmp});
}

/// @nodoc
class _$BroadcastSettingsResponseCopyWithImpl<$Res>
    implements $BroadcastSettingsResponseCopyWith<$Res> {
  _$BroadcastSettingsResponseCopyWithImpl(this._self, this._then);

  final BroadcastSettingsResponse _self;
  final $Res Function(BroadcastSettingsResponse) _then;

  /// Create a copy of BroadcastSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? enabled = null, Object? hls = null, Object? rtmp = null}) {
    return _then(
      BroadcastSettingsResponse(
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        hls: null == hls
            ? _self.hls
            : hls // ignore: cast_nullable_to_non_nullable
                  as HLSSettingsResponse,
        rtmp: null == rtmp
            ? _self.rtmp
            : rtmp // ignore: cast_nullable_to_non_nullable
                  as RTMPSettingsResponse,
      ),
    );
  }
}
