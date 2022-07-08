///
//  Generated code. Do not modify.
//  source: video_coordinator_rpc/coordinator_service.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
import '../video_models/models.pbjson.dart' as $2;

@$core.Deprecated('Use errorDescriptor instead')
const Error$json = const {
  '1': 'Error',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 3, '10': 'code'},
    const {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'data', '3': 3, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode('CgVFcnJvchISCgRjb2RlGAEgASgDUgRjb2RlEiAKC2Rlc2NyaXB0aW9uGAIgASgJUgtkZXNjcmlwdGlvbhISCgRkYXRhGAMgASgMUgRkYXRh');
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
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'jsonencoded_custom_data', '3': 3, '4': 1, '5': 12, '10': 'jsonencodedCustomData'},
    const {'1': 'participants', '3': 4, '4': 3, '5': 9, '10': 'participants'},
    const {'1': 'broadcast', '3': 6, '4': 1, '5': 8, '10': 'broadcast'},
    const {'1': 'broadcast_options', '3': 7, '4': 3, '5': 11, '6': '.stream.video.BroadcastOptions', '10': 'broadcastOptions'},
    const {'1': 'transcribe', '3': 8, '4': 1, '5': 8, '10': 'transcribe'},
    const {'1': 'transcribe_options', '3': 9, '4': 1, '5': 11, '6': '.stream.video.TranscribeOptions', '10': 'transcribeOptions'},
    const {'1': 'recording', '3': 10, '4': 1, '5': 8, '10': 'recording'},
    const {'1': 'ring', '3': 11, '4': 1, '5': 8, '10': 'ring'},
  ],
};

/// Descriptor for `CreateCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCallRequestDescriptor = $convert.base64Decode('ChFDcmVhdGVDYWxsUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSEgoEdHlwZRgCIAEoCVIEdHlwZRI2Chdqc29uZW5jb2RlZF9jdXN0b21fZGF0YRgDIAEoDFIVanNvbmVuY29kZWRDdXN0b21EYXRhEiIKDHBhcnRpY2lwYW50cxgEIAMoCVIMcGFydGljaXBhbnRzEhwKCWJyb2FkY2FzdBgGIAEoCFIJYnJvYWRjYXN0EksKEWJyb2FkY2FzdF9vcHRpb25zGAcgAygLMh4uc3RyZWFtLnZpZGVvLkJyb2FkY2FzdE9wdGlvbnNSEGJyb2FkY2FzdE9wdGlvbnMSHgoKdHJhbnNjcmliZRgIIAEoCFIKdHJhbnNjcmliZRJOChJ0cmFuc2NyaWJlX29wdGlvbnMYCSABKAsyHy5zdHJlYW0udmlkZW8uVHJhbnNjcmliZU9wdGlvbnNSEXRyYW5zY3JpYmVPcHRpb25zEhwKCXJlY29yZGluZxgKIAEoCFIJcmVjb3JkaW5nEhIKBHJpbmcYCyABKAhSBHJpbmc=');
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
    const {'1': 'jsonencoded_custom_data', '3': 3, '4': 1, '5': 12, '10': 'jsonencodedCustomData'},
    const {'1': 'auth_token', '3': 4, '4': 1, '5': 9, '10': 'authToken'},
  ],
};

