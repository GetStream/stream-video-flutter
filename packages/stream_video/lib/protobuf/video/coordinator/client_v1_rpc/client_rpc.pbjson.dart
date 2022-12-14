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
import '../user_v1/user.pbjson.dart' as $1;
import 'envelopes.pbjson.dart' as $3;
import '../../../google/protobuf/timestamp.pbjson.dart' as $7;
import '../member_v1/member.pbjson.dart' as $2;
import '../edge_v1/edge.pbjson.dart' as $4;
import '../utils_v1/utils.pbjson.dart' as $5;
import '../push_v1/push.pbjson.dart' as $6;
import '../broadcast_v1/broadcast.pbjson.dart' as $9;
import '../stat_v1/stat.pbjson.dart' as $8;

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
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'custom_json', '3': 3, '4': 1, '5': 12, '10': 'customJson'},
    const {'1': 'user_input', '3': 4, '4': 1, '5': 11, '6': '.stream.video.coordinator.user_v1.UserInput', '10': 'userInput'},
  ],
};

/// Descriptor for `MemberInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberInputDescriptor = $convert.base64Decode('CgtNZW1iZXJJbnB1dBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSEgoEcm9sZRgCIAEoCVIEcm9sZRIfCgtjdXN0b21fanNvbhgDIAEoDFIKY3VzdG9tSnNvbhJKCgp1c2VyX2lucHV0GAQgASgLMisuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnVzZXJfdjEuVXNlcklucHV0Ugl1c2VySW5wdXQ=');
@$core.Deprecated('Use upsertCallMembersRequestDescriptor instead')
const UpsertCallMembersRequest$json = const {
  '1': 'UpsertCallMembersRequest',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'members', '3': 2, '4': 3, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.MemberInput', '10': 'members'},
    const {'1': 'ring', '3': 3, '4': 1, '5': 8, '10': 'ring'},
  ],
};

/// Descriptor for `UpsertCallMembersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertCallMembersRequestDescriptor = $convert.base64Decode('ChhVcHNlcnRDYWxsTWVtYmVyc1JlcXVlc3QSGQoIY2FsbF9jaWQYASABKAlSB2NhbGxDaWQSTQoHbWVtYmVycxgCIAMoCzIzLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLk1lbWJlcklucHV0UgdtZW1iZXJzEhIKBHJpbmcYAyABKAhSBHJpbmc=');
@$core.Deprecated('Use upsertCallMembersResponseDescriptor instead')
const UpsertCallMembersResponse$json = const {
  '1': 'UpsertCallMembersResponse',
};

/// Descriptor for `UpsertCallMembersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertCallMembersResponseDescriptor = $convert.base64Decode('ChlVcHNlcnRDYWxsTWVtYmVyc1Jlc3BvbnNl');
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
    const {'1': 'members', '3': 2, '4': 3, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.MemberInput', '10': 'members'},
    const {'1': 'ring', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'ring', '17': true},
  ],
  '8': const [
    const {'1': '_ring'},
  ],
};

/// Descriptor for `CreateCallInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCallInputDescriptor = $convert.base64Decode('Cg9DcmVhdGVDYWxsSW5wdXQSRQoEY2FsbBgBIAEoCzIxLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLkNhbGxJbnB1dFIEY2FsbBJNCgdtZW1iZXJzGAIgAygLMjMuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuTWVtYmVySW5wdXRSB21lbWJlcnMSFwoEcmluZxgDIAEoCEgAUgRyaW5niAEBQgcKBV9yaW5n');
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
    const {'1': 'settings_overrides', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallSettings', '10': 'settingsOverrides'},
  ],
};

/// Descriptor for `CallInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callInputDescriptor = $convert.base64Decode('CglDYWxsSW5wdXQSHwoLY3VzdG9tX2pzb24YASABKAxSCmN1c3RvbUpzb24SXQoSc2V0dGluZ3Nfb3ZlcnJpZGVzGAIgASgLMi4uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQ2FsbFNldHRpbmdzUhFzZXR0aW5nc092ZXJyaWRlcw==');
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
@$core.Deprecated('Use roleOverrideDescriptor instead')
const RoleOverride$json = const {
  '1': 'RoleOverride',
  '2': const [
    const {'1': 'user_ids', '3': 1, '4': 3, '5': 9, '10': 'userIds'},
    const {'1': 'role_name', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'roleName', '17': true},
  ],
  '8': const [
    const {'1': '_role_name'},
  ],
};

/// Descriptor for `RoleOverride`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roleOverrideDescriptor = $convert.base64Decode('CgxSb2xlT3ZlcnJpZGUSGQoIdXNlcl9pZHMYASADKAlSB3VzZXJJZHMSIAoJcm9sZV9uYW1lGAIgASgJSABSCHJvbGVOYW1liAEBQgwKCl9yb2xlX25hbWU=');
@$core.Deprecated('Use permissionGrantOverrideDescriptor instead')
const PermissionGrantOverride$json = const {
  '1': 'PermissionGrantOverride',
  '2': const [
    const {'1': 'user_ids', '3': 1, '4': 3, '5': 9, '10': 'userIds'},
    const {'1': 'permissions', '3': 2, '4': 3, '5': 9, '10': 'permissions'},
  ],
};

