///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/client_rpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
import '../call_v1/call.pbjson.dart' as $0;
import 'envelopes.pbjson.dart' as $3;
import '../user_v1/user.pbjson.dart' as $1;
import '../../../google/protobuf/timestamp.pbjson.dart' as $7;
import '../member_v1/member.pbjson.dart' as $2;
import '../edge_v1/edge.pbjson.dart' as $4;
import '../utils_v1/utils.pbjson.dart' as $5;
import '../push_v1/push.pbjson.dart' as $6;

@$core.Deprecated('Use memberFieldDescriptor instead')
const MemberField$json = const {
  '1': 'MemberField',
  '2': const [
    const {'1': 'MEMBER_FIELD_UNSPECIFIED', '2': 0},
    const {'1': 'MEMBER_FIELD_ROLE', '2': 1},
    const {'1': 'MEMBER_FIELD_CUSTOM', '2': 2},
  ],
};

/// Descriptor for `MemberField`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List memberFieldDescriptor = $convert.base64Decode('CgtNZW1iZXJGaWVsZBIcChhNRU1CRVJfRklFTERfVU5TUEVDSUZJRUQQABIVChFNRU1CRVJfRklFTERfUk9MRRABEhcKE01FTUJFUl9GSUVMRF9DVVNUT00QAg==');
@$core.Deprecated('Use userEventTypeDescriptor instead')
const UserEventType$json = const {
  '1': 'UserEventType',
  '2': const [
    const {'1': 'USER_EVENT_TYPE_UNSPECIFIED', '2': 0},
    const {'1': 'USER_EVENT_TYPE_ACCEPTED_CALL', '2': 1},
    const {'1': 'USER_EVENT_TYPE_REJECTED_CALL', '2': 2},
    const {'1': 'USER_EVENT_TYPE_CANCELLED_CALL', '2': 3},
  ],
};

/// Descriptor for `UserEventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userEventTypeDescriptor = $convert.base64Decode('Cg1Vc2VyRXZlbnRUeXBlEh8KG1VTRVJfRVZFTlRfVFlQRV9VTlNQRUNJRklFRBAAEiEKHVVTRVJfRVZFTlRfVFlQRV9BQ0NFUFRFRF9DQUxMEAESIQodVVNFUl9FVkVOVF9UWVBFX1JFSkVDVEVEX0NBTEwQAhIiCh5VU0VSX0VWRU5UX1RZUEVfQ0FOQ0VMTEVEX0NBTEwQAw==');
@$core.Deprecated('Use getCallRequestDescriptor instead')
const GetCallRequest$json = const {
  '1': 'GetCallRequest',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `GetCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCallRequestDescriptor = $convert.base64Decode('Cg5HZXRDYWxsUmVxdWVzdBIZCghjYWxsX2NpZBgBIAEoCVIHY2FsbENpZA==');
@$core.Deprecated('Use getCallResponseDescriptor instead')
const GetCallResponse$json = const {
  '1': 'GetCallResponse',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CallEnvelope', '10': 'call'},
  ],
};

/// Descriptor for `GetCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCallResponseDescriptor = $convert.base64Decode('Cg9HZXRDYWxsUmVzcG9uc2USSAoEY2FsbBgBIAEoCzI0LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLkNhbGxFbnZlbG9wZVIEY2FsbA==');
@$core.Deprecated('Use memberInputDescriptor instead')
const MemberInput$json = const {
  '1': 'MemberInput',
  '2': const [
    const {'1': 'role', '3': 1, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'custom_json', '3': 2, '4': 1, '5': 12, '10': 'customJson'},
  ],
};

/// Descriptor for `MemberInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberInputDescriptor = $convert.base64Decode('CgtNZW1iZXJJbnB1dBISCgRyb2xlGAEgASgJUgRyb2xlEh8KC2N1c3RvbV9qc29uGAIgASgMUgpjdXN0b21Kc29u');
@$core.Deprecated('Use updateCallMembersRequestDescriptor instead')
const UpdateCallMembersRequest$json = const {
  '1': 'UpdateCallMembersRequest',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'members', '3': 2, '4': 3, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.UpdateCallMembersRequest.MembersEntry', '10': 'members'},
    const {'1': 'fields', '3': 3, '4': 3, '5': 14, '6': '.stream.video.coordinator.client_v1_rpc.MemberField', '10': 'fields'},
  ],
  '3': const [UpdateCallMembersRequest_MembersEntry$json],
};

@$core.Deprecated('Use updateCallMembersRequestDescriptor instead')
const UpdateCallMembersRequest_MembersEntry$json = const {
  '1': 'MembersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.MemberInput', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `UpdateCallMembersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCallMembersRequestDescriptor = $convert.base64Decode('ChhVcGRhdGVDYWxsTWVtYmVyc1JlcXVlc3QSGQoIY2FsbF9jaWQYASABKAlSB2NhbGxDaWQSZwoHbWVtYmVycxgCIAMoCzJNLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlVwZGF0ZUNhbGxNZW1iZXJzUmVxdWVzdC5NZW1iZXJzRW50cnlSB21lbWJlcnMSSwoGZmllbGRzGAMgAygOMjMuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuTWVtYmVyRmllbGRSBmZpZWxkcxpvCgxNZW1iZXJzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSSQoFdmFsdWUYAiABKAsyMy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5NZW1iZXJJbnB1dFIFdmFsdWU6AjgB');
@$core.Deprecated('Use updateCallMembersResponseDescriptor instead')
const UpdateCallMembersResponse$json = const {
  '1': 'UpdateCallMembersResponse',
};

/// Descriptor for `UpdateCallMembersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCallMembersResponseDescriptor = $convert.base64Decode('ChlVcGRhdGVDYWxsTWVtYmVyc1Jlc3BvbnNl');
@$core.Deprecated('Use deleteCallMembersRequestDescriptor instead')
const DeleteCallMembersRequest$json = const {
  '1': 'DeleteCallMembersRequest',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'user_ids', '3': 2, '4': 3, '5': 9, '10': 'userIds'},
  ],
};

