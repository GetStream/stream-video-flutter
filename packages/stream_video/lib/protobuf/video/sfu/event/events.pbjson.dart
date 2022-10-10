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
    const {'1': 'connection_quality_changed', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ConnectionQualityChanged', '9': 0, '10': 'connectionQualityChanged'},
    const {'1': 'audio_level_changed', '3': 3, '4': 1, '5': 11, '6': '.stream.video.sfu.event.AudioLevelChanged', '9': 0, '10': 'audioLevelChanged'},
    const {'1': 'subscriber_candidate', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ICECandidateTrickle', '9': 0, '10': 'subscriberCandidate'},
    const {'1': 'publisher_candidate', '3': 5, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ICECandidateTrickle', '9': 0, '10': 'publisherCandidate'},
    const {'1': 'change_publish_quality', '3': 6, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ChangePublishQuality', '9': 0, '10': 'changePublishQuality'},
    const {'1': 'local_device_change', '3': 7, '4': 1, '5': 11, '6': '.stream.video.sfu.event.LocalDeviceChange', '9': 0, '10': 'localDeviceChange'},
    const {'1': 'mute_state_changed', '3': 8, '4': 1, '5': 11, '6': '.stream.video.sfu.event.MuteStateChanged', '9': 0, '10': 'muteStateChanged'},
    const {'1': 'video_quality_changed', '3': 9, '4': 1, '5': 11, '6': '.stream.video.sfu.event.VideoQualityChanged', '9': 0, '10': 'videoQualityChanged'},
    const {'1': 'participant_joined', '3': 10, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ParticipantJoined', '9': 0, '10': 'participantJoined'},
    const {'1': 'participant_left', '3': 11, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ParticipantLeft', '9': 0, '10': 'participantLeft'},
    const {'1': 'dominant_speaker_changed', '3': 12, '4': 1, '5': 11, '6': '.stream.video.sfu.event.DominantSpeakerChanged', '9': 0, '10': 'dominantSpeakerChanged'},
  ],
  '8': const [
    const {'1': 'event_payload'},
  ],
};

/// Descriptor for `SfuEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sfuEventDescriptor = $convert.base64Decode('CghTZnVFdmVudBJUChBzdWJzY3JpYmVyX29mZmVyGAEgASgLMicuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5TdWJzY3JpYmVyT2ZmZXJIAFIPc3Vic2NyaWJlck9mZmVyEnAKGmNvbm5lY3Rpb25fcXVhbGl0eV9jaGFuZ2VkGAIgASgLMjAuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5Db25uZWN0aW9uUXVhbGl0eUNoYW5nZWRIAFIYY29ubmVjdGlvblF1YWxpdHlDaGFuZ2VkElsKE2F1ZGlvX2xldmVsX2NoYW5nZWQYAyABKAsyKS5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkF1ZGlvTGV2ZWxDaGFuZ2VkSABSEWF1ZGlvTGV2ZWxDaGFuZ2VkEmAKFHN1YnNjcmliZXJfY2FuZGlkYXRlGAQgASgLMisuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5JQ0VDYW5kaWRhdGVUcmlja2xlSABSE3N1YnNjcmliZXJDYW5kaWRhdGUSXgoTcHVibGlzaGVyX2NhbmRpZGF0ZRgFIAEoCzIrLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuSUNFQ2FuZGlkYXRlVHJpY2tsZUgAUhJwdWJsaXNoZXJDYW5kaWRhdGUSZAoWY2hhbmdlX3B1Ymxpc2hfcXVhbGl0eRgGIAEoCzIsLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuQ2hhbmdlUHVibGlzaFF1YWxpdHlIAFIUY2hhbmdlUHVibGlzaFF1YWxpdHkSWwoTbG9jYWxfZGV2aWNlX2NoYW5nZRgHIAEoCzIpLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuTG9jYWxEZXZpY2VDaGFuZ2VIAFIRbG9jYWxEZXZpY2VDaGFuZ2USWAoSbXV0ZV9zdGF0ZV9jaGFuZ2VkGAggASgLMiguc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5NdXRlU3RhdGVDaGFuZ2VkSABSEG11dGVTdGF0ZUNoYW5nZWQSYQoVdmlkZW9fcXVhbGl0eV9jaGFuZ2VkGAkgASgLMisuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5WaWRlb1F1YWxpdHlDaGFuZ2VkSABSE3ZpZGVvUXVhbGl0eUNoYW5nZWQSWgoScGFydGljaXBhbnRfam9pbmVkGAogASgLMikuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5QYXJ0aWNpcGFudEpvaW5lZEgAUhFwYXJ0aWNpcGFudEpvaW5lZBJUChBwYXJ0aWNpcGFudF9sZWZ0GAsgASgLMicuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5QYXJ0aWNpcGFudExlZnRIAFIPcGFydGljaXBhbnRMZWZ0EmoKGGRvbWluYW50X3NwZWFrZXJfY2hhbmdlZBgMIAEoCzIuLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuRG9taW5hbnRTcGVha2VyQ2hhbmdlZEgAUhZkb21pbmFudFNwZWFrZXJDaGFuZ2VkQg8KDWV2ZW50X3BheWxvYWQ=');
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
    const {'1': 'channelCount', '3': 1, '4': 1, '5': 5, '10': 'channelCount'},
  ],
};

/// Descriptor for `AudioMediaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioMediaRequestDescriptor = $convert.base64Decode('ChFBdWRpb01lZGlhUmVxdWVzdBIiCgxjaGFubmVsQ291bnQYASABKAVSDGNoYW5uZWxDb3VudA==');
@$core.Deprecated('Use audioSenderDescriptor instead')
const AudioSender$json = const {
  '1': 'AudioSender',
  '2': const [
    const {'1': 'mediaRequest', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event.AudioMediaRequest', '10': 'mediaRequest'},
    const {'1': 'codec', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Codec', '10': 'codec'},
    const {'1': 'layers', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.event.AudioLayerSetting', '10': 'layers'},
  ],
};

/// Descriptor for `AudioSender`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioSenderDescriptor = $convert.base64Decode('CgtBdWRpb1NlbmRlchJNCgxtZWRpYVJlcXVlc3QYASABKAsyKS5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkF1ZGlvTWVkaWFSZXF1ZXN0UgxtZWRpYVJlcXVlc3QSNAoFY29kZWMYAiABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5Db2RlY1IFY29kZWMSQQoGbGF5ZXJzGAMgAygLMikuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5BdWRpb0xheWVyU2V0dGluZ1IGbGF5ZXJz');
@$core.Deprecated('Use videoMediaRequestDescriptor instead')
const VideoMediaRequest$json = const {
  '1': 'VideoMediaRequest',
  '2': const [
    const {'1': 'idealHeight', '3': 1, '4': 1, '5': 5, '10': 'idealHeight'},
    const {'1': 'idealWidth', '3': 2, '4': 1, '5': 5, '10': 'idealWidth'},
    const {'1': 'idealFrameRate', '3': 3, '4': 1, '5': 5, '10': 'idealFrameRate'},
  ],
};

/// Descriptor for `VideoMediaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoMediaRequestDescriptor = $convert.base64Decode('ChFWaWRlb01lZGlhUmVxdWVzdBIgCgtpZGVhbEhlaWdodBgBIAEoBVILaWRlYWxIZWlnaHQSHgoKaWRlYWxXaWR0aBgCIAEoBVIKaWRlYWxXaWR0aBImCg5pZGVhbEZyYW1lUmF0ZRgDIAEoBVIOaWRlYWxGcmFtZVJhdGU=');
@$core.Deprecated('Use videoLayerSettingDescriptor instead')
const VideoLayerSetting$json = const {
  '1': 'VideoLayerSetting',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'active', '3': 2, '4': 1, '5': 8, '10': 'active'},
    const {'1': 'maxBitrate', '3': 3, '4': 1, '5': 5, '10': 'maxBitrate'},
    const {'1': 'scaleResolutionDownBy', '3': 4, '4': 1, '5': 2, '10': 'scaleResolutionDownBy'},
    const {'1': 'priority', '3': 5, '4': 1, '5': 14, '6': '.stream.video.sfu.event.VideoLayerSetting.Priority', '10': 'priority'},
    const {'1': 'codec', '3': 6, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Codec', '10': 'codec'},
  ],
  '4': const [VideoLayerSetting_Priority$json],
};

@$core.Deprecated('Use videoLayerSettingDescriptor instead')
const VideoLayerSetting_Priority$json = const {
  '1': 'Priority',
  '2': const [
    const {'1': 'HIGH', '2': 0},
    const {'1': 'LOW', '2': 1},
    const {'1': 'MEDIUM', '2': 2},
    const {'1': 'VERY_LOW', '2': 3},
  ],
};

/// Descriptor for `VideoLayerSetting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoLayerSettingDescriptor = $convert.base64Decode('ChFWaWRlb0xheWVyU2V0dGluZxISCgRuYW1lGAEgASgJUgRuYW1lEhYKBmFjdGl2ZRgCIAEoCFIGYWN0aXZlEh4KCm1heEJpdHJhdGUYAyABKAVSCm1heEJpdHJhdGUSNAoVc2NhbGVSZXNvbHV0aW9uRG93bkJ5GAQgASgCUhVzY2FsZVJlc29sdXRpb25Eb3duQnkSTgoIcHJpb3JpdHkYBSABKA4yMi5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LlZpZGVvTGF5ZXJTZXR0aW5nLlByaW9yaXR5Ughwcmlvcml0eRI0CgVjb2RlYxgGIAEoCzIeLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLkNvZGVjUgVjb2RlYyI3CghQcmlvcml0eRIICgRISUdIEAASBwoDTE9XEAESCgoGTUVESVVNEAISDAoIVkVSWV9MT1cQAw==');
@$core.Deprecated('Use videoSenderDescriptor instead')
const VideoSender$json = const {
  '1': 'VideoSender',
  '2': const [
    const {'1': 'mediaRequest', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event.VideoMediaRequest', '10': 'mediaRequest'},
    const {'1': 'codec', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Codec', '10': 'codec'},
    const {'1': 'layers', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.event.VideoLayerSetting', '10': 'layers'},
  ],
};

/// Descriptor for `VideoSender`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoSenderDescriptor = $convert.base64Decode('CgtWaWRlb1NlbmRlchJNCgxtZWRpYVJlcXVlc3QYASABKAsyKS5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LlZpZGVvTWVkaWFSZXF1ZXN0UgxtZWRpYVJlcXVlc3QSNAoFY29kZWMYAiABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5Db2RlY1IFY29kZWMSQQoGbGF5ZXJzGAMgAygLMikuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5WaWRlb0xheWVyU2V0dGluZ1IGbGF5ZXJz');
@$core.Deprecated('Use changePublishQualityDescriptor instead')
const ChangePublishQuality$json = const {
  '1': 'ChangePublishQuality',
  '2': const [
    const {'1': 'audio_sender', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.event.AudioSender', '10': 'audioSender'},
    const {'1': 'video_sender', '3': 2, '4': 3, '5': 11, '6': '.stream.video.sfu.event.VideoSender', '10': 'videoSender'},
  ],
};

/// Descriptor for `ChangePublishQuality`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePublishQualityDescriptor = $convert.base64Decode('ChRDaGFuZ2VQdWJsaXNoUXVhbGl0eRJGCgxhdWRpb19zZW5kZXIYASADKAsyIy5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkF1ZGlvU2VuZGVyUgthdWRpb1NlbmRlchJGCgx2aWRlb19zZW5kZXIYAiADKAsyIy5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LlZpZGVvU2VuZGVyUgt2aWRlb1NlbmRlcg==');
