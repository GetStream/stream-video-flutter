///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/envelopes.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use callEnvelopeDescriptor instead')
const CallEnvelope$json = const {
  '1': 'CallEnvelope',
  '2': const [
    const {
      '1': 'users',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.stream.video.coordinator.client_v1_rpc.CallEnvelope.UsersEntry',
      '10': 'users'
    },
    const {
      '1': 'call',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.call_v1.Call',
      '10': 'call'
    },
    const {
      '1': 'details',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.call_v1.CallDetails',
      '10': 'details'
    },
  ],
  '3': const [CallEnvelope_UsersEntry$json],
};

@$core.Deprecated('Use callEnvelopeDescriptor instead')
const CallEnvelope_UsersEntry$json = const {
  '1': 'UsersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.user_v1.User',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

/// Descriptor for `CallEnvelope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callEnvelopeDescriptor = $convert.base64Decode(
    'CgxDYWxsRW52ZWxvcGUSVQoFdXNlcnMYASADKAsyPy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5DYWxsRW52ZWxvcGUuVXNlcnNFbnRyeVIFdXNlcnMSOgoEY2FsbBgCIAEoCzImLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxSBGNhbGwSRwoHZGV0YWlscxgDIAEoCzItLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxEZXRhaWxzUgdkZXRhaWxzGmAKClVzZXJzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSPAoFdmFsdWUYAiABKAsyJi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IudXNlcl92MS5Vc2VyUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use callsEnvelopeDescriptor instead')
const CallsEnvelope$json = const {
  '1': 'CallsEnvelope',
  '2': const [
    const {
      '1': 'users',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.stream.video.coordinator.client_v1_rpc.CallsEnvelope.UsersEntry',
      '10': 'users'
    },
    const {'1': 'call_cids', '3': 2, '4': 3, '5': 9, '10': 'callCids'},
    const {
      '1': 'calls',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.stream.video.coordinator.client_v1_rpc.CallsEnvelope.CallsEntry',
      '10': 'calls'
    },
    const {
      '1': 'details',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.stream.video.coordinator.client_v1_rpc.CallsEnvelope.DetailsEntry',
      '10': 'details'
    },
  ],
  '3': const [
    CallsEnvelope_UsersEntry$json,
    CallsEnvelope_CallsEntry$json,
    CallsEnvelope_DetailsEntry$json
  ],
};

@$core.Deprecated('Use callsEnvelopeDescriptor instead')
const CallsEnvelope_UsersEntry$json = const {
  '1': 'UsersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.user_v1.User',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use callsEnvelopeDescriptor instead')
const CallsEnvelope_CallsEntry$json = const {
  '1': 'CallsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.call_v1.Call',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use callsEnvelopeDescriptor instead')
const CallsEnvelope_DetailsEntry$json = const {
  '1': 'DetailsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.call_v1.CallDetails',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

/// Descriptor for `CallsEnvelope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callsEnvelopeDescriptor = $convert.base64Decode(
    'Cg1DYWxsc0VudmVsb3BlElYKBXVzZXJzGAEgAygLMkAuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuQ2FsbHNFbnZlbG9wZS5Vc2Vyc0VudHJ5UgV1c2VycxIbCgljYWxsX2NpZHMYAiADKAlSCGNhbGxDaWRzElYKBWNhbGxzGAMgAygLMkAuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuQ2FsbHNFbnZlbG9wZS5DYWxsc0VudHJ5UgVjYWxscxJcCgdkZXRhaWxzGAQgAygLMkIuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuQ2FsbHNFbnZlbG9wZS5EZXRhaWxzRW50cnlSB2RldGFpbHMaYAoKVXNlcnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRI8CgV2YWx1ZRgCIAEoCzImLnN0cmVhbS52aWRlby5jb29yZGluYXRvci51c2VyX3YxLlVzZXJSBXZhbHVlOgI4ARpgCgpDYWxsc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EjwKBXZhbHVlGAIgASgLMiYuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQ2FsbFIFdmFsdWU6AjgBGmkKDERldGFpbHNFbnRyeRIQCgNrZXkYASABKAlSA2tleRJDCgV2YWx1ZRgCIAEoCzItLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxEZXRhaWxzUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use membersEnvelopeDescriptor instead')
const MembersEnvelope$json = const {
  '1': 'MembersEnvelope',
  '2': const [
    const {
      '1': 'users',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.stream.video.coordinator.client_v1_rpc.MembersEnvelope.UsersEntry',
      '10': 'users'
    },
    const {
      '1': 'member_user_ids',
      '3': 2,
      '4': 3,
      '5': 9,
      '10': 'memberUserIds'
    },
    const {
      '1': 'members',
      '3': 3,
      '4': 3,
      '5': 11,
      '6':
          '.stream.video.coordinator.client_v1_rpc.MembersEnvelope.MembersEntry',
      '10': 'members'
    },
  ],
  '3': const [
    MembersEnvelope_UsersEntry$json,
    MembersEnvelope_MembersEntry$json
  ],
};

@$core.Deprecated('Use membersEnvelopeDescriptor instead')
const MembersEnvelope_UsersEntry$json = const {
  '1': 'UsersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.user_v1.User',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use membersEnvelopeDescriptor instead')
const MembersEnvelope_MembersEntry$json = const {
  '1': 'MembersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.member_v1.Member',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

/// Descriptor for `MembersEnvelope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membersEnvelopeDescriptor = $convert.base64Decode(
    'Cg9NZW1iZXJzRW52ZWxvcGUSWAoFdXNlcnMYASADKAsyQi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5NZW1iZXJzRW52ZWxvcGUuVXNlcnNFbnRyeVIFdXNlcnMSJgoPbWVtYmVyX3VzZXJfaWRzGAIgAygJUg1tZW1iZXJVc2VySWRzEl4KB21lbWJlcnMYAyADKAsyRC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5NZW1iZXJzRW52ZWxvcGUuTWVtYmVyc0VudHJ5UgdtZW1iZXJzGmAKClVzZXJzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSPAoFdmFsdWUYAiABKAsyJi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IudXNlcl92MS5Vc2VyUgV2YWx1ZToCOAEaZgoMTWVtYmVyc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EkAKBXZhbHVlGAIgASgLMiouc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLm1lbWJlcl92MS5NZW1iZXJSBXZhbHVlOgI4AQ==');