/// Descriptor for `DeleteCallMembersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteCallMembersRequestDescriptor = $convert.base64Decode('ChhEZWxldGVDYWxsTWVtYmVyc1JlcXVlc3QSGQoIY2FsbF9jaWQYASABKAlSB2NhbGxDaWQSGQoIdXNlcl9pZHMYAiADKAlSB3VzZXJJZHM=');
@$core.Deprecated('Use deleteCallMembersResponseDescriptor instead')
const DeleteCallMembersResponse$json = const {
  '1': 'DeleteCallMembersResponse',
};

/// Descriptor for `DeleteCallMembersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteCallMembersResponseDescriptor = $convert.base64Decode('ChlEZWxldGVDYWxsTWVtYmVyc1Jlc3BvbnNl');
@$core.Deprecated('Use createCallInputDescriptor instead')
const CreateCallInput$json = const {
  '1': 'CreateCallInput',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CallInput', '10': 'call'},
    const {'1': 'members', '3': 2, '4': 3, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CreateCallInput.MembersEntry', '10': 'members'},
    const {'1': 'ring', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'ring', '17': true},
  ],
  '3': const [CreateCallInput_MembersEntry$json],
  '8': const [
    const {'1': '_ring'},
  ],
};

@$core.Deprecated('Use createCallInputDescriptor instead')
const CreateCallInput_MembersEntry$json = const {
  '1': 'MembersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.MemberInput', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `CreateCallInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCallInputDescriptor = $convert.base64Decode('Cg9DcmVhdGVDYWxsSW5wdXQSRQoEY2FsbBgBIAEoCzIxLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLkNhbGxJbnB1dFIEY2FsbBJeCgdtZW1iZXJzGAIgAygLMkQuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuQ3JlYXRlQ2FsbElucHV0Lk1lbWJlcnNFbnRyeVIHbWVtYmVycxIXCgRyaW5nGAQgASgISABSBHJpbmeIAQEabwoMTWVtYmVyc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EkkKBXZhbHVlGAIgASgLMjMuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuTWVtYmVySW5wdXRSBXZhbHVlOgI4AUIHCgVfcmluZw==');
@$core.Deprecated('Use createCallRequestDescriptor instead')
const CreateCallRequest$json = const {
  '1': 'CreateCallRequest',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'id', '17': true},
    const {'1': 'input', '3': 3, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CreateCallInput', '10': 'input'},
  ],
  '8': const [
    const {'1': '_id'},
  ],
};

/// Descriptor for `CreateCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCallRequestDescriptor = $convert.base64Decode('ChFDcmVhdGVDYWxsUmVxdWVzdBISCgR0eXBlGAEgASgJUgR0eXBlEhMKAmlkGAIgASgJSABSAmlkiAEBEk0KBWlucHV0GAMgASgLMjcuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuQ3JlYXRlQ2FsbElucHV0UgVpbnB1dEIFCgNfaWQ=');
@$core.Deprecated('Use getOrCreateCallRequestDescriptor instead')
const GetOrCreateCallRequest$json = const {
  '1': 'GetOrCreateCallRequest',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'input', '3': 3, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CreateCallInput', '10': 'input'},
  ],
};

/// Descriptor for `GetOrCreateCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOrCreateCallRequestDescriptor = $convert.base64Decode('ChZHZXRPckNyZWF0ZUNhbGxSZXF1ZXN0EhIKBHR5cGUYASABKAlSBHR5cGUSDgoCaWQYAiABKAlSAmlkEk0KBWlucHV0GAMgASgLMjcuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuQ3JlYXRlQ2FsbElucHV0UgVpbnB1dA==');
@$core.Deprecated('Use joinCallRequestDescriptor instead')
const JoinCallRequest$json = const {
  '1': 'JoinCallRequest',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'input', '3': 3, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CreateCallInput', '10': 'input'},
    const {'1': 'datacenter_id', '3': 4, '4': 1, '5': 9, '10': 'datacenterId'},
  ],
};

/// Descriptor for `JoinCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinCallRequestDescriptor = $convert.base64Decode('Cg9Kb2luQ2FsbFJlcXVlc3QSEgoEdHlwZRgBIAEoCVIEdHlwZRIOCgJpZBgCIAEoCVICaWQSTQoFaW5wdXQYAyABKAsyNy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5DcmVhdGVDYWxsSW5wdXRSBWlucHV0EiMKDWRhdGFjZW50ZXJfaWQYBCABKAlSDGRhdGFjZW50ZXJJZA==');
@$core.Deprecated('Use joinCallResponseDescriptor instead')
const JoinCallResponse$json = const {
  '1': 'JoinCallResponse',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CallEnvelope', '10': 'call'},
    const {'1': 'created', '3': 2, '4': 1, '5': 8, '10': 'created'},
    const {'1': 'edges', '3': 3, '4': 3, '5': 11, '6': '.stream.video.coordinator.edge_v1.Edge', '10': 'edges'},
  ],
};

