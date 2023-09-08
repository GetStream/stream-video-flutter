///
//  Generated code. Do not modify.
//  source: video/sfu/models/models.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class PeerType extends $pb.ProtobufEnum {
  static const PeerType PEER_TYPE_PUBLISHER_UNSPECIFIED = PeerType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PEER_TYPE_PUBLISHER_UNSPECIFIED');
  static const PeerType PEER_TYPE_SUBSCRIBER = PeerType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PEER_TYPE_SUBSCRIBER');

  static const $core.List<PeerType> values = <PeerType> [
    PEER_TYPE_PUBLISHER_UNSPECIFIED,
    PEER_TYPE_SUBSCRIBER,
  ];

  static final $core.Map<$core.int, PeerType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PeerType? valueOf($core.int value) => _byValue[value];

  const PeerType._($core.int v, $core.String n) : super(v, n);
}

class ConnectionQuality extends $pb.ProtobufEnum {
  static const ConnectionQuality CONNECTION_QUALITY_UNSPECIFIED = ConnectionQuality._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONNECTION_QUALITY_UNSPECIFIED');
  static const ConnectionQuality CONNECTION_QUALITY_POOR = ConnectionQuality._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONNECTION_QUALITY_POOR');
  static const ConnectionQuality CONNECTION_QUALITY_GOOD = ConnectionQuality._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONNECTION_QUALITY_GOOD');
  static const ConnectionQuality CONNECTION_QUALITY_EXCELLENT = ConnectionQuality._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONNECTION_QUALITY_EXCELLENT');

  static const $core.List<ConnectionQuality> values = <ConnectionQuality> [
    CONNECTION_QUALITY_UNSPECIFIED,
    CONNECTION_QUALITY_POOR,
    CONNECTION_QUALITY_GOOD,
    CONNECTION_QUALITY_EXCELLENT,
  ];

  static final $core.Map<$core.int, ConnectionQuality> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ConnectionQuality? valueOf($core.int value) => _byValue[value];

  const ConnectionQuality._($core.int v, $core.String n) : super(v, n);
}

class VideoQuality extends $pb.ProtobufEnum {
  static const VideoQuality VIDEO_QUALITY_LOW_UNSPECIFIED = VideoQuality._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VIDEO_QUALITY_LOW_UNSPECIFIED');
  static const VideoQuality VIDEO_QUALITY_MID = VideoQuality._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VIDEO_QUALITY_MID');
  static const VideoQuality VIDEO_QUALITY_HIGH = VideoQuality._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VIDEO_QUALITY_HIGH');
  static const VideoQuality VIDEO_QUALITY_OFF = VideoQuality._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VIDEO_QUALITY_OFF');

  static const $core.List<VideoQuality> values = <VideoQuality> [
    VIDEO_QUALITY_LOW_UNSPECIFIED,
    VIDEO_QUALITY_MID,
    VIDEO_QUALITY_HIGH,
    VIDEO_QUALITY_OFF,
  ];

  static final $core.Map<$core.int, VideoQuality> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VideoQuality? valueOf($core.int value) => _byValue[value];

  const VideoQuality._($core.int v, $core.String n) : super(v, n);
}

class TrackType extends $pb.ProtobufEnum {
  static const TrackType TRACK_TYPE_UNSPECIFIED = TrackType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TRACK_TYPE_UNSPECIFIED');
  static const TrackType TRACK_TYPE_AUDIO = TrackType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TRACK_TYPE_AUDIO');
  static const TrackType TRACK_TYPE_VIDEO = TrackType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TRACK_TYPE_VIDEO');
  static const TrackType TRACK_TYPE_SCREEN_SHARE = TrackType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TRACK_TYPE_SCREEN_SHARE');
  static const TrackType TRACK_TYPE_SCREEN_SHARE_AUDIO = TrackType._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TRACK_TYPE_SCREEN_SHARE_AUDIO');