/// Descriptor for `PermissionGrantOverride`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionGrantOverrideDescriptor = $convert.base64Decode('ChdQZXJtaXNzaW9uR3JhbnRPdmVycmlkZRIZCgh1c2VyX2lkcxgBIAMoCVIHdXNlcklkcxIgCgtwZXJtaXNzaW9ucxgCIAMoCVILcGVybWlzc2lvbnM=');
@$core.Deprecated('Use updateCallPermissionsRequestDescriptor instead')
const UpdateCallPermissionsRequest$json = const {
  '1': 'UpdateCallPermissionsRequest',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'role_override', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.RoleOverride', '9': 0, '10': 'roleOverride'},
    const {'1': 'permission_override', '3': 3, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.PermissionGrantOverride', '9': 0, '10': 'permissionOverride'},
  ],
  '8': const [
    const {'1': 'grant_input'},
  ],
};

/// Descriptor for `UpdateCallPermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCallPermissionsRequestDescriptor = $convert.base64Decode('ChxVcGRhdGVDYWxsUGVybWlzc2lvbnNSZXF1ZXN0EhkKCGNhbGxfY2lkGAEgASgJUgdjYWxsQ2lkElsKDXJvbGVfb3ZlcnJpZGUYAiABKAsyNC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5Sb2xlT3ZlcnJpZGVIAFIMcm9sZU92ZXJyaWRlEnIKE3Blcm1pc3Npb25fb3ZlcnJpZGUYAyABKAsyPy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5QZXJtaXNzaW9uR3JhbnRPdmVycmlkZUgAUhJwZXJtaXNzaW9uT3ZlcnJpZGVCDQoLZ3JhbnRfaW5wdXQ=');
@$core.Deprecated('Use updateCallPermissionsResponseDescriptor instead')
const UpdateCallPermissionsResponse$json = const {
  '1': 'UpdateCallPermissionsResponse',
};

/// Descriptor for `UpdateCallPermissionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCallPermissionsResponseDescriptor = $convert.base64Decode('Ch1VcGRhdGVDYWxsUGVybWlzc2lvbnNSZXNwb25zZQ==');
@$core.Deprecated('Use endCallRequestDescriptor instead')
const EndCallRequest$json = const {
  '1': 'EndCallRequest',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `EndCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endCallRequestDescriptor = $convert.base64Decode('Cg5FbmRDYWxsUmVxdWVzdBIZCghjYWxsX2NpZBgBIAEoCVIHY2FsbENpZA==');
@$core.Deprecated('Use endCallResponseDescriptor instead')
const EndCallResponse$json = const {
  '1': 'EndCallResponse',
};

/// Descriptor for `EndCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endCallResponseDescriptor = $convert.base64Decode('Cg9FbmRDYWxsUmVzcG9uc2U=');
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
@$core.Deprecated('Use queryUsersRequestDescriptor instead')
const QueryUsersRequest$json = const {
  '1': 'QueryUsersRequest',
  '2': const [
    const {'1': 'mq_json', '3': 1, '4': 1, '5': 12, '10': 'mqJson'},
    const {'1': 'limit', '3': 2, '4': 1, '5': 5, '9': 0, '10': 'limit', '17': true},
    const {'1': 'sorts', '3': 3, '4': 3, '5': 11, '6': '.stream.video.coordinator.utils_v1.Sort', '10': 'sorts'},
  ],
  '8': const [
    const {'1': '_limit'},
  ],
};

/// Descriptor for `QueryUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryUsersRequestDescriptor = $convert.base64Decode('ChFRdWVyeVVzZXJzUmVxdWVzdBIXCgdtcV9qc29uGAEgASgMUgZtcUpzb24SGQoFbGltaXQYAiABKAVIAFIFbGltaXSIAQESPQoFc29ydHMYAyADKAsyJy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IudXRpbHNfdjEuU29ydFIFc29ydHNCCAoGX2xpbWl0');
@$core.Deprecated('Use queryUsersResponseDescriptor instead')
const QueryUsersResponse$json = const {
  '1': 'QueryUsersResponse',
  '2': const [
    const {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.stream.video.coordinator.user_v1.User', '10': 'users'},
  ],
};

/// Descriptor for `QueryUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryUsersResponseDescriptor = $convert.base64Decode('ChJRdWVyeVVzZXJzUmVzcG9uc2USPAoFdXNlcnMYASADKAsyJi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IudXNlcl92MS5Vc2VyUgV1c2Vycw==');
@$core.Deprecated('Use upsertUsersRequestDescriptor instead')
const UpsertUsersRequest$json = const {
  '1': 'UpsertUsersRequest',
  '2': const [
    const {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.stream.video.coordinator.user_v1.UserInput', '10': 'users'},
  ],
};

/// Descriptor for `UpsertUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertUsersRequestDescriptor = $convert.base64Decode('ChJVcHNlcnRVc2Vyc1JlcXVlc3QSQQoFdXNlcnMYASADKAsyKy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IudXNlcl92MS5Vc2VySW5wdXRSBXVzZXJz');
@$core.Deprecated('Use upsertUsersResponseDescriptor instead')
const UpsertUsersResponse$json = const {
  '1': 'UpsertUsersResponse',
  '2': const [
    const {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.stream.video.coordinator.user_v1.User', '10': 'users'},
  ],
};

/// Descriptor for `UpsertUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertUsersResponseDescriptor = $convert.base64Decode('ChNVcHNlcnRVc2Vyc1Jlc3BvbnNlEjwKBXVzZXJzGAEgAygLMiYuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnVzZXJfdjEuVXNlclIFdXNlcnM=');
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
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'event_type', '3': 2, '4': 1, '5': 14, '6': '.stream.video.coordinator.client_v1_rpc.UserEventType', '10': 'eventType'},
  ],
};

/// Descriptor for `SendEventRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendEventRequestDescriptor = $convert.base64Decode('ChBTZW5kRXZlbnRSZXF1ZXN0EhkKCGNhbGxfY2lkGAEgASgJUgdjYWxsQ2lkElQKCmV2ZW50X3R5cGUYAiABKA4yNS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5Vc2VyRXZlbnRUeXBlUglldmVudFR5cGU=');
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
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'data_json', '3': 3, '4': 1, '5': 12, '10': 'dataJson'},
  ],
};