/// Descriptor for `JoinCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinCallResponseDescriptor = $convert.base64Decode('ChBKb2luQ2FsbFJlc3BvbnNlEkgKBGNhbGwYASABKAsyNC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5DYWxsRW52ZWxvcGVSBGNhbGwSGAoHY3JlYXRlZBgCIAEoCFIHY3JlYXRlZBI8CgVlZGdlcxgDIAMoCzImLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5lZGdlX3YxLkVkZ2VSBWVkZ2Vz');
@$core.Deprecated('Use callInputDescriptor instead')
const CallInput$json = const {
  '1': 'CallInput',
  '2': const [
    const {'1': 'custom_json', '3': 1, '4': 1, '5': 12, '10': 'customJson'},
    const {'1': 'options', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallOptions', '10': 'options'},
  ],
};

/// Descriptor for `CallInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callInputDescriptor = $convert.base64Decode('CglDYWxsSW5wdXQSHwoLY3VzdG9tX2pzb24YASABKAxSCmN1c3RvbUpzb24SRwoHb3B0aW9ucxgCIAEoCzItLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxPcHRpb25zUgdvcHRpb25z');
@$core.Deprecated('Use getOrCreateCallResponseDescriptor instead')
const GetOrCreateCallResponse$json = const {
  '1': 'GetOrCreateCallResponse',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CallEnvelope', '10': 'call'},
    const {'1': 'created', '3': 2, '4': 1, '5': 8, '10': 'created'},
  ],
};

/// Descriptor for `GetOrCreateCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOrCreateCallResponseDescriptor = $convert.base64Decode('ChdHZXRPckNyZWF0ZUNhbGxSZXNwb25zZRJICgRjYWxsGAEgASgLMjQuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuQ2FsbEVudmVsb3BlUgRjYWxsEhgKB2NyZWF0ZWQYAiABKAhSB2NyZWF0ZWQ=');
@$core.Deprecated('Use updateCallRequestDescriptor instead')
const UpdateCallRequest$json = const {
  '1': 'UpdateCallRequest',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'input', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CallInput', '10': 'input'},
  ],
};

/// Descriptor for `UpdateCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCallRequestDescriptor = $convert.base64Decode('ChFVcGRhdGVDYWxsUmVxdWVzdBIZCghjYWxsX2NpZBgBIAEoCVIHY2FsbENpZBJHCgVpbnB1dBgCIAEoCzIxLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLkNhbGxJbnB1dFIFaW5wdXQ=');
@$core.Deprecated('Use updateCallResponseDescriptor instead')
const UpdateCallResponse$json = const {
  '1': 'UpdateCallResponse',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CallEnvelope', '10': 'call'},
  ],
};

/// Descriptor for `UpdateCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCallResponseDescriptor = $convert.base64Decode('ChJVcGRhdGVDYWxsUmVzcG9uc2USSAoEY2FsbBgBIAEoCzI0LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLkNhbGxFbnZlbG9wZVIEY2FsbA==');
@$core.Deprecated('Use createCallResponseDescriptor instead')
const CreateCallResponse$json = const {
  '1': 'CreateCallResponse',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CallEnvelope', '10': 'call'},
  ],
};

/// Descriptor for `CreateCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCallResponseDescriptor = $convert.base64Decode('ChJDcmVhdGVDYWxsUmVzcG9uc2USSAoEY2FsbBgBIAEoCzI0LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLkNhbGxFbnZlbG9wZVIEY2FsbA==');
@$core.Deprecated('Use queryCallsRequestDescriptor instead')
const QueryCallsRequest$json = const {
  '1': 'QueryCallsRequest',
  '2': const [
    const {'1': 'mq_json', '3': 1, '4': 1, '5': 12, '10': 'mqJson'},
    const {'1': 'limit', '3': 2, '4': 1, '5': 5, '9': 0, '10': 'limit', '17': true},
    const {'1': 'sorts', '3': 3, '4': 3, '5': 11, '6': '.stream.video.coordinator.utils_v1.Sort', '10': 'sorts'},
  ],
  '8': const [
    const {'1': '_limit'},
  ],
};

