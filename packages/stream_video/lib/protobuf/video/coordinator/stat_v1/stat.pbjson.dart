///
//  Generated code. Do not modify.
//  source: video/coordinator/stat_v1/stat.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use mediaTypeDescriptor instead')
const MediaType$json = const {
  '1': 'MediaType',
  '2': const [
    const {'1': 'MEDIA_TYPE_UNSPECIFIED', '2': 0},
    const {'1': 'MEDIA_TYPE_AUDIO', '2': 1},
    const {'1': 'MEDIA_TYPE_VIDEO', '2': 2},
    const {'1': 'MEDIA_TYPE_SCREEN_SHARE', '2': 3},
  ],
};

/// Descriptor for `MediaType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mediaTypeDescriptor = $convert.base64Decode(
    'CglNZWRpYVR5cGUSGgoWTUVESUFfVFlQRV9VTlNQRUNJRklFRBAAEhQKEE1FRElBX1RZUEVfQVVESU8QARIUChBNRURJQV9UWVBFX1ZJREVPEAISGwoXTUVESUFfVFlQRV9TQ1JFRU5fU0hBUkUQAw==');
@$core.Deprecated('Use mediaStateChangeDescriptor instead')
const MediaStateChange$json = const {
  '1': 'MediaStateChange',
  '2': const [
    const {'1': 'MEDIA_STATE_CHANGE_UNSPECIFIED', '2': 0},
    const {'1': 'MEDIA_STATE_CHANGE_STARTED', '2': 1},
    const {'1': 'MEDIA_STATE_CHANGE_ENDED', '2': 2},
  ],
};

/// Descriptor for `MediaStateChange`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mediaStateChangeDescriptor = $convert.base64Decode(
    'ChBNZWRpYVN0YXRlQ2hhbmdlEiIKHk1FRElBX1NUQVRFX0NIQU5HRV9VTlNQRUNJRklFRBAAEh4KGk1FRElBX1NUQVRFX0NIQU5HRV9TVEFSVEVEEAESHAoYTUVESUFfU1RBVEVfQ0hBTkdFX0VOREVEEAI=');
@$core.Deprecated('Use mediaDirectionDescriptor instead')
const MediaDirection$json = const {
  '1': 'MediaDirection',
  '2': const [
    const {'1': 'MEDIA_DIRECTION_UNSPECIFIED', '2': 0},
    const {'1': 'MEDIA_DIRECTION_SEND', '2': 1},
    const {'1': 'MEDIA_DIRECTION_RECEIVE', '2': 2},
  ],
};

/// Descriptor for `MediaDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mediaDirectionDescriptor = $convert.base64Decode(
    'Cg5NZWRpYURpcmVjdGlvbhIfChtNRURJQV9ESVJFQ1RJT05fVU5TUEVDSUZJRUQQABIYChRNRURJQV9ESVJFQ1RJT05fU0VORBABEhsKF01FRElBX0RJUkVDVElPTl9SRUNFSVZFEAI=');
@$core.Deprecated('Use mediaStateChangeReasonDescriptor instead')
const MediaStateChangeReason$json = const {
  '1': 'MediaStateChangeReason',
  '2': const [
    const {'1': 'MEDIA_STATE_CHANGE_REASON_UNSPECIFIED', '2': 0},
    const {'1': 'MEDIA_STATE_CHANGE_REASON_MUTE', '2': 1},
    const {'1': 'MEDIA_STATE_CHANGE_REASON_CONNECTION', '2': 2},
  ],
};

/// Descriptor for `MediaStateChangeReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mediaStateChangeReasonDescriptor =
    $convert.base64Decode(
        'ChZNZWRpYVN0YXRlQ2hhbmdlUmVhc29uEikKJU1FRElBX1NUQVRFX0NIQU5HRV9SRUFTT05fVU5TUEVDSUZJRUQQABIiCh5NRURJQV9TVEFURV9DSEFOR0VfUkVBU09OX01VVEUQARIoCiRNRURJQV9TVEFURV9DSEFOR0VfUkVBU09OX0NPTk5FQ1RJT04QAg==');
@$core.Deprecated('Use participantConnectedDescriptor instead')
const ParticipantConnected$json = const {
  '1': 'ParticipantConnected',
};

/// Descriptor for `ParticipantConnected`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantConnectedDescriptor =
    $convert.base64Decode('ChRQYXJ0aWNpcGFudENvbm5lY3RlZA==');
@$core.Deprecated('Use participantDisconnectedDescriptor instead')
const ParticipantDisconnected$json = const {
  '1': 'ParticipantDisconnected',
};

/// Descriptor for `ParticipantDisconnected`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantDisconnectedDescriptor =
    $convert.base64Decode('ChdQYXJ0aWNpcGFudERpc2Nvbm5lY3RlZA==');
@$core.Deprecated('Use freezeDescriptor instead')
const Freeze$json = const {
  '1': 'Freeze',
  '2': const [
    const {
      '1': 'media_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.stream.video.coordinator.stat_v1.MediaType',
      '10': 'mediaType'
    },
    const {
      '1': 'peer_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'peerId'
    },
    const {
      '1': 'duration',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Duration',
      '10': 'duration'
    },
  ],
};

/// Descriptor for `Freeze`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List freezeDescriptor = $convert.base64Decode(
    'CgZGcmVlemUSSgoKbWVkaWFfdHlwZRgBIAEoDjIrLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5zdGF0X3YxLk1lZGlhVHlwZVIJbWVkaWFUeXBlEiAKB3BlZXJfaWQYAiABKAlCB/pCBHICEAFSBnBlZXJJZBI1CghkdXJhdGlvbhgDIAEoCzIZLmdvb2dsZS5wcm90b2J1Zi5EdXJhdGlvblIIZHVyYXRpb24=');
