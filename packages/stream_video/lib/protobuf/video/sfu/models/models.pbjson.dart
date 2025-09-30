// This is a generated file - do not edit.
//
// Generated from video/sfu/models/models.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use peerTypeDescriptor instead')
const PeerType$json = {
  '1': 'PeerType',
  '2': [
    {'1': 'PEER_TYPE_PUBLISHER_UNSPECIFIED', '2': 0},
    {'1': 'PEER_TYPE_SUBSCRIBER', '2': 1},
  ],
};

/// Descriptor for `PeerType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List peerTypeDescriptor = $convert.base64Decode(
    'CghQZWVyVHlwZRIjCh9QRUVSX1RZUEVfUFVCTElTSEVSX1VOU1BFQ0lGSUVEEAASGAoUUEVFUl'
    '9UWVBFX1NVQlNDUklCRVIQAQ==');

@$core.Deprecated('Use connectionQualityDescriptor instead')
const ConnectionQuality$json = {
  '1': 'ConnectionQuality',
  '2': [
    {'1': 'CONNECTION_QUALITY_UNSPECIFIED', '2': 0},
    {'1': 'CONNECTION_QUALITY_POOR', '2': 1},
    {'1': 'CONNECTION_QUALITY_GOOD', '2': 2},
    {'1': 'CONNECTION_QUALITY_EXCELLENT', '2': 3},
  ],
};

/// Descriptor for `ConnectionQuality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List connectionQualityDescriptor = $convert.base64Decode(
    'ChFDb25uZWN0aW9uUXVhbGl0eRIiCh5DT05ORUNUSU9OX1FVQUxJVFlfVU5TUEVDSUZJRUQQAB'
    'IbChdDT05ORUNUSU9OX1FVQUxJVFlfUE9PUhABEhsKF0NPTk5FQ1RJT05fUVVBTElUWV9HT09E'
    'EAISIAocQ09OTkVDVElPTl9RVUFMSVRZX0VYQ0VMTEVOVBAD');

@$core.Deprecated('Use videoQualityDescriptor instead')
const VideoQuality$json = {
  '1': 'VideoQuality',
  '2': [
    {'1': 'VIDEO_QUALITY_LOW_UNSPECIFIED', '2': 0},
    {'1': 'VIDEO_QUALITY_MID', '2': 1},
    {'1': 'VIDEO_QUALITY_HIGH', '2': 2},
    {'1': 'VIDEO_QUALITY_OFF', '2': 3},
  ],
};

/// Descriptor for `VideoQuality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List videoQualityDescriptor = $convert.base64Decode(
    'CgxWaWRlb1F1YWxpdHkSIQodVklERU9fUVVBTElUWV9MT1dfVU5TUEVDSUZJRUQQABIVChFWSU'
    'RFT19RVUFMSVRZX01JRBABEhYKElZJREVPX1FVQUxJVFlfSElHSBACEhUKEVZJREVPX1FVQUxJ'
    'VFlfT0ZGEAM=');

@$core.Deprecated('Use trackTypeDescriptor instead')
const TrackType$json = {
  '1': 'TrackType',
  '2': [
    {'1': 'TRACK_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'TRACK_TYPE_AUDIO', '2': 1},
    {'1': 'TRACK_TYPE_VIDEO', '2': 2},
    {'1': 'TRACK_TYPE_SCREEN_SHARE', '2': 3},
    {'1': 'TRACK_TYPE_SCREEN_SHARE_AUDIO', '2': 4},
  ],
};

/// Descriptor for `TrackType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List trackTypeDescriptor = $convert.base64Decode(
    'CglUcmFja1R5cGUSGgoWVFJBQ0tfVFlQRV9VTlNQRUNJRklFRBAAEhQKEFRSQUNLX1RZUEVfQV'
    'VESU8QARIUChBUUkFDS19UWVBFX1ZJREVPEAISGwoXVFJBQ0tfVFlQRV9TQ1JFRU5fU0hBUkUQ'
    'AxIhCh1UUkFDS19UWVBFX1NDUkVFTl9TSEFSRV9BVURJTxAE');

@$core.Deprecated('Use participantSourceDescriptor instead')
const ParticipantSource$json = {
  '1': 'ParticipantSource',
  '2': [
    {'1': 'PARTICIPANT_SOURCE_WEBRTC_UNSPECIFIED', '2': 0},
    {'1': 'PARTICIPANT_SOURCE_RTMP', '2': 1},
    {'1': 'PARTICIPANT_SOURCE_WHIP', '2': 2},
    {'1': 'PARTICIPANT_SOURCE_SIP', '2': 3},
    {'1': 'PARTICIPANT_SOURCE_RTSP', '2': 4},
    {'1': 'PARTICIPANT_SOURCE_SRT', '2': 5},
  ],
};

/// Descriptor for `ParticipantSource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List participantSourceDescriptor = $convert.base64Decode(
    'ChFQYXJ0aWNpcGFudFNvdXJjZRIpCiVQQVJUSUNJUEFOVF9TT1VSQ0VfV0VCUlRDX1VOU1BFQ0'
    'lGSUVEEAASGwoXUEFSVElDSVBBTlRfU09VUkNFX1JUTVAQARIbChdQQVJUSUNJUEFOVF9TT1VS'
    'Q0VfV0hJUBACEhoKFlBBUlRJQ0lQQU5UX1NPVVJDRV9TSVAQAxIbChdQQVJUSUNJUEFOVF9TT1'
    'VSQ0VfUlRTUBAEEhoKFlBBUlRJQ0lQQU5UX1NPVVJDRV9TUlQQBQ==');

@$core.Deprecated('Use audioBitrateProfileDescriptor instead')
const AudioBitrateProfile$json = {
  '1': 'AudioBitrateProfile',
  '2': [
    {'1': 'AUDIO_BITRATE_PROFILE_VOICE_STANDARD_UNSPECIFIED', '2': 0},
    {'1': 'AUDIO_BITRATE_PROFILE_VOICE_HIGH_QUALITY', '2': 1},
    {'1': 'AUDIO_BITRATE_PROFILE_MUSIC_HIGH_QUALITY', '2': 2},
  ],
};

/// Descriptor for `AudioBitrateProfile`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List audioBitrateProfileDescriptor = $convert.base64Decode(
    'ChNBdWRpb0JpdHJhdGVQcm9maWxlEjQKMEFVRElPX0JJVFJBVEVfUFJPRklMRV9WT0lDRV9TVE'
    'FOREFSRF9VTlNQRUNJRklFRBAAEiwKKEFVRElPX0JJVFJBVEVfUFJPRklMRV9WT0lDRV9ISUdI'
    'X1FVQUxJVFkQARIsCihBVURJT19CSVRSQVRFX1BST0ZJTEVfTVVTSUNfSElHSF9RVUFMSVRZEA'
    'I=');