/// Descriptor for `QueryCallsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryCallsRequestDescriptor = $convert.base64Decode('ChFRdWVyeUNhbGxzUmVxdWVzdBIXCgdtcV9qc29uGAEgASgMUgZtcUpzb24SGQoFbGltaXQYAiABKAVIAFIFbGltaXSIAQESPQoFc29ydHMYAyADKAsyJy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IudXRpbHNfdjEuU29ydFIFc29ydHNCCAoGX2xpbWl0');
@$core.Deprecated('Use queryCallsResponseDescriptor instead')
const QueryCallsResponse$json = const {
  '1': 'QueryCallsResponse',
  '2': const [
    const {'1': 'calls', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CallsEnvelope', '10': 'calls'},
  ],
};

/// Descriptor for `QueryCallsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryCallsResponseDescriptor = $convert.base64Decode('ChJRdWVyeUNhbGxzUmVzcG9uc2USSwoFY2FsbHMYASABKAsyNS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5DYWxsc0VudmVsb3BlUgVjYWxscw==');
@$core.Deprecated('Use queryMembersRequestDescriptor instead')
const QueryMembersRequest$json = const {
  '1': 'QueryMembersRequest',
  '2': const [
    const {'1': 'mq_json', '3': 1, '4': 1, '5': 12, '10': 'mqJson'},
    const {'1': 'limit', '3': 2, '4': 1, '5': 5, '9': 0, '10': 'limit', '17': true},
    const {'1': 'sorts', '3': 3, '4': 3, '5': 11, '6': '.stream.video.coordinator.utils_v1.Sort', '10': 'sorts'},
  ],
  '8': const [
    const {'1': '_limit'},
  ],
};

/// Descriptor for `QueryMembersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryMembersRequestDescriptor = $convert.base64Decode('ChNRdWVyeU1lbWJlcnNSZXF1ZXN0EhcKB21xX2pzb24YASABKAxSBm1xSnNvbhIZCgVsaW1pdBgCIAEoBUgAUgVsaW1pdIgBARI9CgVzb3J0cxgDIAMoCzInLnN0cmVhbS52aWRlby5jb29yZGluYXRvci51dGlsc192MS5Tb3J0UgVzb3J0c0IICgZfbGltaXQ=');
@$core.Deprecated('Use queryMembersResponseDescriptor instead')
const QueryMembersResponse$json = const {
  '1': 'QueryMembersResponse',
  '2': const [
    const {'1': 'members', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.MembersEnvelope', '10': 'members'},
  ],
};

/// Descriptor for `QueryMembersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryMembersResponseDescriptor = $convert.base64Decode('ChRRdWVyeU1lbWJlcnNSZXNwb25zZRJRCgdtZW1iZXJzGAEgASgLMjcuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuTWVtYmVyc0VudmVsb3BlUgdtZW1iZXJz');
@$core.Deprecated('Use getCallEdgeServerRequestDescriptor instead')
const GetCallEdgeServerRequest$json = const {
  '1': 'GetCallEdgeServerRequest',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'measurements', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.edge_v1.LatencyMeasurements', '10': 'measurements'},
  ],
};

/// Descriptor for `GetCallEdgeServerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCallEdgeServerRequestDescriptor = $convert.base64Decode('ChhHZXRDYWxsRWRnZVNlcnZlclJlcXVlc3QSGQoIY2FsbF9jaWQYASABKAlSB2NhbGxDaWQSWQoMbWVhc3VyZW1lbnRzGAIgASgLMjUuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmVkZ2VfdjEuTGF0ZW5jeU1lYXN1cmVtZW50c1IMbWVhc3VyZW1lbnRz');
@$core.Deprecated('Use getCallEdgeServerResponseDescriptor instead')
const GetCallEdgeServerResponse$json = const {
  '1': 'GetCallEdgeServerResponse',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.CallEnvelope', '10': 'call'},
    const {'1': 'credentials', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.edge_v1.Credentials', '10': 'credentials'},
  ],
};

/// Descriptor for `GetCallEdgeServerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCallEdgeServerResponseDescriptor = $convert.base64Decode('ChlHZXRDYWxsRWRnZVNlcnZlclJlc3BvbnNlEkgKBGNhbGwYASABKAsyNC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5DYWxsRW52ZWxvcGVSBGNhbGwSTwoLY3JlZGVudGlhbHMYAiABKAsyLS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuZWRnZV92MS5DcmVkZW50aWFsc1ILY3JlZGVudGlhbHM=');
@$core.Deprecated('Use createDeviceRequestDescriptor instead')
const CreateDeviceRequest$json = const {
  '1': 'CreateDeviceRequest',
  '2': const [
    const {'1': 'input', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.push_v1.DeviceInput', '10': 'input'},
  ],
};

/// Descriptor for `CreateDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createDeviceRequestDescriptor = $convert.base64Decode('ChNDcmVhdGVEZXZpY2VSZXF1ZXN0EkMKBWlucHV0GAEgASgLMi0uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnB1c2hfdjEuRGV2aWNlSW5wdXRSBWlucHV0');
@$core.Deprecated('Use createDeviceResponseDescriptor instead')
const CreateDeviceResponse$json = const {
  '1': 'CreateDeviceResponse',
  '2': const [
    const {'1': 'device', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.push_v1.Device', '10': 'device'},
  ],
};

/// Descriptor for `CreateDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createDeviceResponseDescriptor = $convert.base64Decode('ChRDcmVhdGVEZXZpY2VSZXNwb25zZRJACgZkZXZpY2UYASABKAsyKC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IucHVzaF92MS5EZXZpY2VSBmRldmljZQ==');
@$core.Deprecated('Use deleteDeviceRequestDescriptor instead')
const DeleteDeviceRequest$json = const {
  '1': 'DeleteDeviceRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteDeviceRequestDescriptor = $convert.base64Decode('ChNEZWxldGVEZXZpY2VSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');
@$core.Deprecated('Use deleteDeviceResponseDescriptor instead')
const DeleteDeviceResponse$json = const {
  '1': 'DeleteDeviceResponse',
};

/// Descriptor for `DeleteDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteDeviceResponseDescriptor = $convert.base64Decode('ChREZWxldGVEZXZpY2VSZXNwb25zZQ==');
@$core.Deprecated('Use queryDevicesRequestDescriptor instead')
const QueryDevicesRequest$json = const {
  '1': 'QueryDevicesRequest',
};

/// Descriptor for `QueryDevicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryDevicesRequestDescriptor = $convert.base64Decode('ChNRdWVyeURldmljZXNSZXF1ZXN0');
@$core.Deprecated('Use queryDevicesResponseDescriptor instead')
const QueryDevicesResponse$json = const {
  '1': 'QueryDevicesResponse',
  '2': const [
    const {'1': 'devices', '3': 1, '4': 3, '5': 11, '6': '.stream.video.coordinator.push_v1.Device', '10': 'devices'},
  ],
};

/// Descriptor for `QueryDevicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryDevicesResponseDescriptor = $convert.base64Decode('ChRRdWVyeURldmljZXNSZXNwb25zZRJCCgdkZXZpY2VzGAEgAygLMiguc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnB1c2hfdjEuRGV2aWNlUgdkZXZpY2Vz');
@$core.Deprecated('Use sendEventRequestDescriptor instead')
const SendEventRequest$json = const {
  '1': 'SendEventRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'event_type', '3': 3, '4': 1, '5': 14, '6': '.stream.video.coordinator.client_v1_rpc.UserEventType', '10': 'eventType'},
  ],
};

/// Descriptor for `SendEventRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendEventRequestDescriptor = $convert.base64Decode('ChBTZW5kRXZlbnRSZXF1ZXN0EhsKCWNhbGxfdHlwZRgBIAEoCVIIY2FsbFR5cGUSFwoHY2FsbF9pZBgCIAEoCVIGY2FsbElkElQKCmV2ZW50X3R5cGUYAyABKA4yNS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5Vc2VyRXZlbnRUeXBlUglldmVudFR5cGU=');
@$core.Deprecated('Use sendEventResponseDescriptor instead')
const SendEventResponse$json = const {
  '1': 'SendEventResponse',
};

/// Descriptor for `SendEventResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendEventResponseDescriptor = $convert.base64Decode('ChFTZW5kRXZlbnRSZXNwb25zZQ==');
@$core.Deprecated('Use sendCustomEventRequestDescriptor instead')
const SendCustomEventRequest$json = const {
  '1': 'SendCustomEventRequest',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `SendCustomEventRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendCustomEventRequestDescriptor = $convert.base64Decode('ChZTZW5kQ3VzdG9tRXZlbnRSZXF1ZXN0EhIKBHR5cGUYASABKAlSBHR5cGUSEgoEZGF0YRgCIAEoDFIEZGF0YQ==');
@$core.Deprecated('Use sendCustomEventResponseDescriptor instead')
const SendCustomEventResponse$json = const {
  '1': 'SendCustomEventResponse',
};

/// Descriptor for `SendCustomEventResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendCustomEventResponseDescriptor = $convert.base64Decode('ChdTZW5kQ3VzdG9tRXZlbnRSZXNwb25zZQ==');
@$core.Deprecated('Use reportCallStatsRequestDescriptor instead')
const ReportCallStatsRequest$json = const {
  '1': 'ReportCallStatsRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'stats_json', '3': 3, '4': 1, '5': 12, '10': 'statsJson'},
  ],
};

/// Descriptor for `ReportCallStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportCallStatsRequestDescriptor = $convert.base64Decode('ChZSZXBvcnRDYWxsU3RhdHNSZXF1ZXN0EhsKCWNhbGxfdHlwZRgBIAEoCVIIY2FsbFR5cGUSFwoHY2FsbF9pZBgCIAEoCVIGY2FsbElkEh0KCnN0YXRzX2pzb24YAyABKAxSCXN0YXRzSnNvbg==');
@$core.Deprecated('Use reportCallStatsResponseDescriptor instead')
const ReportCallStatsResponse$json = const {
  '1': 'ReportCallStatsResponse',
};

/// Descriptor for `ReportCallStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportCallStatsResponseDescriptor = $convert.base64Decode('ChdSZXBvcnRDYWxsU3RhdHNSZXNwb25zZQ==');
@$core.Deprecated('Use getCallStatsRequestDescriptor instead')
const GetCallStatsRequest$json = const {
  '1': 'GetCallStatsRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
  ],
};

/// Descriptor for `GetCallStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCallStatsRequestDescriptor = $convert.base64Decode('ChNHZXRDYWxsU3RhdHNSZXF1ZXN0EhsKCWNhbGxfdHlwZRgBIAEoCVIIY2FsbFR5cGUSFwoHY2FsbF9pZBgCIAEoCVIGY2FsbElk');
@$core.Deprecated('Use reportIssueRequestDescriptor instead')
const ReportIssueRequest$json = const {
  '1': 'ReportIssueRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'custom_json', '3': 4, '4': 1, '5': 12, '10': 'customJson'},
  ],
};

/// Descriptor for `ReportIssueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportIssueRequestDescriptor = $convert.base64Decode('ChJSZXBvcnRJc3N1ZVJlcXVlc3QSGwoJY2FsbF90eXBlGAEgASgJUghjYWxsVHlwZRIXCgdjYWxsX2lkGAIgASgJUgZjYWxsSWQSIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2NyaXB0aW9uEh8KC2N1c3RvbV9qc29uGAQgASgMUgpjdXN0b21Kc29u');
@$core.Deprecated('Use reportIssueResponseDescriptor instead')
const ReportIssueResponse$json = const {
  '1': 'ReportIssueResponse',
};

/// Descriptor for `ReportIssueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportIssueResponseDescriptor = $convert.base64Decode('ChNSZXBvcnRJc3N1ZVJlc3BvbnNl');
@$core.Deprecated('Use reviewCallRequestDescriptor instead')
const ReviewCallRequest$json = const {
  '1': 'ReviewCallRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'stars', '3': 3, '4': 1, '5': 2, '10': 'stars'},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'custom_json', '3': 5, '4': 1, '5': 12, '10': 'customJson'},
  ],
};

