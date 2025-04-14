//
//  Generated code. Do not modify.
//  source: video/sfu/models/models.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class PeerType extends $pb.ProtobufEnum {
  /// todo fix me (marcelo)
  static const PeerType PEER_TYPE_PUBLISHER_UNSPECIFIED =
      PeerType._(0, _omitEnumNames ? '' : 'PEER_TYPE_PUBLISHER_UNSPECIFIED');
  static const PeerType PEER_TYPE_SUBSCRIBER =
      PeerType._(1, _omitEnumNames ? '' : 'PEER_TYPE_SUBSCRIBER');

  static const $core.List<PeerType> values = <PeerType>[
    PEER_TYPE_PUBLISHER_UNSPECIFIED,
    PEER_TYPE_SUBSCRIBER,
  ];

  static final $core.Map<$core.int, PeerType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static PeerType? valueOf($core.int value) => _byValue[value];

  const PeerType._(super.v, super.n);
}

class ConnectionQuality extends $pb.ProtobufEnum {
  static const ConnectionQuality CONNECTION_QUALITY_UNSPECIFIED =
      ConnectionQuality._(
          0, _omitEnumNames ? '' : 'CONNECTION_QUALITY_UNSPECIFIED');
  static const ConnectionQuality CONNECTION_QUALITY_POOR =
      ConnectionQuality._(1, _omitEnumNames ? '' : 'CONNECTION_QUALITY_POOR');
  static const ConnectionQuality CONNECTION_QUALITY_GOOD =
      ConnectionQuality._(2, _omitEnumNames ? '' : 'CONNECTION_QUALITY_GOOD');
  static const ConnectionQuality CONNECTION_QUALITY_EXCELLENT =
      ConnectionQuality._(
          3, _omitEnumNames ? '' : 'CONNECTION_QUALITY_EXCELLENT');

  static const $core.List<ConnectionQuality> values = <ConnectionQuality>[
    CONNECTION_QUALITY_UNSPECIFIED,
    CONNECTION_QUALITY_POOR,
    CONNECTION_QUALITY_GOOD,
    CONNECTION_QUALITY_EXCELLENT,
  ];

  static final $core.Map<$core.int, ConnectionQuality> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ConnectionQuality? valueOf($core.int value) => _byValue[value];

  const ConnectionQuality._(super.v, super.n);
}

class VideoQuality extends $pb.ProtobufEnum {
  static const VideoQuality VIDEO_QUALITY_LOW_UNSPECIFIED =
      VideoQuality._(0, _omitEnumNames ? '' : 'VIDEO_QUALITY_LOW_UNSPECIFIED');
  static const VideoQuality VIDEO_QUALITY_MID =
      VideoQuality._(1, _omitEnumNames ? '' : 'VIDEO_QUALITY_MID');
  static const VideoQuality VIDEO_QUALITY_HIGH =
      VideoQuality._(2, _omitEnumNames ? '' : 'VIDEO_QUALITY_HIGH');
  static const VideoQuality VIDEO_QUALITY_OFF =
      VideoQuality._(3, _omitEnumNames ? '' : 'VIDEO_QUALITY_OFF');

  static const $core.List<VideoQuality> values = <VideoQuality>[
    VIDEO_QUALITY_LOW_UNSPECIFIED,
    VIDEO_QUALITY_MID,
    VIDEO_QUALITY_HIGH,
    VIDEO_QUALITY_OFF,
  ];

  static final $core.Map<$core.int, VideoQuality> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static VideoQuality? valueOf($core.int value) => _byValue[value];

  const VideoQuality._(super.v, super.n);
}

class TrackType extends $pb.ProtobufEnum {
  static const TrackType TRACK_TYPE_UNSPECIFIED =
      TrackType._(0, _omitEnumNames ? '' : 'TRACK_TYPE_UNSPECIFIED');
  static const TrackType TRACK_TYPE_AUDIO =
      TrackType._(1, _omitEnumNames ? '' : 'TRACK_TYPE_AUDIO');
  static const TrackType TRACK_TYPE_VIDEO =
      TrackType._(2, _omitEnumNames ? '' : 'TRACK_TYPE_VIDEO');
  static const TrackType TRACK_TYPE_SCREEN_SHARE =
      TrackType._(3, _omitEnumNames ? '' : 'TRACK_TYPE_SCREEN_SHARE');
  static const TrackType TRACK_TYPE_SCREEN_SHARE_AUDIO =
      TrackType._(4, _omitEnumNames ? '' : 'TRACK_TYPE_SCREEN_SHARE_AUDIO');