/// Descriptor for `SendCustomEventRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendCustomEventRequestDescriptor = $convert.base64Decode('ChZTZW5kQ3VzdG9tRXZlbnRSZXF1ZXN0EhkKCGNhbGxfY2lkGAEgASgJUgdjYWxsQ2lkEhIKBHR5cGUYAiABKAlSBHR5cGUSGwoJZGF0YV9qc29uGAMgASgMUghkYXRhSnNvbg==');
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
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'stats_json', '3': 2, '4': 1, '5': 12, '10': 'statsJson'},
  ],
};

/// Descriptor for `ReportCallStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportCallStatsRequestDescriptor = $convert.base64Decode('ChZSZXBvcnRDYWxsU3RhdHNSZXF1ZXN0EhkKCGNhbGxfY2lkGAEgASgJUgdjYWxsQ2lkEh0KCnN0YXRzX2pzb24YAiABKAxSCXN0YXRzSnNvbg==');
@$core.Deprecated('Use reportCallStatsResponseDescriptor instead')
const ReportCallStatsResponse$json = const {
  '1': 'ReportCallStatsResponse',
};

/// Descriptor for `ReportCallStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportCallStatsResponseDescriptor = $convert.base64Decode('ChdSZXBvcnRDYWxsU3RhdHNSZXNwb25zZQ==');
@$core.Deprecated('Use reportCallStatEventRequestDescriptor instead')
const ReportCallStatEventRequest$json = const {
  '1': 'ReportCallStatEventRequest',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'timestamp', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    const {'1': 'participant_connected', '3': 3, '4': 1, '5': 11, '6': '.stream.video.coordinator.stat_v1.ParticipantConnected', '9': 0, '10': 'participantConnected'},
    const {'1': 'participant_disconnected', '3': 4, '4': 1, '5': 11, '6': '.stream.video.coordinator.stat_v1.ParticipantDisconnected', '9': 0, '10': 'participantDisconnected'},
    const {'1': 'media_state_changed', '3': 5, '4': 1, '5': 11, '6': '.stream.video.coordinator.stat_v1.MediaStateChanged', '9': 0, '10': 'mediaStateChanged'},
  ],
  '8': const [
    const {'1': 'event'},
  ],
};

/// Descriptor for `ReportCallStatEventRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportCallStatEventRequestDescriptor = $convert.base64Decode('ChpSZXBvcnRDYWxsU3RhdEV2ZW50UmVxdWVzdBIZCghjYWxsX2NpZBgBIAEoCVIHY2FsbENpZBI4Cgl0aW1lc3RhbXAYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl0aW1lc3RhbXASbQoVcGFydGljaXBhbnRfY29ubmVjdGVkGAMgASgLMjYuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnN0YXRfdjEuUGFydGljaXBhbnRDb25uZWN0ZWRIAFIUcGFydGljaXBhbnRDb25uZWN0ZWQSdgoYcGFydGljaXBhbnRfZGlzY29ubmVjdGVkGAQgASgLMjkuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnN0YXRfdjEuUGFydGljaXBhbnREaXNjb25uZWN0ZWRIAFIXcGFydGljaXBhbnREaXNjb25uZWN0ZWQSZQoTbWVkaWFfc3RhdGVfY2hhbmdlZBgFIAEoCzIzLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5zdGF0X3YxLk1lZGlhU3RhdGVDaGFuZ2VkSABSEW1lZGlhU3RhdGVDaGFuZ2VkQgcKBWV2ZW50');
@$core.Deprecated('Use reportCallStatEventResponseDescriptor instead')
const ReportCallStatEventResponse$json = const {
  '1': 'ReportCallStatEventResponse',
};