@$core.Deprecated('Use errorCodeDescriptor instead')
const ErrorCode$json = {
  '1': 'ErrorCode',
  '2': [
    {'1': 'ERROR_CODE_UNSPECIFIED', '2': 0},
    {'1': 'ERROR_CODE_PUBLISH_TRACK_NOT_FOUND', '2': 100},
    {'1': 'ERROR_CODE_PUBLISH_TRACKS_MISMATCH', '2': 101},
    {'1': 'ERROR_CODE_PUBLISH_TRACK_OUT_OF_ORDER', '2': 102},
    {'1': 'ERROR_CODE_PUBLISH_TRACK_VIDEO_LAYER_NOT_FOUND', '2': 103},
    {'1': 'ERROR_CODE_LIVE_ENDED', '2': 104},
    {'1': 'ERROR_CODE_PARTICIPANT_NOT_FOUND', '2': 200},
    {'1': 'ERROR_CODE_PARTICIPANT_MIGRATING_OUT', '2': 201},
    {'1': 'ERROR_CODE_PARTICIPANT_MIGRATION_FAILED', '2': 202},
    {'1': 'ERROR_CODE_PARTICIPANT_MIGRATING', '2': 203},
    {'1': 'ERROR_CODE_PARTICIPANT_RECONNECT_FAILED', '2': 204},
    {'1': 'ERROR_CODE_PARTICIPANT_MEDIA_TRANSPORT_FAILURE', '2': 205},
    {'1': 'ERROR_CODE_PARTICIPANT_SIGNAL_LOST', '2': 206},
    {'1': 'ERROR_CODE_CALL_NOT_FOUND', '2': 300},
    {'1': 'ERROR_CODE_CALL_PARTICIPANT_LIMIT_REACHED', '2': 301},
    {'1': 'ERROR_CODE_REQUEST_VALIDATION_FAILED', '2': 400},
    {'1': 'ERROR_CODE_UNAUTHENTICATED', '2': 401},
    {'1': 'ERROR_CODE_PERMISSION_DENIED', '2': 403},
    {'1': 'ERROR_CODE_TOO_MANY_REQUESTS', '2': 429},
    {'1': 'ERROR_CODE_INTERNAL_SERVER_ERROR', '2': 500},
    {'1': 'ERROR_CODE_SFU_SHUTTING_DOWN', '2': 600},
    {'1': 'ERROR_CODE_SFU_FULL', '2': 700},
  ],
};

/// Descriptor for `ErrorCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List errorCodeDescriptor = $convert.base64Decode(
    'CglFcnJvckNvZGUSGgoWRVJST1JfQ09ERV9VTlNQRUNJRklFRBAAEiYKIkVSUk9SX0NPREVfUF'
    'VCTElTSF9UUkFDS19OT1RfRk9VTkQQZBImCiJFUlJPUl9DT0RFX1BVQkxJU0hfVFJBQ0tTX01J'
    'U01BVENIEGUSKQolRVJST1JfQ09ERV9QVUJMSVNIX1RSQUNLX09VVF9PRl9PUkRFUhBmEjIKLk'
    'VSUk9SX0NPREVfUFVCTElTSF9UUkFDS19WSURFT19MQVlFUl9OT1RfRk9VTkQQZxIZChVFUlJP'
    'Ul9DT0RFX0xJVkVfRU5ERUQQaBIlCiBFUlJPUl9DT0RFX1BBUlRJQ0lQQU5UX05PVF9GT1VORB'
    'DIARIpCiRFUlJPUl9DT0RFX1BBUlRJQ0lQQU5UX01JR1JBVElOR19PVVQQyQESLAonRVJST1Jf'
    'Q09ERV9QQVJUSUNJUEFOVF9NSUdSQVRJT05fRkFJTEVEEMoBEiUKIEVSUk9SX0NPREVfUEFSVE'
    'lDSVBBTlRfTUlHUkFUSU5HEMsBEiwKJ0VSUk9SX0NPREVfUEFSVElDSVBBTlRfUkVDT05ORUNU'
    'X0ZBSUxFRBDMARIzCi5FUlJPUl9DT0RFX1BBUlRJQ0lQQU5UX01FRElBX1RSQU5TUE9SVF9GQU'
    'lMVVJFEM0BEicKIkVSUk9SX0NPREVfUEFSVElDSVBBTlRfU0lHTkFMX0xPU1QQzgESHgoZRVJS'
    'T1JfQ09ERV9DQUxMX05PVF9GT1VORBCsAhIuCilFUlJPUl9DT0RFX0NBTExfUEFSVElDSVBBTl'
    'RfTElNSVRfUkVBQ0hFRBCtAhIpCiRFUlJPUl9DT0RFX1JFUVVFU1RfVkFMSURBVElPTl9GQUlM'
    'RUQQkAMSHwoaRVJST1JfQ09ERV9VTkFVVEhFTlRJQ0FURUQQkQMSIQocRVJST1JfQ09ERV9QRV'
    'JNSVNTSU9OX0RFTklFRBCTAxIhChxFUlJPUl9DT0RFX1RPT19NQU5ZX1JFUVVFU1RTEK0DEiUK'
    'IEVSUk9SX0NPREVfSU5URVJOQUxfU0VSVkVSX0VSUk9SEPQDEiEKHEVSUk9SX0NPREVfU0ZVX1'
    'NIVVRUSU5HX0RPV04Q2AQSGAoTRVJST1JfQ09ERV9TRlVfRlVMTBC8BQ==');

@$core.Deprecated('Use sdkTypeDescriptor instead')
const SdkType$json = {
  '1': 'SdkType',
  '2': [
    {'1': 'SDK_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'SDK_TYPE_REACT', '2': 1},
    {'1': 'SDK_TYPE_ANGULAR', '2': 2},
    {'1': 'SDK_TYPE_ANDROID', '2': 3},
    {'1': 'SDK_TYPE_IOS', '2': 4},
    {'1': 'SDK_TYPE_FLUTTER', '2': 5},
    {'1': 'SDK_TYPE_REACT_NATIVE', '2': 6},
    {'1': 'SDK_TYPE_UNITY', '2': 7},
    {'1': 'SDK_TYPE_GO', '2': 8},
    {'1': 'SDK_TYPE_PLAIN_JAVASCRIPT', '2': 9},
  ],
};

/// Descriptor for `SdkType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sdkTypeDescriptor = $convert.base64Decode(
    'CgdTZGtUeXBlEhgKFFNES19UWVBFX1VOU1BFQ0lGSUVEEAASEgoOU0RLX1RZUEVfUkVBQ1QQAR'
    'IUChBTREtfVFlQRV9BTkdVTEFSEAISFAoQU0RLX1RZUEVfQU5EUk9JRBADEhAKDFNES19UWVBF'
    'X0lPUxAEEhQKEFNES19UWVBFX0ZMVVRURVIQBRIZChVTREtfVFlQRV9SRUFDVF9OQVRJVkUQBh'
    'ISCg5TREtfVFlQRV9VTklUWRAHEg8KC1NES19UWVBFX0dPEAgSHQoZU0RLX1RZUEVfUExBSU5f'
    'SkFWQVNDUklQVBAJ');

