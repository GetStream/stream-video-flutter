// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sip_inbound_credentials.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SipInboundCredentials {
  String get apiKey;
  Map<String, Object?> get callCustomData;
  String get callId;
  String get callType;
  String get token;
  Map<String, Object?> get userCustomData;
  String get userId;

  /// Create a copy of SipInboundCredentials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SipInboundCredentialsCopyWith<SipInboundCredentials> get copyWith =>
      _$SipInboundCredentialsCopyWithImpl<SipInboundCredentials>(
        this as SipInboundCredentials,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SipInboundCredentials &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            const DeepCollectionEquality().equals(
              other.callCustomData,
              callCustomData,
            ) &&
            (identical(other.callId, callId) || other.callId == callId) &&
            (identical(other.callType, callType) ||
                other.callType == callType) &&
            (identical(other.token, token) || other.token == token) &&
            const DeepCollectionEquality().equals(
              other.userCustomData,
              userCustomData,
            ) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    apiKey,
    const DeepCollectionEquality().hash(callCustomData),
    callId,
    callType,
    token,
    const DeepCollectionEquality().hash(userCustomData),
    userId,
  );

  @override
  String toString() {
    return 'SipInboundCredentials(apiKey: $apiKey, callCustomData: $callCustomData, callId: $callId, callType: $callType, token: $token, userCustomData: $userCustomData, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $SipInboundCredentialsCopyWith<$Res> {
  factory $SipInboundCredentialsCopyWith(
    SipInboundCredentials value,
    $Res Function(SipInboundCredentials) _then,
  ) = _$SipInboundCredentialsCopyWithImpl;
  @useResult
  $Res call({
    String apiKey,
    Map<String, Object?> callCustomData,
    String callId,
    String callType,
    String token,
    Map<String, Object?> userCustomData,
    String userId,
  });
}

/// @nodoc
class _$SipInboundCredentialsCopyWithImpl<$Res>
    implements $SipInboundCredentialsCopyWith<$Res> {
  _$SipInboundCredentialsCopyWithImpl(this._self, this._then);

  final SipInboundCredentials _self;
  final $Res Function(SipInboundCredentials) _then;

  /// Create a copy of SipInboundCredentials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? callCustomData = null,
    Object? callId = null,
    Object? callType = null,
    Object? token = null,
    Object? userCustomData = null,
    Object? userId = null,
  }) {
    return _then(
      SipInboundCredentials(
        apiKey: null == apiKey
            ? _self.apiKey
            : apiKey // ignore: cast_nullable_to_non_nullable
                  as String,
        callCustomData: null == callCustomData
            ? _self.callCustomData
            : callCustomData // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        callId: null == callId
            ? _self.callId
            : callId // ignore: cast_nullable_to_non_nullable
                  as String,
        callType: null == callType
            ? _self.callType
            : callType // ignore: cast_nullable_to_non_nullable
                  as String,
        token: null == token
            ? _self.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        userCustomData: null == userCustomData
            ? _self.userCustomData
            : userCustomData // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