  static const $core.List<TrackType> values = <TrackType>[
    TRACK_TYPE_UNSPECIFIED,
    TRACK_TYPE_AUDIO,
    TRACK_TYPE_VIDEO,
    TRACK_TYPE_SCREEN_SHARE,
    TRACK_TYPE_SCREEN_SHARE_AUDIO,
  ];

  static final $core.Map<$core.int, TrackType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static TrackType? valueOf($core.int value) => _byValue[value];

  const TrackType._(super.v, super.n);
}

class ErrorCode extends $pb.ProtobufEnum {
  static const ErrorCode ERROR_CODE_UNSPECIFIED =
      ErrorCode._(0, _omitEnumNames ? '' : 'ERROR_CODE_UNSPECIFIED');
  static const ErrorCode ERROR_CODE_PUBLISH_TRACK_NOT_FOUND = ErrorCode._(
      100, _omitEnumNames ? '' : 'ERROR_CODE_PUBLISH_TRACK_NOT_FOUND');
  static const ErrorCode ERROR_CODE_PUBLISH_TRACKS_MISMATCH = ErrorCode._(
      101, _omitEnumNames ? '' : 'ERROR_CODE_PUBLISH_TRACKS_MISMATCH');
  static const ErrorCode ERROR_CODE_PUBLISH_TRACK_OUT_OF_ORDER = ErrorCode._(
      102, _omitEnumNames ? '' : 'ERROR_CODE_PUBLISH_TRACK_OUT_OF_ORDER');
  static const ErrorCode ERROR_CODE_PUBLISH_TRACK_VIDEO_LAYER_NOT_FOUND =
      ErrorCode._(
          103,
          _omitEnumNames
              ? ''
              : 'ERROR_CODE_PUBLISH_TRACK_VIDEO_LAYER_NOT_FOUND');
  static const ErrorCode ERROR_CODE_LIVE_ENDED =
      ErrorCode._(104, _omitEnumNames ? '' : 'ERROR_CODE_LIVE_ENDED');
  static const ErrorCode ERROR_CODE_PARTICIPANT_NOT_FOUND = ErrorCode._(
      200, _omitEnumNames ? '' : 'ERROR_CODE_PARTICIPANT_NOT_FOUND');
  static const ErrorCode ERROR_CODE_PARTICIPANT_MIGRATING_OUT = ErrorCode._(
      201, _omitEnumNames ? '' : 'ERROR_CODE_PARTICIPANT_MIGRATING_OUT');
  static const ErrorCode ERROR_CODE_PARTICIPANT_MIGRATION_FAILED = ErrorCode._(
      202, _omitEnumNames ? '' : 'ERROR_CODE_PARTICIPANT_MIGRATION_FAILED');
  static const ErrorCode ERROR_CODE_PARTICIPANT_MIGRATING = ErrorCode._(
      203, _omitEnumNames ? '' : 'ERROR_CODE_PARTICIPANT_MIGRATING');
  static const ErrorCode ERROR_CODE_PARTICIPANT_RECONNECT_FAILED = ErrorCode._(
      204, _omitEnumNames ? '' : 'ERROR_CODE_PARTICIPANT_RECONNECT_FAILED');
  static const ErrorCode ERROR_CODE_PARTICIPANT_MEDIA_TRANSPORT_FAILURE =
      ErrorCode._(
          205,
          _omitEnumNames
              ? ''
              : 'ERROR_CODE_PARTICIPANT_MEDIA_TRANSPORT_FAILURE');
  static const ErrorCode ERROR_CODE_CALL_NOT_FOUND =
      ErrorCode._(300, _omitEnumNames ? '' : 'ERROR_CODE_CALL_NOT_FOUND');
  static const ErrorCode ERROR_CODE_REQUEST_VALIDATION_FAILED = ErrorCode._(
      400, _omitEnumNames ? '' : 'ERROR_CODE_REQUEST_VALIDATION_FAILED');
  static const ErrorCode ERROR_CODE_UNAUTHENTICATED =
      ErrorCode._(401, _omitEnumNames ? '' : 'ERROR_CODE_UNAUTHENTICATED');
  static const ErrorCode ERROR_CODE_PERMISSION_DENIED =
      ErrorCode._(403, _omitEnumNames ? '' : 'ERROR_CODE_PERMISSION_DENIED');
  static const ErrorCode ERROR_CODE_TOO_MANY_REQUESTS =
      ErrorCode._(429, _omitEnumNames ? '' : 'ERROR_CODE_TOO_MANY_REQUESTS');
  static const ErrorCode ERROR_CODE_INTERNAL_SERVER_ERROR = ErrorCode._(
      500, _omitEnumNames ? '' : 'ERROR_CODE_INTERNAL_SERVER_ERROR');
  static const ErrorCode ERROR_CODE_SFU_SHUTTING_DOWN =
      ErrorCode._(600, _omitEnumNames ? '' : 'ERROR_CODE_SFU_SHUTTING_DOWN');
  static const ErrorCode ERROR_CODE_SFU_FULL =
      ErrorCode._(700, _omitEnumNames ? '' : 'ERROR_CODE_SFU_FULL');

