//
//  Generated code. Do not modify.
//  source: video/sfu/event/events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use sfuEventDescriptor instead')
const SfuEvent$json = {
  '1': 'SfuEvent',
  '2': [
    {'1': 'subscriber_offer', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event.SubscriberOffer', '9': 0, '10': 'subscriberOffer'},
    {'1': 'publisher_answer', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.event.PublisherAnswer', '9': 0, '10': 'publisherAnswer'},
    {'1': 'connection_quality_changed', '3': 3, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ConnectionQualityChanged', '9': 0, '10': 'connectionQualityChanged'},
    {'1': 'audio_level_changed', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.event.AudioLevelChanged', '9': 0, '10': 'audioLevelChanged'},
    {'1': 'ice_trickle', '3': 5, '4': 1, '5': 11, '6': '.stream.video.sfu.models.ICETrickle', '9': 0, '10': 'iceTrickle'},
    {'1': 'change_publish_quality', '3': 6, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ChangePublishQuality', '9': 0, '10': 'changePublishQuality'},
    {'1': 'participant_joined', '3': 10, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ParticipantJoined', '9': 0, '10': 'participantJoined'},
    {'1': 'participant_left', '3': 11, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ParticipantLeft', '9': 0, '10': 'participantLeft'},
    {'1': 'dominant_speaker_changed', '3': 12, '4': 1, '5': 11, '6': '.stream.video.sfu.event.DominantSpeakerChanged', '9': 0, '10': 'dominantSpeakerChanged'},
    {'1': 'join_response', '3': 13, '4': 1, '5': 11, '6': '.stream.video.sfu.event.JoinResponse', '9': 0, '10': 'joinResponse'},
    {'1': 'health_check_response', '3': 14, '4': 1, '5': 11, '6': '.stream.video.sfu.event.HealthCheckResponse', '9': 0, '10': 'healthCheckResponse'},
    {'1': 'track_published', '3': 16, '4': 1, '5': 11, '6': '.stream.video.sfu.event.TrackPublished', '9': 0, '10': 'trackPublished'},
    {'1': 'track_unpublished', '3': 17, '4': 1, '5': 11, '6': '.stream.video.sfu.event.TrackUnpublished', '9': 0, '10': 'trackUnpublished'},
    {'1': 'error', '3': 18, '4': 1, '5': 11, '6': '.stream.video.sfu.event.Error', '9': 0, '10': 'error'},
    {'1': 'call_grants_updated', '3': 19, '4': 1, '5': 11, '6': '.stream.video.sfu.event.CallGrantsUpdated', '9': 0, '10': 'callGrantsUpdated'},
    {'1': 'go_away', '3': 20, '4': 1, '5': 11, '6': '.stream.video.sfu.event.GoAway', '9': 0, '10': 'goAway'},
    {'1': 'ice_restart', '3': 21, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ICERestart', '9': 0, '10': 'iceRestart'},
    {'1': 'pins_updated', '3': 22, '4': 1, '5': 11, '6': '.stream.video.sfu.event.PinsChanged', '9': 0, '10': 'pinsUpdated'},
    {'1': 'call_ended', '3': 23, '4': 1, '5': 11, '6': '.stream.video.sfu.event.CallEnded', '9': 0, '10': 'callEnded'},
    {'1': 'participant_updated', '3': 24, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ParticipantUpdated', '9': 0, '10': 'participantUpdated'},
    {'1': 'participant_migration_complete', '3': 25, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ParticipantMigrationComplete', '9': 0, '10': 'participantMigrationComplete'},
  ],
  '8': [
    {'1': 'event_payload'},
  ],
};

/// Descriptor for `SfuEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sfuEventDescriptor = $convert.base64Decode(
    'CghTZnVFdmVudBJUChBzdWJzY3JpYmVyX29mZmVyGAEgASgLMicuc3RyZWFtLnZpZGVvLnNmdS'
    '5ldmVudC5TdWJzY3JpYmVyT2ZmZXJIAFIPc3Vic2NyaWJlck9mZmVyElQKEHB1Ymxpc2hlcl9h'
    'bnN3ZXIYAiABKAsyJy5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LlB1Ymxpc2hlckFuc3dlckgAUg'
    '9wdWJsaXNoZXJBbnN3ZXIScAoaY29ubmVjdGlvbl9xdWFsaXR5X2NoYW5nZWQYAyABKAsyMC5z'
    'dHJlYW0udmlkZW8uc2Z1LmV2ZW50LkNvbm5lY3Rpb25RdWFsaXR5Q2hhbmdlZEgAUhhjb25uZW'
    'N0aW9uUXVhbGl0eUNoYW5nZWQSWwoTYXVkaW9fbGV2ZWxfY2hhbmdlZBgEIAEoCzIpLnN0cmVh'
    'bS52aWRlby5zZnUuZXZlbnQuQXVkaW9MZXZlbENoYW5nZWRIAFIRYXVkaW9MZXZlbENoYW5nZW'
    'QSRgoLaWNlX3RyaWNrbGUYBSABKAsyIy5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5JQ0VUcmlj'
    'a2xlSABSCmljZVRyaWNrbGUSZAoWY2hhbmdlX3B1Ymxpc2hfcXVhbGl0eRgGIAEoCzIsLnN0cm'
    'VhbS52aWRlby5zZnUuZXZlbnQuQ2hhbmdlUHVibGlzaFF1YWxpdHlIAFIUY2hhbmdlUHVibGlz'
    'aFF1YWxpdHkSWgoScGFydGljaXBhbnRfam9pbmVkGAogASgLMikuc3RyZWFtLnZpZGVvLnNmdS'
    '5ldmVudC5QYXJ0aWNpcGFudEpvaW5lZEgAUhFwYXJ0aWNpcGFudEpvaW5lZBJUChBwYXJ0aWNp'
    'cGFudF9sZWZ0GAsgASgLMicuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5QYXJ0aWNpcGFudExlZn'
    'RIAFIPcGFydGljaXBhbnRMZWZ0EmoKGGRvbWluYW50X3NwZWFrZXJfY2hhbmdlZBgMIAEoCzIu'
    'LnN0cmVhbS52aWRlby5zZnUuZXZlbnQuRG9taW5hbnRTcGVha2VyQ2hhbmdlZEgAUhZkb21pbm'
    'FudFNwZWFrZXJDaGFuZ2VkEksKDWpvaW5fcmVzcG9uc2UYDSABKAsyJC5zdHJlYW0udmlkZW8u'
    'c2Z1LmV2ZW50LkpvaW5SZXNwb25zZUgAUgxqb2luUmVzcG9uc2USYQoVaGVhbHRoX2NoZWNrX3'
    'Jlc3BvbnNlGA4gASgLMisuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5IZWFsdGhDaGVja1Jlc3Bv'
    'bnNlSABSE2hlYWx0aENoZWNrUmVzcG9uc2USUQoPdHJhY2tfcHVibGlzaGVkGBAgASgLMiYuc3'
    'RyZWFtLnZpZGVvLnNmdS5ldmVudC5UcmFja1B1Ymxpc2hlZEgAUg50cmFja1B1Ymxpc2hlZBJX'
    'ChF0cmFja191bnB1Ymxpc2hlZBgRIAEoCzIoLnN0cmVhbS52aWRlby5zZnUuZXZlbnQuVHJhY2'
    'tVbnB1Ymxpc2hlZEgAUhB0cmFja1VucHVibGlzaGVkEjUKBWVycm9yGBIgASgLMh0uc3RyZWFt'
    'LnZpZGVvLnNmdS5ldmVudC5FcnJvckgAUgVlcnJvchJbChNjYWxsX2dyYW50c191cGRhdGVkGB'
    'MgASgLMikuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5DYWxsR3JhbnRzVXBkYXRlZEgAUhFjYWxs'
    'R3JhbnRzVXBkYXRlZBI5Cgdnb19hd2F5GBQgASgLMh4uc3RyZWFtLnZpZGVvLnNmdS5ldmVudC'
    '5Hb0F3YXlIAFIGZ29Bd2F5EkUKC2ljZV9yZXN0YXJ0GBUgASgLMiIuc3RyZWFtLnZpZGVvLnNm'
    'dS5ldmVudC5JQ0VSZXN0YXJ0SABSCmljZVJlc3RhcnQSSAoMcGluc191cGRhdGVkGBYgASgLMi'
    'Muc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5QaW5zQ2hhbmdlZEgAUgtwaW5zVXBkYXRlZBJCCgpj'
    'YWxsX2VuZGVkGBcgASgLMiEuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5DYWxsRW5kZWRIAFIJY2'
    'FsbEVuZGVkEl0KE3BhcnRpY2lwYW50X3VwZGF0ZWQYGCABKAsyKi5zdHJlYW0udmlkZW8uc2Z1'
    'LmV2ZW50LlBhcnRpY2lwYW50VXBkYXRlZEgAUhJwYXJ0aWNpcGFudFVwZGF0ZWQSfAoecGFydG'
    'ljaXBhbnRfbWlncmF0aW9uX2NvbXBsZXRlGBkgASgLMjQuc3RyZWFtLnZpZGVvLnNmdS5ldmVu'
    'dC5QYXJ0aWNpcGFudE1pZ3JhdGlvbkNvbXBsZXRlSABSHHBhcnRpY2lwYW50TWlncmF0aW9uQ2'
    '9tcGxldGVCDwoNZXZlbnRfcGF5bG9hZA==');

@$core.Deprecated('Use participantMigrationCompleteDescriptor instead')
const ParticipantMigrationComplete$json = {
  '1': 'ParticipantMigrationComplete',
};

/// Descriptor for `ParticipantMigrationComplete`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantMigrationCompleteDescriptor = $convert.base64Decode(
    'ChxQYXJ0aWNpcGFudE1pZ3JhdGlvbkNvbXBsZXRl');

@$core.Deprecated('Use pinsChangedDescriptor instead')
const PinsChanged$json = {
  '1': 'PinsChanged',
  '2': [
    {'1': 'pins', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.models.Pin', '10': 'pins'},
  ],
};

/// Descriptor for `PinsChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pinsChangedDescriptor = $convert.base64Decode(
    'CgtQaW5zQ2hhbmdlZBIwCgRwaW5zGAEgAygLMhwuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuUG'
    'luUgRwaW5z');

@$core.Deprecated('Use errorDescriptor instead')
const Error$json = {
  '1': 'Error',
  '2': [
    {'1': 'error', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
    {'1': 'reconnect_strategy', '3': 5, '4': 1, '5': 14, '6': '.stream.video.sfu.models.WebsocketReconnectStrategy', '10': 'reconnectStrategy'},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode(
    'CgVFcnJvchI0CgVlcnJvchgEIAEoCzIeLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLkVycm9yUg'
    'VlcnJvchJiChJyZWNvbm5lY3Rfc3RyYXRlZ3kYBSABKA4yMy5zdHJlYW0udmlkZW8uc2Z1Lm1v'
    'ZGVscy5XZWJzb2NrZXRSZWNvbm5lY3RTdHJhdGVneVIRcmVjb25uZWN0U3RyYXRlZ3k=');

@$core.Deprecated('Use iCETrickleDescriptor instead')
const ICETrickle$json = {
  '1': 'ICETrickle',
  '2': [
    {'1': 'peer_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.PeerType', '10': 'peerType'},
    {'1': 'ice_candidate', '3': 2, '4': 1, '5': 9, '10': 'iceCandidate'},
  ],
};

/// Descriptor for `ICETrickle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCETrickleDescriptor = $convert.base64Decode(
    'CgpJQ0VUcmlja2xlEj4KCXBlZXJfdHlwZRgBIAEoDjIhLnN0cmVhbS52aWRlby5zZnUubW9kZW'
    'xzLlBlZXJUeXBlUghwZWVyVHlwZRIjCg1pY2VfY2FuZGlkYXRlGAIgASgJUgxpY2VDYW5kaWRh'
    'dGU=');

@$core.Deprecated('Use iCERestartDescriptor instead')
const ICERestart$json = {
  '1': 'ICERestart',
  '2': [
    {'1': 'peer_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.PeerType', '10': 'peerType'},
  ],
};

/// Descriptor for `ICERestart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCERestartDescriptor = $convert.base64Decode(
    'CgpJQ0VSZXN0YXJ0Ej4KCXBlZXJfdHlwZRgBIAEoDjIhLnN0cmVhbS52aWRlby5zZnUubW9kZW'
    'xzLlBlZXJUeXBlUghwZWVyVHlwZQ==');

@$core.Deprecated('Use sfuRequestDescriptor instead')
const SfuRequest$json = {
  '1': 'SfuRequest',
  '2': [
    {'1': 'join_request', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event.JoinRequest', '9': 0, '10': 'joinRequest'},
    {'1': 'health_check_request', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.event.HealthCheckRequest', '9': 0, '10': 'healthCheckRequest'},
    {'1': 'leave_call_request', '3': 3, '4': 1, '5': 11, '6': '.stream.video.sfu.event.LeaveCallRequest', '9': 0, '10': 'leaveCallRequest'},
  ],
  '8': [
    {'1': 'request_payload'},
  ],
};

/// Descriptor for `SfuRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sfuRequestDescriptor = $convert.base64Decode(
    'CgpTZnVSZXF1ZXN0EkgKDGpvaW5fcmVxdWVzdBgBIAEoCzIjLnN0cmVhbS52aWRlby5zZnUuZX'
    'ZlbnQuSm9pblJlcXVlc3RIAFILam9pblJlcXVlc3QSXgoUaGVhbHRoX2NoZWNrX3JlcXVlc3QY'
    'AiABKAsyKi5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkhlYWx0aENoZWNrUmVxdWVzdEgAUhJoZW'
    'FsdGhDaGVja1JlcXVlc3QSWAoSbGVhdmVfY2FsbF9yZXF1ZXN0GAMgASgLMiguc3RyZWFtLnZp'
    'ZGVvLnNmdS5ldmVudC5MZWF2ZUNhbGxSZXF1ZXN0SABSEGxlYXZlQ2FsbFJlcXVlc3RCEQoPcm'
    'VxdWVzdF9wYXlsb2Fk');

@$core.Deprecated('Use leaveCallRequestDescriptor instead')
const LeaveCallRequest$json = {
  '1': 'LeaveCallRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `LeaveCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveCallRequestDescriptor = $convert.base64Decode(
    'ChBMZWF2ZUNhbGxSZXF1ZXN0Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZBIWCgZyZW'
    'Fzb24YAiABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use healthCheckRequestDescriptor instead')
const HealthCheckRequest$json = {
  '1': 'HealthCheckRequest',
};

/// Descriptor for `HealthCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthCheckRequestDescriptor = $convert.base64Decode(
    'ChJIZWFsdGhDaGVja1JlcXVlc3Q=');

@$core.Deprecated('Use healthCheckResponseDescriptor instead')
const HealthCheckResponse$json = {
  '1': 'HealthCheckResponse',
  '2': [
    {'1': 'participant_count', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.ParticipantCount', '10': 'participantCount'},
  ],
};

/// Descriptor for `HealthCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthCheckResponseDescriptor = $convert.base64Decode(
    'ChNIZWFsdGhDaGVja1Jlc3BvbnNlElYKEXBhcnRpY2lwYW50X2NvdW50GAEgASgLMikuc3RyZW'
    'FtLnZpZGVvLnNmdS5tb2RlbHMuUGFydGljaXBhbnRDb3VudFIQcGFydGljaXBhbnRDb3VudA==');

@$core.Deprecated('Use trackPublishedDescriptor instead')
const TrackPublished$json = {
  '1': 'TrackPublished',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'type', '3': 3, '4': 1, '5': 14, '6': '.stream.video.sfu.models.TrackType', '10': 'type'},
    {'1': 'participant', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `TrackPublished`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackPublishedDescriptor = $convert.base64Decode(
    'Cg5UcmFja1B1Ymxpc2hlZBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSHQoKc2Vzc2lvbl9pZB'
    'gCIAEoCVIJc2Vzc2lvbklkEjYKBHR5cGUYAyABKA4yIi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVs'
    'cy5UcmFja1R5cGVSBHR5cGUSRgoLcGFydGljaXBhbnQYBCABKAsyJC5zdHJlYW0udmlkZW8uc2'
    'Z1Lm1vZGVscy5QYXJ0aWNpcGFudFILcGFydGljaXBhbnQ=');

@$core.Deprecated('Use trackUnpublishedDescriptor instead')
const TrackUnpublished$json = {
  '1': 'TrackUnpublished',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'type', '3': 3, '4': 1, '5': 14, '6': '.stream.video.sfu.models.TrackType', '10': 'type'},
    {'1': 'cause', '3': 4, '4': 1, '5': 14, '6': '.stream.video.sfu.models.TrackUnpublishReason', '10': 'cause'},
    {'1': 'participant', '3': 5, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `TrackUnpublished`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackUnpublishedDescriptor = $convert.base64Decode(
    'ChBUcmFja1VucHVibGlzaGVkEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIdCgpzZXNzaW9uX2'
    'lkGAIgASgJUglzZXNzaW9uSWQSNgoEdHlwZRgDIAEoDjIiLnN0cmVhbS52aWRlby5zZnUubW9k'
    'ZWxzLlRyYWNrVHlwZVIEdHlwZRJDCgVjYXVzZRgEIAEoDjItLnN0cmVhbS52aWRlby5zZnUubW'
    '9kZWxzLlRyYWNrVW5wdWJsaXNoUmVhc29uUgVjYXVzZRJGCgtwYXJ0aWNpcGFudBgFIAEoCzIk'
    'LnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlBhcnRpY2lwYW50UgtwYXJ0aWNpcGFudA==');

@$core.Deprecated('Use joinRequestDescriptor instead')
const JoinRequest$json = {
  '1': 'JoinRequest',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'subscriber_sdp', '3': 3, '4': 1, '5': 9, '10': 'subscriberSdp'},
    {'1': 'client_details', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.ClientDetails', '10': 'clientDetails'},
    {
      '1': 'migration',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.stream.video.sfu.event.Migration',
      '8': {'3': true},
      '10': 'migration',
    },
    {
      '1': 'fast_reconnect',
      '3': 6,
      '4': 1,
      '5': 8,
      '8': {'3': true},
      '10': 'fastReconnect',
    },
    {'1': 'reconnect_details', '3': 7, '4': 1, '5': 11, '6': '.stream.video.sfu.event.ReconnectDetails', '10': 'reconnectDetails'},
  ],
};

/// Descriptor for `JoinRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRequestDescriptor = $convert.base64Decode(
    'CgtKb2luUmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4SHQoKc2Vzc2lvbl9pZBgCIAEoCV'
    'IJc2Vzc2lvbklkEiUKDnN1YnNjcmliZXJfc2RwGAMgASgJUg1zdWJzY3JpYmVyU2RwEk0KDmNs'
    'aWVudF9kZXRhaWxzGAQgASgLMiYuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuQ2xpZW50RGV0YW'
    'lsc1INY2xpZW50RGV0YWlscxJDCgltaWdyYXRpb24YBSABKAsyIS5zdHJlYW0udmlkZW8uc2Z1'
    'LmV2ZW50Lk1pZ3JhdGlvbkICGAFSCW1pZ3JhdGlvbhIpCg5mYXN0X3JlY29ubmVjdBgGIAEoCE'
    'ICGAFSDWZhc3RSZWNvbm5lY3QSVQoRcmVjb25uZWN0X2RldGFpbHMYByABKAsyKC5zdHJlYW0u'
    'dmlkZW8uc2Z1LmV2ZW50LlJlY29ubmVjdERldGFpbHNSEHJlY29ubmVjdERldGFpbHM=');

@$core.Deprecated('Use reconnectDetailsDescriptor instead')
const ReconnectDetails$json = {
  '1': 'ReconnectDetails',
  '2': [
    {'1': 'strategy', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.WebsocketReconnectStrategy', '10': 'strategy'},
    {'1': 'announced_tracks', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.models.TrackInfo', '10': 'announcedTracks'},
    {'1': 'subscriptions', '3': 4, '4': 3, '5': 11, '6': '.stream.video.sfu.signal.TrackSubscriptionDetails', '10': 'subscriptions'},
    {'1': 'reconnect_attempt', '3': 5, '4': 1, '5': 13, '10': 'reconnectAttempt'},
    {'1': 'from_sfu_id', '3': 6, '4': 1, '5': 9, '10': 'fromSfuId'},
    {'1': 'previous_session_id', '3': 7, '4': 1, '5': 9, '10': 'previousSessionId'},
  ],
};

/// Descriptor for `ReconnectDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconnectDetailsDescriptor = $convert.base64Decode(
    'ChBSZWNvbm5lY3REZXRhaWxzEk8KCHN0cmF0ZWd5GAEgASgOMjMuc3RyZWFtLnZpZGVvLnNmdS'
    '5tb2RlbHMuV2Vic29ja2V0UmVjb25uZWN0U3RyYXRlZ3lSCHN0cmF0ZWd5Ek0KEGFubm91bmNl'
    'ZF90cmFja3MYAyADKAsyIi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5UcmFja0luZm9SD2Fubm'
    '91bmNlZFRyYWNrcxJXCg1zdWJzY3JpcHRpb25zGAQgAygLMjEuc3RyZWFtLnZpZGVvLnNmdS5z'
    'aWduYWwuVHJhY2tTdWJzY3JpcHRpb25EZXRhaWxzUg1zdWJzY3JpcHRpb25zEisKEXJlY29ubm'
    'VjdF9hdHRlbXB0GAUgASgNUhByZWNvbm5lY3RBdHRlbXB0Eh4KC2Zyb21fc2Z1X2lkGAYgASgJ'
    'Uglmcm9tU2Z1SWQSLgoTcHJldmlvdXNfc2Vzc2lvbl9pZBgHIAEoCVIRcHJldmlvdXNTZXNzaW'
    '9uSWQ=');

@$core.Deprecated('Use migrationDescriptor instead')
const Migration$json = {
  '1': 'Migration',
  '2': [
    {'1': 'from_sfu_id', '3': 1, '4': 1, '5': 9, '10': 'fromSfuId'},
    {'1': 'announced_tracks', '3': 2, '4': 3, '5': 11, '6': '.stream.video.sfu.models.TrackInfo', '10': 'announcedTracks'},
    {'1': 'subscriptions', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.signal.TrackSubscriptionDetails', '10': 'subscriptions'},
  ],
};

/// Descriptor for `Migration`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List migrationDescriptor = $convert.base64Decode(
    'CglNaWdyYXRpb24SHgoLZnJvbV9zZnVfaWQYASABKAlSCWZyb21TZnVJZBJNChBhbm5vdW5jZW'
    'RfdHJhY2tzGAIgAygLMiIuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuVHJhY2tJbmZvUg9hbm5v'
    'dW5jZWRUcmFja3MSVwoNc3Vic2NyaXB0aW9ucxgDIAMoCzIxLnN0cmVhbS52aWRlby5zZnUuc2'
    'lnbmFsLlRyYWNrU3Vic2NyaXB0aW9uRGV0YWlsc1INc3Vic2NyaXB0aW9ucw==');

@$core.Deprecated('Use joinResponseDescriptor instead')
const JoinResponse$json = {
  '1': 'JoinResponse',
  '2': [
    {'1': 'call_state', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.CallState', '10': 'callState'},
    {'1': 'reconnected', '3': 2, '4': 1, '5': 8, '10': 'reconnected'},
    {'1': 'fast_reconnect_deadline_seconds', '3': 3, '4': 1, '5': 5, '10': 'fastReconnectDeadlineSeconds'},
  ],
};

/// Descriptor for `JoinResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinResponseDescriptor = $convert.base64Decode(
    'CgxKb2luUmVzcG9uc2USQQoKY2FsbF9zdGF0ZRgBIAEoCzIiLnN0cmVhbS52aWRlby5zZnUubW'
    '9kZWxzLkNhbGxTdGF0ZVIJY2FsbFN0YXRlEiAKC3JlY29ubmVjdGVkGAIgASgIUgtyZWNvbm5l'
    'Y3RlZBJFCh9mYXN0X3JlY29ubmVjdF9kZWFkbGluZV9zZWNvbmRzGAMgASgFUhxmYXN0UmVjb2'
    '5uZWN0RGVhZGxpbmVTZWNvbmRz');

@$core.Deprecated('Use participantJoinedDescriptor instead')
const ParticipantJoined$json = {
  '1': 'ParticipantJoined',
  '2': [
    {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantJoined`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantJoinedDescriptor = $convert.base64Decode(
    'ChFQYXJ0aWNpcGFudEpvaW5lZBIZCghjYWxsX2NpZBgBIAEoCVIHY2FsbENpZBJGCgtwYXJ0aW'
    'NpcGFudBgCIAEoCzIkLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlBhcnRpY2lwYW50UgtwYXJ0'
    'aWNpcGFudA==');

@$core.Deprecated('Use participantLeftDescriptor instead')
const ParticipantLeft$json = {
  '1': 'ParticipantLeft',
  '2': [
    {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantLeft`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantLeftDescriptor = $convert.base64Decode(
    'Cg9QYXJ0aWNpcGFudExlZnQSGQoIY2FsbF9jaWQYASABKAlSB2NhbGxDaWQSRgoLcGFydGljaX'
    'BhbnQYAiABKAsyJC5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5QYXJ0aWNpcGFudFILcGFydGlj'
    'aXBhbnQ=');

@$core.Deprecated('Use participantUpdatedDescriptor instead')
const ParticipantUpdated$json = {
  '1': 'ParticipantUpdated',
  '2': [
    {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    {'1': 'participant', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantUpdatedDescriptor = $convert.base64Decode(
    'ChJQYXJ0aWNpcGFudFVwZGF0ZWQSGQoIY2FsbF9jaWQYASABKAlSB2NhbGxDaWQSRgoLcGFydG'
    'ljaXBhbnQYAiABKAsyJC5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5QYXJ0aWNpcGFudFILcGFy'
    'dGljaXBhbnQ=');

@$core.Deprecated('Use subscriberOfferDescriptor instead')
const SubscriberOffer$json = {
  '1': 'SubscriberOffer',
  '2': [
    {'1': 'ice_restart', '3': 1, '4': 1, '5': 8, '10': 'iceRestart'},
    {'1': 'sdp', '3': 2, '4': 1, '5': 9, '10': 'sdp'},
  ],
};

/// Descriptor for `SubscriberOffer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriberOfferDescriptor = $convert.base64Decode(
    'Cg9TdWJzY3JpYmVyT2ZmZXISHwoLaWNlX3Jlc3RhcnQYASABKAhSCmljZVJlc3RhcnQSEAoDc2'
    'RwGAIgASgJUgNzZHA=');

@$core.Deprecated('Use publisherAnswerDescriptor instead')
const PublisherAnswer$json = {
  '1': 'PublisherAnswer',
  '2': [
    {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
  ],
};

/// Descriptor for `PublisherAnswer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publisherAnswerDescriptor = $convert.base64Decode(
    'Cg9QdWJsaXNoZXJBbnN3ZXISEAoDc2RwGAEgASgJUgNzZHA=');

@$core.Deprecated('Use connectionQualityChangedDescriptor instead')
const ConnectionQualityChanged$json = {
  '1': 'ConnectionQualityChanged',
  '2': [
    {'1': 'connection_quality_updates', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.event.ConnectionQualityInfo', '10': 'connectionQualityUpdates'},
  ],
};

/// Descriptor for `ConnectionQualityChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionQualityChangedDescriptor = $convert.base64Decode(
    'ChhDb25uZWN0aW9uUXVhbGl0eUNoYW5nZWQSawoaY29ubmVjdGlvbl9xdWFsaXR5X3VwZGF0ZX'
    'MYASADKAsyLS5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LkNvbm5lY3Rpb25RdWFsaXR5SW5mb1IY'
    'Y29ubmVjdGlvblF1YWxpdHlVcGRhdGVz');

@$core.Deprecated('Use connectionQualityInfoDescriptor instead')
const ConnectionQualityInfo$json = {
  '1': 'ConnectionQualityInfo',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'connection_quality', '3': 3, '4': 1, '5': 14, '6': '.stream.video.sfu.models.ConnectionQuality', '10': 'connectionQuality'},
  ],
};

/// Descriptor for `ConnectionQualityInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionQualityInfoDescriptor = $convert.base64Decode(
    'ChVDb25uZWN0aW9uUXVhbGl0eUluZm8SFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEh0KCnNlc3'
    'Npb25faWQYAiABKAlSCXNlc3Npb25JZBJZChJjb25uZWN0aW9uX3F1YWxpdHkYAyABKA4yKi5z'
    'dHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5Db25uZWN0aW9uUXVhbGl0eVIRY29ubmVjdGlvblF1YW'
    'xpdHk=');

@$core.Deprecated('Use dominantSpeakerChangedDescriptor instead')
const DominantSpeakerChanged$json = {
  '1': 'DominantSpeakerChanged',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `DominantSpeakerChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dominantSpeakerChangedDescriptor = $convert.base64Decode(
    'ChZEb21pbmFudFNwZWFrZXJDaGFuZ2VkEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIdCgpzZX'
    'NzaW9uX2lkGAIgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use audioLevelDescriptor instead')
const AudioLevel$json = {
  '1': 'AudioLevel',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'level', '3': 3, '4': 1, '5': 2, '10': 'level'},
    {'1': 'is_speaking', '3': 4, '4': 1, '5': 8, '10': 'isSpeaking'},
  ],
};

/// Descriptor for `AudioLevel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioLevelDescriptor = $convert.base64Decode(
    'CgpBdWRpb0xldmVsEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIdCgpzZXNzaW9uX2lkGAIgAS'
    'gJUglzZXNzaW9uSWQSFAoFbGV2ZWwYAyABKAJSBWxldmVsEh8KC2lzX3NwZWFraW5nGAQgASgI'
    'Ugppc1NwZWFraW5n');

@$core.Deprecated('Use audioLevelChangedDescriptor instead')
const AudioLevelChanged$json = {
  '1': 'AudioLevelChanged',
  '2': [
    {'1': 'audio_levels', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.event.AudioLevel', '10': 'audioLevels'},
  ],
};

/// Descriptor for `AudioLevelChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioLevelChangedDescriptor = $convert.base64Decode(
    'ChFBdWRpb0xldmVsQ2hhbmdlZBJFCgxhdWRpb19sZXZlbHMYASADKAsyIi5zdHJlYW0udmlkZW'
    '8uc2Z1LmV2ZW50LkF1ZGlvTGV2ZWxSC2F1ZGlvTGV2ZWxz');

@$core.Deprecated('Use audioMediaRequestDescriptor instead')
const AudioMediaRequest$json = {
  '1': 'AudioMediaRequest',
  '2': [
    {'1': 'channel_count', '3': 1, '4': 1, '5': 5, '10': 'channelCount'},
  ],
};

/// Descriptor for `AudioMediaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioMediaRequestDescriptor = $convert.base64Decode(
    'ChFBdWRpb01lZGlhUmVxdWVzdBIjCg1jaGFubmVsX2NvdW50GAEgASgFUgxjaGFubmVsQ291bn'
    'Q=');

@$core.Deprecated('Use audioSenderDescriptor instead')
const AudioSender$json = {
  '1': 'AudioSender',
  '2': [
    {'1': 'media_request', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event.AudioMediaRequest', '10': 'mediaRequest'},
    {'1': 'codec', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Codec', '10': 'codec'},
  ],
};

/// Descriptor for `AudioSender`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioSenderDescriptor = $convert.base64Decode(
    'CgtBdWRpb1NlbmRlchJOCg1tZWRpYV9yZXF1ZXN0GAEgASgLMikuc3RyZWFtLnZpZGVvLnNmdS'
    '5ldmVudC5BdWRpb01lZGlhUmVxdWVzdFIMbWVkaWFSZXF1ZXN0EjQKBWNvZGVjGAIgASgLMh4u'
    'c3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuQ29kZWNSBWNvZGVj');

@$core.Deprecated('Use videoMediaRequestDescriptor instead')
const VideoMediaRequest$json = {
  '1': 'VideoMediaRequest',
  '2': [
    {'1': 'ideal_height', '3': 1, '4': 1, '5': 5, '10': 'idealHeight'},
    {'1': 'ideal_width', '3': 2, '4': 1, '5': 5, '10': 'idealWidth'},
    {'1': 'ideal_frame_rate', '3': 3, '4': 1, '5': 5, '10': 'idealFrameRate'},
  ],
};

/// Descriptor for `VideoMediaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoMediaRequestDescriptor = $convert.base64Decode(
    'ChFWaWRlb01lZGlhUmVxdWVzdBIhCgxpZGVhbF9oZWlnaHQYASABKAVSC2lkZWFsSGVpZ2h0Eh'
    '8KC2lkZWFsX3dpZHRoGAIgASgFUgppZGVhbFdpZHRoEigKEGlkZWFsX2ZyYW1lX3JhdGUYAyAB'
    'KAVSDmlkZWFsRnJhbWVSYXRl');

@$core.Deprecated('Use videoLayerSettingDescriptor instead')
const VideoLayerSetting$json = {
  '1': 'VideoLayerSetting',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'active', '3': 2, '4': 1, '5': 8, '10': 'active'},
    {'1': 'max_bitrate', '3': 3, '4': 1, '5': 5, '10': 'maxBitrate'},
    {'1': 'scale_resolution_down_by', '3': 4, '4': 1, '5': 2, '10': 'scaleResolutionDownBy'},
    {'1': 'priority', '3': 5, '4': 1, '5': 14, '6': '.stream.video.sfu.event.VideoLayerSetting.Priority', '10': 'priority'},
    {'1': 'codec', '3': 6, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Codec', '10': 'codec'},
    {'1': 'max_framerate', '3': 7, '4': 1, '5': 13, '10': 'maxFramerate'},
  ],
  '4': [VideoLayerSetting_Priority$json],
};

@$core.Deprecated('Use videoLayerSettingDescriptor instead')
const VideoLayerSetting_Priority$json = {
  '1': 'Priority',
  '2': [
    {'1': 'PRIORITY_HIGH_UNSPECIFIED', '2': 0},
    {'1': 'PRIORITY_LOW', '2': 1},
    {'1': 'PRIORITY_MEDIUM', '2': 2},
    {'1': 'PRIORITY_VERY_LOW', '2': 3},
  ],
};

/// Descriptor for `VideoLayerSetting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoLayerSettingDescriptor = $convert.base64Decode(
    'ChFWaWRlb0xheWVyU2V0dGluZxISCgRuYW1lGAEgASgJUgRuYW1lEhYKBmFjdGl2ZRgCIAEoCF'
    'IGYWN0aXZlEh8KC21heF9iaXRyYXRlGAMgASgFUgptYXhCaXRyYXRlEjcKGHNjYWxlX3Jlc29s'
    'dXRpb25fZG93bl9ieRgEIAEoAlIVc2NhbGVSZXNvbHV0aW9uRG93bkJ5Ek4KCHByaW9yaXR5GA'
    'UgASgOMjIuc3RyZWFtLnZpZGVvLnNmdS5ldmVudC5WaWRlb0xheWVyU2V0dGluZy5Qcmlvcml0'
    'eVIIcHJpb3JpdHkSNAoFY29kZWMYBiABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5Db2'
    'RlY1IFY29kZWMSIwoNbWF4X2ZyYW1lcmF0ZRgHIAEoDVIMbWF4RnJhbWVyYXRlImcKCFByaW9y'
    'aXR5Eh0KGVBSSU9SSVRZX0hJR0hfVU5TUEVDSUZJRUQQABIQCgxQUklPUklUWV9MT1cQARITCg'
    '9QUklPUklUWV9NRURJVU0QAhIVChFQUklPUklUWV9WRVJZX0xPVxAD');

@$core.Deprecated('Use videoSenderDescriptor instead')
const VideoSender$json = {
  '1': 'VideoSender',
  '2': [
    {'1': 'media_request', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.event.VideoMediaRequest', '10': 'mediaRequest'},
    {'1': 'codec', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Codec', '10': 'codec'},
    {'1': 'layers', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.event.VideoLayerSetting', '10': 'layers'},
  ],
};

/// Descriptor for `VideoSender`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoSenderDescriptor = $convert.base64Decode(
    'CgtWaWRlb1NlbmRlchJOCg1tZWRpYV9yZXF1ZXN0GAEgASgLMikuc3RyZWFtLnZpZGVvLnNmdS'
    '5ldmVudC5WaWRlb01lZGlhUmVxdWVzdFIMbWVkaWFSZXF1ZXN0EjQKBWNvZGVjGAIgASgLMh4u'
    'c3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuQ29kZWNSBWNvZGVjEkEKBmxheWVycxgDIAMoCzIpLn'
    'N0cmVhbS52aWRlby5zZnUuZXZlbnQuVmlkZW9MYXllclNldHRpbmdSBmxheWVycw==');

@$core.Deprecated('Use changePublishQualityDescriptor instead')
const ChangePublishQuality$json = {
  '1': 'ChangePublishQuality',
  '2': [
    {'1': 'audio_senders', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.event.AudioSender', '10': 'audioSenders'},
    {'1': 'video_senders', '3': 2, '4': 3, '5': 11, '6': '.stream.video.sfu.event.VideoSender', '10': 'videoSenders'},
  ],
};

/// Descriptor for `ChangePublishQuality`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePublishQualityDescriptor = $convert.base64Decode(
    'ChRDaGFuZ2VQdWJsaXNoUXVhbGl0eRJICg1hdWRpb19zZW5kZXJzGAEgAygLMiMuc3RyZWFtLn'
    'ZpZGVvLnNmdS5ldmVudC5BdWRpb1NlbmRlclIMYXVkaW9TZW5kZXJzEkgKDXZpZGVvX3NlbmRl'
    'cnMYAiADKAsyIy5zdHJlYW0udmlkZW8uc2Z1LmV2ZW50LlZpZGVvU2VuZGVyUgx2aWRlb1Nlbm'
    'RlcnM=');

@$core.Deprecated('Use callGrantsUpdatedDescriptor instead')
const CallGrantsUpdated$json = {
  '1': 'CallGrantsUpdated',
  '2': [
    {'1': 'current_grants', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.CallGrants', '10': 'currentGrants'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `CallGrantsUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callGrantsUpdatedDescriptor = $convert.base64Decode(
    'ChFDYWxsR3JhbnRzVXBkYXRlZBJKCg5jdXJyZW50X2dyYW50cxgBIAEoCzIjLnN0cmVhbS52aW'
    'Rlby5zZnUubW9kZWxzLkNhbGxHcmFudHNSDWN1cnJlbnRHcmFudHMSGAoHbWVzc2FnZRgCIAEo'
    'CVIHbWVzc2FnZQ==');

@$core.Deprecated('Use goAwayDescriptor instead')
const GoAway$json = {
  '1': 'GoAway',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.GoAwayReason', '10': 'reason'},
  ],
};

/// Descriptor for `GoAway`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List goAwayDescriptor = $convert.base64Decode(
    'CgZHb0F3YXkSPQoGcmVhc29uGAEgASgOMiUuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuR29Bd2'
    'F5UmVhc29uUgZyZWFzb24=');

@$core.Deprecated('Use callEndedDescriptor instead')
const CallEnded$json = {
  '1': 'CallEnded',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.CallEndedReason', '10': 'reason'},
  ],
};

/// Descriptor for `CallEnded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callEndedDescriptor = $convert.base64Decode(
    'CglDYWxsRW5kZWQSQAoGcmVhc29uGAEgASgOMiguc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuQ2'
    'FsbEVuZGVkUmVhc29uUgZyZWFzb24=');