/// Descriptor for `ReviewCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewCallRequestDescriptor = $convert.base64Decode('ChFSZXZpZXdDYWxsUmVxdWVzdBIbCgljYWxsX3R5cGUYASABKAlSCGNhbGxUeXBlEhcKB2NhbGxfaWQYAiABKAlSBmNhbGxJZBIUCgVzdGFycxgDIAEoAlIFc3RhcnMSIAoLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9uEh8KC2N1c3RvbV9qc29uGAUgASgMUgpjdXN0b21Kc29u');
@$core.Deprecated('Use reviewCallResponseDescriptor instead')
const ReviewCallResponse$json = const {
  '1': 'ReviewCallResponse',
};

/// Descriptor for `ReviewCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewCallResponseDescriptor = $convert.base64Decode('ChJSZXZpZXdDYWxsUmVzcG9uc2U=');
const $core.Map<$core.String, $core.dynamic> ClientRPCServiceBase$json = const {
  '1': 'ClientRPC',
  '2': const [
    const {'1': 'CreateCall', '2': '.stream.video.coordinator.client_v1_rpc.CreateCallRequest', '3': '.stream.video.coordinator.client_v1_rpc.CreateCallResponse'},
    const {'1': 'GetOrCreateCall', '2': '.stream.video.coordinator.client_v1_rpc.GetOrCreateCallRequest', '3': '.stream.video.coordinator.client_v1_rpc.GetOrCreateCallResponse'},
    const {'1': 'JoinCall', '2': '.stream.video.coordinator.client_v1_rpc.JoinCallRequest', '3': '.stream.video.coordinator.client_v1_rpc.JoinCallResponse'},
    const {'1': 'GetCallEdgeServer', '2': '.stream.video.coordinator.client_v1_rpc.GetCallEdgeServerRequest', '3': '.stream.video.coordinator.client_v1_rpc.GetCallEdgeServerResponse'},
    const {'1': 'UpdateCall', '2': '.stream.video.coordinator.client_v1_rpc.UpdateCallRequest', '3': '.stream.video.coordinator.client_v1_rpc.UpdateCallResponse'},
    const {'1': 'QueryCalls', '2': '.stream.video.coordinator.client_v1_rpc.QueryCallsRequest', '3': '.stream.video.coordinator.client_v1_rpc.QueryCallsResponse'},
    const {'1': 'QueryMembers', '2': '.stream.video.coordinator.client_v1_rpc.QueryMembersRequest', '3': '.stream.video.coordinator.client_v1_rpc.QueryMembersResponse'},
    const {'1': 'CreateDevice', '2': '.stream.video.coordinator.client_v1_rpc.CreateDeviceRequest', '3': '.stream.video.coordinator.client_v1_rpc.CreateDeviceResponse'},
    const {'1': 'DeleteDevice', '2': '.stream.video.coordinator.client_v1_rpc.DeleteDeviceRequest', '3': '.stream.video.coordinator.client_v1_rpc.DeleteDeviceResponse'},
    const {'1': 'QueryDevices', '2': '.stream.video.coordinator.client_v1_rpc.QueryDevicesRequest', '3': '.stream.video.coordinator.client_v1_rpc.QueryDevicesResponse'},
    const {'1': 'UpdateCallMembers', '2': '.stream.video.coordinator.client_v1_rpc.UpdateCallMembersRequest', '3': '.stream.video.coordinator.client_v1_rpc.UpdateCallMembersResponse'},
    const {'1': 'DeleteCallMembers', '2': '.stream.video.coordinator.client_v1_rpc.DeleteCallMembersRequest', '3': '.stream.video.coordinator.client_v1_rpc.DeleteCallMembersResponse'},
    const {'1': 'SendEvent', '2': '.stream.video.coordinator.client_v1_rpc.SendEventRequest', '3': '.stream.video.coordinator.client_v1_rpc.SendEventResponse'},
    const {'1': 'SendCustomEvent', '2': '.stream.video.coordinator.client_v1_rpc.SendCustomEventRequest', '3': '.stream.video.coordinator.client_v1_rpc.SendCustomEventResponse'},
    const {'1': 'ReportCallStats', '2': '.stream.video.coordinator.client_v1_rpc.ReportCallStatsRequest', '3': '.stream.video.coordinator.client_v1_rpc.ReportCallStatsResponse'},
    const {'1': 'ReviewCall', '2': '.stream.video.coordinator.client_v1_rpc.ReviewCallRequest', '3': '.stream.video.coordinator.client_v1_rpc.ReviewCallResponse'},
    const {'1': 'ReportIssue', '2': '.stream.video.coordinator.client_v1_rpc.ReportIssueRequest', '3': '.stream.video.coordinator.client_v1_rpc.ReportIssueResponse'},
  ],
};