  static const $core.List<ErrorCode> values = <ErrorCode>[
    ERROR_CODE_UNSPECIFIED,
    ERROR_CODE_PUBLISH_TRACK_NOT_FOUND,
    ERROR_CODE_PUBLISH_TRACKS_MISMATCH,
    ERROR_CODE_PUBLISH_TRACK_OUT_OF_ORDER,
    ERROR_CODE_PUBLISH_TRACK_VIDEO_LAYER_NOT_FOUND,
    ERROR_CODE_LIVE_ENDED,
    ERROR_CODE_PARTICIPANT_NOT_FOUND,
    ERROR_CODE_PARTICIPANT_MIGRATING_OUT,
    ERROR_CODE_PARTICIPANT_MIGRATION_FAILED,
    ERROR_CODE_PARTICIPANT_MIGRATING,
    ERROR_CODE_PARTICIPANT_RECONNECT_FAILED,
    ERROR_CODE_PARTICIPANT_MEDIA_TRANSPORT_FAILURE,
    ERROR_CODE_CALL_NOT_FOUND,
    ERROR_CODE_REQUEST_VALIDATION_FAILED,
    ERROR_CODE_UNAUTHENTICATED,
    ERROR_CODE_PERMISSION_DENIED,
    ERROR_CODE_TOO_MANY_REQUESTS,
    ERROR_CODE_INTERNAL_SERVER_ERROR,
    ERROR_CODE_SFU_SHUTTING_DOWN,
    ERROR_CODE_SFU_FULL,
  ];

  static final $core.Map<$core.int, ErrorCode> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ErrorCode? valueOf($core.int value) => _byValue[value];

  const ErrorCode._(super.v, super.n);
}

class SdkType extends $pb.ProtobufEnum {
  static const SdkType SDK_TYPE_UNSPECIFIED =
      SdkType._(0, _omitEnumNames ? '' : 'SDK_TYPE_UNSPECIFIED');
  static const SdkType SDK_TYPE_REACT =
      SdkType._(1, _omitEnumNames ? '' : 'SDK_TYPE_REACT');
  static const SdkType SDK_TYPE_ANGULAR =
      SdkType._(2, _omitEnumNames ? '' : 'SDK_TYPE_ANGULAR');
  static const SdkType SDK_TYPE_ANDROID =
      SdkType._(3, _omitEnumNames ? '' : 'SDK_TYPE_ANDROID');
  static const SdkType SDK_TYPE_IOS =
      SdkType._(4, _omitEnumNames ? '' : 'SDK_TYPE_IOS');
  static const SdkType SDK_TYPE_FLUTTER =
      SdkType._(5, _omitEnumNames ? '' : 'SDK_TYPE_FLUTTER');
  static const SdkType SDK_TYPE_REACT_NATIVE =
      SdkType._(6, _omitEnumNames ? '' : 'SDK_TYPE_REACT_NATIVE');
  static const SdkType SDK_TYPE_UNITY =
      SdkType._(7, _omitEnumNames ? '' : 'SDK_TYPE_UNITY');
  static const SdkType SDK_TYPE_GO =
      SdkType._(8, _omitEnumNames ? '' : 'SDK_TYPE_GO');
  static const SdkType SDK_TYPE_PLAIN_JAVASCRIPT =
      SdkType._(9, _omitEnumNames ? '' : 'SDK_TYPE_PLAIN_JAVASCRIPT');