@$core.Deprecated('Use trackUnpublishReasonDescriptor instead')
const TrackUnpublishReason$json = {
  '1': 'TrackUnpublishReason',
  '2': [
    {'1': 'TRACK_UNPUBLISH_REASON_UNSPECIFIED', '2': 0},
    {'1': 'TRACK_UNPUBLISH_REASON_USER_MUTED', '2': 1},
    {'1': 'TRACK_UNPUBLISH_REASON_PERMISSION_REVOKED', '2': 2},
    {'1': 'TRACK_UNPUBLISH_REASON_MODERATION', '2': 3},
  ],
};

/// Descriptor for `TrackUnpublishReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List trackUnpublishReasonDescriptor = $convert.base64Decode(
    'ChRUcmFja1VucHVibGlzaFJlYXNvbhImCiJUUkFDS19VTlBVQkxJU0hfUkVBU09OX1VOU1BFQ0'
    'lGSUVEEAASJQohVFJBQ0tfVU5QVUJMSVNIX1JFQVNPTl9VU0VSX01VVEVEEAESLQopVFJBQ0tf'
    'VU5QVUJMSVNIX1JFQVNPTl9QRVJNSVNTSU9OX1JFVk9LRUQQAhIlCiFUUkFDS19VTlBVQkxJU0'
    'hfUkVBU09OX01PREVSQVRJT04QAw==');

@$core.Deprecated('Use goAwayReasonDescriptor instead')
const GoAwayReason$json = {
  '1': 'GoAwayReason',
  '2': [
    {'1': 'GO_AWAY_REASON_UNSPECIFIED', '2': 0},
    {'1': 'GO_AWAY_REASON_SHUTTING_DOWN', '2': 1},
    {'1': 'GO_AWAY_REASON_REBALANCE', '2': 2},
  ],
};

/// Descriptor for `GoAwayReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List goAwayReasonDescriptor = $convert.base64Decode(
    'CgxHb0F3YXlSZWFzb24SHgoaR09fQVdBWV9SRUFTT05fVU5TUEVDSUZJRUQQABIgChxHT19BV0'
    'FZX1JFQVNPTl9TSFVUVElOR19ET1dOEAESHAoYR09fQVdBWV9SRUFTT05fUkVCQUxBTkNFEAI=');

@$core.Deprecated('Use callEndedReasonDescriptor instead')
const CallEndedReason$json = {
  '1': 'CallEndedReason',
  '2': [
    {'1': 'CALL_ENDED_REASON_UNSPECIFIED', '2': 0},
    {'1': 'CALL_ENDED_REASON_ENDED', '2': 1},
    {'1': 'CALL_ENDED_REASON_LIVE_ENDED', '2': 2},
    {'1': 'CALL_ENDED_REASON_KICKED', '2': 3},
    {'1': 'CALL_ENDED_REASON_SESSION_ENDED', '2': 4},
  ],
};

/// Descriptor for `CallEndedReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List callEndedReasonDescriptor = $convert.base64Decode(
    'Cg9DYWxsRW5kZWRSZWFzb24SIQodQ0FMTF9FTkRFRF9SRUFTT05fVU5TUEVDSUZJRUQQABIbCh'
    'dDQUxMX0VOREVEX1JFQVNPTl9FTkRFRBABEiAKHENBTExfRU5ERURfUkVBU09OX0xJVkVfRU5E'
    'RUQQAhIcChhDQUxMX0VOREVEX1JFQVNPTl9LSUNLRUQQAxIjCh9DQUxMX0VOREVEX1JFQVNPTl'
    '9TRVNTSU9OX0VOREVEEAQ=');

@$core.Deprecated('Use websocketReconnectStrategyDescriptor instead')
const WebsocketReconnectStrategy$json = {
  '1': 'WebsocketReconnectStrategy',
  '2': [
    {'1': 'WEBSOCKET_RECONNECT_STRATEGY_UNSPECIFIED', '2': 0},
    {'1': 'WEBSOCKET_RECONNECT_STRATEGY_DISCONNECT', '2': 1},
    {'1': 'WEBSOCKET_RECONNECT_STRATEGY_FAST', '2': 2},
    {'1': 'WEBSOCKET_RECONNECT_STRATEGY_REJOIN', '2': 3},
    {'1': 'WEBSOCKET_RECONNECT_STRATEGY_MIGRATE', '2': 4},
  ],
};

/// Descriptor for `WebsocketReconnectStrategy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List websocketReconnectStrategyDescriptor = $convert.base64Decode(
    'ChpXZWJzb2NrZXRSZWNvbm5lY3RTdHJhdGVneRIsCihXRUJTT0NLRVRfUkVDT05ORUNUX1NUUk'
    'FURUdZX1VOU1BFQ0lGSUVEEAASKwonV0VCU09DS0VUX1JFQ09OTkVDVF9TVFJBVEVHWV9ESVND'
    'T05ORUNUEAESJQohV0VCU09DS0VUX1JFQ09OTkVDVF9TVFJBVEVHWV9GQVNUEAISJwojV0VCU0'
    '9DS0VUX1JFQ09OTkVDVF9TVFJBVEVHWV9SRUpPSU4QAxIoCiRXRUJTT0NLRVRfUkVDT05ORUNU'
    'X1NUUkFURUdZX01JR1JBVEUQBA==');

@$core.Deprecated('Use androidThermalStateDescriptor instead')
const AndroidThermalState$json = {
  '1': 'AndroidThermalState',
  '2': [
    {'1': 'ANDROID_THERMAL_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ANDROID_THERMAL_STATE_NONE', '2': 1},
    {'1': 'ANDROID_THERMAL_STATE_LIGHT', '2': 2},
    {'1': 'ANDROID_THERMAL_STATE_MODERATE', '2': 3},
    {'1': 'ANDROID_THERMAL_STATE_SEVERE', '2': 4},
    {'1': 'ANDROID_THERMAL_STATE_CRITICAL', '2': 5},
    {'1': 'ANDROID_THERMAL_STATE_EMERGENCY', '2': 6},
    {'1': 'ANDROID_THERMAL_STATE_SHUTDOWN', '2': 7},
  ],
};

