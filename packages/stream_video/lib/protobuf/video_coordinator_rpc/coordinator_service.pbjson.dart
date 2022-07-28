///
//  Generated code. Do not modify.
//  source: video_coordinator_rpc/coordinator_service.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
import '../google/protobuf/struct.pbjson.dart' as $2;
import '../google/protobuf/wrappers.pbjson.dart' as $4;
import '../video_models/models.pbjson.dart' as $3;

@$core.Deprecated('Use callStatEventTypeDescriptor instead')
const CallStatEventType$json = const {
  '1': 'CallStatEventType',
  '2': const [
    const {'1': 'AUDIO_FROZEN', '2': 0},
    const {'1': 'AUDIO_DELAY', '2': 1},
    const {'1': 'VIDEO_FROZEN', '2': 2},
    const {'1': 'VIDEO_DELAY', '2': 3},
    const {'1': 'VIDEO_NOT_OPTIMAL', '2': 4},
  ],
};

/// Descriptor for `CallStatEventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List callStatEventTypeDescriptor = $convert.base64Decode('ChFDYWxsU3RhdEV2ZW50VHlwZRIQCgxBVURJT19GUk9aRU4QABIPCgtBVURJT19ERUxBWRABEhAKDFZJREVPX0ZST1pFThACEg8KC1ZJREVPX0RFTEFZEAMSFQoRVklERU9fTk9UX09QVElNQUwQBA==');
@$core.Deprecated('Use userEventTypeDescriptor instead')
const UserEventType$json = const {
  '1': 'UserEventType',
  '2': const [
    const {'1': 'USER_EVENT_TYPE_AUDIO_MUTED_UNSPECIFIED', '2': 0},
    const {'1': 'USER_EVENT_TYPE_AUDIO_UNMUTED', '2': 1},
    const {'1': 'USER_EVENT_TYPE_VIDEO_STARTED', '2': 2},
    const {'1': 'USER_EVENT_TYPE_VIDEO_STOPPED', '2': 3},
  ],
};

/// Descriptor for `UserEventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userEventTypeDescriptor = $convert.base64Decode('Cg1Vc2VyRXZlbnRUeXBlEisKJ1VTRVJfRVZFTlRfVFlQRV9BVURJT19NVVRFRF9VTlNQRUNJRklFRBAAEiEKHVVTRVJfRVZFTlRfVFlQRV9BVURJT19VTk1VVEVEEAESIQodVVNFUl9FVkVOVF9UWVBFX1ZJREVPX1NUQVJURUQQAhIhCh1VU0VSX0VWRU5UX1RZUEVfVklERU9fU1RPUFBFRBAD');
@$core.Deprecated('Use getCallRequestDescriptor instead')
const GetCallRequest$json = const {
  '1': 'GetCallRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
  ],
};

/// Descriptor for `GetCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCallRequestDescriptor = $convert.base64Decode('Cg5HZXRDYWxsUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSEgoEdHlwZRgCIAEoCVIEdHlwZQ==');
@$core.Deprecated('Use getCallResponseDescriptor instead')
const GetCallResponse$json = const {
  '1': 'GetCallResponse',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'call_state', '3': 2, '4': 1, '5': 11, '6': '.stream.video.CallState', '10': 'callState'},
  ],
};

/// Descriptor for `GetCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCallResponseDescriptor = $convert.base64Decode('Cg9HZXRDYWxsUmVzcG9uc2USJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxsEjYKCmNhbGxfc3RhdGUYAiABKAsyFy5zdHJlYW0udmlkZW8uQ2FsbFN0YXRlUgljYWxsU3RhdGU=');
@$core.Deprecated('Use createOrUpdateCallsRequestDescriptor instead')
const CreateOrUpdateCallsRequest$json = const {
  '1': 'CreateOrUpdateCallsRequest',
  '2': const [
    const {'1': 'calls', '3': 1, '4': 3, '5': 11, '6': '.stream.video.CreateCallRequest', '10': 'calls'},
  ],
};

/// Descriptor for `CreateOrUpdateCallsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createOrUpdateCallsRequestDescriptor = $convert.base64Decode('ChpDcmVhdGVPclVwZGF0ZUNhbGxzUmVxdWVzdBI1CgVjYWxscxgBIAMoCzIfLnN0cmVhbS52aWRlby5DcmVhdGVDYWxsUmVxdWVzdFIFY2FsbHM=');
@$core.Deprecated('Use createOrUpdateCallsResponseDescriptor instead')
const CreateOrUpdateCallsResponse$json = const {
  '1': 'CreateOrUpdateCallsResponse',
  '2': const [
    const {'1': 'calls', '3': 1, '4': 3, '5': 11, '6': '.stream.video.Call', '10': 'calls'},
  ],
};

/// Descriptor for `CreateOrUpdateCallsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createOrUpdateCallsResponseDescriptor = $convert.base64Decode('ChtDcmVhdGVPclVwZGF0ZUNhbGxzUmVzcG9uc2USKAoFY2FsbHMYASADKAsyEi5zdHJlYW0udmlkZW8uQ2FsbFIFY2FsbHM=');
@$core.Deprecated('Use createCallRequestDescriptor instead')
const CreateCallRequest$json = const {
  '1': 'CreateCallRequest',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'custom', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
    const {'1': 'participant_ids', '3': 4, '4': 3, '5': 9, '10': 'participantIds'},
    const {'1': 'hls_broadcast', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.BoolValue', '10': 'hlsBroadcast'},
    const {'1': 'rtmp', '3': 7, '4': 1, '5': 11, '6': '.stream.video.RTMPOptions', '10': 'rtmp'},
    const {'1': 'transcribe', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.BoolValue', '10': 'transcribe'},
    const {'1': 'transcribe_options', '3': 9, '4': 1, '5': 11, '6': '.stream.video.TranscribeOptions', '10': 'transcribeOptions'},
    const {'1': 'recording', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.BoolValue', '10': 'recording'},
    const {'1': 'notify', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.BoolValue', '10': 'notify'},
  ],
};

/// Descriptor for `CreateCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCallRequestDescriptor = $convert.base64Decode('ChFDcmVhdGVDYWxsUmVxdWVzdBISCgR0eXBlGAEgASgJUgR0eXBlEg4KAmlkGAIgASgJUgJpZBIvCgZjdXN0b20YAyABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0UgZjdXN0b20SJwoPcGFydGljaXBhbnRfaWRzGAQgAygJUg5wYXJ0aWNpcGFudElkcxI/Cg1obHNfYnJvYWRjYXN0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLkJvb2xWYWx1ZVIMaGxzQnJvYWRjYXN0Ei0KBHJ0bXAYByABKAsyGS5zdHJlYW0udmlkZW8uUlRNUE9wdGlvbnNSBHJ0bXASOgoKdHJhbnNjcmliZRgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5Cb29sVmFsdWVSCnRyYW5zY3JpYmUSTgoSdHJhbnNjcmliZV9vcHRpb25zGAkgASgLMh8uc3RyZWFtLnZpZGVvLlRyYW5zY3JpYmVPcHRpb25zUhF0cmFuc2NyaWJlT3B0aW9ucxI4CglyZWNvcmRpbmcYCiABKAsyGi5nb29nbGUucHJvdG9idWYuQm9vbFZhbHVlUglyZWNvcmRpbmcSMgoGbm90aWZ5GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLkJvb2xWYWx1ZVIGbm90aWZ5');
@$core.Deprecated('Use createCallResponseDescriptor instead')
const CreateCallResponse$json = const {
  '1': 'CreateCallResponse',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '8': const {}, '10': 'call'},
  ],
};

/// Descriptor for `CreateCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCallResponseDescriptor = $convert.base64Decode('ChJDcmVhdGVDYWxsUmVzcG9uc2USMAoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsQgj6QgWKAQIQAVIEY2FsbA==');
@$core.Deprecated('Use updateCallRequestDescriptor instead')
const UpdateCallRequest$json = const {
  '1': 'UpdateCallRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'json_encoded_custom_data', '3': 3, '4': 1, '5': 12, '10': 'jsonEncodedCustomData'},
  ],
};