  static const $core.List<SdkType> values = <SdkType>[
    SDK_TYPE_UNSPECIFIED,
    SDK_TYPE_REACT,
    SDK_TYPE_ANGULAR,
    SDK_TYPE_ANDROID,
    SDK_TYPE_IOS,
    SDK_TYPE_FLUTTER,
    SDK_TYPE_REACT_NATIVE,
    SDK_TYPE_UNITY,
    SDK_TYPE_GO,
    SDK_TYPE_PLAIN_JAVASCRIPT,
  ];

  static final $core.Map<$core.int, SdkType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static SdkType? valueOf($core.int value) => _byValue[value];

  const SdkType._(super.v, super.n);
}

class TrackUnpublishReason extends $pb.ProtobufEnum {
  /// Default value which is used when the specific reason
  /// for muting the track is not known.
  static const TrackUnpublishReason TRACK_UNPUBLISH_REASON_UNSPECIFIED =
      TrackUnpublishReason._(
          0, _omitEnumNames ? '' : 'TRACK_UNPUBLISH_REASON_UNSPECIFIED');

  /// Represents user muting their tracks.
  static const TrackUnpublishReason TRACK_UNPUBLISH_REASON_USER_MUTED =
      TrackUnpublishReason._(
          1, _omitEnumNames ? '' : 'TRACK_UNPUBLISH_REASON_USER_MUTED');

  /// Represents muting the track because the permission to
  /// publish the track has been revoked.
  static const TrackUnpublishReason TRACK_UNPUBLISH_REASON_PERMISSION_REVOKED =
      TrackUnpublishReason._(
          2, _omitEnumNames ? '' : 'TRACK_UNPUBLISH_REASON_PERMISSION_REVOKED');

  /// Represents muting the track due to moderation actions.
  /// This is different from permission revoked because the
  /// participant can unmute themselves here whereas in case
  /// of "permission revoke" it is not possible until the
  /// call permissions are updated.
  static const TrackUnpublishReason TRACK_UNPUBLISH_REASON_MODERATION =
      TrackUnpublishReason._(
          3, _omitEnumNames ? '' : 'TRACK_UNPUBLISH_REASON_MODERATION');

  static const $core.List<TrackUnpublishReason> values = <TrackUnpublishReason>[
    TRACK_UNPUBLISH_REASON_UNSPECIFIED,
    TRACK_UNPUBLISH_REASON_USER_MUTED,
    TRACK_UNPUBLISH_REASON_PERMISSION_REVOKED,
    TRACK_UNPUBLISH_REASON_MODERATION,
  ];

  static final $core.Map<$core.int, TrackUnpublishReason> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static TrackUnpublishReason? valueOf($core.int value) => _byValue[value];

  const TrackUnpublishReason._(super.v, super.n);
}

/// GoAwayReason represents the reason for the SFU to
/// disconnect the client.
class GoAwayReason extends $pb.ProtobufEnum {
  static const GoAwayReason GO_AWAY_REASON_UNSPECIFIED =
      GoAwayReason._(0, _omitEnumNames ? '' : 'GO_AWAY_REASON_UNSPECIFIED');
  static const GoAwayReason GO_AWAY_REASON_SHUTTING_DOWN =
      GoAwayReason._(1, _omitEnumNames ? '' : 'GO_AWAY_REASON_SHUTTING_DOWN');
  static const GoAwayReason GO_AWAY_REASON_REBALANCE =
      GoAwayReason._(2, _omitEnumNames ? '' : 'GO_AWAY_REASON_REBALANCE');

  static const $core.List<GoAwayReason> values = <GoAwayReason>[
    GO_AWAY_REASON_UNSPECIFIED,
    GO_AWAY_REASON_SHUTTING_DOWN,
    GO_AWAY_REASON_REBALANCE,
  ];

  static final $core.Map<$core.int, GoAwayReason> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static GoAwayReason? valueOf($core.int value) => _byValue[value];

  const GoAwayReason._(super.v, super.n);
}