/// Descriptor for `UpdateCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCallRequestDescriptor = $convert.base64Decode('ChFVcGRhdGVDYWxsUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSEgoEdHlwZRgCIAEoCVIEdHlwZRI2Chdqc29uZW5jb2RlZF9jdXN0b21fZGF0YRgDIAEoDFIVanNvbmVuY29kZWRDdXN0b21EYXRhEh0KCmF1dGhfdG9rZW4YBCABKAlSCWF1dGhUb2tlbg==');
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
    const {'1': 'call_id', '3': 1, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
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
final $typed_data.Uint8List selectEdgeServerRequestDescriptor = $convert.base64Decode('ChdTZWxlY3RFZGdlU2VydmVyUmVxdWVzdBIXCgdjYWxsX2lkGAEgASgJUgZjYWxsSWQSFwoHdXNlcl9pZBgCIAEoCVIGdXNlcklkEmAKD2xhdGVuY3lfYnlfZWRnZRgDIAMoCzI4LnN0cmVhbS52aWRlby5TZWxlY3RFZGdlU2VydmVyUmVxdWVzdC5MYXRlbmN5QnlFZGdlRW50cnlSDWxhdGVuY3lCeUVkZ2UaVwoSTGF0ZW5jeUJ5RWRnZUVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EisKBXZhbHVlGAIgASgLMhUuc3RyZWFtLnZpZGVvLkxhdGVuY3lSBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use selectEdgeServerResponseDescriptor instead')
const SelectEdgeServerResponse$json = const {
  '1': 'SelectEdgeServerResponse',
  '2': const [
    const {'1': 'edge_server', '3': 1, '4': 1, '5': 11, '6': '.stream.video.EdgeServer', '10': 'edgeServer'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `SelectEdgeServerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectEdgeServerResponseDescriptor = $convert.base64Decode('ChhTZWxlY3RFZGdlU2VydmVyUmVzcG9uc2USOQoLZWRnZV9zZXJ2ZXIYASABKAsyGC5zdHJlYW0udmlkZW8uRWRnZVNlcnZlclIKZWRnZVNlcnZlchIUCgV0b2tlbhgCIAEoCVIFdG9rZW4=');
@$core.Deprecated('Use addDeviceRequestDescriptor instead')
const AddDeviceRequest$json = const {
  '1': 'AddDeviceRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'push_provider', '3': 3, '4': 1, '5': 9, '10': 'pushProvider'},
    const {'1': 'disabled', '3': 4, '4': 1, '5': 8, '10': 'disabled'},
    const {'1': 'disabled_reason', '3': 5, '4': 1, '5': 9, '10': 'disabledReason'},
    const {'1': 'push_provider_name', '3': 6, '4': 1, '5': 9, '10': 'pushProviderName'},
  ],
};

/// Descriptor for `AddDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addDeviceRequestDescriptor = $convert.base64Decode('ChBBZGREZXZpY2VSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIOCgJpZBgCIAEoCVICaWQSIwoNcHVzaF9wcm92aWRlchgDIAEoCVIMcHVzaFByb3ZpZGVyEhoKCGRpc2FibGVkGAQgASgIUghkaXNhYmxlZBInCg9kaXNhYmxlZF9yZWFzb24YBSABKAlSDmRpc2FibGVkUmVhc29uEiwKEnB1c2hfcHJvdmlkZXJfbmFtZRgGIAEoCVIQcHVzaFByb3ZpZGVyTmFtZQ==');
@$core.Deprecated('Use addDeviceResponseDescriptor instead')
const AddDeviceResponse$json = const {
  '1': 'AddDeviceResponse',
};

/// Descriptor for `AddDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addDeviceResponseDescriptor = $convert.base64Decode('ChFBZGREZXZpY2VSZXNwb25zZQ==');
@$core.Deprecated('Use removeDeviceRequestDescriptor instead')
const RemoveDeviceRequest$json = const {
  '1': 'RemoveDeviceRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `RemoveDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeDeviceRequestDescriptor = $convert.base64Decode('ChNSZW1vdmVEZXZpY2VSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');
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
  ],
};

/// Descriptor for `CreateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createUserRequestDescriptor = $convert.base64Decode('ChFDcmVhdGVVc2VyUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');
@$core.Deprecated('Use createOrUpdateUsersRequestDescriptor instead')
const CreateOrUpdateUsersRequest$json = const {
  '1': 'CreateOrUpdateUsersRequest',
  '2': const [
    const {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.stream.video.CreateUserRequest', '10': 'users'},
  ],
};

/// Descriptor for `CreateOrUpdateUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createOrUpdateUsersRequestDescriptor = $convert.base64Decode('ChpDcmVhdGVPclVwZGF0ZVVzZXJzUmVxdWVzdBI1CgV1c2VycxgBIAMoCzIfLnN0cmVhbS52aWRlby5DcmVhdGVVc2VyUmVxdWVzdFIFdXNlcnM=');
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
    const {'1': 'call_id', '3': 1, '4': 1, '5': 9, '10': 'callId'},
  ],
};

/// Descriptor for `JoinCallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinCallRequestDescriptor = $convert.base64Decode('Cg9Kb2luQ2FsbFJlcXVlc3QSFwoHY2FsbF9pZBgBIAEoCVIGY2FsbElk');
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
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
  ],
};

