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
    const {'1': 'participant_joined', '3': 10, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ParticipantJoined', '9': 0, '10': 'participantJoined'},
    const {'1': 'participant_left', '3': 11, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ParticipantLeft', '9': 0, '10': 'participantLeft'},
    const {'1': 'dominant_speaker_changed', '3': 12, '4': 1, '5': 11, '6': '.stream.video.sfu.event.DominantSpeakerChanged', '9': 0, '10': 'dominantSpeakerChanged'},
    const {'1': 'join_response', '3': 13, '4': 1, '5': 11, '6': '.stream.video.sfu.event.JoinResponse', '9': 0, '10': 'joinResponse'},
    const {'1': 'health_check_response', '3': 14, '4': 1, '5': 11, '6': '.stream.video.sfu.event.HealthCheckResponse', '9': 0, '10': 'healthCheckResponse'},
    const {'1': 'track_published', '3': 16, '4': 1, '5': 11, '6': '.stream.video.sfu.event.TrackPublished', '9': 0, '10': 'trackPublished'},
    const {'1': 'track_unpublished', '3': 17, '4': 1, '5': 11, '6': '.stream.video.sfu.event.TrackUnpublished', '9': 0, '10': 'trackUnpublished'},
    const {'1': 'error', '3': 18, '4': 1, '5': 11, '6': '.stream.video.sfu.event.Error', '9': 0, '10': 'error'},
    const {'1': 'call_grants_updated', '3': 19, '4': 1, '5': 11, '6': '.stream.video.sfu.event.CallGrantsUpdated', '9': 0, '10': 'callGrantsUpdated'},
    const {'1': 'go_away', '3': 20, '4': 1, '5': 11, '6': '.stream.video.sfu.event.GoAway', '9': 0, '10': 'goAway'},
    const {'1': 'ice_restart', '3': 21, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ICERestart', '9': 0, '10': 'iceRestart'},
    const {'1': 'pins_updated', '3': 22, '4': 1, '5': 11, '6': '.stream.video.sfu.event.PinsChanged', '9': 0, '10': 'pinsUpdated'},
  ],
  '8': const [
    const {'1': 'event_payload'},
  ],
};

/// Descriptor for `SfuEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sfuEventDescriptor = $convert.base64Decode('CghTZnVFdmVudBJUChBzdWJzY3JpYmVyX29mZmVyGAEgASgLMicuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5TdWJzY3JpYmVyT2ZmZXJIAFIPc3Vic2NyaWJlck9mZmVyElQKEHB1Ymxpc2hlcl9hbnN3ZXIYAiABKAsyJy5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LlB1Ymxpc2hlckFuc3dlckgAUg9wdWJsaXNoZXJBbnN3ZXIScAoaY29ubmVjdGlvbl9xdWFsaXR5X2NoYW5nZWQYAyABKAsyMC5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkNvbm5lY3Rpb25RdWFsaXR5Q2hhbmdlZEgAUhhjb25uZWN0aW9uUXVhbGl0eUNoYW5nZWQSWwoTYXVkaW9fbGV2ZWxfY2hhbmdlZBgEIAEoCzIpLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuQXVkaW9MZXZlbENoYW5nZWRIAFIRYXVkaW9MZXZlbENoYW5nZWQSRgoLaWNlX3RyaWNrbGUYBSABKAsyIy5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5JQ0VUcmlja2xlSABSCmljZVRyaWNrbGUSZAoWY2hhbmdlX3B1Ymxpc2hfcXVhbGl0eRgGIAEoCzIsLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuQ2hhbmdlUHVibGlzaFF1YWxpdHlIAFIUY2hhbmdlUHVibGlzaFF1YWxpdHkSWgoScGFydGljaXBhbnRfam9pbmVkGAogASgLMikuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5QYXJ0aWNpcGFudEpvaW5lZEgAUhFwYXJ0aWNpcGFudEpvaW5lZBJUChBwYXJ0aWNpcGFudF9sZWZ0GAsgASgLMicuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5QYXJ0aWNpcGFudExlZnRIAFIPcGFydGljaXBhbnRMZWZ0EmoKGGRvbWluYW50X3NwZWFrZXJfY2hhbmdlZBgMIAEoCzIuLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuRG9taW5hbnRTcGVha2VyQ2hhbmdlZEgAUhZkb21pbmFudFNwZWFrZXJDaGFuZ2VkEksKDWpvaW5fcmVzcG9uc2UYDSABKAsyJC5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkpvaW5SZXNwb25zZUgAUgxqb2luUmVzcG9uc2USYQoVaGVhbHRoX2NoZWNrX3Jlc3BvbnNlGA4gASgLMisuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5IZWFsdGhDaGVja1Jlc3BvbnNlSABSE2hlYWx0aENoZWNrUmVzcG9uc2USUQoPdHJhY2tfcHVibGlzaGVkGBAgASgLMiYuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5UcmFja1B1Ymxpc2hlZEgAUg50cmFja1B1Ymxpc2hlZBJXChF0cmFja191bnB1Ymxpc2hlZBgRIAEoCzIoLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuVHJhY2tVbnB1Ymxpc2hlZEgAUhB0cmFja1VucHVibGlzaGVkEjUKBWVycm9yGBIgASgLMh0uc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5FcnJvckgAUgVlcnJvchJbChNjYWxsX2dyYW50c191cGRhdGVkGBMgASgLMikuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5DYWxsR3JhbnRzVXBkYXRlZEgAUhFjYWxsR3JhbnRzVXBkYXRlZBI5Cgdnb19hd2F5GBQgASgLMh4uc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5Hb0F3YXlIAFIGZ29Bd2F5EkUKC2ljZV9yZXN0YXJ0GBUgASgLMiIuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5JQ0VSZXN0YXJ0SABSCmljZVJlc3RhcnQSSAoMcGluc191cGRhdGVkGBYgASgLMiMuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5QaW5zQ2hhbmdlZEgAUgtwaW5zVXBkYXRlZEIPCg1ldmVudF9wYXlsb2Fk');
@$core.Deprecated('Use pinsChangedDescriptor instead')
const PinsChanged$json = const {
  '1': 'PinsChanged',
  '2': const [
    const {'1': 'pins', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.models.Pin', '10': 'pins'},
  ],
};

/// Descriptor for `PinsChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pinsChangedDescriptor = $convert.base64Decode('CgtQaW5zQ2hhbmdlZBIwCgRwaW5zGAEgAygLMhwuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuUGluUgRwaW5z');
@$core.Deprecated('Use errorDescriptor instead')
const Error$json = const {
  '1': 'Error',
  '2': const [
    const {'1': 'error', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode('CgVFcnJvchI0CgVlcnJvchgEIAEoCzIeLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLkVycm9yUgVlcnJvcg==');
@$core.Deprecated('Use iCETrickleDescriptor instead')
const ICETrickle$json = const {
  '1': 'ICETrickle',
  '2': const [
    const {'1': 'peer_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.PeerType', '10': 'peerType'},
    const {'1': 'ice_candidate', '3': 2, '4': 1, '5': 9, '10': 'iceCandidate'},
  ],
};

/// Descriptor for `ICETrickle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCETrickleDescriptor = $convert.base64Decode('CgpJQ0VUcmlja2xlEj4KCXBlZXJfdHlwZRgBIAEoDjIhLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlBlZXJUeXBlUghwZWVyVHlwZRIjCg1pY2VfY2FuZGlkYXRlGAIgASgJUgxpY2VDYW5kaWRhdGU=');
@$core.Deprecated('Use iCERestartDescriptor instead')
const ICERestart$json = const {
  '1': 'ICERestart',
  '2': const [
    const {'1': 'peer_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.PeerType', '10': 'peerType'},
  ],
};

/// Descriptor for `ICERestart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCERestartDescriptor = $convert.base64Decode('CgpJQ0VSZXN0YXJ0Ej4KCXBlZXJfdHlwZRgBIAEoDjIhLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlBlZXJUeXBlUghwZWVyVHlwZQ==');
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
};

/// Descriptor for `HealthCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthCheckRequestDescriptor = $convert.base64Decode('ChJIZWFsdGhDaGVja1JlcXVlc3Q=');
@$core.Deprecated('Use healthCheckResponseDescriptor instead')
const HealthCheckResponse$json = const {
  '1': 'HealthCheckResponse',
  '2': const [
    const {'1': 'participant_count', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.ParticipantCount', '10': 'participantCount'},
  ],
};

/// Descriptor for `HealthCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthCheckResponseDescriptor = $convert.base64Decode('ChNIZWFsdGhDaGVja1Jlc3BvbnNlElYKEXBhcnRpY2lwYW50X2NvdW50GAEgASgLMikuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuUGFydGljaXBhbnRDb3VudFIQcGFydGljaXBhbnRDb3VudA==');
@$core.Deprecated('Use trackPublishedDescriptor instead')
const TrackPublished$json = const {
  '1': 'TrackPublished',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'type', '3': 3, '4': 1, '5': 14, '6': '.stream.video.sfu.models.TrackType', '10': 'type'},
    const {'1': 'participant', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `TrackPublished`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackPublishedDescriptor = $convert.base64Decode('Cg5UcmFja1B1Ymxpc2hlZBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEjYKBHR5cGUYAyABKA4yIi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5UcmFja1R5cGVSBHR5cGUSRgoLcGFydGljaXBhbnQYBCABKAsyJC5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5QYXJ0aWNpcGFudFILcGFydGljaXBhbnQ=');
@$core.Deprecated('Use trackUnpublishedDescriptor instead')
const TrackUnpublished$json = const {
  '1': 'TrackUnpublished',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'type', '3': 3, '4': 1, '5': 14, '6': '.stream.video.sfu.models.TrackType', '10': 'type'},
    const {'1': 'cause', '3': 4, '4': 1, '5': 14, '6': '.stream.video.sfu.models.TrackUnpublishReason', '10': 'cause'},
    const {'1': 'participant', '3': 5, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `TrackUnpublished`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackUnpublishedDescriptor = $convert.base64Decode('ChBUcmFja1VucHVibGlzaGVkEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIdCgpzZXNzaW9uX2lkGAIgASgJUglzZXNzaW9uSWQSNgoEdHlwZRgDIAEoDjIiLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlRyYWNrVHlwZVIEdHlwZRJDCgVjYXVzZRgEIAEoDjItLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlRyYWNrVW5wdWJsaXNoUmVhc29uUgVjYXVzZRJGCgtwYXJ0aWNpcGFudBgFIAEoCzIkLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlBhcnRpY2lwYW50UgtwYXJ0aWNpcGFudA==');
@$core.Deprecated('Use joinRequestDescriptor instead')
const JoinRequest$json = const {
  '1': 'JoinRequest',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'subscriber_sdp', '3': 3, '4': 1, '5': 9, '10': 'subscriberSdp'},
    const {'1': 'client_details', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.ClientDetails', '10': 'clientDetails'},
    const {'1': 'migration', '3': 5, '4': 1, '5': 11, '6': '.stream.video.sfu.event.Migration', '10': 'migration'},
    const {'1': 'fast_reconnect', '3': 6, '4': 1, '5': 8, '10': 'fastReconnect'},
  ],
};

/// Descriptor for `JoinRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRequestDescriptor = $convert.base64Decode('CgtKb2luUmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4SHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEiUKDnN1YnNjcmliZXJfc2RwGAMgASgJUg1zdWJzY3JpYmVyU2RwEk0KDmNsaWVudF9kZXRhaWxzGAQgASgLMiYuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuQ2xpZW50RGV0YWlsc1INY2xpZW50RGV0YWlscxI/CgltaWdyYXRpb24YBSABKAsyIS5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50Lk1pZ3JhdGlvblIJbWlncmF0aW9uEiUKDmZhc3RfcmVjb25uZWN0GAYgASgIUg1mYXN0UmVjb25uZWN0');
@$core.Deprecated('Use migrationDescriptor instead')
const Migration$json = const {
  '1': 'Migration',
  '2': const [
    const {'1': 'from_sfu_id', '3': 1, '4': 1, '5': 9, '10': 'fromSfuId'},
    const {'1': 'announced_tracks', '3': 2, '4': 3, '5': 11, '6': '.stream.video.sfu.models.TrackInfo', '10': 'announcedTracks'},
    const {'1': 'subscriptions', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.signal.TrackSubscriptionDetails', '10': 'subscriptions'},
  ],
};

/// Descriptor for `Migration`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List migrationDescriptor = $convert.base64Decode('CglNaWdyYXRpb24SHgoLZnJvbV9zZnVfaWQYASABKAlSCWZyb21TZnVJZBJNChBhbm5vdW5jZWRfdHJhY2tzGAIgAygLMiIuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuVHJhY2tJbmZvUg9hbm5vdW5jZWRUcmFja3MSVwoNc3Vic2NyaXB0aW9ucxgDIAMoCzIxLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlRyYWNrU3Vic2NyaXB0aW9uRGV0YWlsc1INc3Vic2NyaXB0aW9ucw==');
@$core.Deprecated('Use joinResponseDescriptor instead')
const JoinResponse$json = const {
  '1': 'JoinResponse',
  '2': const [
    const {'1': 'call_state', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.CallState', '10': 'callState'},
    const {'1': 'reconnected', '3': 2, '4': 1, '5': 8, '10': 'reconnected'},
  ],
};

/// Descriptor for `JoinResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinResponseDescriptor = $convert.base64Decode('CgxKb2luUmVzcG9uc2USQQoKY2FsbF9zdGF0ZRgBIAEoCzIiLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLkNhbGxTdGF0ZVIJY2FsbFN0YXRlEiAKC3JlY29ubmVjdGVkGAIgASgIUgtyZWNvbm5lY3RlZA==');
@$core.Deprecated('Use participantJoinedDescriptor instead')
const ParticipantJoined$json = const {
  '1': 'ParticipantJoined',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantJoined`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantJoinedDescriptor = $convert.base64Decode('ChFQYXJ0aWNpcGFudEpvaW5lZBIZCghjYWxsX2NpZBgBIAEoCVIHY2FsbENpZBJGCgtwYXJ0aWNpcGFudBgCIAEoCzIkLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlBhcnRpY2lwYW50UgtwYXJ0aWNpcGFudA==');
@$core.Deprecated('Use participantLeftDescriptor instead')
const ParticipantLeft$json = const {
  '1': 'ParticipantLeft',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantLeft`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantLeftDescriptor = $convert.base64Decode('Cg9QYXJ0aWNpcGFudExlZnQSGQoIY2FsbF9jaWQYASABKAlSB2NhbGxDaWQSRgoLcGFydGljaXBhbnQYAiABKAsyJC5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5QYXJ0aWNpcGFudFILcGFydGljaXBhbnQ=');
@$core.Deprecated('Use subscriberOfferDescriptor instead')
const SubscriberOffer$json = const {
  '1': 'SubscriberOffer',
  '2': const [
    const {'1': 'ice_restart', '3': 1, '4': 1, '5': 8, '10': 'iceRestart'},
    const {'1': 'sdp', '3': 2, '4': 1, '5': 9, '10': 'sdp'},
  ],
};

/// Descriptor for `SubscriberOffer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriberOfferDescriptor = $convert.base64Decode('Cg9TdWJzY3JpYmVyT2ZmZXISHwoLaWNlX3Jlc3RhcnQYASABKAhSCmljZVJlc3RhcnQSEAoDc2RwGAIgASgJUgNzZHA=');
@$core.Deprecated('Use publisherAnswerDescriptor instead')
const PublisherAnswer$json = const {
  '1': 'PublisherAnswer',
  '2': const [
    const {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
  ],
};

/// Descriptor for `PublisherAnswer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publisherAnswerDescriptor = $convert.base64Decode('Cg9QdWJsaXNoZXJBbnN3ZXISEAoDc2RwGAEgASgJUgNzZHA=');
@$core.Deprecated('Use connectionQualityChangedDescriptor instead')
const ConnectionQualityChanged$json = const {
  '1': 'ConnectionQualityChanged',
  '2': const [
    const {'1': 'connection_quality_updates', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.event.ConnectionQualityInfo', '10': 'connectionQualityUpdates'},
  ],
};

/// Descriptor for `ConnectionQualityChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionQualityChangedDescriptor = $convert.base64Decode('ChhDb25uZWN0aW9uUXVhbGl0eUNoYW5nZWQSawoaY29ubmVjdGlvbl9xdWFsaXR5X3VwZGF0ZXMYASADKAsyLS5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkNvbm5lY3Rpb25RdWFsaXR5SW5mb1IYY29ubmVjdGlvblF1YWxpdHlVcGRhdGVz');
@$core.Deprecated('Use connectionQualityInfoDescriptor instead')
const ConnectionQualityInfo$json = const {
  '1': 'ConnectionQualityInfo',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'connection_quality', '3': 3, '4': 1, '5': 14, '6': '.stream.video.sfu.models.ConnectionQuality', '10': 'connectionQuality'},
  ],
};

/// Descriptor for `ConnectionQualityInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionQualityInfoDescriptor = $convert.base64Decode('ChVDb25uZWN0aW9uUXVhbGl0eUluZm8SFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEh0KCnNlc3Npb25faWQYAiABKAlSCXNlc3Npb25JZBJZChJjb25uZWN0aW9uX3F1YWxpdHkYAyABKA4yKi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5Db25uZWN0aW9uUXVhbGl0eVIRY29ubmVjdGlvblF1YWxpdHk=');
@$core.Deprecated('Use dominantSpeakerChangedDescriptor instead')
const DominantSpeakerChanged$json = const {
  '1': 'DominantSpeakerChanged',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `DominantSpeakerChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dominantSpeakerChangedDescriptor = $convert.base64Decode('ChZEb21pbmFudFNwZWFrZXJDaGFuZ2VkEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIdCgpzZXNzaW9uX2lkGAIgASgJUglzZXNzaW9uSWQ=');
@$core.Deprecated('Use audioLevelDescriptor instead')
const AudioLevel$json = const {
  '1': 'AudioLevel',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'level', '3': 3, '4': 1, '5': 2, '10': 'level'},
    const {'1': 'is_speaking', '3': 4, '4': 1, '5': 8, '10': 'isSpeaking'},
  ],
};

/// Descriptor for `AudioLevel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioLevelDescriptor = $convert.base64Decode('CgpBdWRpb0xldmVsEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIdCgpzZXNzaW9uX2lkGAIgASgJUglzZXNzaW9uSWQSFAoFbGV2ZWwYAyABKAJSBWxldmVsEh8KC2lzX3NwZWFraW5nGAQgASgIUgppc1NwZWFraW5n');
@$core.Deprecated('Use audioLevelChangedDescriptor instead')
const AudioLevelChanged$json = const {
  '1': 'AudioLevelChanged',
  '2': const [
    const {'1': 'audio_levels', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.event.AudioLevel', '10': 'audioLevels'},
  ],
};

/// Descriptor for `AudioLevelChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioLevelChangedDescriptor = $convert.base64Decode('ChFBdWRpb0xldmVsQ2hhbmdlZBJFCgxhdWRpb19sZXZlbHMYASADKAsyIi5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkF1ZGlvTGV2ZWxSC2F1ZGlvTGV2ZWxz');
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
  ],
};

/// Descriptor for `AudioSender`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioSenderDescriptor = $convert.base64Decode('CgtBdWRpb1NlbmRlchJOCg1tZWRpYV9yZXF1ZXN0GAEgASgLMikuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5BdWRpb01lZGlhUmVxdWVzdFIMbWVkaWFSZXF1ZXN0EjQKBWNvZGVjGAIgASgLMh4uc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuQ29kZWNSBWNvZGVj');
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
@$core.Deprecated('Use callGrantsUpdatedDescriptor instead')
const CallGrantsUpdated$json = const {
  '1': 'CallGrantsUpdated',
  '2': const [
    const {'1': 'current_grants', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.CallGrants', '10': 'currentGrants'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `CallGrantsUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callGrantsUpdatedDescriptor = $convert.base64Decode('ChFDYWxsR3JhbnRzVXBkYXRlZBJKCg5jdXJyZW50X2dyYW50cxgBIAEoCzIjLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLkNhbGxHcmFudHNSDWN1cnJlbnRHcmFudHMSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use goAwayDescriptor instead')
const GoAway$json = const {
  '1': 'GoAway',
  '2': const [
    const {'1': 'reason', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.GoAwayReason', '10': 'reason'},
  ],
};

/// Descriptor for `GoAway`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List goAwayDescriptor = $convert.base64Decode('CgZHb0F3YXkSPQoGcmVhc29uGAEgASgOMiUuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuR29Bd2F5UmVhc29uUgZyZWFzb24=');