/// Descriptor for `ReportCallStatEventResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportCallStatEventResponseDescriptor = $convert.base64Decode('ChtSZXBvcnRDYWxsU3RhdEV2ZW50UmVzcG9uc2U=');
@$core.Deprecated('Use getCallStatsRequestDescriptor instead')
const GetCallStatsRequest$json = const {
  '1': 'GetCallStatsRequest',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `GetCallStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCallStatsRequestDescriptor = $convert.base64Decode('ChNHZXRDYWxsU3RhdHNSZXF1ZXN0EhkKCGNhbGxfY2lkGAEgASgJUgdjYWxsQ2lk');
@$core.Deprecated('Use reportIssueRequestDescriptor instead')
const ReportIssueRequest$json = const {
  '1': 'ReportIssueRequest',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'custom_json', '3': 3, '4': 1, '5': 12, '10': 'customJson'},
  ],
};

/// Descriptor for `ReportIssueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportIssueRequestDescriptor = $convert.base64Decode('ChJSZXBvcnRJc3N1ZVJlcXVlc3QSGQoIY2FsbF9jaWQYASABKAlSB2NhbGxDaWQSIAoLZGVzY3JpcHRpb24YAiABKAlSC2Rlc2NyaXB0aW9uEh8KC2N1c3RvbV9qc29uGAMgASgMUgpjdXN0b21Kc29u');
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
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'stars', '3': 2, '4': 1, '5': 2, '10': 'stars'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'custom_json', '3': 4, '4': 1, '5': 12, '10': 'customJson'},
  ],
};

/// Descriptor for `ReviewCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewCallRequestDescriptor = $convert.base64Decode('ChFSZXZpZXdDYWxsUmVxdWVzdBIZCghjYWxsX2NpZBgBIAEoCVIHY2FsbENpZBIUCgVzdGFycxgCIAEoAlIFc3RhcnMSIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2NyaXB0aW9uEh8KC2N1c3RvbV9qc29uGAQgASgMUgpjdXN0b21Kc29u');
@$core.Deprecated('Use reviewCallResponseDescriptor instead')
const ReviewCallResponse$json = const {
  '1': 'ReviewCallResponse',
};

/// Descriptor for `ReviewCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewCallResponseDescriptor = $convert.base64Decode('ChJSZXZpZXdDYWxsUmVzcG9uc2U=');
@$core.Deprecated('Use startBroadcastRequestDescriptor instead')
const StartBroadcastRequest$json = const {
  '1': 'StartBroadcastRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'hls_broadcast', '3': 3, '4': 1, '5': 8, '10': 'hlsBroadcast'},
    const {'1': 'rtmp', '3': 5, '4': 1, '5': 11, '6': '.stream.video.coordinator.broadcast_v1.RTMPOptions', '10': 'rtmp'},
  ],
};

/// Descriptor for `StartBroadcastRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startBroadcastRequestDescriptor = $convert.base64Decode('ChVTdGFydEJyb2FkY2FzdFJlcXVlc3QSGwoJY2FsbF90eXBlGAEgASgJUghjYWxsVHlwZRIXCgdjYWxsX2lkGAIgASgJUgZjYWxsSWQSIwoNaGxzX2Jyb2FkY2FzdBgDIAEoCFIMaGxzQnJvYWRjYXN0EkYKBHJ0bXAYBSABKAsyMi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuYnJvYWRjYXN0X3YxLlJUTVBPcHRpb25zUgRydG1w');
@$core.Deprecated('Use startBroadcastResponseDescriptor instead')
const StartBroadcastResponse$json = const {
  '1': 'StartBroadcastResponse',
  '2': const [
    const {'1': 'broadcast', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.broadcast_v1.Broadcast', '10': 'broadcast'},
  ],
};

/// Descriptor for `StartBroadcastResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startBroadcastResponseDescriptor = $convert.base64Decode('ChZTdGFydEJyb2FkY2FzdFJlc3BvbnNlEk4KCWJyb2FkY2FzdBgBIAEoCzIwLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5icm9hZGNhc3RfdjEuQnJvYWRjYXN0Uglicm9hZGNhc3Q=');
@$core.Deprecated('Use stopBroadcastRequestDescriptor instead')
const StopBroadcastRequest$json = const {
  '1': 'StopBroadcastRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
  ],
};

