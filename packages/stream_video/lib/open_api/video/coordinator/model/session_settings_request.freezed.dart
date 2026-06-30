// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionSettingsRequest {
  int get inactivityTimeoutSeconds;

  /// Create a copy of SessionSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionSettingsRequestCopyWith<SessionSettingsRequest> get copyWith =>
      _$SessionSettingsRequestCopyWithImpl<SessionSettingsRequest>(
        this as SessionSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionSettingsRequest &&
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
    return 'SessionSettingsRequest(inactivityTimeoutSeconds: $inactivityTimeoutSeconds)';
  }
}

/// @nodoc
abstract mixin class $SessionSettingsRequestCopyWith<$Res> {
  factory $SessionSettingsRequestCopyWith(
    SessionSettingsRequest value,
    $Res Function(SessionSettingsRequest) _then,
  ) = _$SessionSettingsRequestCopyWithImpl;
  @useResult
  $Res call({int inactivityTimeoutSeconds});
}

/// @nodoc
class _$SessionSettingsRequestCopyWithImpl<$Res>
    implements $SessionSettingsRequestCopyWith<$Res> {
  _$SessionSettingsRequestCopyWithImpl(this._self, this._then);

  final SessionSettingsRequest _self;
  final $Res Function(SessionSettingsRequest) _then;

  /// Create a copy of SessionSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? inactivityTimeoutSeconds = null}) {
    return _then(
      SessionSettingsRequest(
        inactivityTimeoutSeconds: null == inactivityTimeoutSeconds
            ? _self.inactivityTimeoutSeconds
            : inactivityTimeoutSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