  static const $core.List<TrackType> values = <TrackType> [
    TRACK_TYPE_UNSPECIFIED,
    TRACK_TYPE_AUDIO,
    TRACK_TYPE_VIDEO,
    TRACK_TYPE_SCREEN_SHARE,
    TRACK_TYPE_SCREEN_SHARE_AUDIO,
  ];

  static final $core.Map<$core.int, TrackType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TrackType? valueOf($core.int value) => _byValue[value];

  const TrackType._($core.int v, $core.String n) : super(v, n);
}

class ErrorCode extends $pb.ProtobufEnum {
  static const ErrorCode ERROR_CODE_UNSPECIFIED = ErrorCode._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_UNSPECIFIED');
  static const ErrorCode ERROR_CODE_PUBLISH_TRACK_NOT_FOUND = ErrorCode._(100, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_PUBLISH_TRACK_NOT_FOUND');
  static const ErrorCode ERROR_CODE_PUBLISH_TRACKS_MISMATCH = ErrorCode._(101, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_PUBLISH_TRACKS_MISMATCH');
  static const ErrorCode ERROR_CODE_PUBLISH_TRACK_OUT_OF_ORDER = ErrorCode._(102, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_PUBLISH_TRACK_OUT_OF_ORDER');
  static const ErrorCode ERROR_CODE_PUBLISH_TRACK_VIDEO_LAYER_NOT_FOUND = ErrorCode._(103, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_PUBLISH_TRACK_VIDEO_LAYER_NOT_FOUND');
  static const ErrorCode ERROR_CODE_LIVE_ENDED = ErrorCode._(104, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_LIVE_ENDED');
  static const ErrorCode ERROR_CODE_PARTICIPANT_NOT_FOUND = ErrorCode._(200, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_PARTICIPANT_NOT_FOUND');
  static const ErrorCode ERROR_CODE_PARTICIPANT_MIGRATING_OUT = ErrorCode._(201, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_PARTICIPANT_MIGRATING_OUT');
  static const ErrorCode ERROR_CODE_PARTICIPANT_MIGRATION_FAILED = ErrorCode._(202, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_PARTICIPANT_MIGRATION_FAILED');
  static const ErrorCode ERROR_CODE_PARTICIPANT_MIGRATING = ErrorCode._(203, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_PARTICIPANT_MIGRATING');
  static const ErrorCode ERROR_CODE_PARTICIPANT_RECONNECT_FAILED = ErrorCode._(204, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_PARTICIPANT_RECONNECT_FAILED');
  static const ErrorCode ERROR_CODE_PARTICIPANT_MEDIA_TRANSPORT_FAILURE = ErrorCode._(205, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_PARTICIPANT_MEDIA_TRANSPORT_FAILURE');
  static const ErrorCode ERROR_CODE_CALL_NOT_FOUND = ErrorCode._(300, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_CALL_NOT_FOUND');
  static const ErrorCode ERROR_CODE_REQUEST_VALIDATION_FAILED = ErrorCode._(400, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_REQUEST_VALIDATION_FAILED');
  static const ErrorCode ERROR_CODE_UNAUTHENTICATED = ErrorCode._(401, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_UNAUTHENTICATED');
  static const ErrorCode ERROR_CODE_PERMISSION_DENIED = ErrorCode._(403, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_PERMISSION_DENIED');
  static const ErrorCode ERROR_CODE_TOO_MANY_REQUESTS = ErrorCode._(429, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_TOO_MANY_REQUESTS');
  static const ErrorCode ERROR_CODE_INTERNAL_SERVER_ERROR = ErrorCode._(500, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_INTERNAL_SERVER_ERROR');
  static const ErrorCode ERROR_CODE_SFU_SHUTTING_DOWN = ErrorCode._(600, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_SFU_SHUTTING_DOWN');
  static const ErrorCode ERROR_CODE_SFU_FULL = ErrorCode._(700, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ERROR_CODE_SFU_FULL');

  static const $core.List<ErrorCode> values = <ErrorCode> [
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

  static final $core.Map<$core.int, ErrorCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ErrorCode? valueOf($core.int value) => _byValue[value];

  const ErrorCode._($core.int v, $core.String n) : super(v, n);
}

class SdkType extends $pb.ProtobufEnum {
  static const SdkType SDK_TYPE_UNSPECIFIED = SdkType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SDK_TYPE_UNSPECIFIED');
  static const SdkType SDK_TYPE_REACT = SdkType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SDK_TYPE_REACT');
  static const SdkType SDK_TYPE_ANGULAR = SdkType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SDK_TYPE_ANGULAR');
  static const SdkType SDK_TYPE_ANDROID = SdkType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SDK_TYPE_ANDROID');
  static const SdkType SDK_TYPE_IOS = SdkType._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SDK_TYPE_IOS');
  static const SdkType SDK_TYPE_FLUTTER = SdkType._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SDK_TYPE_FLUTTER');
  static const SdkType SDK_TYPE_REACT_NATIVE = SdkType._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SDK_TYPE_REACT_NATIVE');
  static const SdkType SDK_TYPE_UNITY = SdkType._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SDK_TYPE_UNITY');

  static const $core.List<SdkType> values = <SdkType> [
    SDK_TYPE_UNSPECIFIED,
    SDK_TYPE_REACT,
    SDK_TYPE_ANGULAR,
    SDK_TYPE_ANDROID,
    SDK_TYPE_IOS,
    SDK_TYPE_FLUTTER,
    SDK_TYPE_REACT_NATIVE,
    SDK_TYPE_UNITY,
  ];

  static final $core.Map<$core.int, SdkType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SdkType? valueOf($core.int value) => _byValue[value];

  const SdkType._($core.int v, $core.String n) : super(v, n);
}

class TrackUnpublishReason extends $pb.ProtobufEnum {
  static const TrackUnpublishReason TRACK_UNPUBLISH_REASON_UNSPECIFIED = TrackUnpublishReason._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TRACK_UNPUBLISH_REASON_UNSPECIFIED');
  static const TrackUnpublishReason TRACK_UNPUBLISH_REASON_USER_MUTED = TrackUnpublishReason._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TRACK_UNPUBLISH_REASON_USER_MUTED');
  static const TrackUnpublishReason TRACK_UNPUBLISH_REASON_PERMISSION_REVOKED = TrackUnpublishReason._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TRACK_UNPUBLISH_REASON_PERMISSION_REVOKED');
  static const TrackUnpublishReason TRACK_UNPUBLISH_REASON_MODERATION = TrackUnpublishReason._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TRACK_UNPUBLISH_REASON_MODERATION');

  static const $core.List<TrackUnpublishReason> values = <TrackUnpublishReason> [
    TRACK_UNPUBLISH_REASON_UNSPECIFIED,
    TRACK_UNPUBLISH_REASON_USER_MUTED,
    TRACK_UNPUBLISH_REASON_PERMISSION_REVOKED,
    TRACK_UNPUBLISH_REASON_MODERATION,
  ];

  static final $core.Map<$core.int, TrackUnpublishReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TrackUnpublishReason? valueOf($core.int value) => _byValue[value];

  const TrackUnpublishReason._($core.int v, $core.String n) : super(v, n);
}

class GoAwayReason extends $pb.ProtobufEnum {
  static const GoAwayReason GO_AWAY_REASON_UNSPECIFIED = GoAwayReason._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GO_AWAY_REASON_UNSPECIFIED');
  static const GoAwayReason GO_AWAY_REASON_SHUTTING_DOWN = GoAwayReason._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GO_AWAY_REASON_SHUTTING_DOWN');
  static const GoAwayReason GO_AWAY_REASON_REBALANCE = GoAwayReason._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GO_AWAY_REASON_REBALANCE');

  static const $core.List<GoAwayReason> values = <GoAwayReason> [
    GO_AWAY_REASON_UNSPECIFIED,
    GO_AWAY_REASON_SHUTTING_DOWN,
    GO_AWAY_REASON_REBALANCE,
  ];

  static final $core.Map<$core.int, GoAwayReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GoAwayReason? valueOf($core.int value) => _byValue[value];

  const GoAwayReason._($core.int v, $core.String n) : super(v, n);
}