/// Descriptor for `StopBroadcastRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopBroadcastRequestDescriptor = $convert.base64Decode('ChRTdG9wQnJvYWRjYXN0UmVxdWVzdBIbCgljYWxsX3R5cGUYASABKAlSCGNhbGxUeXBlEhcKB2NhbGxfaWQYAiABKAlSBmNhbGxJZA==');
@$core.Deprecated('Use stopBroadcastResponseDescriptor instead')
const StopBroadcastResponse$json = const {
  '1': 'StopBroadcastResponse',
};

/// Descriptor for `StopBroadcastResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopBroadcastResponseDescriptor = $convert.base64Decode('ChVTdG9wQnJvYWRjYXN0UmVzcG9uc2U=');
@$core.Deprecated('Use startRecordingRequestDescriptor instead')
const StartRecordingRequest$json = const {
  '1': 'StartRecordingRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
  ],
};

/// Descriptor for `StartRecordingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRecordingRequestDescriptor = $convert.base64Decode('ChVTdGFydFJlY29yZGluZ1JlcXVlc3QSGwoJY2FsbF90eXBlGAEgASgJUghjYWxsVHlwZRIXCgdjYWxsX2lkGAIgASgJUgZjYWxsSWQ=');
@$core.Deprecated('Use startRecordingResponseDescriptor instead')
const StartRecordingResponse$json = const {
  '1': 'StartRecordingResponse',
};

/// Descriptor for `StartRecordingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRecordingResponseDescriptor = $convert.base64Decode('ChZTdGFydFJlY29yZGluZ1Jlc3BvbnNl');
@$core.Deprecated('Use stopRecordingRequestDescriptor instead')
const StopRecordingRequest$json = const {
  '1': 'StopRecordingRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
  ],
};

/// Descriptor for `StopRecordingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopRecordingRequestDescriptor = $convert.base64Decode('ChRTdG9wUmVjb3JkaW5nUmVxdWVzdBIbCgljYWxsX3R5cGUYASABKAlSCGNhbGxUeXBlEhcKB2NhbGxfaWQYAiABKAlSBmNhbGxJZA==');
@$core.Deprecated('Use stopRecordingResponseDescriptor instead')
const StopRecordingResponse$json = const {
  '1': 'StopRecordingResponse',
};

