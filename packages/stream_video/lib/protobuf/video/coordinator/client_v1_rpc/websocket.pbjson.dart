///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/websocket.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use websocketEventDescriptor instead')
const WebsocketEvent$json = const {
  '1': 'WebsocketEvent',
  '2': const [
    const {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.WebsocketEvent.UsersEntry', '10': 'users'},
    const {'1': 'calls', '3': 2, '4': 3, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.WebsocketEvent.CallsEntry', '10': 'calls'},
    const {'1': 'call_details', '3': 3, '4': 3, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.WebsocketEvent.CallDetailsEntry', '10': 'callDetails'},
    const {'1': 'event_sender_id', '3': 4, '4': 1, '5': 9, '10': 'eventSenderId'},
    const {'1': 'healthcheck', '3': 20, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.WebsocketHealthcheck', '9': 0, '10': 'healthcheck'},
    const {'1': 'call_created', '3': 30, '4': 1, '5': 11, '6': '.stream.video.coordinator.event_v1.CallCreated', '9': 0, '10': 'callCreated'},
    const {'1': 'call_updated', '3': 31, '4': 1, '5': 11, '6': '.stream.video.coordinator.event_v1.CallUpdated', '9': 0, '10': 'callUpdated'},
    const {'1': 'call_deleted', '3': 32, '4': 1, '5': 11, '6': '.stream.video.coordinator.event_v1.CallDeleted', '9': 0, '10': 'callDeleted'},
    const {'1': 'call_members_updated', '3': 33, '4': 1, '5': 11, '6': '.stream.video.coordinator.event_v1.CallMembersUpdated', '9': 0, '10': 'callMembersUpdated'},
    const {'1': 'call_members_deleted', '3': 34, '4': 1, '5': 11, '6': '.stream.video.coordinator.event_v1.CallMembersDeleted', '9': 0, '10': 'callMembersDeleted'},
    const {'1': 'call_ended', '3': 36, '4': 1, '5': 11, '6': '.stream.video.coordinator.event_v1.CallEnded', '9': 0, '10': 'callEnded'},
    const {'1': 'call_accepted', '3': 40, '4': 1, '5': 11, '6': '.stream.video.coordinator.event_v1.CallAccepted', '9': 0, '10': 'callAccepted'},
    const {'1': 'call_rejected', '3': 41, '4': 1, '5': 11, '6': '.stream.video.coordinator.event_v1.CallRejected', '9': 0, '10': 'callRejected'},
    const {'1': 'call_cancelled', '3': 42, '4': 1, '5': 11, '6': '.stream.video.coordinator.event_v1.CallCancelled', '9': 0, '10': 'callCancelled'},
    const {'1': 'user_updated', '3': 50, '4': 1, '5': 11, '6': '.stream.video.coordinator.event_v1.UserUpdated', '9': 0, '10': 'userUpdated'},
  ],
  '3': const [WebsocketEvent_UsersEntry$json, WebsocketEvent_CallsEntry$json, WebsocketEvent_CallDetailsEntry$json],
  '8': const [
    const {'1': 'event'},
  ],
};

@$core.Deprecated('Use websocketEventDescriptor instead')
const WebsocketEvent_UsersEntry$json = const {
  '1': 'UsersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.user_v1.User', '10': 'value'},
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use websocketEventDescriptor instead')
const WebsocketEvent_CallsEntry$json = const {
  '1': 'CallsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '10': 'value'},
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use websocketEventDescriptor instead')
const WebsocketEvent_CallDetailsEntry$json = const {
  '1': 'CallDetailsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `WebsocketEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List websocketEventDescriptor = $convert.base64Decode('Cg5XZWJzb2NrZXRFdmVudBJXCgV1c2VycxgBIAMoCzJBLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLldlYnNvY2tldEV2ZW50LlVzZXJzRW50cnlSBXVzZXJzElcKBWNhbGxzGAIgAygLMkEuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuV2Vic29ja2V0RXZlbnQuQ2FsbHNFbnRyeVIFY2FsbHMSagoMY2FsbF9kZXRhaWxzGAMgAygLMkcuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuV2Vic29ja2V0RXZlbnQuQ2FsbERldGFpbHNFbnRyeVILY2FsbERldGFpbHMSJgoPZXZlbnRfc2VuZGVyX2lkGAQgASgJUg1ldmVudFNlbmRlcklkEmAKC2hlYWx0aGNoZWNrGBQgASgLMjwuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsaWVudF92MV9ycGMuV2Vic29ja2V0SGVhbHRoY2hlY2tIAFILaGVhbHRoY2hlY2sSUwoMY2FsbF9jcmVhdGVkGB4gASgLMi4uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmV2ZW50X3YxLkNhbGxDcmVhdGVkSABSC2NhbGxDcmVhdGVkElMKDGNhbGxfdXBkYXRlZBgfIAEoCzIuLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5ldmVudF92MS5DYWxsVXBkYXRlZEgAUgtjYWxsVXBkYXRlZBJTCgxjYWxsX2RlbGV0ZWQYICABKAsyLi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuZXZlbnRfdjEuQ2FsbERlbGV0ZWRIAFILY2FsbERlbGV0ZWQSaQoUY2FsbF9tZW1iZXJzX3VwZGF0ZWQYISABKAsyNS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuZXZlbnRfdjEuQ2FsbE1lbWJlcnNVcGRhdGVkSABSEmNhbGxNZW1iZXJzVXBkYXRlZBJpChRjYWxsX21lbWJlcnNfZGVsZXRlZBgiIAEoCzI1LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5ldmVudF92MS5DYWxsTWVtYmVyc0RlbGV0ZWRIAFISY2FsbE1lbWJlcnNEZWxldGVkEk0KCmNhbGxfZW5kZWQYJCABKAsyLC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuZXZlbnRfdjEuQ2FsbEVuZGVkSABSCWNhbGxFbmRlZBJWCg1jYWxsX2FjY2VwdGVkGCggASgLMi8uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmV2ZW50X3YxLkNhbGxBY2NlcHRlZEgAUgxjYWxsQWNjZXB0ZWQSVgoNY2FsbF9yZWplY3RlZBgpIAEoCzIvLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5ldmVudF92MS5DYWxsUmVqZWN0ZWRIAFIMY2FsbFJlamVjdGVkElkKDmNhbGxfY2FuY2VsbGVkGCogASgLMjAuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmV2ZW50X3YxLkNhbGxDYW5jZWxsZWRIAFINY2FsbENhbmNlbGxlZBJTCgx1c2VyX3VwZGF0ZWQYMiABKAsyLi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuZXZlbnRfdjEuVXNlclVwZGF0ZWRIAFILdXNlclVwZGF0ZWQaYAoKVXNlcnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRI8CgV2YWx1ZRgCIAEoCzImLnN0cmVhbS52aWRlby5jb29yZGluYXRvci51c2VyX3YxLlVzZXJSBXZhbHVlOgI4ARpgCgpDYWxsc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EjwKBXZhbHVlGAIgASgLMiYuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQ2FsbFIFdmFsdWU6AjgBGm0KEENhbGxEZXRhaWxzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSQwoFdmFsdWUYAiABKAsyLS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsRGV0YWlsc1IFdmFsdWU6AjgBQgcKBWV2ZW50');
@$core.Deprecated('Use websocketClientEventDescriptor instead')
const WebsocketClientEvent$json = const {
  '1': 'WebsocketClientEvent',
  '2': const [
    const {'1': 'healthcheck', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.WebsocketHealthcheck', '9': 0, '10': 'healthcheck'},
    const {'1': 'auth_request', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.client_v1_rpc.WebsocketAuthRequest', '9': 0, '10': 'authRequest'},
  ],
  '8': const [
    const {'1': 'event'},
  ],
};

/// Descriptor for `WebsocketClientEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List websocketClientEventDescriptor = $convert.base64Decode('ChRXZWJzb2NrZXRDbGllbnRFdmVudBJgCgtoZWFsdGhjaGVjaxgBIAEoCzI8LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLldlYnNvY2tldEhlYWx0aGNoZWNrSABSC2hlYWx0aGNoZWNrEmEKDGF1dGhfcmVxdWVzdBgCIAEoCzI8LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbGllbnRfdjFfcnBjLldlYnNvY2tldEF1dGhSZXF1ZXN0SABSC2F1dGhSZXF1ZXN0QgcKBWV2ZW50');
@$core.Deprecated('Use websocketAuthRequestDescriptor instead')
const WebsocketAuthRequest$json = const {
  '1': 'WebsocketAuthRequest',
  '2': const [
    const {'1': 'api_key', '3': 1, '4': 1, '5': 9, '10': 'apiKey'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'user', '3': 3, '4': 1, '5': 11, '6': '.stream.video.coordinator.user_v1.UserInput', '10': 'user'},
    const {'1': 'device', '3': 4, '4': 1, '5': 11, '6': '.stream.video.coordinator.push_v1.DeviceInput', '10': 'device'},
  ],
};

/// Descriptor for `WebsocketAuthRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List websocketAuthRequestDescriptor = $convert.base64Decode('ChRXZWJzb2NrZXRBdXRoUmVxdWVzdBIXCgdhcGlfa2V5GAEgASgJUgZhcGlLZXkSFAoFdG9rZW4YAiABKAlSBXRva2VuEj8KBHVzZXIYAyABKAsyKy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IudXNlcl92MS5Vc2VySW5wdXRSBHVzZXISRQoGZGV2aWNlGAQgASgLMi0uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnB1c2hfdjEuRGV2aWNlSW5wdXRSBmRldmljZQ==');
@$core.Deprecated('Use websocketHealthcheckDescriptor instead')
const WebsocketHealthcheck$json = const {
  '1': 'WebsocketHealthcheck',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'client_id', '3': 2, '4': 1, '5': 9, '10': 'clientId'},
    const {'1': 'call_type', '3': 3, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 4, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 'video', '3': 5, '4': 1, '5': 8, '10': 'video'},
    const {'1': 'audio', '3': 6, '4': 1, '5': 8, '10': 'audio'},
  ],
};

/// Descriptor for `WebsocketHealthcheck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List websocketHealthcheckDescriptor = $convert.base64Decode('ChRXZWJzb2NrZXRIZWFsdGhjaGVjaxIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSGwoJY2xpZW50X2lkGAIgASgJUghjbGllbnRJZBIbCgljYWxsX3R5cGUYAyABKAlSCGNhbGxUeXBlEhcKB2NhbGxfaWQYBCABKAlSBmNhbGxJZBIUCgV2aWRlbxgFIAEoCFIFdmlkZW8SFAoFYXVkaW8YBiABKAhSBWF1ZGlv');