@$core.Deprecated('Use clientRPCServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> ClientRPCServiceBase$messageJson = const {
  '.stream.video.coordinator.client_v1_rpc.CreateCallRequest': CreateCallRequest$json,
  '.stream.video.coordinator.client_v1_rpc.CreateCallInput': CreateCallInput$json,
  '.stream.video.coordinator.client_v1_rpc.CallInput': CallInput$json,
  '.stream.video.coordinator.call_v1.CallOptions': $0.CallOptions$json,
  '.stream.video.coordinator.call_v1.RecordingOptions': $0.RecordingOptions$json,
  '.stream.video.coordinator.call_v1.BroadcastingOptions': $0.BroadcastingOptions$json,
  '.stream.video.coordinator.client_v1_rpc.CreateCallInput.MembersEntry': CreateCallInput_MembersEntry$json,
  '.stream.video.coordinator.client_v1_rpc.MemberInput': MemberInput$json,
  '.stream.video.coordinator.client_v1_rpc.CreateCallResponse': CreateCallResponse$json,
  '.stream.video.coordinator.client_v1_rpc.CallEnvelope': $3.CallEnvelope$json,
  '.stream.video.coordinator.client_v1_rpc.CallEnvelope.UsersEntry': $3.CallEnvelope_UsersEntry$json,
  '.stream.video.coordinator.user_v1.User': $1.User$json,
  '.google.protobuf.Timestamp': $7.Timestamp$json,
  '.stream.video.coordinator.call_v1.Call': $0.Call$json,
  '.stream.video.coordinator.call_v1.CallDetails': $0.CallDetails$json,
  '.stream.video.coordinator.call_v1.CallDetails.MembersEntry': $0.CallDetails_MembersEntry$json,
  '.stream.video.coordinator.member_v1.Member': $2.Member$json,
  '.stream.video.coordinator.client_v1_rpc.GetOrCreateCallRequest': GetOrCreateCallRequest$json,
  '.stream.video.coordinator.client_v1_rpc.GetOrCreateCallResponse': GetOrCreateCallResponse$json,
  '.stream.video.coordinator.client_v1_rpc.JoinCallRequest': JoinCallRequest$json,
  '.stream.video.coordinator.client_v1_rpc.JoinCallResponse': JoinCallResponse$json,
  '.stream.video.coordinator.edge_v1.Edge': $4.Edge$json,
  '.stream.video.coordinator.edge_v1.Coordinates': $4.Coordinates$json,
  '.stream.video.coordinator.client_v1_rpc.GetCallEdgeServerRequest': GetCallEdgeServerRequest$json,
  '.stream.video.coordinator.edge_v1.LatencyMeasurements': $4.LatencyMeasurements$json,
  '.stream.video.coordinator.edge_v1.LatencyMeasurements.MeasurementsEntry': $4.LatencyMeasurements_MeasurementsEntry$json,
  '.stream.video.coordinator.edge_v1.Latency': $4.Latency$json,
  '.stream.video.coordinator.client_v1_rpc.GetCallEdgeServerResponse': GetCallEdgeServerResponse$json,
  '.stream.video.coordinator.edge_v1.Credentials': $4.Credentials$json,
  '.stream.video.coordinator.edge_v1.EdgeServer': $4.EdgeServer$json,
  '.stream.video.coordinator.edge_v1.ICEServer': $4.ICEServer$json,
  '.stream.video.coordinator.client_v1_rpc.UpdateCallRequest': UpdateCallRequest$json,
  '.stream.video.coordinator.client_v1_rpc.UpdateCallResponse': UpdateCallResponse$json,
  '.stream.video.coordinator.client_v1_rpc.QueryCallsRequest': QueryCallsRequest$json,
  '.stream.video.coordinator.utils_v1.Sort': $5.Sort$json,
  '.stream.video.coordinator.client_v1_rpc.QueryCallsResponse': QueryCallsResponse$json,
  '.stream.video.coordinator.client_v1_rpc.CallsEnvelope': $3.CallsEnvelope$json,
  '.stream.video.coordinator.client_v1_rpc.CallsEnvelope.UsersEntry': $3.CallsEnvelope_UsersEntry$json,
  '.stream.video.coordinator.client_v1_rpc.CallsEnvelope.CallsEntry': $3.CallsEnvelope_CallsEntry$json,
  '.stream.video.coordinator.client_v1_rpc.CallsEnvelope.DetailsEntry': $3.CallsEnvelope_DetailsEntry$json,
  '.stream.video.coordinator.client_v1_rpc.QueryMembersRequest': QueryMembersRequest$json,
  '.stream.video.coordinator.client_v1_rpc.QueryMembersResponse': QueryMembersResponse$json,
  '.stream.video.coordinator.client_v1_rpc.MembersEnvelope': $3.MembersEnvelope$json,
  '.stream.video.coordinator.client_v1_rpc.MembersEnvelope.UsersEntry': $3.MembersEnvelope_UsersEntry$json,
  '.stream.video.coordinator.client_v1_rpc.MembersEnvelope.MembersEntry': $3.MembersEnvelope_MembersEntry$json,
  '.stream.video.coordinator.client_v1_rpc.CreateDeviceRequest': CreateDeviceRequest$json,
  '.stream.video.coordinator.push_v1.DeviceInput': $6.DeviceInput$json,
  '.stream.video.coordinator.client_v1_rpc.CreateDeviceResponse': CreateDeviceResponse$json,
  '.stream.video.coordinator.push_v1.Device': $6.Device$json,
  '.stream.video.coordinator.client_v1_rpc.DeleteDeviceRequest': DeleteDeviceRequest$json,
  '.stream.video.coordinator.client_v1_rpc.DeleteDeviceResponse': DeleteDeviceResponse$json,
  '.stream.video.coordinator.client_v1_rpc.QueryDevicesRequest': QueryDevicesRequest$json,
  '.stream.video.coordinator.client_v1_rpc.QueryDevicesResponse': QueryDevicesResponse$json,
  '.stream.video.coordinator.client_v1_rpc.UpdateCallMembersRequest': UpdateCallMembersRequest$json,
  '.stream.video.coordinator.client_v1_rpc.UpdateCallMembersRequest.MembersEntry': UpdateCallMembersRequest_MembersEntry$json,
  '.stream.video.coordinator.client_v1_rpc.UpdateCallMembersResponse': UpdateCallMembersResponse$json,
  '.stream.video.coordinator.client_v1_rpc.DeleteCallMembersRequest': DeleteCallMembersRequest$json,
  '.stream.video.coordinator.client_v1_rpc.DeleteCallMembersResponse': DeleteCallMembersResponse$json,
  '.stream.video.coordinator.client_v1_rpc.SendEventRequest': SendEventRequest$json,
  '.stream.video.coordinator.client_v1_rpc.SendEventResponse': SendEventResponse$json,
  '.stream.video.coordinator.client_v1_rpc.SendCustomEventRequest': SendCustomEventRequest$json,
  '.stream.video.coordinator.client_v1_rpc.SendCustomEventResponse': SendCustomEventResponse$json,
  '.stream.video.coordinator.client_v1_rpc.ReportCallStatsRequest': ReportCallStatsRequest$json,
  '.stream.video.coordinator.client_v1_rpc.ReportCallStatsResponse': ReportCallStatsResponse$json,
  '.stream.video.coordinator.client_v1_rpc.ReviewCallRequest': ReviewCallRequest$json,
  '.stream.video.coordinator.client_v1_rpc.ReviewCallResponse': ReviewCallResponse$json,
  '.stream.video.coordinator.client_v1_rpc.ReportIssueRequest': ReportIssueRequest$json,
  '.stream.video.coordinator.client_v1_rpc.ReportIssueResponse': ReportIssueResponse$json,
};