/// Descriptor for `StopRecordingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopRecordingResponseDescriptor = $convert.base64Decode('ChVTdG9wUmVjb3JkaW5nUmVzcG9uc2U=');
const $core.Map<$core.String, $core.dynamic> ClientRPCServiceBase$json = const {
  '1': 'ClientRPC',
  '2': const [
    const {'1': 'CreateCall', '2': '.stream.video.coordinator.client_v1_rpc.CreateCallRequest', '3': '.stream.video.coordinator.client_v1_rpc.CreateCallResponse'},
    const {'1': 'GetOrCreateCall', '2': '.stream.video.coordinator.client_v1_rpc.GetOrCreateCallRequest', '3': '.stream.video.coordinator.client_v1_rpc.GetOrCreateCallResponse'},
    const {'1': 'JoinCall', '2': '.stream.video.coordinator.client_v1_rpc.JoinCallRequest', '3': '.stream.video.coordinator.client_v1_rpc.JoinCallResponse'},
    const {'1': 'GetCallEdgeServer', '2': '.stream.video.coordinator.client_v1_rpc.GetCallEdgeServerRequest', '3': '.stream.video.coordinator.client_v1_rpc.GetCallEdgeServerResponse'},
    const {'1': 'UpdateCall', '2': '.stream.video.coordinator.client_v1_rpc.UpdateCallRequest', '3': '.stream.video.coordinator.client_v1_rpc.UpdateCallResponse'},
    const {'1': 'UpdateCallPermissions', '2': '.stream.video.coordinator.client_v1_rpc.UpdateCallPermissionsRequest', '3': '.stream.video.coordinator.client_v1_rpc.UpdateCallPermissionsResponse'},
    const {'1': 'EndCall', '2': '.stream.video.coordinator.client_v1_rpc.EndCallRequest', '3': '.stream.video.coordinator.client_v1_rpc.EndCallResponse'},
    const {'1': 'QueryCalls', '2': '.stream.video.coordinator.client_v1_rpc.QueryCallsRequest', '3': '.stream.video.coordinator.client_v1_rpc.QueryCallsResponse'},
    const {'1': 'QueryMembers', '2': '.stream.video.coordinator.client_v1_rpc.QueryMembersRequest', '3': '.stream.video.coordinator.client_v1_rpc.QueryMembersResponse'},
    const {'1': 'CreateDevice', '2': '.stream.video.coordinator.client_v1_rpc.CreateDeviceRequest', '3': '.stream.video.coordinator.client_v1_rpc.CreateDeviceResponse'},
    const {'1': 'DeleteDevice', '2': '.stream.video.coordinator.client_v1_rpc.DeleteDeviceRequest', '3': '.stream.video.coordinator.client_v1_rpc.DeleteDeviceResponse'},
    const {'1': 'QueryDevices', '2': '.stream.video.coordinator.client_v1_rpc.QueryDevicesRequest', '3': '.stream.video.coordinator.client_v1_rpc.QueryDevicesResponse'},
    const {'1': 'StartBroadcast', '2': '.stream.video.coordinator.client_v1_rpc.StartBroadcastRequest', '3': '.stream.video.coordinator.client_v1_rpc.StartBroadcastResponse'},
    const {'1': 'StopBroadcast', '2': '.stream.video.coordinator.client_v1_rpc.StopBroadcastRequest', '3': '.stream.video.coordinator.client_v1_rpc.StopBroadcastResponse'},
    const {'1': 'StartRecording', '2': '.stream.video.coordinator.client_v1_rpc.StartRecordingRequest', '3': '.stream.video.coordinator.client_v1_rpc.StartRecordingResponse'},
    const {'1': 'StopRecording', '2': '.stream.video.coordinator.client_v1_rpc.StopRecordingRequest', '3': '.stream.video.coordinator.client_v1_rpc.StopRecordingResponse'},
    const {'1': 'UpsertCallMembers', '2': '.stream.video.coordinator.client_v1_rpc.UpsertCallMembersRequest', '3': '.stream.video.coordinator.client_v1_rpc.UpsertCallMembersResponse'},
    const {'1': 'DeleteCallMembers', '2': '.stream.video.coordinator.client_v1_rpc.DeleteCallMembersRequest', '3': '.stream.video.coordinator.client_v1_rpc.DeleteCallMembersResponse'},
    const {'1': 'SendEvent', '2': '.stream.video.coordinator.client_v1_rpc.SendEventRequest', '3': '.stream.video.coordinator.client_v1_rpc.SendEventResponse'},
    const {'1': 'SendCustomEvent', '2': '.stream.video.coordinator.client_v1_rpc.SendCustomEventRequest', '3': '.stream.video.coordinator.client_v1_rpc.SendCustomEventResponse'},
    const {'1': 'QueryUsers', '2': '.stream.video.coordinator.client_v1_rpc.QueryUsersRequest', '3': '.stream.video.coordinator.client_v1_rpc.QueryUsersResponse'},
    const {'1': 'UpsertUsers', '2': '.stream.video.coordinator.client_v1_rpc.UpsertUsersRequest', '3': '.stream.video.coordinator.client_v1_rpc.UpsertUsersResponse'},
    const {'1': 'ReportCallStats', '2': '.stream.video.coordinator.client_v1_rpc.ReportCallStatsRequest', '3': '.stream.video.coordinator.client_v1_rpc.ReportCallStatsResponse'},
    const {'1': 'ReportCallStatEvent', '2': '.stream.video.coordinator.client_v1_rpc.ReportCallStatEventRequest', '3': '.stream.video.coordinator.client_v1_rpc.ReportCallStatEventResponse'},
    const {'1': 'ReviewCall', '2': '.stream.video.coordinator.client_v1_rpc.ReviewCallRequest', '3': '.stream.video.coordinator.client_v1_rpc.ReviewCallResponse'},
    const {'1': 'ReportIssue', '2': '.stream.video.coordinator.client_v1_rpc.ReportIssueRequest', '3': '.stream.video.coordinator.client_v1_rpc.ReportIssueResponse'},
  ],
};

