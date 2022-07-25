///
//  Generated code. Do not modify.
//  source: video_events/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use websocketEventDescriptor instead')
const WebsocketEvent$json = const {
  '1': 'WebsocketEvent',
  '2': const [
    const {'1': 'health_check', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Healthcheck', '9': 0, '10': 'healthCheck'},
    const {'1': 'call_ringing', '3': 2, '4': 1, '5': 11, '6': '.stream.video.CallRinging', '9': 0, '10': 'callRinging'},
    const {'1': 'call_created', '3': 3, '4': 1, '5': 11, '6': '.stream.video.CallCreated', '9': 0, '10': 'callCreated'},
    const {'1': 'call_updated', '3': 4, '4': 1, '5': 11, '6': '.stream.video.CallUpdated', '9': 0, '10': 'callUpdated'},
    const {'1': 'call_ended', '3': 5, '4': 1, '5': 11, '6': '.stream.video.CallEnded', '9': 0, '10': 'callEnded'},
    const {'1': 'call_deleted', '3': 6, '4': 1, '5': 11, '6': '.stream.video.CallDeleted', '9': 0, '10': 'callDeleted'},
    const {'1': 'user_updated', '3': 7, '4': 1, '5': 11, '6': '.stream.video.UserUpdated', '9': 0, '10': 'userUpdated'},
    const {'1': 'participant_invited', '3': 8, '4': 1, '5': 11, '6': '.stream.video.ParticipantInvited', '9': 0, '10': 'participantInvited'},
    const {'1': 'participant_updated', '3': 9, '4': 1, '5': 11, '6': '.stream.video.ParticipantUpdated', '9': 0, '10': 'participantUpdated'},
    const {'1': 'participant_deleted', '3': 10, '4': 1, '5': 11, '6': '.stream.video.ParticipantDeleted', '9': 0, '10': 'participantDeleted'},
    const {'1': 'participant_joined', '3': 11, '4': 1, '5': 11, '6': '.stream.video.ParticipantJoined', '9': 0, '10': 'participantJoined'},
    const {'1': 'participant_left', '3': 12, '4': 1, '5': 11, '6': '.stream.video.ParticipantLeft', '9': 0, '10': 'participantLeft'},
    const {'1': 'broadcast_started', '3': 13, '4': 1, '5': 11, '6': '.stream.video.BroadcastStarted', '9': 0, '10': 'broadcastStarted'},
    const {'1': 'broadcast_ended', '3': 14, '4': 1, '5': 11, '6': '.stream.video.BroadcastEnded', '9': 0, '10': 'broadcastEnded'},
    const {'1': 'auth_payload', '3': 15, '4': 1, '5': 11, '6': '.stream.video.AuthPayload', '9': 0, '10': 'authPayload'},
    const {'1': 'audio_muted', '3': 16, '4': 1, '5': 11, '6': '.stream.video.AudioMuted', '9': 0, '10': 'audioMuted'},
    const {'1': 'audio_unmuted', '3': 17, '4': 1, '5': 11, '6': '.stream.video.AudioUnmuted', '9': 0, '10': 'audioUnmuted'},
    const {'1': 'video_started', '3': 18, '4': 1, '5': 11, '6': '.stream.video.VideoStarted', '9': 0, '10': 'videoStarted'},
    const {'1': 'video_stopped', '3': 19, '4': 1, '5': 11, '6': '.stream.video.VideoStopped', '9': 0, '10': 'videoStopped'},
    const {'1': 'screenshare_started', '3': 20, '4': 1, '5': 11, '6': '.stream.video.ScreenshareStarted', '9': 0, '10': 'screenshareStarted'},
    const {'1': 'screenshare_stopped', '3': 21, '4': 1, '5': 11, '6': '.stream.video.ScreenshareStopped', '9': 0, '10': 'screenshareStopped'},
    const {'1': 'recording_started', '3': 22, '4': 1, '5': 11, '6': '.stream.video.RecordingStarted', '9': 0, '10': 'recordingStarted'},
    const {'1': 'recording_stopped', '3': 23, '4': 1, '5': 11, '6': '.stream.video.RecordingStopped', '9': 0, '10': 'recordingStopped'},
  ],
  '8': const [
    const {'1': 'event_payload'},
  ],
};

/// Descriptor for `WebsocketEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List websocketEventDescriptor = $convert.base64Decode('Cg5XZWJzb2NrZXRFdmVudBI+CgxoZWFsdGhfY2hlY2sYASABKAsyGS5zdHJlYW0udmlkZW8uSGVhbHRoY2hlY2tIAFILaGVhbHRoQ2hlY2sSPgoMY2FsbF9yaW5naW5nGAIgASgLMhkuc3RyZWFtLnZpZGVvLkNhbGxSaW5naW5nSABSC2NhbGxSaW5naW5nEj4KDGNhbGxfY3JlYXRlZBgDIAEoCzIZLnN0cmVhbS52aWRlby5DYWxsQ3JlYXRlZEgAUgtjYWxsQ3JlYXRlZBI+CgxjYWxsX3VwZGF0ZWQYBCABKAsyGS5zdHJlYW0udmlkZW8uQ2FsbFVwZGF0ZWRIAFILY2FsbFVwZGF0ZWQSOAoKY2FsbF9lbmRlZBgFIAEoCzIXLnN0cmVhbS52aWRlby5DYWxsRW5kZWRIAFIJY2FsbEVuZGVkEj4KDGNhbGxfZGVsZXRlZBgGIAEoCzIZLnN0cmVhbS52aWRlby5DYWxsRGVsZXRlZEgAUgtjYWxsRGVsZXRlZBI+Cgx1c2VyX3VwZGF0ZWQYByABKAsyGS5zdHJlYW0udmlkZW8uVXNlclVwZGF0ZWRIAFILdXNlclVwZGF0ZWQSUwoTcGFydGljaXBhbnRfaW52aXRlZBgIIAEoCzIgLnN0cmVhbS52aWRlby5QYXJ0aWNpcGFudEludml0ZWRIAFIScGFydGljaXBhbnRJbnZpdGVkElMKE3BhcnRpY2lwYW50X3VwZGF0ZWQYCSABKAsyIC5zdHJlYW0udmlkZW8uUGFydGljaXBhbnRVcGRhdGVkSABSEnBhcnRpY2lwYW50VXBkYXRlZBJTChNwYXJ0aWNpcGFudF9kZWxldGVkGAogASgLMiAuc3RyZWFtLnZpZGVvLlBhcnRpY2lwYW50RGVsZXRlZEgAUhJwYXJ0aWNpcGFudERlbGV0ZWQSUAoScGFydGljaXBhbnRfam9pbmVkGAsgASgLMh8uc3RyZWFtLnZpZGVvLlBhcnRpY2lwYW50Sm9pbmVkSABSEXBhcnRpY2lwYW50Sm9pbmVkEkoKEHBhcnRpY2lwYW50X2xlZnQYDCABKAsyHS5zdHJlYW0udmlkZW8uUGFydGljaXBhbnRMZWZ0SABSD3BhcnRpY2lwYW50TGVmdBJNChFicm9hZGNhc3Rfc3RhcnRlZBgNIAEoCzIeLnN0cmVhbS52aWRlby5Ccm9hZGNhc3RTdGFydGVkSABSEGJyb2FkY2FzdFN0YXJ0ZWQSRwoPYnJvYWRjYXN0X2VuZGVkGA4gASgLMhwuc3RyZWFtLnZpZGVvLkJyb2FkY2FzdEVuZGVkSABSDmJyb2FkY2FzdEVuZGVkEj4KDGF1dGhfcGF5bG9hZBgPIAEoCzIZLnN0cmVhbS52aWRlby5BdXRoUGF5bG9hZEgAUgthdXRoUGF5bG9hZBI7CgthdWRpb19tdXRlZBgQIAEoCzIYLnN0cmVhbS52aWRlby5BdWRpb011dGVkSABSCmF1ZGlvTXV0ZWQSQQoNYXVkaW9fdW5tdXRlZBgRIAEoCzIaLnN0cmVhbS52aWRlby5BdWRpb1VubXV0ZWRIAFIMYXVkaW9Vbm11dGVkEkEKDXZpZGVvX3N0YXJ0ZWQYEiABKAsyGi5zdHJlYW0udmlkZW8uVmlkZW9TdGFydGVkSABSDHZpZGVvU3RhcnRlZBJBCg12aWRlb19zdG9wcGVkGBMgASgLMhouc3RyZWFtLnZpZGVvLlZpZGVvU3RvcHBlZEgAUgx2aWRlb1N0b3BwZWQSUwoTc2NyZWVuc2hhcmVfc3RhcnRlZBgUIAEoCzIgLnN0cmVhbS52aWRlby5TY3JlZW5zaGFyZVN0YXJ0ZWRIAFISc2NyZWVuc2hhcmVTdGFydGVkElMKE3NjcmVlbnNoYXJlX3N0b3BwZWQYFSABKAsyIC5zdHJlYW0udmlkZW8uU2NyZWVuc2hhcmVTdG9wcGVkSABSEnNjcmVlbnNoYXJlU3RvcHBlZBJNChFyZWNvcmRpbmdfc3RhcnRlZBgWIAEoCzIeLnN0cmVhbS52aWRlby5SZWNvcmRpbmdTdGFydGVkSABSEHJlY29yZGluZ1N0YXJ0ZWQSTQoRcmVjb3JkaW5nX3N0b3BwZWQYFyABKAsyHi5zdHJlYW0udmlkZW8uUmVjb3JkaW5nU3RvcHBlZEgAUhByZWNvcmRpbmdTdG9wcGVkQg8KDWV2ZW50X3BheWxvYWQ=');
@$core.Deprecated('Use healthcheckDescriptor instead')
const Healthcheck$json = const {
  '1': 'Healthcheck',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'client_id', '3': 2, '4': 1, '5': 9, '10': 'clientId'},
    const {'1': 'call_type', '3': 3, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 4, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'video', '3': 5, '4': 1, '5': 8, '10': 'video'},
    const {'1': 'audio', '3': 6, '4': 1, '5': 8, '10': 'audio'},
  ],
};