/// Descriptor for `AndroidThermalState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List androidThermalStateDescriptor = $convert.base64Decode(
    'ChNBbmRyb2lkVGhlcm1hbFN0YXRlEiUKIUFORFJPSURfVEhFUk1BTF9TVEFURV9VTlNQRUNJRk'
    'lFRBAAEh4KGkFORFJPSURfVEhFUk1BTF9TVEFURV9OT05FEAESHwobQU5EUk9JRF9USEVSTUFM'
    'X1NUQVRFX0xJR0hUEAISIgoeQU5EUk9JRF9USEVSTUFMX1NUQVRFX01PREVSQVRFEAMSIAocQU'
    '5EUk9JRF9USEVSTUFMX1NUQVRFX1NFVkVSRRAEEiIKHkFORFJPSURfVEhFUk1BTF9TVEFURV9D'
    'UklUSUNBTBAFEiMKH0FORFJPSURfVEhFUk1BTF9TVEFURV9FTUVSR0VOQ1kQBhIiCh5BTkRST0'
    'lEX1RIRVJNQUxfU1RBVEVfU0hVVERPV04QBw==');

@$core.Deprecated('Use appleThermalStateDescriptor instead')
const AppleThermalState$json = {
  '1': 'AppleThermalState',
  '2': [
    {'1': 'APPLE_THERMAL_STATE_UNSPECIFIED', '2': 0},
    {'1': 'APPLE_THERMAL_STATE_NOMINAL', '2': 1},
    {'1': 'APPLE_THERMAL_STATE_FAIR', '2': 2},
    {'1': 'APPLE_THERMAL_STATE_SERIOUS', '2': 3},
    {'1': 'APPLE_THERMAL_STATE_CRITICAL', '2': 4},
  ],
};

/// Descriptor for `AppleThermalState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List appleThermalStateDescriptor = $convert.base64Decode(
    'ChFBcHBsZVRoZXJtYWxTdGF0ZRIjCh9BUFBMRV9USEVSTUFMX1NUQVRFX1VOU1BFQ0lGSUVEEA'
    'ASHwobQVBQTEVfVEhFUk1BTF9TVEFURV9OT01JTkFMEAESHAoYQVBQTEVfVEhFUk1BTF9TVEFU'
    'RV9GQUlSEAISHwobQVBQTEVfVEhFUk1BTF9TVEFURV9TRVJJT1VTEAMSIAocQVBQTEVfVEhFUk'
    '1BTF9TVEFURV9DUklUSUNBTBAE');

@$core.Deprecated('Use clientCapabilityDescriptor instead')
const ClientCapability$json = {
  '1': 'ClientCapability',
  '2': [
    {'1': 'CLIENT_CAPABILITY_UNSPECIFIED', '2': 0},
    {'1': 'CLIENT_CAPABILITY_SUBSCRIBER_VIDEO_PAUSE', '2': 1},
  ],
};

/// Descriptor for `ClientCapability`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List clientCapabilityDescriptor = $convert.base64Decode(
    'ChBDbGllbnRDYXBhYmlsaXR5EiEKHUNMSUVOVF9DQVBBQklMSVRZX1VOU1BFQ0lGSUVEEAASLA'
    'ooQ0xJRU5UX0NBUEFCSUxJVFlfU1VCU0NSSUJFUl9WSURFT19QQVVTRRAB');

@$core.Deprecated('Use callStateDescriptor instead')
const CallState$json = {
  '1': 'CallState',
  '2': [
    {
      '1': 'participants',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.stream.video.sfu.models.Participant',
      '10': 'participants'
    },
    {
      '1': 'started_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'participant_count',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.stream.video.sfu.models.ParticipantCount',
      '10': 'participantCount'
    },
    {
      '1': 'pins',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.stream.video.sfu.models.Pin',
      '10': 'pins'
    },
  ],
};

/// Descriptor for `CallState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callStateDescriptor = $convert.base64Decode(
    'CglDYWxsU3RhdGUSSAoMcGFydGljaXBhbnRzGAEgAygLMiQuc3RyZWFtLnZpZGVvLnNmdS5tb2'
    'RlbHMuUGFydGljaXBhbnRSDHBhcnRpY2lwYW50cxI5CgpzdGFydGVkX2F0GAIgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0ElYKEXBhcnRpY2lwYW50X2NvdW50GA'
    'MgASgLMikuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuUGFydGljaXBhbnRDb3VudFIQcGFydGlj'
    'aXBhbnRDb3VudBIwCgRwaW5zGAQgAygLMhwuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuUGluUg'
    'RwaW5z');

@$core.Deprecated('Use participantCountDescriptor instead')
const ParticipantCount$json = {
  '1': 'ParticipantCount',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    {'1': 'anonymous', '3': 2, '4': 1, '5': 13, '10': 'anonymous'},
  ],
};

/// Descriptor for `ParticipantCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantCountDescriptor = $convert.base64Decode(
    'ChBQYXJ0aWNpcGFudENvdW50EhQKBXRvdGFsGAEgASgNUgV0b3RhbBIcCglhbm9ueW1vdXMYAi'
    'ABKA1SCWFub255bW91cw==');