@$core.Deprecated('Use mediaStateChangedDescriptor instead')
const MediaStateChanged$json = const {
  '1': 'MediaStateChanged',
  '2': const [
    const {
      '1': 'media_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.stream.video.coordinator.stat_v1.MediaType',
      '10': 'mediaType'
    },
    const {
      '1': 'change',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.stream.video.coordinator.stat_v1.MediaStateChange',
      '10': 'change'
    },
    const {
      '1': 'direction',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.stream.video.coordinator.stat_v1.MediaDirection',
      '10': 'direction'
    },
    const {
      '1': 'reason',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.stream.video.coordinator.stat_v1.MediaStateChangeReason',
      '10': 'reason'
    },
  ],
};

/// Descriptor for `MediaStateChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaStateChangedDescriptor = $convert.base64Decode(
    'ChFNZWRpYVN0YXRlQ2hhbmdlZBJKCgptZWRpYV90eXBlGAEgASgOMisuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnN0YXRfdjEuTWVkaWFUeXBlUgltZWRpYVR5cGUSSgoGY2hhbmdlGAIgASgOMjIuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnN0YXRfdjEuTWVkaWFTdGF0ZUNoYW5nZVIGY2hhbmdlEk4KCWRpcmVjdGlvbhgDIAEoDjIwLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5zdGF0X3YxLk1lZGlhRGlyZWN0aW9uUglkaXJlY3Rpb24SUAoGcmVhc29uGAQgASgOMjguc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnN0YXRfdjEuTWVkaWFTdGF0ZUNoYW5nZVJlYXNvblIGcmVhc29u');
@$core.Deprecated('Use timelineEventDescriptor instead')
const TimelineEvent$json = const {
  '1': 'TimelineEvent',
  '2': const [
    const {
      '1': 'timestamp',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    const {
      '1': 'participant_connected',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.stat_v1.ParticipantConnected',
      '9': 0,
      '10': 'participantConnected'
    },
    const {
      '1': 'participant_disconnected',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.stat_v1.ParticipantDisconnected',
      '9': 0,
      '10': 'participantDisconnected'
    },
    const {
      '1': 'media_state_changed',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.stat_v1.MediaStateChanged',
      '9': 0,
      '10': 'mediaStateChanged'
    },
    const {
      '1': 'freeze',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.stat_v1.Freeze',
      '9': 0,
      '10': 'freeze'
    },
  ],
  '8': const [
    const {'1': 'event'},
  ],
};

/// Descriptor for `TimelineEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timelineEventDescriptor = $convert.base64Decode(
    'Cg1UaW1lbGluZUV2ZW50EjgKCXRpbWVzdGFtcBgBIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXRpbWVzdGFtcBJtChVwYXJ0aWNpcGFudF9jb25uZWN0ZWQYAiABKAsyNi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3Iuc3RhdF92MS5QYXJ0aWNpcGFudENvbm5lY3RlZEgAUhRwYXJ0aWNpcGFudENvbm5lY3RlZBJ2ChhwYXJ0aWNpcGFudF9kaXNjb25uZWN0ZWQYAyABKAsyOS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3Iuc3RhdF92MS5QYXJ0aWNpcGFudERpc2Nvbm5lY3RlZEgAUhdwYXJ0aWNpcGFudERpc2Nvbm5lY3RlZBJlChNtZWRpYV9zdGF0ZV9jaGFuZ2VkGAQgASgLMjMuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnN0YXRfdjEuTWVkaWFTdGF0ZUNoYW5nZWRIAFIRbWVkaWFTdGF0ZUNoYW5nZWQSQgoGZnJlZXplGAUgASgLMiguc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnN0YXRfdjEuRnJlZXplSABSBmZyZWV6ZUIHCgVldmVudA==');
@$core.Deprecated('Use callParticipantTimelineDescriptor instead')
const CallParticipantTimeline$json = const {
  '1': 'CallParticipantTimeline',
  '2': const [
    const {
      '1': 'user_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'userId'
    },
    const {
      '1': 'events',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.stream.video.coordinator.stat_v1.TimelineEvent',
      '10': 'events'
    },
  ],
};

/// Descriptor for `CallParticipantTimeline`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callParticipantTimelineDescriptor =
    $convert.base64Decode(
        'ChdDYWxsUGFydGljaXBhbnRUaW1lbGluZRIgCgd1c2VyX2lkGAEgASgJQgf6QgRyAhABUgZ1c2VySWQSRwoGZXZlbnRzGAIgAygLMi8uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnN0YXRfdjEuVGltZWxpbmVFdmVudFIGZXZlbnRz');
@$core.Deprecated('Use sessionDescriptor instead')
const Session$json = const {
  '1': 'Session',
  '2': const [
    const {
      '1': 'session_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'sessionId'
    },
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'call_type', '3': 3, '4': 1, '5': 9, '10': 'callType'},
    const {
      '1': 'start',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'start'
    },
    const {
      '1': 'end',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'end'
    },
  ],
};

/// Descriptor for `Session`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionDescriptor = $convert.base64Decode(
    'CgdTZXNzaW9uEiYKCnNlc3Npb25faWQYASABKAlCB/pCBHICEAFSCXNlc3Npb25JZBIXCgdjYWxsX2lkGAIgASgJUgZjYWxsSWQSGwoJY2FsbF90eXBlGAMgASgJUghjYWxsVHlwZRIwCgVzdGFydBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBXN0YXJ0EiwKA2VuZBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSA2VuZA==');
