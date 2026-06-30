// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionSettingsResponse {
  int get inactivityTimeoutSeconds;

  /// Create a copy of SessionSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionSettingsResponseCopyWith<SessionSettingsResponse> get copyWith =>
      _$SessionSettingsResponseCopyWithImpl<SessionSettingsResponse>(
        this as SessionSettingsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionSettingsResponse &&
            (identical(
                  other.inactivityTimeoutSeconds,
                  inactivityTimeoutSeconds,
                ) ||
                other.inactivityTimeoutSeconds == inactivityTimeoutSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, inactivityTimeoutSeconds);

  @override
  String toString() {
    return 'SessionSettingsResponse(inactivityTimeoutSeconds: $inactivityTimeoutSeconds)';
  }
}

/// @nodoc
abstract mixin class $SessionSettingsResponseCopyWith<$Res> {
  factory $SessionSettingsResponseCopyWith(
    SessionSettingsResponse value,
    $Res Function(SessionSettingsResponse) _then,
  ) = _$SessionSettingsResponseCopyWithImpl;
  @useResult
  $Res call({int inactivityTimeoutSeconds});
}

/// @nodoc
class _$SessionSettingsResponseCopyWithImpl<$Res>
    implements $SessionSettingsResponseCopyWith<$Res> {
  _$SessionSettingsResponseCopyWithImpl(this._self, this._then);

  final SessionSettingsResponse _self;
  final $Res Function(SessionSettingsResponse) _then;

  /// Create a copy of SessionSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? inactivityTimeoutSeconds = null}) {
    return _then(
      SessionSettingsResponse(
        inactivityTimeoutSeconds: null == inactivityTimeoutSeconds
            ? _self.inactivityTimeoutSeconds
            : inactivityTimeoutSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
