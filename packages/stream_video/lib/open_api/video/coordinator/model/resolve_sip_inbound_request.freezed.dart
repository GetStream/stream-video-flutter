// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolve_sip_inbound_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResolveSipInboundRequest {
  SIPChallengeRequest? get challenge;
  String? get routingNumber;
  String get sipCallerNumber;
  Map<String, String>? get sipHeaders;
  String get sipTrunkNumber;
  String? get trunkId;

  /// Create a copy of ResolveSipInboundRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResolveSipInboundRequestCopyWith<ResolveSipInboundRequest> get copyWith =>
      _$ResolveSipInboundRequestCopyWithImpl<ResolveSipInboundRequest>(
        this as ResolveSipInboundRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResolveSipInboundRequest &&
            (identical(other.challenge, challenge) ||
                other.challenge == challenge) &&
            (identical(other.routingNumber, routingNumber) ||
                other.routingNumber == routingNumber) &&
            (identical(other.sipCallerNumber, sipCallerNumber) ||
                other.sipCallerNumber == sipCallerNumber) &&
            const DeepCollectionEquality().equals(
              other.sipHeaders,
              sipHeaders,
            ) &&
            (identical(other.sipTrunkNumber, sipTrunkNumber) ||
                other.sipTrunkNumber == sipTrunkNumber) &&
            (identical(other.trunkId, trunkId) || other.trunkId == trunkId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    challenge,
    routingNumber,
    sipCallerNumber,
    const DeepCollectionEquality().hash(sipHeaders),
    sipTrunkNumber,
    trunkId,
  );

  @override
  String toString() {
    return 'ResolveSipInboundRequest(challenge: $challenge, routingNumber: $routingNumber, sipCallerNumber: $sipCallerNumber, sipHeaders: $sipHeaders, sipTrunkNumber: $sipTrunkNumber, trunkId: $trunkId)';
  }
}

/// @nodoc
abstract mixin class $ResolveSipInboundRequestCopyWith<$Res> {
  factory $ResolveSipInboundRequestCopyWith(
    ResolveSipInboundRequest value,
    $Res Function(ResolveSipInboundRequest) _then,
  ) = _$ResolveSipInboundRequestCopyWithImpl;
  @useResult
  $Res call({
    SIPChallengeRequest? challenge,
    String? routingNumber,
    String sipCallerNumber,
    Map<String, String>? sipHeaders,
    String sipTrunkNumber,
    String? trunkId,
  });
}

/// @nodoc
class _$ResolveSipInboundRequestCopyWithImpl<$Res>
    implements $ResolveSipInboundRequestCopyWith<$Res> {
  _$ResolveSipInboundRequestCopyWithImpl(this._self, this._then);

  final ResolveSipInboundRequest _self;
  final $Res Function(ResolveSipInboundRequest) _then;

  /// Create a copy of ResolveSipInboundRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? challenge = freezed,
    Object? routingNumber = freezed,
    Object? sipCallerNumber = null,
    Object? sipHeaders = freezed,
    Object? sipTrunkNumber = null,
    Object? trunkId = freezed,
  }) {
    return _then(
      ResolveSipInboundRequest(
        challenge: freezed == challenge
            ? _self.challenge
            : challenge // ignore: cast_nullable_to_non_nullable
                  as SIPChallengeRequest?,
        routingNumber: freezed == routingNumber
            ? _self.routingNumber
            : routingNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        sipCallerNumber: null == sipCallerNumber
            ? _self.sipCallerNumber
            : sipCallerNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        sipHeaders: freezed == sipHeaders
            ? _self.sipHeaders
            : sipHeaders // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        sipTrunkNumber: null == sipTrunkNumber
            ? _self.sipTrunkNumber
            : sipTrunkNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        trunkId: freezed == trunkId
            ? _self.trunkId
            : trunkId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
