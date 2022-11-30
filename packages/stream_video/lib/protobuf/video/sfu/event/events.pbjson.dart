///
//  Generated code. Do not modify.
//  source: video/sfu/event/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use sfuEventDescriptor instead')
const SfuEvent$json = const {
  '1': 'SfuEvent',
  '2': const [
    const {'1': 'subscriber_offer', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event.SubscriberOffer', '9': 0, '10': 'subscriberOffer'},
    const {'1': 'publisher_answer', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.event.PublisherAnswer', '9': 0, '10': 'publisherAnswer'},
    const {'1': 'connection_quality_changed', '3': 3, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ConnectionQualityChanged', '9': 0, '10': 'connectionQualityChanged'},
    const {'1': 'audio_level_changed', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.event.AudioLevelChanged', '9': 0, '10': 'audioLevelChanged'},
    const {'1': 'ice_trickle', '3': 5, '4': 1, '5': 11, '6': '.stream.video.sfu.models.ICETrickle', '9': 0, '10': 'iceTrickle'},
    const {'1': 'change_publish_quality', '3': 6, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ChangePublishQuality', '9': 0, '10': 'changePublishQuality'},
    const {'1': 'local_device_change', '3': 7, '4': 1, '5': 11, '6': '.stream.video.sfu.event.LocalDeviceChange', '9': 0, '10': 'localDeviceChange'},
    const {'1': 'mute_state_changed', '3': 8, '4': 1, '5': 11, '6': '.stream.video.sfu.event.MuteStateChanged', '9': 0, '10': 'muteStateChanged'},
    const {'1': 'video_quality_changed', '3': 9, '4': 1, '5': 11, '6': '.stream.video.sfu.event.VideoQualityChanged', '9': 0, '10': 'videoQualityChanged'},
    const {'1': 'participant_joined', '3': 10, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ParticipantJoined', '9': 0, '10': 'participantJoined'},
    const {'1': 'participant_left', '3': 11, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ParticipantLeft', '9': 0, '10': 'participantLeft'},
    const {'1': 'dominant_speaker_changed', '3': 12, '4': 1, '5': 11, '6': '.stream.video.sfu.event.DominantSpeakerChanged', '9': 0, '10': 'dominantSpeakerChanged'},
    const {'1': 'join_response', '3': 13, '4': 1, '5': 11, '6': '.stream.video.sfu.event.JoinResponse', '9': 0, '10': 'joinResponse'},
    const {'1': 'health_check_response', '3': 14, '4': 1, '5': 11, '6': '.stream.video.sfu.event.HealthCheckResponse', '9': 0, '10': 'healthCheckResponse'},
    const {'1': 'call_ended', '3': 15, '4': 1, '5': 11, '6': '.stream.video.sfu.event.CallEnded', '9': 0, '10': 'callEnded'},
  ],
  '8': const [
    const {'1': 'event_payload'},
  ],
};

/// Descriptor for `SfuEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sfuEventDescriptor = $convert.base64Decode('CghTZnVFdmVudBJUChBzdWJzY3JpYmVyX29mZmVyGAEgASgLMicuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5TdWJzY3JpYmVyT2ZmZXJIAFIPc3Vic2NyaWJlck9mZmVyElQKEHB1Ymxpc2hlcl9hbnN3ZXIYAiABKAsyJy5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LlB1Ymxpc2hlckFuc3dlckgAUg9wdWJsaXNoZXJBbnN3ZXIScAoaY29ubmVjdGlvbl9xdWFsaXR5X2NoYW5nZWQYAyABKAsyMC5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkNvbm5lY3Rpb25RdWFsaXR5Q2hhbmdlZEgAUhhjb25uZWN0aW9uUXVhbGl0eUNoYW5nZWQSWwoTYXVkaW9fbGV2ZWxfY2hhbmdlZBgEIAEoCzIpLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuQXVkaW9MZXZlbENoYW5nZWRIAFIRYXVkaW9MZXZlbENoYW5nZWQSRgoLaWNlX3RyaWNrbGUYBSABKAsyIy5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5JQ0VUcmlja2xlSABSCmljZVRyaWNrbGUSZAoWY2hhbmdlX3B1Ymxpc2hfcXVhbGl0eRgGIAEoCzIsLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuQ2hhbmdlUHVibGlzaFF1YWxpdHlIAFIUY2hhbmdlUHVibGlzaFF1YWxpdHkSWwoTbG9jYWxfZGV2aWNlX2NoYW5nZRgHIAEoCzIpLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuTG9jYWxEZXZpY2VDaGFuZ2VIAFIRbG9jYWxEZXZpY2VDaGFuZ2USWAoSbXV0ZV9zdGF0ZV9jaGFuZ2VkGAggASgLMiguc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5NdXRlU3RhdGVDaGFuZ2VkSABSEG11dGVTdGF0ZUNoYW5nZWQSYQoVdmlkZW9fcXVhbGl0eV9jaGFuZ2VkGAkgASgLMisuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5WaWRlb1F1YWxpdHlDaGFuZ2VkSABSE3ZpZGVvUXVhbGl0eUNoYW5nZWQSWgoScGFydGljaXBhbnRfam9pbmVkGAogASgLMikuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5QYXJ0aWNpcGFudEpvaW5lZEgAUhFwYXJ0aWNpcGFudEpvaW5lZBJUChBwYXJ0aWNpcGFudF9sZWZ0GAsgASgLMicuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5QYXJ0aWNpcGFudExlZnRIAFIPcGFydGljaXBhbnRMZWZ0EmoKGGRvbWluYW50X3NwZWFrZXJfY2hhbmdlZBgMIAEoCzIuLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuRG9taW5hbnRTcGVha2VyQ2hhbmdlZEgAUhZkb21pbmFudFNwZWFrZXJDaGFuZ2VkEksKDWpvaW5fcmVzcG9uc2UYDSABKAsyJC5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkpvaW5SZXNwb25zZUgAUgxqb2luUmVzcG9uc2USYQoVaGVhbHRoX2NoZWNrX3Jlc3BvbnNlGA4gASgLMisuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5IZWFsdGhDaGVja1Jlc3BvbnNlSABSE2hlYWx0aENoZWNrUmVzcG9uc2USQgoKY2FsbF9lbmRlZBgPIAEoCzIhLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuQ2FsbEVuZGVkSABSCWNhbGxFbmRlZEIPCg1ldmVudF9wYXlsb2Fk');
@$core.Deprecated('Use sfuRequestDescriptor instead')
const SfuRequest$json = const {
  '1': 'SfuRequest',
  '2': const [
    const {'1': 'join_request', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event.JoinRequest', '9': 0, '10': 'joinRequest'},
    const {'1': 'health_check_request', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.event.HealthCheckRequest', '9': 0, '10': 'healthCheckRequest'},
  ],
  '8': const [
    const {'1': 'request_payload'},
  ],
};

/// Descriptor for `SfuRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sfuRequestDescriptor = $convert.base64Decode('CgpTZnVSZXF1ZXN0EkgKDGpvaW5fcmVxdWVzdBgBIAEoCzIjLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuSm9pblJlcXVlc3RIAFILam9pblJlcXVlc3QSXgoUaGVhbHRoX2NoZWNrX3JlcXVlc3QYAiABKAsyKi5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkhlYWx0aENoZWNrUmVxdWVzdEgAUhJoZWFsdGhDaGVja1JlcXVlc3RCEQoPcmVxdWVzdF9wYXlsb2Fk');
@$core.Deprecated('Use healthCheckRequestDescriptor instead')
const HealthCheckRequest$json = const {
  '1': 'HealthCheckRequest',
  '2': const [
    const {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `HealthCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthCheckRequestDescriptor = $convert.base64Decode('ChJIZWFsdGhDaGVja1JlcXVlc3QSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklk');
@$core.Deprecated('Use healthCheckResponseDescriptor instead')
const HealthCheckResponse$json = const {
  '1': 'HealthCheckResponse',
  '2': const [
    const {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `HealthCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthCheckResponseDescriptor = $convert.base64Decode('ChNIZWFsdGhDaGVja1Jlc3BvbnNlEh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZA==');
@$core.Deprecated('Use joinRequestDescriptor instead')
const JoinRequest$json = const {
  '1': 'JoinRequest',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'publish', '3': 3, '4': 1, '5': 8, '10': 'publish'},
    const {'1': 'codec_settings', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.CodecSettings', '10': 'codecSettings'},
  ],
};

/// Descriptor for `JoinRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRequestDescriptor = $convert.base64Decode('CgtKb2luUmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4SHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEhgKB3B1Ymxpc2gYAyABKAhSB3B1Ymxpc2gSTQoOY29kZWNfc2V0dGluZ3MYBCABKAsyJi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5Db2RlY1NldHRpbmdzUg1jb2RlY1NldHRpbmdz');
@$core.Deprecated('Use joinResponseDescriptor instead')
const JoinResponse$json = const {
  '1': 'JoinResponse',
  '2': const [
    const {'1': 'call_state', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.CallState', '10': 'callState'},
    const {'1': 'own_session_id', '3': 2, '4': 1, '5': 9, '10': 'ownSessionId'},
  ],
};

/// Descriptor for `JoinResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinResponseDescriptor = $convert.base64Decode('CgxKb2luUmVzcG9uc2USQQoKY2FsbF9zdGF0ZRgBIAEoCzIiLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLkNhbGxTdGF0ZVIJY2FsbFN0YXRlEiQKDm93bl9zZXNzaW9uX2lkGAIgASgJUgxvd25TZXNzaW9uSWQ=');
@$core.Deprecated('Use participantJoinedDescriptor instead')
const ParticipantJoined$json = const {
  '1': 'ParticipantJoined',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Call', '10': 'call'},
    const {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantJoined`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantJoinedDescriptor = $convert.base64Decode('ChFQYXJ0aWNpcGFudEpvaW5lZBIxCgRjYWxsGAEgASgLMh0uc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuQ2FsbFIEY2FsbBJGCgtwYXJ0aWNpcGFudBgCIAEoCzIkLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlBhcnRpY2lwYW50UgtwYXJ0aWNpcGFudA==');
@$core.Deprecated('Use participantLeftDescriptor instead')
const ParticipantLeft$json = const {
  '1': 'ParticipantLeft',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Call', '10': 'call'},
    const {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantLeft`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantLeftDescriptor = $convert.base64Decode('Cg9QYXJ0aWNpcGFudExlZnQSMQoEY2FsbBgBIAEoCzIdLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLkNhbGxSBGNhbGwSRgoLcGFydGljaXBhbnQYAiABKAsyJC5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5QYXJ0aWNpcGFudFILcGFydGljaXBhbnQ=');
@$core.Deprecated('Use muteStateChangedDescriptor instead')
const MuteStateChanged$json = const {
  '1': 'MuteStateChanged',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'audio_muted', '3': 2, '4': 1, '5': 8, '10': 'audioMuted'},
    const {'1': 'video_muted', '3': 3, '4': 1, '5': 8, '10': 'videoMuted'},
  ],
};

/// Descriptor for `MuteStateChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List muteStateChangedDescriptor = $convert.base64Decode('ChBNdXRlU3RhdGVDaGFuZ2VkEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIfCgthdWRpb19tdXRlZBgCIAEoCFIKYXVkaW9NdXRlZBIfCgt2aWRlb19tdXRlZBgDIAEoCFIKdmlkZW9NdXRlZA==');
@$core.Deprecated('Use videoQualityChangedDescriptor instead')
const VideoQualityChanged$json = const {
  '1': 'VideoQualityChanged',
  '2': const [
    const {'1': 'stream_qualities', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.models.StreamQuality', '10': 'streamQualities'},
  ],
};

/// Descriptor for `VideoQualityChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoQualityChangedDescriptor = $convert.base64Decode('ChNWaWRlb1F1YWxpdHlDaGFuZ2VkElEKEHN0cmVhbV9xdWFsaXRpZXMYASADKAsyJi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5TdHJlYW1RdWFsaXR5Ug9zdHJlYW1RdWFsaXRpZXM=');
@$core.Deprecated('Use subscriberOfferDescriptor instead')
const SubscriberOffer$json = const {
  '1': 'SubscriberOffer',
  '2': const [
    const {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
  ],
};

/// Descriptor for `SubscriberOffer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriberOfferDescriptor = $convert.base64Decode('Cg9TdWJzY3JpYmVyT2ZmZXISEAoDc2RwGAEgASgJUgNzZHA=');
@$core.Deprecated('Use publisherAnswerDescriptor instead')
const PublisherAnswer$json = const {
  '1': 'PublisherAnswer',
  '2': const [
    const {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
  ],
};

/// Descriptor for `PublisherAnswer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publisherAnswerDescriptor = $convert.base64Decode('Cg9QdWJsaXNoZXJBbnN3ZXISEAoDc2RwGAEgASgJUgNzZHA=');
@$core.Deprecated('Use localDeviceChangeDescriptor instead')
const LocalDeviceChange$json = const {
  '1': 'LocalDeviceChange',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
  ],
};

/// Descriptor for `LocalDeviceChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localDeviceChangeDescriptor = $convert.base64Decode('ChFMb2NhbERldmljZUNoYW5nZRISCgR0eXBlGAEgASgJUgR0eXBl');
@$core.Deprecated('Use iCECandidateTrickleDescriptor instead')
const ICECandidateTrickle$json = const {
  '1': 'ICECandidateTrickle',
  '2': const [
    const {'1': 'candidate', '3': 1, '4': 1, '5': 9, '10': 'candidate'},
  ],
};

/// Descriptor for `ICECandidateTrickle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCECandidateTrickleDescriptor = $convert.base64Decode('ChNJQ0VDYW5kaWRhdGVUcmlja2xlEhwKCWNhbmRpZGF0ZRgBIAEoCVIJY2FuZGlkYXRl');
@$core.Deprecated('Use connectionQualityChangedDescriptor instead')
const ConnectionQualityChanged$json = const {
  '1': 'ConnectionQualityChanged',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'connection_quality', '3': 2, '4': 1, '5': 14, '6': '.stream.video.sfu.models.ConnectionQuality', '10': 'connectionQuality'},
  ],
};

/// Descriptor for `ConnectionQualityChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionQualityChangedDescriptor = $convert.base64Decode('ChhDb25uZWN0aW9uUXVhbGl0eUNoYW5nZWQSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkElkKEmNvbm5lY3Rpb25fcXVhbGl0eRgCIAEoDjIqLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLkNvbm5lY3Rpb25RdWFsaXR5UhFjb25uZWN0aW9uUXVhbGl0eQ==');
@$core.Deprecated('Use dominantSpeakerChangedDescriptor instead')
const DominantSpeakerChanged$json = const {
  '1': 'DominantSpeakerChanged',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `DominantSpeakerChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dominantSpeakerChangedDescriptor = $convert.base64Decode('ChZEb21pbmFudFNwZWFrZXJDaGFuZ2VkEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZA==');
@$core.Deprecated('Use audioLevelChangedDescriptor instead')
const AudioLevelChanged$json = const {
  '1': 'AudioLevelChanged',
  '2': const [
    const {'1': 'audio_levels', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.event.AudioLevel', '10': 'audioLevels'},
  ],
};

/// Descriptor for `AudioLevelChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioLevelChangedDescriptor = $convert.base64Decode('ChFBdWRpb0xldmVsQ2hhbmdlZBJFCgxhdWRpb19sZXZlbHMYASADKAsyIi5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkF1ZGlvTGV2ZWxSC2F1ZGlvTGV2ZWxz');
@$core.Deprecated('Use callEndedDescriptor instead')
const CallEnded$json = const {
  '1': 'CallEnded',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `CallEnded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callEndedDescriptor = $convert.base64Decode('CglDYWxsRW5kZWQSGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use audioLevelDescriptor instead')
const AudioLevel$json = const {
  '1': 'AudioLevel',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'level', '3': 2, '4': 1, '5': 2, '10': 'level'},
  ],
};

/// Descriptor for `AudioLevel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioLevelDescriptor = $convert.base64Decode('CgpBdWRpb0xldmVsEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIUCgVsZXZlbBgCIAEoAlIFbGV2ZWw=');
@$core.Deprecated('Use audioLayerSettingDescriptor instead')
const AudioLayerSetting$json = const {
  '1': 'AudioLayerSetting',
};

/// Descriptor for `AudioLayerSetting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioLayerSettingDescriptor = $convert.base64Decode('ChFBdWRpb0xheWVyU2V0dGluZw==');
@$core.Deprecated('Use audioMediaRequestDescriptor instead')
const AudioMediaRequest$json = const {
  '1': 'AudioMediaRequest',
  '2': const [
    const {'1': 'channel_count', '3': 1, '4': 1, '5': 5, '10': 'channelCount'},
  ],
};

/// Descriptor for `AudioMediaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioMediaRequestDescriptor = $convert.base64Decode('ChFBdWRpb01lZGlhUmVxdWVzdBIjCg1jaGFubmVsX2NvdW50GAEgASgFUgxjaGFubmVsQ291bnQ=');
@$core.Deprecated('Use audioSenderDescriptor instead')
const AudioSender$json = const {
  '1': 'AudioSender',
  '2': const [
    const {'1': 'media_request', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event.AudioMediaRequest', '10': 'mediaRequest'},
    const {'1': 'codec', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Codec', '10': 'codec'},
    const {'1': 'layers', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.event.AudioLayerSetting', '10': 'layers'},
  ],
};

/// Descriptor for `AudioSender`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioSenderDescriptor = $convert.base64Decode('CgtBdWRpb1NlbmRlchJOCg1tZWRpYV9yZXF1ZXN0GAEgASgLMikuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5BdWRpb01lZGlhUmVxdWVzdFIMbWVkaWFSZXF1ZXN0EjQKBWNvZGVjGAIgASgLMh4uc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuQ29kZWNSBWNvZGVjEkEKBmxheWVycxgDIAMoCzIpLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuQXVkaW9MYXllclNldHRpbmdSBmxheWVycw==');
@$core.Deprecated('Use videoMediaRequestDescriptor instead')
const VideoMediaRequest$json = const {
  '1': 'VideoMediaRequest',
  '2': const [
    const {'1': 'ideal_height', '3': 1, '4': 1, '5': 5, '10': 'idealHeight'},
    const {'1': 'ideal_width', '3': 2, '4': 1, '5': 5, '10': 'idealWidth'},
    const {'1': 'ideal_frame_rate', '3': 3, '4': 1, '5': 5, '10': 'idealFrameRate'},
  ],
};

/// Descriptor for `VideoMediaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoMediaRequestDescriptor = $convert.base64Decode('ChFWaWRlb01lZGlhUmVxdWVzdBIhCgxpZGVhbF9oZWlnaHQYASABKAVSC2lkZWFsSGVpZ2h0Eh8KC2lkZWFsX3dpZHRoGAIgASgFUgppZGVhbFdpZHRoEigKEGlkZWFsX2ZyYW1lX3JhdGUYAyABKAVSDmlkZWFsRnJhbWVSYXRl');
@$core.Deprecated('Use videoLayerSettingDescriptor instead')
const VideoLayerSetting$json = const {
  '1': 'VideoLayerSetting',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'active', '3': 2, '4': 1, '5': 8, '10': 'active'},
    const {'1': 'max_bitrate', '3': 3, '4': 1, '5': 5, '10': 'maxBitrate'},
    const {'1': 'scale_resolution_down_by', '3': 4, '4': 1, '5': 2, '10': 'scaleResolutionDownBy'},
    const {'1': 'priority', '3': 5, '4': 1, '5': 14, '6': '.stream.video.sfu.event.VideoLayerSetting.Priority', '10': 'priority'},
    const {'1': 'codec', '3': 6, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Codec', '10': 'codec'},
  ],
  '4': const [VideoLayerSetting_Priority$json],
};

@$core.Deprecated('Use videoLayerSettingDescriptor instead')
const VideoLayerSetting_Priority$json = const {
  '1': 'Priority',
  '2': const [
    const {'1': 'PRIORITY_HIGH_UNSPECIFIED', '2': 0},
    const {'1': 'PRIORITY_LOW', '2': 1},
    const {'1': 'PRIORITY_MEDIUM', '2': 2},
    const {'1': 'PRIORITY_VERY_LOW', '2': 3},
  ],
};

/// Descriptor for `VideoLayerSetting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoLayerSettingDescriptor = $convert.base64Decode('ChFWaWRlb0xheWVyU2V0dGluZxISCgRuYW1lGAEgASgJUgRuYW1lEhYKBmFjdGl2ZRgCIAEoCFIGYWN0aXZlEh8KC21heF9iaXRyYXRlGAMgASgFUgptYXhCaXRyYXRlEjcKGHNjYWxlX3Jlc29sdXRpb25fZG93bl9ieRgEIAEoAlIVc2NhbGVSZXNvbHV0aW9uRG93bkJ5Ek4KCHByaW9yaXR5GAUgASgOMjIuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5WaWRlb0xheWVyU2V0dGluZy5Qcmlvcml0eVIIcHJpb3JpdHkSNAoFY29kZWMYBiABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5Db2RlY1IFY29kZWMiZwoIUHJpb3JpdHkSHQoZUFJJT1JJVFlfSElHSF9VTlNQRUNJRklFRBAAEhAKDFBSSU9SSVRZX0xPVxABEhMKD1BSSU9SSVRZX01FRElVTRACEhUKEVBSSU9SSVRZX1ZFUllfTE9XEAM=');
@$core.Deprecated('Use videoSenderDescriptor instead')
const VideoSender$json = const {
  '1': 'VideoSender',
  '2': const [
    const {'1': 'media_request', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event.VideoMediaRequest', '10': 'mediaRequest'},
    const {'1': 'codec', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Codec', '10': 'codec'},
    const {'1': 'layers', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.event.VideoLayerSetting', '10': 'layers'},
  ],
};

/// Descriptor for `VideoSender`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoSenderDescriptor = $convert.base64Decode('CgtWaWRlb1NlbmRlchJOCg1tZWRpYV9yZXF1ZXN0GAEgASgLMikuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5WaWRlb01lZGlhUmVxdWVzdFIMbWVkaWFSZXF1ZXN0EjQKBWNvZGVjGAIgASgLMh4uc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuQ29kZWNSBWNvZGVjEkEKBmxheWVycxgDIAMoCzIpLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuVmlkZW9MYXllclNldHRpbmdSBmxheWVycw==');
@$core.Deprecated('Use changePublishQualityDescriptor instead')
const ChangePublishQuality$json = const {
  '1': 'ChangePublishQuality',
  '2': const [
    const {'1': 'audio_senders', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.event.AudioSender', '10': 'audioSenders'},
    const {'1': 'video_senders', '3': 2, '4': 3, '5': 11, '6': '.stream.video.sfu.event.VideoSender', '10': 'videoSenders'},
  ],
};

/// Descriptor for `ChangePublishQuality`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePublishQualityDescriptor = $convert.base64Decode('ChRDaGFuZ2VQdWJsaXNoUXVhbGl0eRJICg1hdWRpb19zZW5kZXJzGAEgAygLMiMuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5BdWRpb1NlbmRlclIMYXVkaW9TZW5kZXJzEkgKDXZpZGVvX3NlbmRlcnMYAiADKAsyIy5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LlZpZGVvU2VuZGVyUgx2aWRlb1NlbmRlcnM=');
