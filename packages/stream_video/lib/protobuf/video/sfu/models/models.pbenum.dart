// This is a generated file - do not edit.
//
// Generated from video/sfu/models/models.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

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

  static final $core.List<PeerType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static PeerType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PeerType._(super.value, super.name);
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

  static final $core.List<ConnectionQuality?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ConnectionQuality? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConnectionQuality._(super.value, super.name);
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

  static final $core.List<VideoQuality?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static VideoQuality? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VideoQuality._(super.value, super.name);
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

  static final $core.List<TrackType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TrackType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TrackType._(super.value, super.name);
}

/// must be aligned with kit
class ParticipantSource extends $pb.ProtobufEnum {
  static const ParticipantSource PARTICIPANT_SOURCE_WEBRTC_UNSPECIFIED =
      ParticipantSource._(
          0, _omitEnumNames ? '' : 'PARTICIPANT_SOURCE_WEBRTC_UNSPECIFIED');
  static const ParticipantSource PARTICIPANT_SOURCE_RTMP =
      ParticipantSource._(1, _omitEnumNames ? '' : 'PARTICIPANT_SOURCE_RTMP');
  static const ParticipantSource PARTICIPANT_SOURCE_WHIP =
      ParticipantSource._(2, _omitEnumNames ? '' : 'PARTICIPANT_SOURCE_WHIP');
  static const ParticipantSource PARTICIPANT_SOURCE_SIP =
      ParticipantSource._(3, _omitEnumNames ? '' : 'PARTICIPANT_SOURCE_SIP');
  static const ParticipantSource PARTICIPANT_SOURCE_RTSP =
      ParticipantSource._(4, _omitEnumNames ? '' : 'PARTICIPANT_SOURCE_RTSP');
  static const ParticipantSource PARTICIPANT_SOURCE_SRT =
      ParticipantSource._(5, _omitEnumNames ? '' : 'PARTICIPANT_SOURCE_SRT');

  static const $core.List<ParticipantSource> values = <ParticipantSource>[
    PARTICIPANT_SOURCE_WEBRTC_UNSPECIFIED,
    PARTICIPANT_SOURCE_RTMP,
    PARTICIPANT_SOURCE_WHIP,
    PARTICIPANT_SOURCE_SIP,
    PARTICIPANT_SOURCE_RTSP,
    PARTICIPANT_SOURCE_SRT,
  ];

  static final $core.List<ParticipantSource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ParticipantSource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ParticipantSource._(super.value, super.name);
}

class AudioBitrateProfile extends $pb.ProtobufEnum {
  static const AudioBitrateProfile
      AUDIO_BITRATE_PROFILE_VOICE_STANDARD_UNSPECIFIED = AudioBitrateProfile._(
          0,
          _omitEnumNames
              ? ''
              : 'AUDIO_BITRATE_PROFILE_VOICE_STANDARD_UNSPECIFIED');
  static const AudioBitrateProfile AUDIO_BITRATE_PROFILE_VOICE_HIGH_QUALITY =
      AudioBitrateProfile._(
          1, _omitEnumNames ? '' : 'AUDIO_BITRATE_PROFILE_VOICE_HIGH_QUALITY');
  static const AudioBitrateProfile AUDIO_BITRATE_PROFILE_MUSIC_HIGH_QUALITY =
      AudioBitrateProfile._(
          2, _omitEnumNames ? '' : 'AUDIO_BITRATE_PROFILE_MUSIC_HIGH_QUALITY');

  static const $core.List<AudioBitrateProfile> values = <AudioBitrateProfile>[
    AUDIO_BITRATE_PROFILE_VOICE_STANDARD_UNSPECIFIED,
    AUDIO_BITRATE_PROFILE_VOICE_HIGH_QUALITY,
    AUDIO_BITRATE_PROFILE_MUSIC_HIGH_QUALITY,
  ];

  static final $core.List<AudioBitrateProfile?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AudioBitrateProfile? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AudioBitrateProfile._(super.value, super.name);
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
  static const ErrorCode ERROR_CODE_PARTICIPANT_SIGNAL_LOST = ErrorCode._(
      206, _omitEnumNames ? '' : 'ERROR_CODE_PARTICIPANT_SIGNAL_LOST');
  static const ErrorCode ERROR_CODE_CALL_NOT_FOUND =
      ErrorCode._(300, _omitEnumNames ? '' : 'ERROR_CODE_CALL_NOT_FOUND');
  static const ErrorCode ERROR_CODE_CALL_PARTICIPANT_LIMIT_REACHED =
      ErrorCode._(301,
          _omitEnumNames ? '' : 'ERROR_CODE_CALL_PARTICIPANT_LIMIT_REACHED');
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
    ERROR_CODE_PARTICIPANT_SIGNAL_LOST,
    ERROR_CODE_CALL_NOT_FOUND,
    ERROR_CODE_CALL_PARTICIPANT_LIMIT_REACHED,
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

  const ErrorCode._(super.value, super.name);
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

  static final $core.List<SdkType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 9);
  static SdkType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SdkType._(super.value, super.name);
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

  static final $core.List<TrackUnpublishReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static TrackUnpublishReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TrackUnpublishReason._(super.value, super.name);
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

  static final $core.List<GoAwayReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static GoAwayReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GoAwayReason._(super.value, super.name);
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

  static final $core.List<CallEndedReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CallEndedReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CallEndedReason._(super.value, super.name);
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

  static final $core.List<WebsocketReconnectStrategy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static WebsocketReconnectStrategy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WebsocketReconnectStrategy._(super.value, super.name);
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

  static final $core.List<AndroidThermalState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static AndroidThermalState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AndroidThermalState._(super.value, super.name);
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

  static final $core.List<AppleThermalState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AppleThermalState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AppleThermalState._(super.value, super.name);
}

/// ClientCapability defines a feature that client supports
class ClientCapability extends $pb.ProtobufEnum {
  static const ClientCapability CLIENT_CAPABILITY_UNSPECIFIED =
      ClientCapability._(
          0, _omitEnumNames ? '' : 'CLIENT_CAPABILITY_UNSPECIFIED');

  /// Enables SFU pausing inbound video
  static const ClientCapability CLIENT_CAPABILITY_SUBSCRIBER_VIDEO_PAUSE =
      ClientCapability._(
          1, _omitEnumNames ? '' : 'CLIENT_CAPABILITY_SUBSCRIBER_VIDEO_PAUSE');

  static const $core.List<ClientCapability> values = <ClientCapability>[
    CLIENT_CAPABILITY_UNSPECIFIED,
    CLIENT_CAPABILITY_SUBSCRIBER_VIDEO_PAUSE,
  ];

  static final $core.List<ClientCapability?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static ClientCapability? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ClientCapability._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