/// Descriptor for `Healthcheck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthcheckDescriptor = $convert.base64Decode('CgtIZWFsdGhjaGVjaxIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSGwoJY2xpZW50X2lkGAIgASgJUghjbGllbnRJZBIbCgljYWxsX3R5cGUYAyABKAlSCGNhbGxUeXBlEhcKB2NhbGxfaWQYBCABKAlSBmNhbGxJZBIUCgV2aWRlbxgFIAEoCFIFdmlkZW8SFAoFYXVkaW8YBiABKAhSBWF1ZGlv');
@$core.Deprecated('Use authPayloadDescriptor instead')
const AuthPayload$json = const {
  '1': 'AuthPayload',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.stream.video.UserRequest', '10': 'user'},
    const {'1': 'device', '3': 2, '4': 1, '5': 11, '6': '.stream.video.DeviceRequest', '10': 'device'},
    const {'1': 'token', '3': 3, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `AuthPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authPayloadDescriptor = $convert.base64Decode('CgtBdXRoUGF5bG9hZBItCgR1c2VyGAEgASgLMhkuc3RyZWFtLnZpZGVvLlVzZXJSZXF1ZXN0UgR1c2VyEjMKBmRldmljZRgCIAEoCzIbLnN0cmVhbS52aWRlby5EZXZpY2VSZXF1ZXN0UgZkZXZpY2USFAoFdG9rZW4YAyABKAlSBXRva2Vu');
@$core.Deprecated('Use callRingingDescriptor instead')
const CallRinging$json = const {
  '1': 'CallRinging',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `CallRinging`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callRingingDescriptor = $convert.base64Decode('CgtDYWxsUmluZ2luZxImCgRjYWxsGAEgASgLMhIuc3RyZWFtLnZpZGVvLkNhbGxSBGNhbGw=');
@$core.Deprecated('Use callCreatedDescriptor instead')
const CallCreated$json = const {
  '1': 'CallCreated',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `CallCreated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callCreatedDescriptor = $convert.base64Decode('CgtDYWxsQ3JlYXRlZBImCgRjYWxsGAEgASgLMhIuc3RyZWFtLnZpZGVvLkNhbGxSBGNhbGw=');
@$core.Deprecated('Use callUpdatedDescriptor instead')
const CallUpdated$json = const {
  '1': 'CallUpdated',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `CallUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callUpdatedDescriptor = $convert.base64Decode('CgtDYWxsVXBkYXRlZBImCgRjYWxsGAEgASgLMhIuc3RyZWFtLnZpZGVvLkNhbGxSBGNhbGw=');
@$core.Deprecated('Use callEndedDescriptor instead')
const CallEnded$json = const {
  '1': 'CallEnded',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `CallEnded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callEndedDescriptor = $convert.base64Decode('CglDYWxsRW5kZWQSJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxs');
@$core.Deprecated('Use callDeletedDescriptor instead')
const CallDeleted$json = const {
  '1': 'CallDeleted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `CallDeleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callDeletedDescriptor = $convert.base64Decode('CgtDYWxsRGVsZXRlZBImCgRjYWxsGAEgASgLMhIuc3RyZWFtLnZpZGVvLkNhbGxSBGNhbGw=');
@$core.Deprecated('Use audioMutedDescriptor instead')
const AudioMuted$json = const {
  '1': 'AudioMuted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'userId'},
    const {'1': 'all_users', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'allUsers'},
  ],
  '8': const [
    const {'1': 'target'},
  ],
};

/// Descriptor for `AudioMuted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioMutedDescriptor = $convert.base64Decode('CgpBdWRpb011dGVkEiYKBGNhbGwYASABKAsyEi5zdHJlYW0udmlkZW8uQ2FsbFIEY2FsbBIZCgd1c2VyX2lkGAIgASgJSABSBnVzZXJJZBIdCglhbGxfdXNlcnMYAyABKAhIAFIIYWxsVXNlcnNCCAoGdGFyZ2V0');
@$core.Deprecated('Use audioUnmutedDescriptor instead')
const AudioUnmuted$json = const {
  '1': 'AudioUnmuted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `AudioUnmuted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioUnmutedDescriptor = $convert.base64Decode('CgxBdWRpb1VubXV0ZWQSJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxsEhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJZA==');
@$core.Deprecated('Use videoStartedDescriptor instead')
const VideoStarted$json = const {
  '1': 'VideoStarted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `VideoStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoStartedDescriptor = $convert.base64Decode('CgxWaWRlb1N0YXJ0ZWQSJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxsEhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJZA==');
@$core.Deprecated('Use videoStoppedDescriptor instead')
const VideoStopped$json = const {
  '1': 'VideoStopped',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `VideoStopped`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoStoppedDescriptor = $convert.base64Decode('CgxWaWRlb1N0b3BwZWQSJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxsEhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJZA==');
@$core.Deprecated('Use screenshareStartedDescriptor instead')
const ScreenshareStarted$json = const {
  '1': 'ScreenshareStarted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `ScreenshareStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List screenshareStartedDescriptor = $convert.base64Decode('ChJTY3JlZW5zaGFyZVN0YXJ0ZWQSJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxsEhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJZA==');
@$core.Deprecated('Use screenshareStoppedDescriptor instead')
const ScreenshareStopped$json = const {
  '1': 'ScreenshareStopped',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `ScreenshareStopped`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List screenshareStoppedDescriptor = $convert.base64Decode('ChJTY3JlZW5zaGFyZVN0b3BwZWQSJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxsEhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJZA==');
@$core.Deprecated('Use recordingStartedDescriptor instead')
const RecordingStarted$json = const {
  '1': 'RecordingStarted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `RecordingStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordingStartedDescriptor = $convert.base64Decode('ChBSZWNvcmRpbmdTdGFydGVkEiYKBGNhbGwYASABKAsyEi5zdHJlYW0udmlkZW8uQ2FsbFIEY2FsbA==');
@$core.Deprecated('Use recordingStoppedDescriptor instead')
const RecordingStopped$json = const {
  '1': 'RecordingStopped',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `RecordingStopped`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordingStoppedDescriptor = $convert.base64Decode('ChBSZWNvcmRpbmdTdG9wcGVkEiYKBGNhbGwYASABKAsyEi5zdHJlYW0udmlkZW8uQ2FsbFIEY2FsbA==');
@$core.Deprecated('Use userUpdatedDescriptor instead')
const UserUpdated$json = const {
  '1': 'UserUpdated',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.stream.video.User', '10': 'user'},
  ],
};

/// Descriptor for `UserUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userUpdatedDescriptor = $convert.base64Decode('CgtVc2VyVXBkYXRlZBImCgR1c2VyGAEgASgLMhIuc3RyZWFtLnZpZGVvLlVzZXJSBHVzZXI=');
@$core.Deprecated('Use participantInvitedDescriptor instead')
const ParticipantInvited$json = const {
  '1': 'ParticipantInvited',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantInvited`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantInvitedDescriptor = $convert.base64Decode('ChJQYXJ0aWNpcGFudEludml0ZWQSJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxsEjsKC3BhcnRpY2lwYW50GAIgASgLMhkuc3RyZWFtLnZpZGVvLlBhcnRpY2lwYW50UgtwYXJ0aWNpcGFudA==');
@$core.Deprecated('Use participantUpdatedDescriptor instead')
const ParticipantUpdated$json = const {
  '1': 'ParticipantUpdated',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantUpdatedDescriptor = $convert.base64Decode('ChJQYXJ0aWNpcGFudFVwZGF0ZWQSJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxsEjsKC3BhcnRpY2lwYW50GAIgASgLMhkuc3RyZWFtLnZpZGVvLlBhcnRpY2lwYW50UgtwYXJ0aWNpcGFudA==');
@$core.Deprecated('Use participantDeletedDescriptor instead')
const ParticipantDeleted$json = const {
  '1': 'ParticipantDeleted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `ParticipantDeleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantDeletedDescriptor = $convert.base64Decode('ChJQYXJ0aWNpcGFudERlbGV0ZWQSJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxsEhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJZA==');
@$core.Deprecated('Use participantJoinedDescriptor instead')
const ParticipantJoined$json = const {
  '1': 'ParticipantJoined',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantJoined`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantJoinedDescriptor = $convert.base64Decode('ChFQYXJ0aWNpcGFudEpvaW5lZBImCgRjYWxsGAEgASgLMhIuc3RyZWFtLnZpZGVvLkNhbGxSBGNhbGwSOwoLcGFydGljaXBhbnQYAiABKAsyGS5zdHJlYW0udmlkZW8uUGFydGljaXBhbnRSC3BhcnRpY2lwYW50');
@$core.Deprecated('Use participantLeftDescriptor instead')
const ParticipantLeft$json = const {
  '1': 'ParticipantLeft',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantLeft`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantLeftDescriptor = $convert.base64Decode('Cg9QYXJ0aWNpcGFudExlZnQSJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxsEjsKC3BhcnRpY2lwYW50GAIgASgLMhkuc3RyZWFtLnZpZGVvLlBhcnRpY2lwYW50UgtwYXJ0aWNpcGFudA==');
@$core.Deprecated('Use broadcastStartedDescriptor instead')
const BroadcastStarted$json = const {
  '1': 'BroadcastStarted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `BroadcastStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastStartedDescriptor = $convert.base64Decode('ChBCcm9hZGNhc3RTdGFydGVkEiYKBGNhbGwYASABKAsyEi5zdHJlYW0udmlkZW8uQ2FsbFIEY2FsbA==');
@$core.Deprecated('Use broadcastEndedDescriptor instead')
const BroadcastEnded$json = const {
  '1': 'BroadcastEnded',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `BroadcastEnded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastEndedDescriptor = $convert.base64Decode('Cg5Ccm9hZGNhc3RFbmRlZBImCgRjYWxsGAEgASgLMhIuc3RyZWFtLnZpZGVvLkNhbGxSBGNhbGw=');