/// Descriptor for `StartBroadcastRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startBroadcastRequestDescriptor = $convert.base64Decode('ChVTdGFydEJyb2FkY2FzdFJlcXVlc3QSEgoEdHlwZRgBIAEoCVIEdHlwZQ==');
@$core.Deprecated('Use startBroadcastResponseDescriptor instead')
const StartBroadcastResponse$json = const {
  '1': 'StartBroadcastResponse',
};

/// Descriptor for `StartBroadcastResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startBroadcastResponseDescriptor = $convert.base64Decode('ChZTdGFydEJyb2FkY2FzdFJlc3BvbnNl');
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
    const {'1': 'call_id', '3': 1, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'storage_options', '3': 2, '4': 1, '5': 11, '6': '.stream.video.RecordingStorageOptions', '10': 'storageOptions'},
    const {'1': 'codec', '3': 3, '4': 1, '5': 14, '6': '.stream.video.Codec', '10': 'codec'},
  ],
};

/// Descriptor for `StartRecordingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRecordingRequestDescriptor = $convert.base64Decode('ChVTdGFydFJlY29yZGluZ1JlcXVlc3QSFwoHY2FsbF9pZBgBIAEoCVIGY2FsbElkEk4KD3N0b3JhZ2Vfb3B0aW9ucxgCIAEoCzIlLnN0cmVhbS52aWRlby5SZWNvcmRpbmdTdG9yYWdlT3B0aW9uc1IOc3RvcmFnZU9wdGlvbnMSKQoFY29kZWMYAyABKA4yEy5zdHJlYW0udmlkZW8uQ29kZWNSBWNvZGVj');
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
    const {'1': 'call_id', '3': 1, '4': 1, '5': 9, '10': 'callId'},
  ],
};

/// Descriptor for `StopRecordingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopRecordingRequestDescriptor = $convert.base64Decode('ChRTdG9wUmVjb3JkaW5nUmVxdWVzdBIXCgdjYWxsX2lkGAEgASgJUgZjYWxsSWQ=');
@$core.Deprecated('Use stopRecordingResponseDescriptor instead')
const StopRecordingResponse$json = const {
  '1': 'StopRecordingResponse',
};

/// Descriptor for `StopRecordingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopRecordingResponseDescriptor = $convert.base64Decode('ChVTdG9wUmVjb3JkaW5nUmVzcG9uc2U=');
@$core.Deprecated('Use getRecordingsRequestDescriptor instead')
const GetRecordingsRequest$json = const {
  '1': 'GetRecordingsRequest',
};

/// Descriptor for `GetRecordingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecordingsRequestDescriptor = $convert.base64Decode('ChRHZXRSZWNvcmRpbmdzUmVxdWVzdA==');
@$core.Deprecated('Use getRecordingsResponseDescriptor instead')
const GetRecordingsResponse$json = const {
  '1': 'GetRecordingsResponse',
};