/// Descriptor for `ClientRPC`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List clientRPCServiceDescriptor = $convert.base64Decode('CglDbGllbnRSUEMSgwEKCkNyZWF0ZUNhbGwSOS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5DcmVhdGVDYWxsUmVxdWVzdBo6LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLkNyZWF0ZUNhbGxSZXNwb25zZRKSAQoPR2V0T3JDcmVhdGVDYWxsEj4uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuR2V0T3JDcmVhdGVDYWxsUmVxdWVzdBo/LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLkdldE9yQ3JlYXRlQ2FsbFJlc3BvbnNlEn0KCEpvaW5DYWxsEjcuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuSm9pbkNhbGxSZXF1ZXN0Gjguc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuSm9pbkNhbGxSZXNwb25zZRKYAQoRR2V0Q2FsbEVkZ2VTZXJ2ZXISQC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5HZXRDYWxsRWRnZVNlcnZlclJlcXVlc3QaQS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5HZXRDYWxsRWRnZVNlcnZlclJlc3BvbnNlEoMBCgpVcGRhdGVDYWxsEjkuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuVXBkYXRlQ2FsbFJlcXVlc3QaOi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5VcGRhdGVDYWxsUmVzcG9uc2USgwEKClF1ZXJ5Q2FsbHMSOS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5RdWVyeUNhbGxzUmVxdWVzdBo6LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlF1ZXJ5Q2FsbHNSZXNwb25zZRKJAQoMUXVlcnlNZW1iZXJzEjsuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuUXVlcnlNZW1iZXJzUmVxdWVzdBo8LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlF1ZXJ5TWVtYmVyc1Jlc3BvbnNlEokBCgxDcmVhdGVEZXZpY2USOy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5DcmVhdGVEZXZpY2VSZXF1ZXN0Gjwuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuQ3JlYXRlRGV2aWNlUmVzcG9uc2USiQEKDERlbGV0ZURldmljZRI7LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLkRlbGV0ZURldmljZVJlcXVlc3QaPC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5EZWxldGVEZXZpY2VSZXNwb25zZRKJAQoMUXVlcnlEZXZpY2VzEjsuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuUXVlcnlEZXZpY2VzUmVxdWVzdBo8LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlF1ZXJ5RGV2aWNlc1Jlc3BvbnNlEpgBChFVcGRhdGVDYWxsTWVtYmVycxJALnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlVwZGF0ZUNhbGxNZW1iZXJzUmVxdWVzdBpBLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlVwZGF0ZUNhbGxNZW1iZXJzUmVzcG9uc2USmAEKEURlbGV0ZUNhbGxNZW1iZXJzEkAuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuRGVsZXRlQ2FsbE1lbWJlcnNSZXF1ZXN0GkEuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuRGVsZXRlQ2FsbE1lbWJlcnNSZXNwb25zZRKAAQoJU2VuZEV2ZW50Ejguc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuU2VuZEV2ZW50UmVxdWVzdBo5LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlNlbmRFdmVudFJlc3BvbnNlEpIBCg9TZW5kQ3VzdG9tRXZlbnQSPi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5TZW5kQ3VzdG9tRXZlbnRSZXF1ZXN0Gj8uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuU2VuZEN1c3RvbUV2ZW50UmVzcG9uc2USkgEKD1JlcG9ydENhbGxTdGF0cxI+LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlJlcG9ydENhbGxTdGF0c1JlcXVlc3QaPy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5SZXBvcnRDYWxsU3RhdHNSZXNwb25zZRKDAQoKUmV2aWV3Q2FsbBI5LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlJldmlld0NhbGxSZXF1ZXN0Gjouc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuUmV2aWV3Q2FsbFJlc3BvbnNlEoYBCgtSZXBvcnRJc3N1ZRI6LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlJlcG9ydElzc3VlUmVxdWVzdBo7LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlJlcG9ydElzc3VlUmVzcG9uc2U=');