@$core.Deprecated('Use clientRPCServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> ClientRPCServiceBase$messageJson = const {
  '.stream.video.coordinator.client_v1_rpc.CreateCallRequest': CreateCallRequest$json,
  '.stream.video.coordinator.client_v1_rpc.CreateCallInput': CreateCallInput$json,
  '.stream.video.coordinator.client_v1_rpc.CallInput': CallInput$json,
  '.stream.video.coordinator.call_v1.CallSettings': $0.CallSettings$json,
  '.stream.video.coordinator.call_v1.RecordingOptions': $0.RecordingOptions$json,
  '.stream.video.coordinator.call_v1.BroadcastingOptions': $0.BroadcastingOptions$json,
  '.stream.video.coordinator.client_v1_rpc.MemberInput': MemberInput$json,
  '.stream.video.coordinator.user_v1.UserInput': $1.UserInput$json,
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
  '.stream.video.coordinator.client_v1_rpc.UpdateCallPermissionsRequest': UpdateCallPermissionsRequest$json,
  '.stream.video.coordinator.client_v1_rpc.RoleOverride': RoleOverride$json,
  '.stream.video.coordinator.client_v1_rpc.PermissionGrantOverride': PermissionGrantOverride$json,
  '.stream.video.coordinator.client_v1_rpc.UpdateCallPermissionsResponse': UpdateCallPermissionsResponse$json,
  '.stream.video.coordinator.client_v1_rpc.EndCallRequest': EndCallRequest$json,
  '.stream.video.coordinator.client_v1_rpc.EndCallResponse': EndCallResponse$json,
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
  '.stream.video.coordinator.client_v1_rpc.StartBroadcastRequest': StartBroadcastRequest$json,
  '.stream.video.coordinator.broadcast_v1.RTMPOptions': $9.RTMPOptions$json,
  '.stream.video.coordinator.client_v1_rpc.StartBroadcastResponse': StartBroadcastResponse$json,
  '.stream.video.coordinator.broadcast_v1.Broadcast': $9.Broadcast$json,
  '.stream.video.coordinator.client_v1_rpc.StopBroadcastRequest': StopBroadcastRequest$json,
  '.stream.video.coordinator.client_v1_rpc.StopBroadcastResponse': StopBroadcastResponse$json,
  '.stream.video.coordinator.client_v1_rpc.StartRecordingRequest': StartRecordingRequest$json,
  '.stream.video.coordinator.client_v1_rpc.StartRecordingResponse': StartRecordingResponse$json,
  '.stream.video.coordinator.client_v1_rpc.StopRecordingRequest': StopRecordingRequest$json,
  '.stream.video.coordinator.client_v1_rpc.StopRecordingResponse': StopRecordingResponse$json,
  '.stream.video.coordinator.client_v1_rpc.UpsertCallMembersRequest': UpsertCallMembersRequest$json,
  '.stream.video.coordinator.client_v1_rpc.UpsertCallMembersResponse': UpsertCallMembersResponse$json,
  '.stream.video.coordinator.client_v1_rpc.DeleteCallMembersRequest': DeleteCallMembersRequest$json,
  '.stream.video.coordinator.client_v1_rpc.DeleteCallMembersResponse': DeleteCallMembersResponse$json,
  '.stream.video.coordinator.client_v1_rpc.SendEventRequest': SendEventRequest$json,
  '.stream.video.coordinator.client_v1_rpc.SendEventResponse': SendEventResponse$json,
  '.stream.video.coordinator.client_v1_rpc.SendCustomEventRequest': SendCustomEventRequest$json,
  '.stream.video.coordinator.client_v1_rpc.SendCustomEventResponse': SendCustomEventResponse$json,
  '.stream.video.coordinator.client_v1_rpc.QueryUsersRequest': QueryUsersRequest$json,
  '.stream.video.coordinator.client_v1_rpc.QueryUsersResponse': QueryUsersResponse$json,
  '.stream.video.coordinator.client_v1_rpc.UpsertUsersRequest': UpsertUsersRequest$json,
  '.stream.video.coordinator.client_v1_rpc.UpsertUsersResponse': UpsertUsersResponse$json,
  '.stream.video.coordinator.client_v1_rpc.ReportCallStatsRequest': ReportCallStatsRequest$json,
  '.stream.video.coordinator.client_v1_rpc.ReportCallStatsResponse': ReportCallStatsResponse$json,
  '.stream.video.coordinator.client_v1_rpc.ReportCallStatEventRequest': ReportCallStatEventRequest$json,
  '.stream.video.coordinator.stat_v1.ParticipantConnected': $8.ParticipantConnected$json,
  '.stream.video.coordinator.stat_v1.ParticipantDisconnected': $8.ParticipantDisconnected$json,
  '.stream.video.coordinator.stat_v1.MediaStateChanged': $8.MediaStateChanged$json,
  '.stream.video.coordinator.client_v1_rpc.ReportCallStatEventResponse': ReportCallStatEventResponse$json,
  '.stream.video.coordinator.client_v1_rpc.ReviewCallRequest': ReviewCallRequest$json,
  '.stream.video.coordinator.client_v1_rpc.ReviewCallResponse': ReviewCallResponse$json,
  '.stream.video.coordinator.client_v1_rpc.ReportIssueRequest': ReportIssueRequest$json,
  '.stream.video.coordinator.client_v1_rpc.ReportIssueResponse': ReportIssueResponse$json,
};