/// Descriptor for `GetRecordingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecordingsResponseDescriptor = $convert.base64Decode('ChVHZXRSZWNvcmRpbmdzUmVzcG9uc2U=');
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
    const {'1': 'SendCustomEvent', '2': '.stream.video.SendCustomEventRequest', '3': '.stream.video.SendCustomEventResponse'},
    const {'1': 'CreateOrUpdateCalls', '2': '.stream.video.CreateOrUpdateCallsRequest', '3': '.stream.video.CreateOrUpdateCallsResponse'},
    const {'1': 'CreateOrUpdateUsers', '2': '.stream.video.CreateOrUpdateUsersRequest', '3': '.stream.video.CreateOrUpdateUsersResponse'},
    const {'1': 'TranscribeCall', '2': '.stream.video.TranscribeCallRequest', '3': '.stream.video.TranscribeCallResponse'},
    const {'1': 'StopTranscribeCall', '2': '.stream.video.StopTranscribeCallRequest', '3': '.stream.video.StopTranscribeCallResponse'},
    const {'1': 'StartBroadcast', '2': '.stream.video.StartBroadcastRequest', '3': '.stream.video.StartBroadcastResponse'},
    const {'1': 'StopBroadcast', '2': '.stream.video.StopBroadcastRequest', '3': '.stream.video.StartBroadcastResponse'},
    const {'1': 'CreateUser', '2': '.stream.video.CreateUserRequest', '3': '.stream.video.CreateUserResponse'},
    const {'1': 'DeleteUser', '2': '.stream.video.DeleteUserRequest', '3': '.stream.video.DeleteUserResponse'},
    const {'1': 'ExportUser', '2': '.stream.video.ExportUserRequest', '3': '.stream.video.ExportUserResponse'},
    const {'1': 'StartRecording', '2': '.stream.video.StartRecordingRequest', '3': '.stream.video.StartRecordingResponse'},
    const {'1': 'StopRecording', '2': '.stream.video.StopRecordingRequest', '3': '.stream.video.StopRecordingResponse'},
    const {'1': 'GetRecordings', '2': '.stream.video.GetRecordingsRequest', '3': '.stream.video.GetRecordingsResponse'},
  ],
};

@$core.Deprecated('Use callCoordinatorServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> CallCoordinatorServiceBase$messageJson = const {
  '.stream.video.CreateCallRequest': CreateCallRequest$json,
  '.stream.video.BroadcastOptions': $2.BroadcastOptions$json,
  '.stream.video.TranscribeOptions': $2.TranscribeOptions$json,
  '.stream.video.CreateCallResponse': CreateCallResponse$json,
  '.stream.video.Call': $2.Call$json,
  '.stream.video.GetCallRequest': GetCallRequest$json,
  '.stream.video.GetCallResponse': GetCallResponse$json,
  '.stream.video.CallState': $2.CallState$json,
  '.stream.video.Participant': $2.Participant$json,
  '.stream.video.UpdateCallRequest': UpdateCallRequest$json,
  '.stream.video.UpdateCallResponse': UpdateCallResponse$json,
  '.stream.video.DeleteCallRequest': DeleteCallRequest$json,
  '.stream.video.DeleteCallResponse': DeleteCallResponse$json,
  '.stream.video.JoinCallRequest': JoinCallRequest$json,
  '.stream.video.JoinCallResponse': JoinCallResponse$json,
  '.stream.video.User': $2.User$json,
  '.stream.video.Edge': $2.Edge$json,
  '.stream.video.UserCapability': UserCapability$json,
  '.stream.video.SelectEdgeServerRequest': SelectEdgeServerRequest$json,
  '.stream.video.SelectEdgeServerRequest.LatencyByEdgeEntry': SelectEdgeServerRequest_LatencyByEdgeEntry$json,
  '.stream.video.Latency': $2.Latency$json,
  '.stream.video.SelectEdgeServerResponse': SelectEdgeServerResponse$json,
  '.stream.video.EdgeServer': $2.EdgeServer$json,
  '.stream.video.LeaveCallRequest': LeaveCallRequest$json,
  '.stream.video.LeaveCallResponse': LeaveCallResponse$json,
  '.stream.video.EndCallRequest': EndCallRequest$json,
  '.stream.video.EndCallResponse': EndCallResponse$json,
  '.stream.video.AddDeviceRequest': AddDeviceRequest$json,
  '.stream.video.AddDeviceResponse': AddDeviceResponse$json,
  '.stream.video.RemoveDeviceRequest': RemoveDeviceRequest$json,
  '.stream.video.RemoveDeviceResponse': RemoveDeviceResponse$json,
  '.stream.video.ListDevicesRequest': ListDevicesRequest$json,
  '.stream.video.ListDevicesResponse': ListDevicesResponse$json,
  '.stream.video.Device': $2.Device$json,
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
  '.stream.video.CreateUserResponse': CreateUserResponse$json,
  '.stream.video.DeleteUserRequest': DeleteUserRequest$json,
  '.stream.video.DeleteUserResponse': DeleteUserResponse$json,
  '.stream.video.ExportUserRequest': ExportUserRequest$json,
  '.stream.video.ExportUserResponse': ExportUserResponse$json,
  '.stream.video.StartRecordingRequest': StartRecordingRequest$json,
  '.stream.video.RecordingStorageOptions': $2.RecordingStorageOptions$json,
  '.stream.video.StartRecordingResponse': StartRecordingResponse$json,
  '.stream.video.StopRecordingRequest': StopRecordingRequest$json,
  '.stream.video.StopRecordingResponse': StopRecordingResponse$json,
  '.stream.video.GetRecordingsRequest': GetRecordingsRequest$json,
  '.stream.video.GetRecordingsResponse': GetRecordingsResponse$json,
};