@$core.Deprecated('Use pinDescriptor instead')
const Pin$json = {
  '1': 'Pin',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `Pin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pinDescriptor = $convert.base64Decode(
    'CgNQaW4SFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEh0KCnNlc3Npb25faWQYAiABKAlSCXNlc3'
    'Npb25JZA==');

@$core.Deprecated('Use participantDescriptor instead')
const Participant$json = {
  '1': 'Participant',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'published_tracks',
      '3': 3,
      '4': 3,
      '5': 14,
      '6': '.stream.video.sfu.models.TrackType',
      '10': 'publishedTracks'
    },
    {
      '1': 'joined_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'joinedAt'
    },
    {
      '1': 'track_lookup_prefix',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'trackLookupPrefix'
    },
    {
      '1': 'connection_quality',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.ConnectionQuality',
      '10': 'connectionQuality'
    },
    {'1': 'is_speaking', '3': 7, '4': 1, '5': 8, '10': 'isSpeaking'},
    {
      '1': 'is_dominant_speaker',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'isDominantSpeaker'
    },
    {'1': 'audio_level', '3': 9, '4': 1, '5': 2, '10': 'audioLevel'},
    {'1': 'name', '3': 10, '4': 1, '5': 9, '10': 'name'},
    {'1': 'image', '3': 11, '4': 1, '5': 9, '10': 'image'},
    {
      '1': 'custom',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'custom'
    },
    {'1': 'roles', '3': 13, '4': 3, '5': 9, '10': 'roles'},
    {
      '1': 'source',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.ParticipantSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `Participant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantDescriptor = $convert.base64Decode(
    'CgtQYXJ0aWNpcGFudBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSHQoKc2Vzc2lvbl9pZBgCIA'
    'EoCVIJc2Vzc2lvbklkEk0KEHB1Ymxpc2hlZF90cmFja3MYAyADKA4yIi5zdHJlYW0udmlkZW8u'
    'c2Z1Lm1vZGVscy5UcmFja1R5cGVSD3B1Ymxpc2hlZFRyYWNrcxI3Cglqb2luZWRfYXQYBCABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghqb2luZWRBdBIuChN0cmFja19sb29rdXBf'
    'cHJlZml4GAUgASgJUhF0cmFja0xvb2t1cFByZWZpeBJZChJjb25uZWN0aW9uX3F1YWxpdHkYBi'
    'ABKA4yKi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5Db25uZWN0aW9uUXVhbGl0eVIRY29ubmVj'
    'dGlvblF1YWxpdHkSHwoLaXNfc3BlYWtpbmcYByABKAhSCmlzU3BlYWtpbmcSLgoTaXNfZG9taW'
    '5hbnRfc3BlYWtlchgIIAEoCFIRaXNEb21pbmFudFNwZWFrZXISHwoLYXVkaW9fbGV2ZWwYCSAB'
    'KAJSCmF1ZGlvTGV2ZWwSEgoEbmFtZRgKIAEoCVIEbmFtZRIUCgVpbWFnZRgLIAEoCVIFaW1hZ2'
    'USLwoGY3VzdG9tGAwgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIGY3VzdG9tEhQKBXJv'
    'bGVzGA0gAygJUgVyb2xlcxJCCgZzb3VyY2UYDiABKA4yKi5zdHJlYW0udmlkZW8uc2Z1Lm1vZG'
    'Vscy5QYXJ0aWNpcGFudFNvdXJjZVIGc291cmNl');

@$core.Deprecated('Use streamQualityDescriptor instead')
const StreamQuality$json = {
  '1': 'StreamQuality',
  '2': [
    {
      '1': 'video_quality',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.VideoQuality',
      '10': 'videoQuality'
    },
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `StreamQuality`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamQualityDescriptor = $convert.base64Decode(
    'Cg1TdHJlYW1RdWFsaXR5EkoKDXZpZGVvX3F1YWxpdHkYASABKA4yJS5zdHJlYW0udmlkZW8uc2'
    'Z1Lm1vZGVscy5WaWRlb1F1YWxpdHlSDHZpZGVvUXVhbGl0eRIXCgd1c2VyX2lkGAIgASgJUgZ1'
    'c2VySWQ=');

@$core.Deprecated('Use videoDimensionDescriptor instead')
const VideoDimension$json = {
  '1': 'VideoDimension',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 13, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 13, '10': 'height'},
  ],
};

/// Descriptor for `VideoDimension`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoDimensionDescriptor = $convert.base64Decode(
    'Cg5WaWRlb0RpbWVuc2lvbhIUCgV3aWR0aBgBIAEoDVIFd2lkdGgSFgoGaGVpZ2h0GAIgASgNUg'
    'ZoZWlnaHQ=');

@$core.Deprecated('Use videoLayerDescriptor instead')
const VideoLayer$json = {
  '1': 'VideoLayer',
  '2': [
    {'1': 'rid', '3': 1, '4': 1, '5': 9, '10': 'rid'},
    {
      '1': 'video_dimension',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.sfu.models.VideoDimension',
      '10': 'videoDimension'
    },
    {'1': 'bitrate', '3': 4, '4': 1, '5': 13, '10': 'bitrate'},
    {'1': 'fps', '3': 5, '4': 1, '5': 13, '10': 'fps'},
    {
      '1': 'quality',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.VideoQuality',
      '10': 'quality'
    },
  ],
};

/// Descriptor for `VideoLayer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoLayerDescriptor = $convert.base64Decode(
    'CgpWaWRlb0xheWVyEhAKA3JpZBgBIAEoCVIDcmlkElAKD3ZpZGVvX2RpbWVuc2lvbhgCIAEoCz'
    'InLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlZpZGVvRGltZW5zaW9uUg52aWRlb0RpbWVuc2lv'
    'bhIYCgdiaXRyYXRlGAQgASgNUgdiaXRyYXRlEhAKA2ZwcxgFIAEoDVIDZnBzEj8KB3F1YWxpdH'
    'kYBiABKA4yJS5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5WaWRlb1F1YWxpdHlSB3F1YWxpdHk=');

@$core.Deprecated('Use subscribeOptionDescriptor instead')
const SubscribeOption$json = {
  '1': 'SubscribeOption',
  '2': [
    {
      '1': 'track_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.TrackType',
      '10': 'trackType'
    },
    {
      '1': 'codecs',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.stream.video.sfu.models.Codec',
      '10': 'codecs'
    },
  ],
};

/// Descriptor for `SubscribeOption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeOptionDescriptor = $convert.base64Decode(
    'Cg9TdWJzY3JpYmVPcHRpb24SQQoKdHJhY2tfdHlwZRgBIAEoDjIiLnN0cmVhbS52aWRlby5zZn'
    'UubW9kZWxzLlRyYWNrVHlwZVIJdHJhY2tUeXBlEjYKBmNvZGVjcxgCIAMoCzIeLnN0cmVhbS52'
    'aWRlby5zZnUubW9kZWxzLkNvZGVjUgZjb2RlY3M=');

@$core.Deprecated('Use publishOptionDescriptor instead')
const PublishOption$json = {
  '1': 'PublishOption',
  '2': [
    {
      '1': 'track_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.TrackType',
      '10': 'trackType'
    },
    {
      '1': 'codec',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.sfu.models.Codec',
      '10': 'codec'
    },
    {'1': 'bitrate', '3': 3, '4': 1, '5': 5, '10': 'bitrate'},
    {'1': 'fps', '3': 4, '4': 1, '5': 5, '10': 'fps'},
    {
      '1': 'max_spatial_layers',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'maxSpatialLayers'
    },
    {
      '1': 'max_temporal_layers',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'maxTemporalLayers'
    },
    {
      '1': 'video_dimension',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.stream.video.sfu.models.VideoDimension',
      '10': 'videoDimension'
    },
    {'1': 'id', '3': 8, '4': 1, '5': 5, '10': 'id'},
    {'1': 'use_single_layer', '3': 9, '4': 1, '5': 8, '10': 'useSingleLayer'},
    {
      '1': 'audio_bitrate_profiles',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.stream.video.sfu.models.AudioBitrate',
      '10': 'audioBitrateProfiles'
    },
  ],
};