/// Descriptor for `ClientRPC`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List clientRPCServiceDescriptor = $convert.base64Decode('CglDbGllbnRSUEMSgwEKCkNyZWF0ZUNhbGwSOS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5DcmVhdGVDYWxsUmVxdWVzdBo6LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLkNyZWF0ZUNhbGxSZXNwb25zZRKSAQoPR2V0T3JDcmVhdGVDYWxsEj4uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuR2V0T3JDcmVhdGVDYWxsUmVxdWVzdBo/LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLkdldE9yQ3JlYXRlQ2FsbFJlc3BvbnNlEn0KCEpvaW5DYWxsEjcuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuSm9pbkNhbGxSZXF1ZXN0Gjguc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuSm9pbkNhbGxSZXNwb25zZRKYAQoRR2V0Q2FsbEVkZ2VTZXJ2ZXISQC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5HZXRDYWxsRWRnZVNlcnZlclJlcXVlc3QaQS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5HZXRDYWxsRWRnZVNlcnZlclJlc3BvbnNlEoMBCgpVcGRhdGVDYWxsEjkuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuVXBkYXRlQ2FsbFJlcXVlc3QaOi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5VcGRhdGVDYWxsUmVzcG9uc2USpAEKFVVwZGF0ZUNhbGxQZXJtaXNzaW9ucxJELnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlVwZGF0ZUNhbGxQZXJtaXNzaW9uc1JlcXVlc3QaRS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5VcGRhdGVDYWxsUGVybWlzc2lvbnNSZXNwb25zZRJ6CgdFbmRDYWxsEjYuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuRW5kQ2FsbFJlcXVlc3QaNy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5FbmRDYWxsUmVzcG9uc2USgwEKClF1ZXJ5Q2FsbHMSOS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5RdWVyeUNhbGxzUmVxdWVzdBo6LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlF1ZXJ5Q2FsbHNSZXNwb25zZRKJAQoMUXVlcnlNZW1iZXJzEjsuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuUXVlcnlNZW1iZXJzUmVxdWVzdBo8LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlF1ZXJ5TWVtYmVyc1Jlc3BvbnNlEokBCgxDcmVhdGVEZXZpY2USOy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5DcmVhdGVEZXZpY2VSZXF1ZXN0Gjwuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuQ3JlYXRlRGV2aWNlUmVzcG9uc2USiQEKDERlbGV0ZURldmljZRI7LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLkRlbGV0ZURldmljZVJlcXVlc3QaPC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5EZWxldGVEZXZpY2VSZXNwb25zZRKJAQoMUXVlcnlEZXZpY2VzEjsuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuUXVlcnlEZXZpY2VzUmVxdWVzdBo8LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlF1ZXJ5RGV2aWNlc1Jlc3BvbnNlEo8BCg5TdGFydEJyb2FkY2FzdBI9LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlN0YXJ0QnJvYWRjYXN0UmVxdWVzdBo+LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlN0YXJ0QnJvYWRjYXN0UmVzcG9uc2USjAEKDVN0b3BCcm9hZGNhc3QSPC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5TdG9wQnJvYWRjYXN0UmVxdWVzdBo9LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlN0b3BCcm9hZGNhc3RSZXNwb25zZRKPAQoOU3RhcnRSZWNvcmRpbmcSPS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5TdGFydFJlY29yZGluZ1JlcXVlc3QaPi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5TdGFydFJlY29yZGluZ1Jlc3BvbnNlEowBCg1TdG9wUmVjb3JkaW5nEjwuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuU3RvcFJlY29yZGluZ1JlcXVlc3QaPS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5TdG9wUmVjb3JkaW5nUmVzcG9uc2USmAEKEVVwc2VydENhbGxNZW1iZXJzEkAuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuVXBzZXJ0Q2FsbE1lbWJlcnNSZXF1ZXN0GkEuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuVXBzZXJ0Q2FsbE1lbWJlcnNSZXNwb25zZRKYAQoRRGVsZXRlQ2FsbE1lbWJlcnMSQC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5EZWxldGVDYWxsTWVtYmVyc1JlcXVlc3QaQS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5EZWxldGVDYWxsTWVtYmVyc1Jlc3BvbnNlEoABCglTZW5kRXZlbnQSOC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5TZW5kRXZlbnRSZXF1ZXN0Gjkuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuU2VuZEV2ZW50UmVzcG9uc2USkgEKD1NlbmRDdXN0b21FdmVudBI+LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlNlbmRDdXN0b21FdmVudFJlcXVlc3QaPy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5TZW5kQ3VzdG9tRXZlbnRSZXNwb25zZRKDAQoKUXVlcnlVc2VycxI5LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlF1ZXJ5VXNlcnNSZXF1ZXN0Gjouc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuUXVlcnlVc2Vyc1Jlc3BvbnNlEoYBCgtVcHNlcnRVc2VycxI6LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlVwc2VydFVzZXJzUmVxdWVzdBo7LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlVwc2VydFVzZXJzUmVzcG9uc2USkgEKD1JlcG9ydENhbGxTdGF0cxI+LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlJlcG9ydENhbGxTdGF0c1JlcXVlc3QaPy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5SZXBvcnRDYWxsU3RhdHNSZXNwb25zZRKeAQoTUmVwb3J0Q2FsbFN0YXRFdmVudBJCLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLlJlcG9ydENhbGxTdGF0RXZlbnRSZXF1ZXN0GkMuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuUmVwb3J0Q2FsbFN0YXRFdmVudFJlc3BvbnNlEoMBCgpSZXZpZXdDYWxsEjkuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuUmV2aWV3Q2FsbFJlcXVlc3QaOi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xpZW50X3YxX3JwYy5SZXZpZXdDYWxsUmVzcG9uc2UShgEKC1JlcG9ydElzc3VlEjouc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuUmVwb3J0SXNzdWVSZXF1ZXN0Gjsuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuUmVwb3J0SXNzdWVSZXNwb25zZQ==');