/// Descriptor for `UpdateCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCallRequestDescriptor = $convert.base64Decode('ChFVcGRhdGVDYWxsUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSEgoEdHlwZRgCIAEoCVIEdHlwZRI3Chhqc29uX2VuY29kZWRfY3VzdG9tX2RhdGEYAyABKAxSFWpzb25FbmNvZGVkQ3VzdG9tRGF0YQ==');
@$core.Deprecated('Use updateCallResponseDescriptor instead')
const UpdateCallResponse$json = const {
  '1': 'UpdateCallResponse',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `UpdateCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCallResponseDescriptor = $convert.base64Decode('ChJVcGRhdGVDYWxsUmVzcG9uc2USJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxs');
@$core.Deprecated('Use deleteCallRequestDescriptor instead')
const DeleteCallRequest$json = const {
  '1': 'DeleteCallRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteCallRequestDescriptor = $convert.base64Decode('ChFEZWxldGVDYWxsUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');
@$core.Deprecated('Use deleteCallResponseDescriptor instead')
const DeleteCallResponse$json = const {
  '1': 'DeleteCallResponse',
};

/// Descriptor for `DeleteCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteCallResponseDescriptor = $convert.base64Decode('ChJEZWxldGVDYWxsUmVzcG9uc2U=');
@$core.Deprecated('Use selectEdgeServerRequestDescriptor instead')
const SelectEdgeServerRequest$json = const {
  '1': 'SelectEdgeServerRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'latency_by_edge', '3': 3, '4': 3, '5': 11, '6': '.stream.video.SelectEdgeServerRequest.LatencyByEdgeEntry', '10': 'latencyByEdge'},
  ],
  '3': const [SelectEdgeServerRequest_LatencyByEdgeEntry$json],
};