/// CallEndedReason represents the reason for the call to end.
class CallEndedReason extends $pb.ProtobufEnum {
  static const CallEndedReason CALL_ENDED_REASON_UNSPECIFIED =
      CallEndedReason._(
          0, _omitEnumNames ? '' : 'CALL_ENDED_REASON_UNSPECIFIED');
  static const CallEndedReason CALL_ENDED_REASON_ENDED =
      CallEndedReason._(1, _omitEnumNames ? '' : 'CALL_ENDED_REASON_ENDED');
  static const CallEndedReason CALL_ENDED_REASON_LIVE_ENDED = CallEndedReason._(
      2, _omitEnumNames ? '' : 'CALL_ENDED_REASON_LIVE_ENDED');
  static const CallEndedReason CALL_ENDED_REASON_KICKED =
      CallEndedReason._(3, _omitEnumNames ? '' : 'CALL_ENDED_REASON_KICKED');
  static const CallEndedReason CALL_ENDED_REASON_SESSION_ENDED =
      CallEndedReason._(
          4, _omitEnumNames ? '' : 'CALL_ENDED_REASON_SESSION_ENDED');

  static const $core.List<CallEndedReason> values = <CallEndedReason>[
    CALL_ENDED_REASON_UNSPECIFIED,
    CALL_ENDED_REASON_ENDED,
    CALL_ENDED_REASON_LIVE_ENDED,
    CALL_ENDED_REASON_KICKED,
    CALL_ENDED_REASON_SESSION_ENDED,
  ];

  static final $core.Map<$core.int, CallEndedReason> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static CallEndedReason? valueOf($core.int value) => _byValue[value];

  const CallEndedReason._(super.v, super.n);
}

/// WebsocketReconnectStrategy defines the ws strategies available for handling reconnections.
class WebsocketReconnectStrategy extends $pb.ProtobufEnum {
  static const WebsocketReconnectStrategy
      WEBSOCKET_RECONNECT_STRATEGY_UNSPECIFIED = WebsocketReconnectStrategy._(
          0, _omitEnumNames ? '' : 'WEBSOCKET_RECONNECT_STRATEGY_UNSPECIFIED');

  /// Sent after reaching the maximum reconnection attempts, or any other unrecoverable error leading to permanent disconnect.
  static const WebsocketReconnectStrategy
      WEBSOCKET_RECONNECT_STRATEGY_DISCONNECT = WebsocketReconnectStrategy._(
          1, _omitEnumNames ? '' : 'WEBSOCKET_RECONNECT_STRATEGY_DISCONNECT');

  /// SDK should maintaining existing publisher/subscriber pc instances
  /// and establish a new WebSocket connection.
  static const WebsocketReconnectStrategy WEBSOCKET_RECONNECT_STRATEGY_FAST =
      WebsocketReconnectStrategy._(
          2, _omitEnumNames ? '' : 'WEBSOCKET_RECONNECT_STRATEGY_FAST');

  /// SDK should obtain new credentials from the coordinator, drops existing pc instances, set a new session_id and initializes
  /// a completely new WebSocket connection, ensuring a comprehensive reset.
  static const WebsocketReconnectStrategy WEBSOCKET_RECONNECT_STRATEGY_REJOIN =
      WebsocketReconnectStrategy._(
          3, _omitEnumNames ? '' : 'WEBSOCKET_RECONNECT_STRATEGY_REJOIN');

  /// SDK should migrate to a new SFU instance
  static const WebsocketReconnectStrategy WEBSOCKET_RECONNECT_STRATEGY_MIGRATE =
      WebsocketReconnectStrategy._(
          4, _omitEnumNames ? '' : 'WEBSOCKET_RECONNECT_STRATEGY_MIGRATE');

  static const $core.List<WebsocketReconnectStrategy> values =
      <WebsocketReconnectStrategy>[
    WEBSOCKET_RECONNECT_STRATEGY_UNSPECIFIED,
    WEBSOCKET_RECONNECT_STRATEGY_DISCONNECT,
    WEBSOCKET_RECONNECT_STRATEGY_FAST,
    WEBSOCKET_RECONNECT_STRATEGY_REJOIN,
    WEBSOCKET_RECONNECT_STRATEGY_MIGRATE,
  ];

  static final $core.Map<$core.int, WebsocketReconnectStrategy> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static WebsocketReconnectStrategy? valueOf($core.int value) =>
      _byValue[value];

  const WebsocketReconnectStrategy._(super.v, super.n);
}