/// Descriptor for `PublishOption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishOptionDescriptor = $convert.base64Decode(
    'Cg1QdWJsaXNoT3B0aW9uEkEKCnRyYWNrX3R5cGUYASABKA4yIi5zdHJlYW0udmlkZW8uc2Z1Lm'
    '1vZGVscy5UcmFja1R5cGVSCXRyYWNrVHlwZRI0CgVjb2RlYxgCIAEoCzIeLnN0cmVhbS52aWRl'
    'by5zZnUubW9kZWxzLkNvZGVjUgVjb2RlYxIYCgdiaXRyYXRlGAMgASgFUgdiaXRyYXRlEhAKA2'
    'ZwcxgEIAEoBVIDZnBzEiwKEm1heF9zcGF0aWFsX2xheWVycxgFIAEoBVIQbWF4U3BhdGlhbExh'
    'eWVycxIuChNtYXhfdGVtcG9yYWxfbGF5ZXJzGAYgASgFUhFtYXhUZW1wb3JhbExheWVycxJQCg'
    '92aWRlb19kaW1lbnNpb24YByABKAsyJy5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5WaWRlb0Rp'
    'bWVuc2lvblIOdmlkZW9EaW1lbnNpb24SDgoCaWQYCCABKAVSAmlkEigKEHVzZV9zaW5nbGVfbG'
    'F5ZXIYCSABKAhSDnVzZVNpbmdsZUxheWVyElsKFmF1ZGlvX2JpdHJhdGVfcHJvZmlsZXMYCiAD'
    'KAsyJS5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5BdWRpb0JpdHJhdGVSFGF1ZGlvQml0cmF0ZV'
    'Byb2ZpbGVz');

@$core.Deprecated('Use codecDescriptor instead')
const Codec$json = {
  '1': 'Codec',
  '2': [
    {'1': 'payload_type', '3': 16, '4': 1, '5': 13, '10': 'payloadType'},
    {'1': 'name', '3': 10, '4': 1, '5': 9, '10': 'name'},
    {'1': 'clock_rate', '3': 14, '4': 1, '5': 13, '10': 'clockRate'},
    {
      '1': 'encoding_parameters',
      '3': 15,
      '4': 1,
      '5': 9,
      '10': 'encodingParameters'
    },
    {'1': 'fmtp', '3': 12, '4': 1, '5': 9, '10': 'fmtp'},
  ],
};

/// Descriptor for `Codec`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List codecDescriptor = $convert.base64Decode(
    'CgVDb2RlYxIhCgxwYXlsb2FkX3R5cGUYECABKA1SC3BheWxvYWRUeXBlEhIKBG5hbWUYCiABKA'
    'lSBG5hbWUSHQoKY2xvY2tfcmF0ZRgOIAEoDVIJY2xvY2tSYXRlEi8KE2VuY29kaW5nX3BhcmFt'
    'ZXRlcnMYDyABKAlSEmVuY29kaW5nUGFyYW1ldGVycxISCgRmbXRwGAwgASgJUgRmbXRw');