@$core.Deprecated('Use selectEdgeServerRequestDescriptor instead')
const SelectEdgeServerRequest_LatencyByEdgeEntry$json = const {
  '1': 'LatencyByEdgeEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.stream.video.Latency', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `SelectEdgeServerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectEdgeServerRequestDescriptor = $convert.base64Decode('ChdTZWxlY3RFZGdlU2VydmVyUmVxdWVzdBIbCgljYWxsX3R5cGUYASABKAlSCGNhbGxUeXBlEhcKB2NhbGxfaWQYAiABKAlSBmNhbGxJZBJgCg9sYXRlbmN5X2J5X2VkZ2UYAyADKAsyOC5zdHJlYW0udmlkZW8uU2VsZWN0RWRnZVNlcnZlclJlcXVlc3QuTGF0ZW5jeUJ5RWRnZUVudHJ5Ug1sYXRlbmN5QnlFZGdlGlcKEkxhdGVuY3lCeUVkZ2VFbnRyeRIQCgNrZXkYASABKAlSA2tleRIrCgV2YWx1ZRgCIAEoCzIVLnN0cmVhbS52aWRlby5MYXRlbmN5UgV2YWx1ZToCOAE=');
@$core.Deprecated('Use selectEdgeServerResponseDescriptor instead')
const SelectEdgeServerResponse$json = const {
  '1': 'SelectEdgeServerResponse',
  '2': const [
    const {'1': 'edge_server', '3': 1, '4': 1, '5': 11, '6': '.stream.video.EdgeServer', '8': const {}, '10': 'edgeServer'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'token'},
  ],
};

/// Descriptor for `SelectEdgeServerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectEdgeServerResponseDescriptor = $convert.base64Decode('ChhTZWxlY3RFZGdlU2VydmVyUmVzcG9uc2USQwoLZWRnZV9zZXJ2ZXIYASABKAsyGC5zdHJlYW0udmlkZW8uRWRnZVNlcnZlckII+kIFigECEAFSCmVkZ2VTZXJ2ZXISHQoFdG9rZW4YAiABKAlCB/pCBHICEAFSBXRva2Vu');
@$core.Deprecated('Use addDeviceRequestDescriptor instead')
const AddDeviceRequest$json = const {
  '1': 'AddDeviceRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'push_provider_name', '3': 2, '4': 1, '5': 9, '10': 'pushProviderName'},
    const {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `AddDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addDeviceRequestDescriptor = $convert.base64Decode('ChBBZGREZXZpY2VSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBIsChJwdXNoX3Byb3ZpZGVyX25hbWUYAiABKAlSEHB1c2hQcm92aWRlck5hbWUSFwoHdXNlcl9pZBgDIAEoCVIGdXNlcklk');
@$core.Deprecated('Use addDeviceResponseDescriptor instead')
const AddDeviceResponse$json = const {
  '1': 'AddDeviceResponse',
  '2': const [
    const {'1': 'device', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Device', '10': 'device'},
  ],
};

/// Descriptor for `AddDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addDeviceResponseDescriptor = $convert.base64Decode('ChFBZGREZXZpY2VSZXNwb25zZRIsCgZkZXZpY2UYASABKAsyFC5zdHJlYW0udmlkZW8uRGV2aWNlUgZkZXZpY2U=');
@$core.Deprecated('Use removeDeviceRequestDescriptor instead')
const RemoveDeviceRequest$json = const {
  '1': 'RemoveDeviceRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `RemoveDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeDeviceRequestDescriptor = $convert.base64Decode('ChNSZW1vdmVEZXZpY2VSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBIXCgd1c2VyX2lkGAIgASgJUgZ1c2VySWQ=');
@$core.Deprecated('Use removeDeviceResponseDescriptor instead')
const RemoveDeviceResponse$json = const {
  '1': 'RemoveDeviceResponse',
};

/// Descriptor for `RemoveDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeDeviceResponseDescriptor = $convert.base64Decode('ChRSZW1vdmVEZXZpY2VSZXNwb25zZQ==');
@$core.Deprecated('Use listDevicesRequestDescriptor instead')
const ListDevicesRequest$json = const {
  '1': 'ListDevicesRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `ListDevicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDevicesRequestDescriptor = $convert.base64Decode('ChJMaXN0RGV2aWNlc1JlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklk');
@$core.Deprecated('Use listDevicesResponseDescriptor instead')
const ListDevicesResponse$json = const {
  '1': 'ListDevicesResponse',
  '2': const [
    const {'1': 'devices', '3': 1, '4': 3, '5': 11, '6': '.stream.video.Device', '10': 'devices'},
  ],
};

/// Descriptor for `ListDevicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDevicesResponseDescriptor = $convert.base64Decode('ChNMaXN0RGV2aWNlc1Jlc3BvbnNlEi4KB2RldmljZXMYASADKAsyFC5zdHJlYW0udmlkZW8uRGV2aWNlUgdkZXZpY2Vz');
@$core.Deprecated('Use createUserRequestDescriptor instead')
const CreateUserRequest$json = const {
  '1': 'CreateUserRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'teams', '3': 2, '4': 3, '5': 9, '10': 'teams'},
    const {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'custom', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
    const {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'image_url', '3': 6, '4': 1, '5': 9, '10': 'imageUrl'},
  ],
};

/// Descriptor for `CreateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createUserRequestDescriptor = $convert.base64Decode('ChFDcmVhdGVVc2VyUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSFAoFdGVhbXMYAiADKAlSBXRlYW1zEhIKBHJvbGUYAyABKAlSBHJvbGUSLwoGY3VzdG9tGAQgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIGY3VzdG9tEhIKBG5hbWUYBSABKAlSBG5hbWUSGwoJaW1hZ2VfdXJsGAYgASgJUghpbWFnZVVybA==');
@$core.Deprecated('Use createOrUpdateUsersRequestDescriptor instead')
const CreateOrUpdateUsersRequest$json = const {
  '1': 'CreateOrUpdateUsersRequest',
  '2': const [
    const {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.stream.video.CreateUserRequest', '10': 'users'},
    const {'1': 'full_update', '3': 2, '4': 1, '5': 8, '10': 'fullUpdate'},
  ],
};

/// Descriptor for `CreateOrUpdateUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createOrUpdateUsersRequestDescriptor = $convert.base64Decode('ChpDcmVhdGVPclVwZGF0ZVVzZXJzUmVxdWVzdBI1CgV1c2VycxgBIAMoCzIfLnN0cmVhbS52aWRlby5DcmVhdGVVc2VyUmVxdWVzdFIFdXNlcnMSHwoLZnVsbF91cGRhdGUYAiABKAhSCmZ1bGxVcGRhdGU=');
@$core.Deprecated('Use createOrUpdateUsersResponseDescriptor instead')
const CreateOrUpdateUsersResponse$json = const {
  '1': 'CreateOrUpdateUsersResponse',
  '2': const [
    const {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.stream.video.User', '10': 'users'},
  ],
};

/// Descriptor for `CreateOrUpdateUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createOrUpdateUsersResponseDescriptor = $convert.base64Decode('ChtDcmVhdGVPclVwZGF0ZVVzZXJzUmVzcG9uc2USKAoFdXNlcnMYASADKAsyEi5zdHJlYW0udmlkZW8uVXNlclIFdXNlcnM=');
@$core.Deprecated('Use deleteUserRequestDescriptor instead')
const DeleteUserRequest$json = const {
  '1': 'DeleteUserRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteUserRequestDescriptor = $convert.base64Decode('ChFEZWxldGVVc2VyUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');
@$core.Deprecated('Use exportUserRequestDescriptor instead')
const ExportUserRequest$json = const {
  '1': 'ExportUserRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `ExportUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportUserRequestDescriptor = $convert.base64Decode('ChFFeHBvcnRVc2VyUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');
@$core.Deprecated('Use exportUserResponseDescriptor instead')
const ExportUserResponse$json = const {
  '1': 'ExportUserResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `ExportUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportUserResponseDescriptor = $convert.base64Decode('ChJFeHBvcnRVc2VyUmVzcG9uc2USDgoCaWQYASABKAlSAmlk');
@$core.Deprecated('Use deleteUserResponseDescriptor instead')
const DeleteUserResponse$json = const {
  '1': 'DeleteUserResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteUserResponseDescriptor = $convert.base64Decode('ChJEZWxldGVVc2VyUmVzcG9uc2USDgoCaWQYASABKAlSAmlk');
@$core.Deprecated('Use createUserResponseDescriptor instead')
const CreateUserResponse$json = const {
  '1': 'CreateUserResponse',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.stream.video.User', '10': 'user'},
  ],
};

/// Descriptor for `CreateUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createUserResponseDescriptor = $convert.base64Decode('ChJDcmVhdGVVc2VyUmVzcG9uc2USJgoEdXNlchgBIAEoCzISLnN0cmVhbS52aWRlby5Vc2VyUgR1c2Vy');
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
@$core.Deprecated('Use joinCallRequestDescriptor instead')
const JoinCallRequest$json = const {
  '1': 'JoinCallRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
  ],
};

/// Descriptor for `JoinCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinCallRequestDescriptor = $convert.base64Decode('Cg9Kb2luQ2FsbFJlcXVlc3QSDgoCaWQYASABKAlSAmlkEhIKBHR5cGUYAiABKAlSBHR5cGU=');
@$core.Deprecated('Use userCapabilityDescriptor instead')
const UserCapability$json = const {
  '1': 'UserCapability',
  '2': const [
    const {'1': 'action', '3': 1, '4': 1, '5': 9, '10': 'action'},
    const {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `UserCapability`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userCapabilityDescriptor = $convert.base64Decode('Cg5Vc2VyQ2FwYWJpbGl0eRIWCgZhY3Rpb24YASABKAlSBmFjdGlvbhIgCgtkZXNjcmlwdGlvbhgCIAEoCVILZGVzY3JpcHRpb24=');
@$core.Deprecated('Use joinCallResponseDescriptor instead')
const JoinCallResponse$json = const {
  '1': 'JoinCallResponse',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.stream.video.User', '10': 'user'},
    const {'1': 'call', '3': 2, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'call_state', '3': 3, '4': 1, '5': 11, '6': '.stream.video.CallState', '10': 'callState'},
    const {'1': 'edges', '3': 4, '4': 3, '5': 11, '6': '.stream.video.Edge', '10': 'edges'},
    const {'1': 'own_capabilities', '3': 5, '4': 3, '5': 11, '6': '.stream.video.UserCapability', '10': 'ownCapabilities'},
  ],
};

/// Descriptor for `JoinCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinCallResponseDescriptor = $convert.base64Decode('ChBKb2luQ2FsbFJlc3BvbnNlEiYKBHVzZXIYASABKAsyEi5zdHJlYW0udmlkZW8uVXNlclIEdXNlchImCgRjYWxsGAIgASgLMhIuc3RyZWFtLnZpZGVvLkNhbGxSBGNhbGwSNgoKY2FsbF9zdGF0ZRgDIAEoCzIXLnN0cmVhbS52aWRlby5DYWxsU3RhdGVSCWNhbGxTdGF0ZRIoCgVlZGdlcxgEIAMoCzISLnN0cmVhbS52aWRlby5FZGdlUgVlZGdlcxJHChBvd25fY2FwYWJpbGl0aWVzGAUgAygLMhwuc3RyZWFtLnZpZGVvLlVzZXJDYXBhYmlsaXR5Ug9vd25DYXBhYmlsaXRpZXM=');
@$core.Deprecated('Use leaveCallRequestDescriptor instead')
const LeaveCallRequest$json = const {
  '1': 'LeaveCallRequest',
};

/// Descriptor for `LeaveCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveCallRequestDescriptor = $convert.base64Decode('ChBMZWF2ZUNhbGxSZXF1ZXN0');
@$core.Deprecated('Use leaveCallResponseDescriptor instead')
const LeaveCallResponse$json = const {
  '1': 'LeaveCallResponse',
};

/// Descriptor for `LeaveCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveCallResponseDescriptor = $convert.base64Decode('ChFMZWF2ZUNhbGxSZXNwb25zZQ==');
@$core.Deprecated('Use endCallRequestDescriptor instead')
const EndCallRequest$json = const {
  '1': 'EndCallRequest',
};

/// Descriptor for `EndCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endCallRequestDescriptor = $convert.base64Decode('Cg5FbmRDYWxsUmVxdWVzdA==');
@$core.Deprecated('Use endCallResponseDescriptor instead')
const EndCallResponse$json = const {
  '1': 'EndCallResponse',
};

/// Descriptor for `EndCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endCallResponseDescriptor = $convert.base64Decode('Cg9FbmRDYWxsUmVzcG9uc2U=');
@$core.Deprecated('Use startBroadcastRequestDescriptor instead')
const StartBroadcastRequest$json = const {
  '1': 'StartBroadcastRequest',
  '2': const [
    const {'1': 'call_id', '3': 1, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'call_type', '3': 2, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'hls_broadcast', '3': 3, '4': 1, '5': 8, '10': 'hlsBroadcast'},
    const {'1': 'rtmp', '3': 5, '4': 1, '5': 11, '6': '.stream.video.RTMPOptions', '10': 'rtmp'},
  ],
};

/// Descriptor for `StartBroadcastRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startBroadcastRequestDescriptor = $convert.base64Decode('ChVTdGFydEJyb2FkY2FzdFJlcXVlc3QSFwoHY2FsbF9pZBgBIAEoCVIGY2FsbElkEhsKCWNhbGxfdHlwZRgCIAEoCVIIY2FsbFR5cGUSIwoNaGxzX2Jyb2FkY2FzdBgDIAEoCFIMaGxzQnJvYWRjYXN0Ei0KBHJ0bXAYBSABKAsyGS5zdHJlYW0udmlkZW8uUlRNUE9wdGlvbnNSBHJ0bXA=');
@$core.Deprecated('Use startBroadcastResponseDescriptor instead')
const StartBroadcastResponse$json = const {
  '1': 'StartBroadcastResponse',
  '2': const [
    const {'1': 'broadcast', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Broadcast', '10': 'broadcast'},
  ],
};

/// Descriptor for `StartBroadcastResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startBroadcastResponseDescriptor = $convert.base64Decode('ChZTdGFydEJyb2FkY2FzdFJlc3BvbnNlEjUKCWJyb2FkY2FzdBgBIAEoCzIXLnN0cmVhbS52aWRlby5Ccm9hZGNhc3RSCWJyb2FkY2FzdA==');
@$core.Deprecated('Use stopBroadcastRequestDescriptor instead')
const StopBroadcastRequest$json = const {
  '1': 'StopBroadcastRequest',
};

/// Descriptor for `StopBroadcastRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopBroadcastRequestDescriptor = $convert.base64Decode('ChRTdG9wQnJvYWRjYXN0UmVxdWVzdA==');
@$core.Deprecated('Use stopBroadcastResponseDescriptor instead')
const StopBroadcastResponse$json = const {
  '1': 'StopBroadcastResponse',
};

/// Descriptor for `StopBroadcastResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopBroadcastResponseDescriptor = $convert.base64Decode('ChVTdG9wQnJvYWRjYXN0UmVzcG9uc2U=');
@$core.Deprecated('Use transcribeCallRequestDescriptor instead')
const TranscribeCallRequest$json = const {
  '1': 'TranscribeCallRequest',
};

/// Descriptor for `TranscribeCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transcribeCallRequestDescriptor = $convert.base64Decode('ChVUcmFuc2NyaWJlQ2FsbFJlcXVlc3Q=');
@$core.Deprecated('Use transcribeCallResponseDescriptor instead')
const TranscribeCallResponse$json = const {
  '1': 'TranscribeCallResponse',
};

/// Descriptor for `TranscribeCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transcribeCallResponseDescriptor = $convert.base64Decode('ChZUcmFuc2NyaWJlQ2FsbFJlc3BvbnNl');
@$core.Deprecated('Use stopTranscribeCallRequestDescriptor instead')
const StopTranscribeCallRequest$json = const {
  '1': 'StopTranscribeCallRequest',
};

/// Descriptor for `StopTranscribeCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopTranscribeCallRequestDescriptor = $convert.base64Decode('ChlTdG9wVHJhbnNjcmliZUNhbGxSZXF1ZXN0');
@$core.Deprecated('Use stopTranscribeCallResponseDescriptor instead')
const StopTranscribeCallResponse$json = const {
  '1': 'StopTranscribeCallResponse',
};

/// Descriptor for `StopTranscribeCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopTranscribeCallResponseDescriptor = $convert.base64Decode('ChpTdG9wVHJhbnNjcmliZUNhbGxSZXNwb25zZQ==');
@$core.Deprecated('Use storeLatencyRequestDescriptor instead')
const StoreLatencyRequest$json = const {
  '1': 'StoreLatencyRequest',
};

/// Descriptor for `StoreLatencyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeLatencyRequestDescriptor = $convert.base64Decode('ChNTdG9yZUxhdGVuY3lSZXF1ZXN0');
@$core.Deprecated('Use storeLatencyResponseDescriptor instead')
const StoreLatencyResponse$json = const {
  '1': 'StoreLatencyResponse',
};

/// Descriptor for `StoreLatencyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeLatencyResponseDescriptor = $convert.base64Decode('ChRTdG9yZUxhdGVuY3lSZXNwb25zZQ==');
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
@$core.Deprecated('Use storeCallStatsRequestDescriptor instead')
const StoreCallStatsRequest$json = const {
  '1': 'StoreCallStatsRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'stats', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'stats'},
  ],
};

/// Descriptor for `StoreCallStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeCallStatsRequestDescriptor = $convert.base64Decode('ChVTdG9yZUNhbGxTdGF0c1JlcXVlc3QSGwoJY2FsbF90eXBlGAEgASgJUghjYWxsVHlwZRIXCgdjYWxsX2lkGAIgASgJUgZjYWxsSWQSLQoFc3RhdHMYAyABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0UgVzdGF0cw==');
@$core.Deprecated('Use callStatEventDescriptor instead')
const CallStatEvent$json = const {
  '1': 'CallStatEvent',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.CallStatEventType', '10': 'type'},
    const {'1': 'time', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'time'},
  ],
};

/// Descriptor for `CallStatEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callStatEventDescriptor = $convert.base64Decode('Cg1DYWxsU3RhdEV2ZW50EjMKBHR5cGUYASABKA4yHy5zdHJlYW0udmlkZW8uQ2FsbFN0YXRFdmVudFR5cGVSBHR5cGUSGwoEdGltZRgCIAEoCUIH+kIEcgIQAVIEdGltZQ==');
@$core.Deprecated('Use reportIssueRequestDescriptor instead')
const ReportIssueRequest$json = const {
  '1': 'ReportIssueRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'custom', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
  ],
};

/// Descriptor for `ReportIssueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportIssueRequestDescriptor = $convert.base64Decode('ChJSZXBvcnRJc3N1ZVJlcXVlc3QSGwoJY2FsbF90eXBlGAEgASgJUghjYWxsVHlwZRIXCgdjYWxsX2lkGAIgASgJUgZjYWxsSWQSIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2NyaXB0aW9uEi8KBmN1c3RvbRgEIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdHJ1Y3RSBmN1c3RvbQ==');
@$core.Deprecated('Use reviewCallRequestDescriptor instead')
const ReviewCallRequest$json = const {
  '1': 'ReviewCallRequest',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'stars', '3': 3, '4': 1, '5': 2, '10': 'stars'},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'custom', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
  ],
};

/// Descriptor for `ReviewCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewCallRequestDescriptor = $convert.base64Decode('ChFSZXZpZXdDYWxsUmVxdWVzdBIbCgljYWxsX3R5cGUYASABKAlSCGNhbGxUeXBlEhcKB2NhbGxfaWQYAiABKAlSBmNhbGxJZBIUCgVzdGFycxgDIAEoAlIFc3RhcnMSIAoLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9uEi8KBmN1c3RvbRgFIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdHJ1Y3RSBmN1c3RvbQ==');
@$core.Deprecated('Use reviewCallResponseDescriptor instead')
const ReviewCallResponse$json = const {
  '1': 'ReviewCallResponse',
};

/// Descriptor for `ReviewCallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewCallResponseDescriptor = $convert.base64Decode('ChJSZXZpZXdDYWxsUmVzcG9uc2U=');
@$core.Deprecated('Use reportIssueResponseDescriptor instead')
const ReportIssueResponse$json = const {
  '1': 'ReportIssueResponse',
};

/// Descriptor for `ReportIssueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportIssueResponseDescriptor = $convert.base64Decode('ChNSZXBvcnRJc3N1ZVJlc3BvbnNl');
@$core.Deprecated('Use participantCallStatEventDescriptor instead')
const ParticipantCallStatEvent$json = const {
  '1': 'ParticipantCallStatEvent',
  '2': const [
    const {'1': 'participant_id', '3': 1, '4': 1, '5': 9, '10': 'participantId'},
    const {'1': 'call_timeline', '3': 2, '4': 3, '5': 11, '6': '.stream.video.CallStatEvent', '10': 'callTimeline'},
  ],
};

/// Descriptor for `ParticipantCallStatEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantCallStatEventDescriptor = $convert.base64Decode('ChhQYXJ0aWNpcGFudENhbGxTdGF0RXZlbnQSJQoOcGFydGljaXBhbnRfaWQYASABKAlSDXBhcnRpY2lwYW50SWQSQAoNY2FsbF90aW1lbGluZRgCIAMoCzIbLnN0cmVhbS52aWRlby5DYWxsU3RhdEV2ZW50UgxjYWxsVGltZWxpbmU=');
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
@$core.Deprecated('Use callStatsDescriptor instead')
const CallStats$json = const {
  '1': 'CallStats',
  '2': const [
    const {'1': 'call_timeline', '3': 1, '4': 3, '5': 11, '6': '.stream.video.CallStatEvent', '10': 'callTimeline'},
    const {'1': 'participant_timelines', '3': 2, '4': 3, '5': 11, '6': '.stream.video.ParticipantCallStatEvent', '10': 'participantTimelines'},
  ],
};

/// Descriptor for `CallStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callStatsDescriptor = $convert.base64Decode('CglDYWxsU3RhdHMSQAoNY2FsbF90aW1lbGluZRgBIAMoCzIbLnN0cmVhbS52aWRlby5DYWxsU3RhdEV2ZW50UgxjYWxsVGltZWxpbmUSWwoVcGFydGljaXBhbnRfdGltZWxpbmVzGAIgAygLMiYuc3RyZWFtLnZpZGVvLlBhcnRpY2lwYW50Q2FsbFN0YXRFdmVudFIUcGFydGljaXBhbnRUaW1lbGluZXM=');
@$core.Deprecated('Use getCallStatsResponseDescriptor instead')
const GetCallStatsResponse$json = const {
  '1': 'GetCallStatsResponse',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
    const {'1': 'call_stats', '3': 2, '4': 1, '5': 11, '6': '.stream.video.CallStats', '10': 'callStats'},
  ],
};

/// Descriptor for `GetCallStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCallStatsResponseDescriptor = $convert.base64Decode('ChRHZXRDYWxsU3RhdHNSZXNwb25zZRImCgRjYWxsGAEgASgLMhIuc3RyZWFtLnZpZGVvLkNhbGxSBGNhbGwSNgoKY2FsbF9zdGF0cxgCIAEoCzIXLnN0cmVhbS52aWRlby5DYWxsU3RhdHNSCWNhbGxTdGF0cw==');
@$core.Deprecated('Use storeCallStatsResponseDescriptor instead')
const StoreCallStatsResponse$json = const {
  '1': 'StoreCallStatsResponse',
};

/// Descriptor for `StoreCallStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeCallStatsResponseDescriptor = $convert.base64Decode('ChZTdG9yZUNhbGxTdGF0c1Jlc3BvbnNl');
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
  '2': const [
    const {'1': 's3_file_url', '3': 1, '4': 1, '5': 9, '10': 's3FileUrl'},
  ],
};

/// Descriptor for `StopRecordingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopRecordingResponseDescriptor = $convert.base64Decode('ChVTdG9wUmVjb3JkaW5nUmVzcG9uc2USHgoLczNfZmlsZV91cmwYASABKAlSCXMzRmlsZVVybA==');
@$core.Deprecated('Use getRecordingsRequestDescriptor instead')
const GetRecordingsRequest$json = const {
  '1': 'GetRecordingsRequest',
};

/// Descriptor for `GetRecordingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecordingsRequestDescriptor = $convert.base64Decode('ChRHZXRSZWNvcmRpbmdzUmVxdWVzdA==');
@$core.Deprecated('Use getRecordingsResponseDescriptor instead')
const GetRecordingsResponse$json = const {
  '1': 'GetRecordingsResponse',
  '2': const [
    const {'1': 'recordings', '3': 1, '4': 3, '5': 11, '6': '.stream.video.GetRecordingsResponse.Recording', '10': 'recordings'},
  ],
  '3': const [GetRecordingsResponse_Recording$json],
};

@$core.Deprecated('Use getRecordingsResponseDescriptor instead')
const GetRecordingsResponse_Recording$json = const {
  '1': 'Recording',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 's3_file_url', '3': 3, '4': 1, '5': 9, '10': 's3FileUrl'},
    const {'1': 'start_time', '3': 4, '4': 1, '5': 9, '10': 'startTime'},
    const {'1': 'stop_time', '3': 5, '4': 1, '5': 9, '10': 'stopTime'},
  ],
};

/// Descriptor for `GetRecordingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecordingsResponseDescriptor = $convert.base64Decode('ChVHZXRSZWNvcmRpbmdzUmVzcG9uc2USTQoKcmVjb3JkaW5ncxgBIAMoCzItLnN0cmVhbS52aWRlby5HZXRSZWNvcmRpbmdzUmVzcG9uc2UuUmVjb3JkaW5nUgpyZWNvcmRpbmdzGp0BCglSZWNvcmRpbmcSGwoJY2FsbF90eXBlGAEgASgJUghjYWxsVHlwZRIXCgdjYWxsX2lkGAIgASgJUgZjYWxsSWQSHgoLczNfZmlsZV91cmwYAyABKAlSCXMzRmlsZVVybBIdCgpzdGFydF90aW1lGAQgASgJUglzdGFydFRpbWUSGwoJc3RvcF90aW1lGAUgASgJUghzdG9wVGltZQ==');
@$core.Deprecated('Use sendEventRequestDescriptor instead')
const SendEventRequest$json = const {
  '1': 'SendEventRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'call_type', '3': 2, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 3, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'event_type', '3': 4, '4': 1, '5': 14, '6': '.stream.video.UserEventType', '10': 'eventType'},
  ],
};

/// Descriptor for `SendEventRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendEventRequestDescriptor = $convert.base64Decode('ChBTZW5kRXZlbnRSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIbCgljYWxsX3R5cGUYAiABKAlSCGNhbGxUeXBlEhcKB2NhbGxfaWQYAyABKAlSBmNhbGxJZBI6CgpldmVudF90eXBlGAQgASgOMhsuc3RyZWFtLnZpZGVvLlVzZXJFdmVudFR5cGVSCWV2ZW50VHlwZQ==');
@$core.Deprecated('Use sendEventResponseDescriptor instead')
const SendEventResponse$json = const {
  '1': 'SendEventResponse',
};

/// Descriptor for `SendEventResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendEventResponseDescriptor = $convert.base64Decode('ChFTZW5kRXZlbnRSZXNwb25zZQ==');
const $core.Map<$core.String, $core.dynamic> CallCoordinatorServiceBase$json = const {
  '1': 'CallCoordinatorService',
  '2': const [
    const {'1': 'CreateCall', '2': '.stream.video.CreateCallRequest', '3': '.stream.video.CreateCallResponse'},
    const {'1': 'GetCall', '2': '.stream.video.GetCallRequest', '3': '.stream.video.GetCallResponse'},
    const {'1': 'UpdateCall', '2': '.stream.video.UpdateCallRequest', '3': '.stream.video.UpdateCallResponse'},
    const {'1': 'DeleteCall', '2': '.stream.video.DeleteCallRequest', '3': '.stream.video.DeleteCallResponse'},
    const {'1': 'JoinCall', '2': '.stream.video.JoinCallRequest', '3': '.stream.video.JoinCallResponse'},
    const {'1': 'SelectEdgeServer', '2': '.stream.video.SelectEdgeServerRequest', '3': '.stream.video.SelectEdgeServerResponse'},
    const {'1': 'LeaveCall', '2': '.stream.video.LeaveCallRequest', '3': '.stream.video.LeaveCallResponse'},
    const {'1': 'EndCall', '2': '.stream.video.EndCallRequest', '3': '.stream.video.EndCallResponse'},
    const {'1': 'AddDevice', '2': '.stream.video.AddDeviceRequest', '3': '.stream.video.AddDeviceResponse'},
    const {'1': 'RemoveDevice', '2': '.stream.video.RemoveDeviceRequest', '3': '.stream.video.RemoveDeviceResponse'},
    const {'1': 'ListDevices', '2': '.stream.video.ListDevicesRequest', '3': '.stream.video.ListDevicesResponse'},
    const {'1': 'SendEvent', '2': '.stream.video.SendEventRequest', '3': '.stream.video.SendEventResponse'},
    const {'1': 'SendCustomEvent', '2': '.stream.video.SendCustomEventRequest', '3': '.stream.video.SendCustomEventResponse'},
    const {'1': 'CreateOrUpdateCalls', '2': '.stream.video.CreateOrUpdateCallsRequest', '3': '.stream.video.CreateOrUpdateCallsResponse'},
    const {'1': 'CreateOrUpdateUsers', '2': '.stream.video.CreateOrUpdateUsersRequest', '3': '.stream.video.CreateOrUpdateUsersResponse'},
    const {'1': 'TranscribeCall', '2': '.stream.video.TranscribeCallRequest', '3': '.stream.video.TranscribeCallResponse'},
    const {'1': 'StopTranscribeCall', '2': '.stream.video.StopTranscribeCallRequest', '3': '.stream.video.StopTranscribeCallResponse'},
    const {'1': 'StartBroadcast', '2': '.stream.video.StartBroadcastRequest', '3': '.stream.video.StartBroadcastResponse'},
    const {'1': 'StopBroadcast', '2': '.stream.video.StopBroadcastRequest', '3': '.stream.video.StopBroadcastResponse'},
    const {'1': 'StartRecording', '2': '.stream.video.StartRecordingRequest', '3': '.stream.video.StartRecordingResponse'},
    const {'1': 'StopRecording', '2': '.stream.video.StopRecordingRequest', '3': '.stream.video.StopRecordingResponse'},
    const {'1': 'GetRecordings', '2': '.stream.video.GetRecordingsRequest', '3': '.stream.video.GetRecordingsResponse'},
    const {'1': 'CreateUser', '2': '.stream.video.CreateUserRequest', '3': '.stream.video.CreateUserResponse'},
    const {'1': 'DeleteUser', '2': '.stream.video.DeleteUserRequest', '3': '.stream.video.DeleteUserResponse'},
    const {'1': 'ExportUser', '2': '.stream.video.ExportUserRequest', '3': '.stream.video.ExportUserResponse'},
    const {'1': 'StoreCallStats', '2': '.stream.video.StoreCallStatsRequest', '3': '.stream.video.StoreCallStatsResponse'},
    const {'1': 'GetCallStats', '2': '.stream.video.GetCallStatsRequest', '3': '.stream.video.GetCallStatsResponse'},
    const {'1': 'ReviewCall', '2': '.stream.video.ReviewCallRequest', '3': '.stream.video.ReviewCallResponse'},
    const {'1': 'ReportIssue', '2': '.stream.video.ReportIssueRequest', '3': '.stream.video.ReportIssueResponse'},
  ],
};

@$core.Deprecated('Use callCoordinatorServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> CallCoordinatorServiceBase$messageJson = const {
  '.stream.video.CreateCallRequest': CreateCallRequest$json,
  '.google.protobuf.Struct': $2.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $2.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $2.Value$json,
  '.google.protobuf.ListValue': $2.ListValue$json,
  '.google.protobuf.BoolValue': $4.BoolValue$json,
  '.stream.video.RTMPOptions': $3.RTMPOptions$json,
  '.stream.video.TranscribeOptions': $3.TranscribeOptions$json,
  '.stream.video.CreateCallResponse': CreateCallResponse$json,
  '.stream.video.Call': $3.Call$json,
  '.stream.video.Broadcast': $3.Broadcast$json,
  '.stream.video.GetCallRequest': GetCallRequest$json,
  '.stream.video.GetCallResponse': GetCallResponse$json,
  '.stream.video.CallState': $3.CallState$json,
  '.stream.video.Participant': $3.Participant$json,
  '.stream.video.User': $3.User$json,
  '.stream.video.UpdateCallRequest': UpdateCallRequest$json,
  '.stream.video.UpdateCallResponse': UpdateCallResponse$json,
  '.stream.video.DeleteCallRequest': DeleteCallRequest$json,
  '.stream.video.DeleteCallResponse': DeleteCallResponse$json,
  '.stream.video.JoinCallRequest': JoinCallRequest$json,
  '.stream.video.JoinCallResponse': JoinCallResponse$json,
  '.stream.video.Edge': $3.Edge$json,
  '.stream.video.UserCapability': UserCapability$json,
  '.stream.video.SelectEdgeServerRequest': SelectEdgeServerRequest$json,
  '.stream.video.SelectEdgeServerRequest.LatencyByEdgeEntry': SelectEdgeServerRequest_LatencyByEdgeEntry$json,
  '.stream.video.Latency': $3.Latency$json,
  '.stream.video.SelectEdgeServerResponse': SelectEdgeServerResponse$json,
  '.stream.video.EdgeServer': $3.EdgeServer$json,
  '.stream.video.LeaveCallRequest': LeaveCallRequest$json,
  '.stream.video.LeaveCallResponse': LeaveCallResponse$json,
  '.stream.video.EndCallRequest': EndCallRequest$json,
  '.stream.video.EndCallResponse': EndCallResponse$json,
  '.stream.video.AddDeviceRequest': AddDeviceRequest$json,
  '.stream.video.AddDeviceResponse': AddDeviceResponse$json,
  '.stream.video.Device': $3.Device$json,
  '.stream.video.RemoveDeviceRequest': RemoveDeviceRequest$json,
  '.stream.video.RemoveDeviceResponse': RemoveDeviceResponse$json,
  '.stream.video.ListDevicesRequest': ListDevicesRequest$json,
  '.stream.video.ListDevicesResponse': ListDevicesResponse$json,
  '.stream.video.SendEventRequest': SendEventRequest$json,
  '.stream.video.SendEventResponse': SendEventResponse$json,
  '.stream.video.SendCustomEventRequest': SendCustomEventRequest$json,
  '.stream.video.SendCustomEventResponse': SendCustomEventResponse$json,
  '.stream.video.CreateOrUpdateCallsRequest': CreateOrUpdateCallsRequest$json,
  '.stream.video.CreateOrUpdateCallsResponse': CreateOrUpdateCallsResponse$json,
  '.stream.video.CreateOrUpdateUsersRequest': CreateOrUpdateUsersRequest$json,
  '.stream.video.CreateUserRequest': CreateUserRequest$json,
  '.stream.video.CreateOrUpdateUsersResponse': CreateOrUpdateUsersResponse$json,
  '.stream.video.TranscribeCallRequest': TranscribeCallRequest$json,
  '.stream.video.TranscribeCallResponse': TranscribeCallResponse$json,
  '.stream.video.StopTranscribeCallRequest': StopTranscribeCallRequest$json,
  '.stream.video.StopTranscribeCallResponse': StopTranscribeCallResponse$json,
  '.stream.video.StartBroadcastRequest': StartBroadcastRequest$json,
  '.stream.video.StartBroadcastResponse': StartBroadcastResponse$json,
  '.stream.video.StopBroadcastRequest': StopBroadcastRequest$json,
  '.stream.video.StopBroadcastResponse': StopBroadcastResponse$json,
  '.stream.video.StartRecordingRequest': StartRecordingRequest$json,
  '.stream.video.StartRecordingResponse': StartRecordingResponse$json,
  '.stream.video.StopRecordingRequest': StopRecordingRequest$json,
  '.stream.video.StopRecordingResponse': StopRecordingResponse$json,
  '.stream.video.GetRecordingsRequest': GetRecordingsRequest$json,
  '.stream.video.GetRecordingsResponse': GetRecordingsResponse$json,
  '.stream.video.GetRecordingsResponse.Recording': GetRecordingsResponse_Recording$json,
  '.stream.video.CreateUserResponse': CreateUserResponse$json,
  '.stream.video.DeleteUserRequest': DeleteUserRequest$json,
  '.stream.video.DeleteUserResponse': DeleteUserResponse$json,
  '.stream.video.ExportUserRequest': ExportUserRequest$json,
  '.stream.video.ExportUserResponse': ExportUserResponse$json,
  '.stream.video.StoreCallStatsRequest': StoreCallStatsRequest$json,
  '.stream.video.StoreCallStatsResponse': StoreCallStatsResponse$json,
  '.stream.video.GetCallStatsRequest': GetCallStatsRequest$json,
  '.stream.video.GetCallStatsResponse': GetCallStatsResponse$json,
  '.stream.video.CallStats': CallStats$json,
  '.stream.video.CallStatEvent': CallStatEvent$json,
  '.stream.video.ParticipantCallStatEvent': ParticipantCallStatEvent$json,
  '.stream.video.ReviewCallRequest': ReviewCallRequest$json,
  '.stream.video.ReviewCallResponse': ReviewCallResponse$json,
  '.stream.video.ReportIssueRequest': ReportIssueRequest$json,
  '.stream.video.ReportIssueResponse': ReportIssueResponse$json,
};

/// Descriptor for `CallCoordinatorService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List callCoordinatorServiceDescriptor = $convert.base64Decode('ChZDYWxsQ29vcmRpbmF0b3JTZXJ2aWNlEk8KCkNyZWF0ZUNhbGwSHy5zdHJlYW0udmlkZW8uQ3JlYXRlQ2FsbFJlcXVlc3QaIC5zdHJlYW0udmlkZW8uQ3JlYXRlQ2FsbFJlc3BvbnNlEkYKB0dldENhbGwSHC5zdHJlYW0udmlkZW8uR2V0Q2FsbFJlcXVlc3QaHS5zdHJlYW0udmlkZW8uR2V0Q2FsbFJlc3BvbnNlEk8KClVwZGF0ZUNhbGwSHy5zdHJlYW0udmlkZW8uVXBkYXRlQ2FsbFJlcXVlc3QaIC5zdHJlYW0udmlkZW8uVXBkYXRlQ2FsbFJlc3BvbnNlEk8KCkRlbGV0ZUNhbGwSHy5zdHJlYW0udmlkZW8uRGVsZXRlQ2FsbFJlcXVlc3QaIC5zdHJlYW0udmlkZW8uRGVsZXRlQ2FsbFJlc3BvbnNlEkkKCEpvaW5DYWxsEh0uc3RyZWFtLnZpZGVvLkpvaW5DYWxsUmVxdWVzdBoeLnN0cmVhbS52aWRlby5Kb2luQ2FsbFJlc3BvbnNlEmEKEFNlbGVjdEVkZ2VTZXJ2ZXISJS5zdHJlYW0udmlkZW8uU2VsZWN0RWRnZVNlcnZlclJlcXVlc3QaJi5zdHJlYW0udmlkZW8uU2VsZWN0RWRnZVNlcnZlclJlc3BvbnNlEkwKCUxlYXZlQ2FsbBIeLnN0cmVhbS52aWRlby5MZWF2ZUNhbGxSZXF1ZXN0Gh8uc3RyZWFtLnZpZGVvLkxlYXZlQ2FsbFJlc3BvbnNlEkYKB0VuZENhbGwSHC5zdHJlYW0udmlkZW8uRW5kQ2FsbFJlcXVlc3QaHS5zdHJlYW0udmlkZW8uRW5kQ2FsbFJlc3BvbnNlEkwKCUFkZERldmljZRIeLnN0cmVhbS52aWRlby5BZGREZXZpY2VSZXF1ZXN0Gh8uc3RyZWFtLnZpZGVvLkFkZERldmljZVJlc3BvbnNlElUKDFJlbW92ZURldmljZRIhLnN0cmVhbS52aWRlby5SZW1vdmVEZXZpY2VSZXF1ZXN0GiIuc3RyZWFtLnZpZGVvLlJlbW92ZURldmljZVJlc3BvbnNlElIKC0xpc3REZXZpY2VzEiAuc3RyZWFtLnZpZGVvLkxpc3REZXZpY2VzUmVxdWVzdBohLnN0cmVhbS52aWRlby5MaXN0RGV2aWNlc1Jlc3BvbnNlEkwKCVNlbmRFdmVudBIeLnN0cmVhbS52aWRlby5TZW5kRXZlbnRSZXF1ZXN0Gh8uc3RyZWFtLnZpZGVvLlNlbmRFdmVudFJlc3BvbnNlEl4KD1NlbmRDdXN0b21FdmVudBIkLnN0cmVhbS52aWRlby5TZW5kQ3VzdG9tRXZlbnRSZXF1ZXN0GiUuc3RyZWFtLnZpZGVvLlNlbmRDdXN0b21FdmVudFJlc3BvbnNlEmoKE0NyZWF0ZU9yVXBkYXRlQ2FsbHMSKC5zdHJlYW0udmlkZW8uQ3JlYXRlT3JVcGRhdGVDYWxsc1JlcXVlc3QaKS5zdHJlYW0udmlkZW8uQ3JlYXRlT3JVcGRhdGVDYWxsc1Jlc3BvbnNlEmoKE0NyZWF0ZU9yVXBkYXRlVXNlcnMSKC5zdHJlYW0udmlkZW8uQ3JlYXRlT3JVcGRhdGVVc2Vyc1JlcXVlc3QaKS5zdHJlYW0udmlkZW8uQ3JlYXRlT3JVcGRhdGVVc2Vyc1Jlc3BvbnNlElsKDlRyYW5zY3JpYmVDYWxsEiMuc3RyZWFtLnZpZGVvLlRyYW5zY3JpYmVDYWxsUmVxdWVzdBokLnN0cmVhbS52aWRlby5UcmFuc2NyaWJlQ2FsbFJlc3BvbnNlEmcKElN0b3BUcmFuc2NyaWJlQ2FsbBInLnN0cmVhbS52aWRlby5TdG9wVHJhbnNjcmliZUNhbGxSZXF1ZXN0Giguc3RyZWFtLnZpZGVvLlN0b3BUcmFuc2NyaWJlQ2FsbFJlc3BvbnNlElsKDlN0YXJ0QnJvYWRjYXN0EiMuc3RyZWFtLnZpZGVvLlN0YXJ0QnJvYWRjYXN0UmVxdWVzdBokLnN0cmVhbS52aWRlby5TdGFydEJyb2FkY2FzdFJlc3BvbnNlElgKDVN0b3BCcm9hZGNhc3QSIi5zdHJlYW0udmlkZW8uU3RvcEJyb2FkY2FzdFJlcXVlc3QaIy5zdHJlYW0udmlkZW8uU3RvcEJyb2FkY2FzdFJlc3BvbnNlElsKDlN0YXJ0UmVjb3JkaW5nEiMuc3RyZWFtLnZpZGVvLlN0YXJ0UmVjb3JkaW5nUmVxdWVzdBokLnN0cmVhbS52aWRlby5TdGFydFJlY29yZGluZ1Jlc3BvbnNlElgKDVN0b3BSZWNvcmRpbmcSIi5zdHJlYW0udmlkZW8uU3RvcFJlY29yZGluZ1JlcXVlc3QaIy5zdHJlYW0udmlkZW8uU3RvcFJlY29yZGluZ1Jlc3BvbnNlElgKDUdldFJlY29yZGluZ3MSIi5zdHJlYW0udmlkZW8uR2V0UmVjb3JkaW5nc1JlcXVlc3QaIy5zdHJlYW0udmlkZW8uR2V0UmVjb3JkaW5nc1Jlc3BvbnNlEk8KCkNyZWF0ZVVzZXISHy5zdHJlYW0udmlkZW8uQ3JlYXRlVXNlclJlcXVlc3QaIC5zdHJlYW0udmlkZW8uQ3JlYXRlVXNlclJlc3BvbnNlEk8KCkRlbGV0ZVVzZXISHy5zdHJlYW0udmlkZW8uRGVsZXRlVXNlclJlcXVlc3QaIC5zdHJlYW0udmlkZW8uRGVsZXRlVXNlclJlc3BvbnNlEk8KCkV4cG9ydFVzZXISHy5zdHJlYW0udmlkZW8uRXhwb3J0VXNlclJlcXVlc3QaIC5zdHJlYW0udmlkZW8uRXhwb3J0VXNlclJlc3BvbnNlElsKDlN0b3JlQ2FsbFN0YXRzEiMuc3RyZWFtLnZpZGVvLlN0b3JlQ2FsbFN0YXRzUmVxdWVzdBokLnN0cmVhbS52aWRlby5TdG9yZUNhbGxTdGF0c1Jlc3BvbnNlElUKDEdldENhbGxTdGF0cxIhLnN0cmVhbS52aWRlby5HZXRDYWxsU3RhdHNSZXF1ZXN0GiIuc3RyZWFtLnZpZGVvLkdldENhbGxTdGF0c1Jlc3BvbnNlEk8KClJldmlld0NhbGwSHy5zdHJlYW0udmlkZW8uUmV2aWV3Q2FsbFJlcXVlc3QaIC5zdHJlYW0udmlkZW8uUmV2aWV3Q2FsbFJlc3BvbnNlElIKC1JlcG9ydElzc3VlEiAuc3RyZWFtLnZpZGVvLlJlcG9ydElzc3VlUmVxdWVzdBohLnN0cmVhbS52aWRlby5SZXBvcnRJc3N1ZVJlc3BvbnNl');