/// AndroidThermalState is reported by the Android API. The full list of values is documented here
/// https://developer.android.com/reference/android/os/PowerManager.html#getCurrentThermalStatus()
class AndroidThermalState extends $pb.ProtobufEnum {
  static const AndroidThermalState ANDROID_THERMAL_STATE_UNSPECIFIED =
      AndroidThermalState._(
          0, _omitEnumNames ? '' : 'ANDROID_THERMAL_STATE_UNSPECIFIED');
  static const AndroidThermalState ANDROID_THERMAL_STATE_NONE =
      AndroidThermalState._(
          1, _omitEnumNames ? '' : 'ANDROID_THERMAL_STATE_NONE');
  static const AndroidThermalState ANDROID_THERMAL_STATE_LIGHT =
      AndroidThermalState._(
          2, _omitEnumNames ? '' : 'ANDROID_THERMAL_STATE_LIGHT');
  static const AndroidThermalState ANDROID_THERMAL_STATE_MODERATE =
      AndroidThermalState._(
          3, _omitEnumNames ? '' : 'ANDROID_THERMAL_STATE_MODERATE');
  static const AndroidThermalState ANDROID_THERMAL_STATE_SEVERE =
      AndroidThermalState._(
          4, _omitEnumNames ? '' : 'ANDROID_THERMAL_STATE_SEVERE');
  static const AndroidThermalState ANDROID_THERMAL_STATE_CRITICAL =
      AndroidThermalState._(
          5, _omitEnumNames ? '' : 'ANDROID_THERMAL_STATE_CRITICAL');
  static const AndroidThermalState ANDROID_THERMAL_STATE_EMERGENCY =
      AndroidThermalState._(
          6, _omitEnumNames ? '' : 'ANDROID_THERMAL_STATE_EMERGENCY');
  static const AndroidThermalState ANDROID_THERMAL_STATE_SHUTDOWN =
      AndroidThermalState._(
          7, _omitEnumNames ? '' : 'ANDROID_THERMAL_STATE_SHUTDOWN');

  static const $core.List<AndroidThermalState> values = <AndroidThermalState>[
    ANDROID_THERMAL_STATE_UNSPECIFIED,
    ANDROID_THERMAL_STATE_NONE,
    ANDROID_THERMAL_STATE_LIGHT,
    ANDROID_THERMAL_STATE_MODERATE,
    ANDROID_THERMAL_STATE_SEVERE,
    ANDROID_THERMAL_STATE_CRITICAL,
    ANDROID_THERMAL_STATE_EMERGENCY,
    ANDROID_THERMAL_STATE_SHUTDOWN,
  ];

  static final $core.Map<$core.int, AndroidThermalState> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static AndroidThermalState? valueOf($core.int value) => _byValue[value];

  const AndroidThermalState._(super.v, super.n);
}

/// AppleThermalState is the thermal state as reported by Apple devices when available or applicable to the platform.
/// The full list of states (enum) is available here: https://developer.apple.com/documentation/foundation/processinfo/thermalstate
class AppleThermalState extends $pb.ProtobufEnum {
  static const AppleThermalState APPLE_THERMAL_STATE_UNSPECIFIED =
      AppleThermalState._(
          0, _omitEnumNames ? '' : 'APPLE_THERMAL_STATE_UNSPECIFIED');
  static const AppleThermalState APPLE_THERMAL_STATE_NOMINAL =
      AppleThermalState._(
          1, _omitEnumNames ? '' : 'APPLE_THERMAL_STATE_NOMINAL');
  static const AppleThermalState APPLE_THERMAL_STATE_FAIR =
      AppleThermalState._(2, _omitEnumNames ? '' : 'APPLE_THERMAL_STATE_FAIR');
  static const AppleThermalState APPLE_THERMAL_STATE_SERIOUS =
      AppleThermalState._(
          3, _omitEnumNames ? '' : 'APPLE_THERMAL_STATE_SERIOUS');
  static const AppleThermalState APPLE_THERMAL_STATE_CRITICAL =
      AppleThermalState._(
          4, _omitEnumNames ? '' : 'APPLE_THERMAL_STATE_CRITICAL');

  static const $core.List<AppleThermalState> values = <AppleThermalState>[
    APPLE_THERMAL_STATE_UNSPECIFIED,
    APPLE_THERMAL_STATE_NOMINAL,
    APPLE_THERMAL_STATE_FAIR,
    APPLE_THERMAL_STATE_SERIOUS,
    APPLE_THERMAL_STATE_CRITICAL,
  ];

  static final $core.Map<$core.int, AppleThermalState> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static AppleThermalState? valueOf($core.int value) => _byValue[value];

  const AppleThermalState._(super.v, super.n);
}

const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
