///
//  Generated code. Do not modify.
//  source: video/sfu/event_v1/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use eventDescriptor instead')
const Event$json = const {
  '1': 'Event',
  '2': const [
    const {'1': 'subscriber_offer', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.SubscriberOffer', '9': 0, '10': 'subscriberOffer'},
    const {'1': 'connection_quality_changed', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.ConnectionQualityChanged', '9': 0, '10': 'connectionQualityChanged'},
    const {'1': 'audio_level_changed', '3': 3, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.AudioLevelChanged', '9': 0, '10': 'audioLevelChanged'},
    const {'1': 'subscriber_candidate', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.ICECandidateTrickle', '9': 0, '10': 'subscriberCandidate'},
    const {'1': 'publisher_candidate', '3': 5, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.ICECandidateTrickle', '9': 0, '10': 'publisherCandidate'},
    const {'1': 'change_publish_quality', '3': 6, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.ChangePublishQuality', '9': 0, '10': 'changePublishQuality'},
    const {'1': 'mute_state_changed', '3': 7, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.MuteStateChanged', '9': 0, '10': 'muteStateChanged'},
    const {'1': 'video_quality_changed', '3': 8, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.VideoQualityChanged', '9': 0, '10': 'videoQualityChanged'},
    const {'1': 'participant_connected', '3': 9, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.ParticipantConnected', '9': 0, '10': 'participantConnected'},
    const {'1': 'participant_disconnected', '3': 10, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.ParticipantDisconnected', '9': 0, '10': 'participantDisconnected'},
    const {'1': 'dominant_speaker_changed', '3': 11, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.DominantSpeakerChanged', '9': 0, '10': 'dominantSpeakerChanged'},
    const {'1': 'local_device_change', '3': 12, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.LocalDeviceChanged', '9': 0, '10': 'localDeviceChange'},
  ],
  '8': const [
    const {'1': 'event_payload'},
  ],
};

/// Descriptor for `Event`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDescriptor = $convert.base64Decode('CgVFdmVudBJXChBzdWJzY3JpYmVyX29mZmVyGAEgASgLMiouc3RyZWFtLnZpZGVvLnNmdS5ldmVudF92MS5TdWJzY3JpYmVyT2ZmZXJIAFIPc3Vic2NyaWJlck9mZmVyEnMKGmNvbm5lY3Rpb25fcXVhbGl0eV9jaGFuZ2VkGAIgASgLMjMuc3RyZWFtLnZpZGVvLnNmdS5ldmVudF92MS5Db25uZWN0aW9uUXVhbGl0eUNoYW5nZWRIAFIYY29ubmVjdGlvblF1YWxpdHlDaGFuZ2VkEl4KE2F1ZGlvX2xldmVsX2NoYW5nZWQYAyABKAsyLC5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50X3YxLkF1ZGlvTGV2ZWxDaGFuZ2VkSABSEWF1ZGlvTGV2ZWxDaGFuZ2VkEmMKFHN1YnNjcmliZXJfY2FuZGlkYXRlGAQgASgLMi4uc3RyZWFtLnZpZGVvLnNmdS5ldmVudF92MS5JQ0VDYW5kaWRhdGVUcmlja2xlSABSE3N1YnNjcmliZXJDYW5kaWRhdGUSYQoTcHVibGlzaGVyX2NhbmRpZGF0ZRgFIAEoCzIuLnN0cmVhbS52aWRlby5zZnUuZXZlbnRfdjEuSUNFQ2FuZGlkYXRlVHJpY2tsZUgAUhJwdWJsaXNoZXJDYW5kaWRhdGUSZwoWY2hhbmdlX3B1Ymxpc2hfcXVhbGl0eRgGIAEoCzIvLnN0cmVhbS52aWRlby5zZnUuZXZlbnRfdjEuQ2hhbmdlUHVibGlzaFF1YWxpdHlIAFIUY2hhbmdlUHVibGlzaFF1YWxpdHkSWwoSbXV0ZV9zdGF0ZV9jaGFuZ2VkGAcgASgLMisuc3RyZWFtLnZpZGVvLnNmdS5ldmVudF92MS5NdXRlU3RhdGVDaGFuZ2VkSABSEG11dGVTdGF0ZUNoYW5nZWQSZAoVdmlkZW9fcXVhbGl0eV9jaGFuZ2VkGAggASgLMi4uc3RyZWFtLnZpZGVvLnNmdS5ldmVudF92MS5WaWRlb1F1YWxpdHlDaGFuZ2VkSABSE3ZpZGVvUXVhbGl0eUNoYW5nZWQSZgoVcGFydGljaXBhbnRfY29ubmVjdGVkGAkgASgLMi8uc3RyZWFtLnZpZGVvLnNmdS5ldmVudF92MS5QYXJ0aWNpcGFudENvbm5lY3RlZEgAUhRwYXJ0aWNpcGFudENvbm5lY3RlZBJvChhwYXJ0aWNpcGFudF9kaXNjb25uZWN0ZWQYCiABKAsyMi5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50X3YxLlBhcnRpY2lwYW50RGlzY29ubmVjdGVkSABSF3BhcnRpY2lwYW50RGlzY29ubmVjdGVkEm0KGGRvbWluYW50X3NwZWFrZXJfY2hhbmdlZBgLIAEoCzIxLnN0cmVhbS52aWRlby5zZnUuZXZlbnRfdjEuRG9taW5hbnRTcGVha2VyQ2hhbmdlZEgAUhZkb21pbmFudFNwZWFrZXJDaGFuZ2VkEl8KE2xvY2FsX2RldmljZV9jaGFuZ2UYDCABKAsyLS5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50X3YxLkxvY2FsRGV2aWNlQ2hhbmdlZEgAUhFsb2NhbERldmljZUNoYW5nZUIPCg1ldmVudF9wYXlsb2Fk');
@$core.Deprecated('Use participantConnectedDescriptor instead')
const ParticipantConnected$json = const {
  '1': 'ParticipantConnected',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models_v1.Call', '10': 'call'},
    const {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models_v1.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantConnected`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantConnectedDescriptor = $convert.base64Decode('ChRQYXJ0aWNpcGFudENvbm5lY3RlZBI0CgRjYWxsGAEgASgLMiAuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHNfdjEuQ2FsbFIEY2FsbBJJCgtwYXJ0aWNpcGFudBgCIAEoCzInLnN0cmVhbS52aWRlby5zZnUubW9kZWxzX3YxLlBhcnRpY2lwYW50UgtwYXJ0aWNpcGFudA==');
@$core.Deprecated('Use participantDisconnectedDescriptor instead')
const ParticipantDisconnected$json = const {
  '1': 'ParticipantDisconnected',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models_v1.Call', '10': 'call'},
    const {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models_v1.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantDisconnected`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantDisconnectedDescriptor = $convert.base64Decode('ChdQYXJ0aWNpcGFudERpc2Nvbm5lY3RlZBI0CgRjYWxsGAEgASgLMiAuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHNfdjEuQ2FsbFIEY2FsbBJJCgtwYXJ0aWNpcGFudBgCIAEoCzInLnN0cmVhbS52aWRlby5zZnUubW9kZWxzX3YxLlBhcnRpY2lwYW50UgtwYXJ0aWNpcGFudA==');
@$core.Deprecated('Use muteStateChangedDescriptor instead')
const MuteStateChanged$json = const {
  '1': 'MuteStateChanged',
  '2': const [
    const {'1': 'participant', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models_v1.Participant', '10': 'participant'},
    const {'1': 'audio_muted', '3': 2, '4': 1, '5': 8, '10': 'audioMuted'},
    const {'1': 'video_muted', '3': 3, '4': 1, '5': 8, '10': 'videoMuted'},
  ],
};

/// Descriptor for `MuteStateChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List muteStateChangedDescriptor = $convert.base64Decode('ChBNdXRlU3RhdGVDaGFuZ2VkEkkKC3BhcnRpY2lwYW50GAEgASgLMicuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHNfdjEuUGFydGljaXBhbnRSC3BhcnRpY2lwYW50Eh8KC2F1ZGlvX211dGVkGAIgASgIUgphdWRpb011dGVkEh8KC3ZpZGVvX211dGVkGAMgASgIUgp2aWRlb011dGVk');
@$core.Deprecated('Use videoQualityChangedDescriptor instead')
const VideoQualityChanged$json = const {
  '1': 'VideoQualityChanged',
  '2': const [
    const {'1': 'stream_qualities', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.models_v1.StreamQuality', '10': 'streamQualities'},
  ],
};

/// Descriptor for `VideoQualityChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoQualityChangedDescriptor = $convert.base64Decode('ChNWaWRlb1F1YWxpdHlDaGFuZ2VkElQKEHN0cmVhbV9xdWFsaXRpZXMYASADKAsyKS5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVsc192MS5TdHJlYW1RdWFsaXR5Ug9zdHJlYW1RdWFsaXRpZXM=');
@$core.Deprecated('Use subscriberOfferDescriptor instead')
const SubscriberOffer$json = const {
  '1': 'SubscriberOffer',
  '2': const [
    const {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
  ],
};

/// Descriptor for `SubscriberOffer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriberOfferDescriptor = $convert.base64Decode('Cg9TdWJzY3JpYmVyT2ZmZXISEAoDc2RwGAEgASgJUgNzZHA=');
@$core.Deprecated('Use localDeviceChangedDescriptor instead')
const LocalDeviceChanged$json = const {
  '1': 'LocalDeviceChanged',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
  ],
};

/// Descriptor for `LocalDeviceChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localDeviceChangedDescriptor = $convert.base64Decode('ChJMb2NhbERldmljZUNoYW5nZWQSEgoEdHlwZRgBIAEoCVIEdHlwZQ==');
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
    const {'1': 'connection_quality', '3': 2, '4': 1, '5': 14, '6': '.stream.video.sfu.models_v1.ConnectionQuality', '10': 'connectionQuality'},
  ],
};

/// Descriptor for `ConnectionQualityChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionQualityChangedDescriptor = $convert.base64Decode('ChhDb25uZWN0aW9uUXVhbGl0eUNoYW5nZWQSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkElwKEmNvbm5lY3Rpb25fcXVhbGl0eRgCIAEoDjItLnN0cmVhbS52aWRlby5zZnUubW9kZWxzX3YxLkNvbm5lY3Rpb25RdWFsaXR5UhFjb25uZWN0aW9uUXVhbGl0eQ==');
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
    const {'1': 'audio_levels', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.event_v1.AudioLevel', '10': 'audioLevels'},
  ],
};

/// Descriptor for `AudioLevelChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioLevelChangedDescriptor = $convert.base64Decode('ChFBdWRpb0xldmVsQ2hhbmdlZBJICgxhdWRpb19sZXZlbHMYASADKAsyJS5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50X3YxLkF1ZGlvTGV2ZWxSC2F1ZGlvTGV2ZWxz');
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
    const {'1': 'media_request', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.AudioMediaRequest', '10': 'mediaRequest'},
    const {'1': 'codec', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models_v1.Codec', '10': 'codec'},
    const {'1': 'layers', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.event_v1.AudioLayerSetting', '10': 'layers'},
  ],
};

/// Descriptor for `AudioSender`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioSenderDescriptor = $convert.base64Decode('CgtBdWRpb1NlbmRlchJRCg1tZWRpYV9yZXF1ZXN0GAEgASgLMiwuc3RyZWFtLnZpZGVvLnNmdS5ldmVudF92MS5BdWRpb01lZGlhUmVxdWVzdFIMbWVkaWFSZXF1ZXN0EjcKBWNvZGVjGAIgASgLMiEuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHNfdjEuQ29kZWNSBWNvZGVjEkQKBmxheWVycxgDIAMoCzIsLnN0cmVhbS52aWRlby5zZnUuZXZlbnRfdjEuQXVkaW9MYXllclNldHRpbmdSBmxheWVycw==');
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
    const {'1': 'priority', '3': 5, '4': 1, '5': 14, '6': '.stream.video.sfu.event_v1.VideoLayerSetting.Priority', '10': 'priority'},
    const {'1': 'codec', '3': 6, '4': 1, '5': 11, '6': '.stream.video.sfu.models_v1.Codec', '10': 'codec'},
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
final $typed_data.Uint8List videoLayerSettingDescriptor = $convert.base64Decode('ChFWaWRlb0xheWVyU2V0dGluZxISCgRuYW1lGAEgASgJUgRuYW1lEhYKBmFjdGl2ZRgCIAEoCFIGYWN0aXZlEh8KC21heF9iaXRyYXRlGAMgASgFUgptYXhCaXRyYXRlEjcKGHNjYWxlX3Jlc29sdXRpb25fZG93bl9ieRgEIAEoAlIVc2NhbGVSZXNvbHV0aW9uRG93bkJ5ElEKCHByaW9yaXR5GAUgASgOMjUuc3RyZWFtLnZpZGVvLnNmdS5ldmVudF92MS5WaWRlb0xheWVyU2V0dGluZy5Qcmlvcml0eVIIcHJpb3JpdHkSNwoFY29kZWMYBiABKAsyIS5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVsc192MS5Db2RlY1IFY29kZWMiZwoIUHJpb3JpdHkSHQoZUFJJT1JJVFlfSElHSF9VTlNQRUNJRklFRBAAEhAKDFBSSU9SSVRZX0xPVxABEhMKD1BSSU9SSVRZX01FRElVTRACEhUKEVBSSU9SSVRZX1ZFUllfTE9XEAM=');
@$core.Deprecated('Use videoSenderDescriptor instead')
const VideoSender$json = const {
  '1': 'VideoSender',
  '2': const [
    const {'1': 'media_request', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event_v1.VideoMediaRequest', '10': 'mediaRequest'},
    const {'1': 'codec', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models_v1.Codec', '10': 'codec'},
    const {'1': 'layers', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.event_v1.VideoLayerSetting', '10': 'layers'},
  ],
};

/// Descriptor for `VideoSender`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoSenderDescriptor = $convert.base64Decode('CgtWaWRlb1NlbmRlchJRCg1tZWRpYV9yZXF1ZXN0GAEgASgLMiwuc3RyZWFtLnZpZGVvLnNmdS5ldmVudF92MS5WaWRlb01lZGlhUmVxdWVzdFIMbWVkaWFSZXF1ZXN0EjcKBWNvZGVjGAIgASgLMiEuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHNfdjEuQ29kZWNSBWNvZGVjEkQKBmxheWVycxgDIAMoCzIsLnN0cmVhbS52aWRlby5zZnUuZXZlbnRfdjEuVmlkZW9MYXllclNldHRpbmdSBmxheWVycw==');
@$core.Deprecated('Use changePublishQualityDescriptor instead')
const ChangePublishQuality$json = const {
  '1': 'ChangePublishQuality',
  '2': const [
    const {'1': 'audio_senders', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.event_v1.AudioSender', '10': 'audioSenders'},
    const {'1': 'video_senders', '3': 2, '4': 3, '5': 11, '6': '.stream.video.sfu.event_v1.VideoSender', '10': 'videoSenders'},
  ],
};

/// Descriptor for `ChangePublishQuality`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePublishQualityDescriptor = $convert.base64Decode('ChRDaGFuZ2VQdWJsaXNoUXVhbGl0eRJLCg1hdWRpb19zZW5kZXJzGAEgAygLMiYuc3RyZWFtLnZpZGVvLnNmdS5ldmVudF92MS5BdWRpb1NlbmRlclIMYXVkaW9TZW5kZXJzEksKDXZpZGVvX3NlbmRlcnMYAiADKAsyJi5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50X3YxLlZpZGVvU2VuZGVyUgx2aWRlb1NlbmRlcnM=');