@$core.Deprecated('Use iCETrickleDescriptor instead')
const ICETrickle$json = {
  '1': 'ICETrickle',
  '2': [
    {
      '1': 'peer_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.PeerType',
      '10': 'peerType'
    },
    {'1': 'ice_candidate', '3': 2, '4': 1, '5': 9, '10': 'iceCandidate'},
    {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `ICETrickle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCETrickleDescriptor = $convert.base64Decode(
    'CgpJQ0VUcmlja2xlEj4KCXBlZXJfdHlwZRgBIAEoDjIhLnN0cmVhbS52aWRlby5zZnUubW9kZW'
    'xzLlBlZXJUeXBlUghwZWVyVHlwZRIjCg1pY2VfY2FuZGlkYXRlGAIgASgJUgxpY2VDYW5kaWRh'
    'dGUSHQoKc2Vzc2lvbl9pZBgDIAEoCVIJc2Vzc2lvbklk');

@$core.Deprecated('Use audioBitrateDescriptor instead')
const AudioBitrate$json = {
  '1': 'AudioBitrate',
  '2': [
    {
      '1': 'profile',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.AudioBitrateProfile',
      '10': 'profile'
    },
    {'1': 'bitrate', '3': 2, '4': 1, '5': 5, '10': 'bitrate'},
  ],
};

/// Descriptor for `AudioBitrate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioBitrateDescriptor = $convert.base64Decode(
    'CgxBdWRpb0JpdHJhdGUSRgoHcHJvZmlsZRgBIAEoDjIsLnN0cmVhbS52aWRlby5zZnUubW9kZW'
    'xzLkF1ZGlvQml0cmF0ZVByb2ZpbGVSB3Byb2ZpbGUSGAoHYml0cmF0ZRgCIAEoBVIHYml0cmF0'
    'ZQ==');

@$core.Deprecated('Use trackInfoDescriptor instead')
const TrackInfo$json = {
  '1': 'TrackInfo',
  '2': [
    {'1': 'track_id', '3': 1, '4': 1, '5': 9, '10': 'trackId'},
    {
      '1': 'track_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.TrackType',
      '10': 'trackType'
    },
    {
      '1': 'layers',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.stream.video.sfu.models.VideoLayer',
      '10': 'layers'
    },
    {'1': 'mid', '3': 6, '4': 1, '5': 9, '10': 'mid'},
    {'1': 'dtx', '3': 7, '4': 1, '5': 8, '10': 'dtx'},
    {'1': 'stereo', '3': 8, '4': 1, '5': 8, '10': 'stereo'},
    {'1': 'red', '3': 9, '4': 1, '5': 8, '10': 'red'},
    {'1': 'muted', '3': 10, '4': 1, '5': 8, '10': 'muted'},
    {
      '1': 'codec',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.stream.video.sfu.models.Codec',
      '10': 'codec'
    },
    {
      '1': 'publish_option_id',
      '3': 12,
      '4': 1,
      '5': 5,
      '10': 'publishOptionId'
    },
  ],
};

/// Descriptor for `TrackInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackInfoDescriptor = $convert.base64Decode(
    'CglUcmFja0luZm8SGQoIdHJhY2tfaWQYASABKAlSB3RyYWNrSWQSQQoKdHJhY2tfdHlwZRgCIA'
    'EoDjIiLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlRyYWNrVHlwZVIJdHJhY2tUeXBlEjsKBmxh'
    'eWVycxgFIAMoCzIjLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlZpZGVvTGF5ZXJSBmxheWVycx'
    'IQCgNtaWQYBiABKAlSA21pZBIQCgNkdHgYByABKAhSA2R0eBIWCgZzdGVyZW8YCCABKAhSBnN0'
    'ZXJlbxIQCgNyZWQYCSABKAhSA3JlZBIUCgVtdXRlZBgKIAEoCFIFbXV0ZWQSNAoFY29kZWMYCy'
    'ABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5Db2RlY1IFY29kZWMSKgoRcHVibGlzaF9v'
    'cHRpb25faWQYDCABKAVSD3B1Ymxpc2hPcHRpb25JZA==');

@$core.Deprecated('Use errorDescriptor instead')
const Error$json = {
  '1': 'Error',
  '2': [
    {
      '1': 'code',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.ErrorCode',
      '10': 'code'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'should_retry', '3': 3, '4': 1, '5': 8, '10': 'shouldRetry'},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode(
    'CgVFcnJvchI2CgRjb2RlGAEgASgOMiIuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuRXJyb3JDb2'
    'RlUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USIQoMc2hvdWxkX3JldHJ5GAMgASgI'
    'UgtzaG91bGRSZXRyeQ==');

@$core.Deprecated('Use clientDetailsDescriptor instead')
const ClientDetails$json = {
  '1': 'ClientDetails',
  '2': [
    {
      '1': 'sdk',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.stream.video.sfu.models.Sdk',
      '10': 'sdk'
    },
    {
      '1': 'os',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.sfu.models.OS',
      '10': 'os'
    },
    {
      '1': 'browser',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.stream.video.sfu.models.Browser',
      '10': 'browser'
    },
    {
      '1': 'device',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.stream.video.sfu.models.Device',
      '10': 'device'
    },
  ],
};

/// Descriptor for `ClientDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDetailsDescriptor = $convert.base64Decode(
    'Cg1DbGllbnREZXRhaWxzEi4KA3NkaxgBIAEoCzIcLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLl'
    'Nka1IDc2RrEisKAm9zGAIgASgLMhsuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuT1NSAm9zEjoK'
    'B2Jyb3dzZXIYAyABKAsyIC5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5Ccm93c2VyUgdicm93c2'
    'VyEjcKBmRldmljZRgEIAEoCzIfLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLkRldmljZVIGZGV2'
    'aWNl');

@$core.Deprecated('Use sdkDescriptor instead')
const Sdk$json = {
  '1': 'Sdk',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.SdkType',
      '10': 'type'
    },
    {'1': 'major', '3': 2, '4': 1, '5': 9, '10': 'major'},
    {'1': 'minor', '3': 3, '4': 1, '5': 9, '10': 'minor'},
    {'1': 'patch', '3': 4, '4': 1, '5': 9, '10': 'patch'},
  ],
};

/// Descriptor for `Sdk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sdkDescriptor = $convert.base64Decode(
    'CgNTZGsSNAoEdHlwZRgBIAEoDjIgLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlNka1R5cGVSBH'
    'R5cGUSFAoFbWFqb3IYAiABKAlSBW1ham9yEhQKBW1pbm9yGAMgASgJUgVtaW5vchIUCgVwYXRj'
    'aBgEIAEoCVIFcGF0Y2g=');

@$core.Deprecated('Use oSDescriptor instead')
const OS$json = {
  '1': 'OS',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'architecture', '3': 3, '4': 1, '5': 9, '10': 'architecture'},
  ],
};

/// Descriptor for `OS`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oSDescriptor = $convert.base64Decode(
    'CgJPUxISCgRuYW1lGAEgASgJUgRuYW1lEhgKB3ZlcnNpb24YAiABKAlSB3ZlcnNpb24SIgoMYX'
    'JjaGl0ZWN0dXJlGAMgASgJUgxhcmNoaXRlY3R1cmU=');