/// Descriptor for `CallCoordinatorService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List callCoordinatorServiceDescriptor = $convert.base64Decode('ChZDYWxsQ29vcmRpbmF0b3JTZXJ2aWNlEk8KCkNyZWF0ZUNhbGwSHy5zdHJlYW0udmlkZW8uQ3JlYXRlQ2FsbFJlcXVlc3QaIC5zdHJlYW0udmlkZW8uQ3JlYXRlQ2FsbFJlc3BvbnNlEkYKB0dldENhbGwSHC5zdHJlYW0udmlkZW8uR2V0Q2FsbFJlcXVlc3QaHS5zdHJlYW0udmlkZW8uR2V0Q2FsbFJlc3BvbnNlEk8KClVwZGF0ZUNhbGwSHy5zdHJlYW0udmlkZW8uVXBkYXRlQ2FsbFJlcXVlc3QaIC5zdHJlYW0udmlkZW8uVXBkYXRlQ2FsbFJlc3BvbnNlEk8KCkRlbGV0ZUNhbGwSHy5zdHJlYW0udmlkZW8uRGVsZXRlQ2FsbFJlcXVlc3QaIC5zdHJlYW0udmlkZW8uRGVsZXRlQ2FsbFJlc3BvbnNlEkkKCEpvaW5DYWxsEh0uc3RyZWFtLnZpZGVvLkpvaW5DYWxsUmVxdWVzdBoeLnN0cmVhbS52aWRlby5Kb2luQ2FsbFJlc3BvbnNlEmEKEFNlbGVjdEVkZ2VTZXJ2ZXISJS5zdHJlYW0udmlkZW8uU2VsZWN0RWRnZVNlcnZlclJlcXVlc3QaJi5zdHJlYW0udmlkZW8uU2VsZWN0RWRnZVNlcnZlclJlc3BvbnNlEkwKCUxlYXZlQ2FsbBIeLnN0cmVhbS52aWRlby5MZWF2ZUNhbGxSZXF1ZXN0Gh8uc3RyZWFtLnZpZGVvLkxlYXZlQ2FsbFJlc3BvbnNlEkYKB0VuZENhbGwSHC5zdHJlYW0udmlkZW8uRW5kQ2FsbFJlcXVlc3QaHS5zdHJlYW0udmlkZW8uRW5kQ2FsbFJlc3BvbnNlEkwKCUFkZERldmljZRIeLnN0cmVhbS52aWRlby5BZGREZXZpY2VSZXF1ZXN0Gh8uc3RyZWFtLnZpZGVvLkFkZERldmljZVJlc3BvbnNlElUKDFJlbW92ZURldmljZRIhLnN0cmVhbS52aWRlby5SZW1vdmVEZXZpY2VSZXF1ZXN0GiIuc3RyZWFtLnZpZGVvLlJlbW92ZURldmljZVJlc3BvbnNlElIKC0xpc3REZXZpY2VzEiAuc3RyZWFtLnZpZGVvLkxpc3REZXZpY2VzUmVxdWVzdBohLnN0cmVhbS52aWRlby5MaXN0RGV2aWNlc1Jlc3BvbnNlEl4KD1NlbmRDdXN0b21FdmVudBIkLnN0cmVhbS52aWRlby5TZW5kQ3VzdG9tRXZlbnRSZXF1ZXN0GiUuc3RyZWFtLnZpZGVvLlNlbmRDdXN0b21FdmVudFJlc3BvbnNlEmoKE0NyZWF0ZU9yVXBkYXRlQ2FsbHMSKC5zdHJlYW0udmlkZW8uQ3JlYXRlT3JVcGRhdGVDYWxsc1JlcXVlc3QaKS5zdHJlYW0udmlkZW8uQ3JlYXRlT3JVcGRhdGVDYWxsc1Jlc3BvbnNlEmoKE0NyZWF0ZU9yVXBkYXRlVXNlcnMSKC5zdHJlYW0udmlkZW8uQ3JlYXRlT3JVcGRhdGVVc2Vyc1JlcXVlc3QaKS5zdHJlYW0udmlkZW8uQ3JlYXRlT3JVcGRhdGVVc2Vyc1Jlc3BvbnNlElsKDlRyYW5zY3JpYmVDYWxsEiMuc3RyZWFtLnZpZGVvLlRyYW5zY3JpYmVDYWxsUmVxdWVzdBokLnN0cmVhbS52aWRlby5UcmFuc2NyaWJlQ2FsbFJlc3BvbnNlEmcKElN0b3BUcmFuc2NyaWJlQ2FsbBInLnN0cmVhbS52aWRlby5TdG9wVHJhbnNjcmliZUNhbGxSZXF1ZXN0Giguc3RyZWFtLnZpZGVvLlN0b3BUcmFuc2NyaWJlQ2FsbFJlc3BvbnNlElsKDlN0YXJ0QnJvYWRjYXN0EiMuc3RyZWFtLnZpZGVvLlN0YXJ0QnJvYWRjYXN0UmVxdWVzdBokLnN0cmVhbS52aWRlby5TdGFydEJyb2FkY2FzdFJlc3BvbnNlElkKDVN0b3BCcm9hZGNhc3QSIi5zdHJlYW0udmlkZW8uU3RvcEJyb2FkY2FzdFJlcXVlc3QaJC5zdHJlYW0udmlkZW8uU3RhcnRCcm9hZGNhc3RSZXNwb25zZRJPCgpDcmVhdGVVc2VyEh8uc3RyZWFtLnZpZGVvLkNyZWF0ZVVzZXJSZXF1ZXN0GiAuc3RyZWFtLnZpZGVvLkNyZWF0ZVVzZXJSZXNwb25zZRJPCgpEZWxldGVVc2VyEh8uc3RyZWFtLnZpZGVvLkRlbGV0ZVVzZXJSZXF1ZXN0GiAuc3RyZWFtLnZpZGVvLkRlbGV0ZVVzZXJSZXNwb25zZRJPCgpFeHBvcnRVc2VyEh8uc3RyZWFtLnZpZGVvLkV4cG9ydFVzZXJSZXF1ZXN0GiAuc3RyZWFtLnZpZGVvLkV4cG9ydFVzZXJSZXNwb25zZRJbCg5TdGFydFJlY29yZGluZxIjLnN0cmVhbS52aWRlby5TdGFydFJlY29yZGluZ1JlcXVlc3QaJC5zdHJlYW0udmlkZW8uU3RhcnRSZWNvcmRpbmdSZXNwb25zZRJYCg1TdG9wUmVjb3JkaW5nEiIuc3RyZWFtLnZpZGVvLlN0b3BSZWNvcmRpbmdSZXF1ZXN0GiMuc3RyZWFtLnZpZGVvLlN0b3BSZWNvcmRpbmdSZXNwb25zZRJYCg1HZXRSZWNvcmRpbmdzEiIuc3RyZWFtLnZpZGVvLkdldFJlY29yZGluZ3NSZXF1ZXN0GiMuc3RyZWFtLnZpZGVvLkdldFJlY29yZGluZ3NSZXNwb25zZQ==');