@$core.Deprecated('Use browserDescriptor instead')
const Browser$json = {
  '1': 'Browser',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `Browser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List browserDescriptor = $convert.base64Decode(
    'CgdCcm93c2VyEhIKBG5hbWUYASABKAlSBG5hbWUSGAoHdmVyc2lvbhgCIAEoCVIHdmVyc2lvbg'
    '==');

@$core.Deprecated('Use rTMPIngressDescriptor instead')
const RTMPIngress$json = {
  '1': 'RTMPIngress',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 13, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 13, '10': 'height'},
    {'1': 'frame_rate', '3': 3, '4': 1, '5': 1, '10': 'frameRate'},
    {'1': 'software', '3': 4, '4': 1, '5': 9, '10': 'software'},
    {'1': 'version', '3': 5, '4': 1, '5': 9, '10': 'version'},
    {'1': 'encoder', '3': 6, '4': 1, '5': 9, '10': 'encoder'},
    {'1': 'remote_addr', '3': 7, '4': 1, '5': 9, '10': 'remoteAddr'},
  ],
};

/// Descriptor for `RTMPIngress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rTMPIngressDescriptor = $convert.base64Decode(
    'CgtSVE1QSW5ncmVzcxIUCgV3aWR0aBgBIAEoDVIFd2lkdGgSFgoGaGVpZ2h0GAIgASgNUgZoZW'
    'lnaHQSHQoKZnJhbWVfcmF0ZRgDIAEoAVIJZnJhbWVSYXRlEhoKCHNvZnR3YXJlGAQgASgJUghz'
    'b2Z0d2FyZRIYCgd2ZXJzaW9uGAUgASgJUgd2ZXJzaW9uEhgKB2VuY29kZXIYBiABKAlSB2VuY2'
    '9kZXISHwoLcmVtb3RlX2FkZHIYByABKAlSCnJlbW90ZUFkZHI=');

@$core.Deprecated('Use deviceDescriptor instead')
const Device$json = {
  '1': 'Device',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `Device`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceDescriptor = $convert.base64Decode(
    'CgZEZXZpY2USEgoEbmFtZRgBIAEoCVIEbmFtZRIYCgd2ZXJzaW9uGAIgASgJUgd2ZXJzaW9u');

@$core.Deprecated('Use callDescriptor instead')
const Call$json = {
  '1': 'Call',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'created_by_user_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'createdByUserId'
    },
    {'1': 'host_user_id', '3': 4, '4': 1, '5': 9, '10': 'hostUserId'},
    {
      '1': 'custom',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'custom'
    },
    {
      '1': 'created_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Call`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callDescriptor = $convert.base64Decode(
    'CgRDYWxsEhIKBHR5cGUYASABKAlSBHR5cGUSDgoCaWQYAiABKAlSAmlkEisKEmNyZWF0ZWRfYn'
    'lfdXNlcl9pZBgDIAEoCVIPY3JlYXRlZEJ5VXNlcklkEiAKDGhvc3RfdXNlcl9pZBgEIAEoCVIK'
    'aG9zdFVzZXJJZBIvCgZjdXN0b20YBSABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0UgZjdX'
    'N0b20SOQoKY3JlYXRlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNy'
    'ZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'IJdXBkYXRlZEF0');

@$core.Deprecated('Use callGrantsDescriptor instead')
const CallGrants$json = {
  '1': 'CallGrants',
  '2': [
    {'1': 'can_publish_audio', '3': 1, '4': 1, '5': 8, '10': 'canPublishAudio'},
    {'1': 'can_publish_video', '3': 2, '4': 1, '5': 8, '10': 'canPublishVideo'},
    {'1': 'can_screenshare', '3': 3, '4': 1, '5': 8, '10': 'canScreenshare'},
  ],
};

/// Descriptor for `CallGrants`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callGrantsDescriptor = $convert.base64Decode(
    'CgpDYWxsR3JhbnRzEioKEWNhbl9wdWJsaXNoX2F1ZGlvGAEgASgIUg9jYW5QdWJsaXNoQXVkaW'
    '8SKgoRY2FuX3B1Ymxpc2hfdmlkZW8YAiABKAhSD2NhblB1Ymxpc2hWaWRlbxInCg9jYW5fc2Ny'
    'ZWVuc2hhcmUYAyABKAhSDmNhblNjcmVlbnNoYXJl');

@$core.Deprecated('Use inputDevicesDescriptor instead')
const InputDevices$json = {
  '1': 'InputDevices',
  '2': [
    {
      '1': 'available_devices',
      '3': 1,
      '4': 3,
      '5': 9,
      '10': 'availableDevices'
    },
    {'1': 'current_device', '3': 2, '4': 1, '5': 9, '10': 'currentDevice'},
    {'1': 'is_permitted', '3': 3, '4': 1, '5': 8, '10': 'isPermitted'},
  ],
};

/// Descriptor for `InputDevices`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inputDevicesDescriptor = $convert.base64Decode(
    'CgxJbnB1dERldmljZXMSKwoRYXZhaWxhYmxlX2RldmljZXMYASADKAlSEGF2YWlsYWJsZURldm'
    'ljZXMSJQoOY3VycmVudF9kZXZpY2UYAiABKAlSDWN1cnJlbnREZXZpY2USIQoMaXNfcGVybWl0'
    'dGVkGAMgASgIUgtpc1Blcm1pdHRlZA==');

@$core.Deprecated('Use androidStateDescriptor instead')
const AndroidState$json = {
  '1': 'AndroidState',
  '2': [
    {
      '1': 'thermal_state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.AndroidThermalState',
      '10': 'thermalState'
    },
    {
      '1': 'is_power_saver_mode',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'isPowerSaverMode'
    },
  ],
};

/// Descriptor for `AndroidState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List androidStateDescriptor = $convert.base64Decode(
    'CgxBbmRyb2lkU3RhdGUSUQoNdGhlcm1hbF9zdGF0ZRgBIAEoDjIsLnN0cmVhbS52aWRlby5zZn'
    'UubW9kZWxzLkFuZHJvaWRUaGVybWFsU3RhdGVSDHRoZXJtYWxTdGF0ZRItChNpc19wb3dlcl9z'
    'YXZlcl9tb2RlGAIgASgIUhBpc1Bvd2VyU2F2ZXJNb2Rl');

@$core.Deprecated('Use appleStateDescriptor instead')
const AppleState$json = {
  '1': 'AppleState',
  '2': [
    {
      '1': 'thermal_state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.AppleThermalState',
      '10': 'thermalState'
    },
    {
      '1': 'is_low_power_mode_enabled',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'isLowPowerModeEnabled'
    },
  ],
};

/// Descriptor for `AppleState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appleStateDescriptor = $convert.base64Decode(
    'CgpBcHBsZVN0YXRlEk8KDXRoZXJtYWxfc3RhdGUYASABKA4yKi5zdHJlYW0udmlkZW8uc2Z1Lm'
    '1vZGVscy5BcHBsZVRoZXJtYWxTdGF0ZVIMdGhlcm1hbFN0YXRlEjgKGWlzX2xvd19wb3dlcl9t'
    'b2RlX2VuYWJsZWQYAiABKAhSFWlzTG93UG93ZXJNb2RlRW5hYmxlZA==');

@$core.Deprecated('Use performanceStatsDescriptor instead')
const PerformanceStats$json = {
  '1': 'PerformanceStats',
  '2': [
    {
      '1': 'track_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.stream.video.sfu.models.TrackType',
      '10': 'trackType'
    },
    {
      '1': 'codec',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.sfu.models.Codec',
      '10': 'codec'
    },
    {'1': 'avg_frame_time_ms', '3': 3, '4': 1, '5': 2, '10': 'avgFrameTimeMs'},
    {'1': 'avg_fps', '3': 4, '4': 1, '5': 2, '10': 'avgFps'},
    {
      '1': 'video_dimension',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.stream.video.sfu.models.VideoDimension',
      '10': 'videoDimension'
    },
    {'1': 'target_bitrate', '3': 6, '4': 1, '5': 5, '10': 'targetBitrate'},
  ],
};

/// Descriptor for `PerformanceStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List performanceStatsDescriptor = $convert.base64Decode(
    'ChBQZXJmb3JtYW5jZVN0YXRzEkEKCnRyYWNrX3R5cGUYASABKA4yIi5zdHJlYW0udmlkZW8uc2'
    'Z1Lm1vZGVscy5UcmFja1R5cGVSCXRyYWNrVHlwZRI0CgVjb2RlYxgCIAEoCzIeLnN0cmVhbS52'
    'aWRlby5zZnUubW9kZWxzLkNvZGVjUgVjb2RlYxIpChFhdmdfZnJhbWVfdGltZV9tcxgDIAEoAl'
    'IOYXZnRnJhbWVUaW1lTXMSFwoHYXZnX2ZwcxgEIAEoAlIGYXZnRnBzElAKD3ZpZGVvX2RpbWVu'
    'c2lvbhgFIAEoCzInLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlZpZGVvRGltZW5zaW9uUg52aW'
    'Rlb0RpbWVuc2lvbhIlCg50YXJnZXRfYml0cmF0ZRgGIAEoBVINdGFyZ2V0Qml0cmF0ZQ==');
