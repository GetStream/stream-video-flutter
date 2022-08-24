///
//  Generated code. Do not modify.
//  source: sfu_signal_rpc/signal.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
import '../sfu_models/models.pbjson.dart' as $1;
import '../google/protobuf/struct.pbjson.dart' as $0;

@$core.Deprecated('Use updateVideoQualityRequestDescriptor instead')
const UpdateVideoQualityRequest$json = const {
  '1': 'UpdateVideoQualityRequest',
  '2': const [
    const {'1': 'stream_qualities', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.StreamQuality', '10': 'streamQualities'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `UpdateVideoQualityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateVideoQualityRequestDescriptor = $convert.base64Decode('ChlVcGRhdGVWaWRlb1F1YWxpdHlSZXF1ZXN0EkoKEHN0cmVhbV9xdWFsaXRpZXMYASADKAsyHy5zdHJlYW0udmlkZW8uc2Z1LlN0cmVhbVF1YWxpdHlSD3N0cmVhbVF1YWxpdGllcxIdCgpzZXNzaW9uX2lkGAIgASgJUglzZXNzaW9uSWQ=');
@$core.Deprecated('Use updateVideoQualityResponseDescriptor instead')
const UpdateVideoQualityResponse$json = const {
  '1': 'UpdateVideoQualityResponse',
};

/// Descriptor for `UpdateVideoQualityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateVideoQualityResponseDescriptor = $convert.base64Decode('ChpVcGRhdGVWaWRlb1F1YWxpdHlSZXNwb25zZQ==');
@$core.Deprecated('Use updateMuteStateRequestDescriptor instead')
const UpdateMuteStateRequest$json = const {
  '1': 'UpdateMuteStateRequest',
  '2': const [
    const {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'audio_mute_changed', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.AudioMuteChanged', '9': 0, '10': 'audioMuteChanged'},
    const {'1': 'video_mute_changed', '3': 3, '4': 1, '5': 11, '6': '.stream.video.sfu.VideoMuteChanged', '9': 0, '10': 'videoMuteChanged'},
  ],
  '8': const [
    const {'1': 'mute'},
  ],
};

/// Descriptor for `UpdateMuteStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMuteStateRequestDescriptor = $convert.base64Decode('ChZVcGRhdGVNdXRlU3RhdGVSZXF1ZXN0Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZBJSChJhdWRpb19tdXRlX2NoYW5nZWQYAiABKAsyIi5zdHJlYW0udmlkZW8uc2Z1LkF1ZGlvTXV0ZUNoYW5nZWRIAFIQYXVkaW9NdXRlQ2hhbmdlZBJSChJ2aWRlb19tdXRlX2NoYW5nZWQYAyABKAsyIi5zdHJlYW0udmlkZW8uc2Z1LlZpZGVvTXV0ZUNoYW5nZWRIAFIQdmlkZW9NdXRlQ2hhbmdlZEIGCgRtdXRl');
@$core.Deprecated('Use updateMuteStateResponseDescriptor instead')
const UpdateMuteStateResponse$json = const {
  '1': 'UpdateMuteStateResponse',
};

/// Descriptor for `UpdateMuteStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMuteStateResponseDescriptor = $convert.base64Decode('ChdVcGRhdGVNdXRlU3RhdGVSZXNwb25zZQ==');
@$core.Deprecated('Use audioMuteChangedDescriptor instead')
const AudioMuteChanged$json = const {
  '1': 'AudioMuteChanged',
  '2': const [
    const {'1': 'muted', '3': 1, '4': 1, '5': 8, '10': 'muted'},
  ],
};

/// Descriptor for `AudioMuteChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioMuteChangedDescriptor = $convert.base64Decode('ChBBdWRpb011dGVDaGFuZ2VkEhQKBW11dGVkGAEgASgIUgVtdXRlZA==');
@$core.Deprecated('Use videoMuteChangedDescriptor instead')
const VideoMuteChanged$json = const {
  '1': 'VideoMuteChanged',
  '2': const [
    const {'1': 'muted', '3': 2, '4': 1, '5': 8, '10': 'muted'},
  ],
};

/// Descriptor for `VideoMuteChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoMuteChangedDescriptor = $convert.base64Decode('ChBWaWRlb011dGVDaGFuZ2VkEhQKBW11dGVkGAIgASgIUgVtdXRlZA==');
@$core.Deprecated('Use updateSubscriptionsRequestDescriptor instead')
const UpdateSubscriptionsRequest$json = const {
  '1': 'UpdateSubscriptionsRequest',
  '2': const [
    const {'1': 'subscriptions', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.UpdateSubscriptionsRequest.SubscriptionsEntry', '10': 'subscriptions'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
  '3': const [UpdateSubscriptionsRequest_SubscriptionsEntry$json],
};

@$core.Deprecated('Use updateSubscriptionsRequestDescriptor instead')
const UpdateSubscriptionsRequest_SubscriptionsEntry$json = const {
  '1': 'SubscriptionsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.VideoDimension', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `UpdateSubscriptionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSubscriptionsRequestDescriptor = $convert.base64Decode('ChpVcGRhdGVTdWJzY3JpcHRpb25zUmVxdWVzdBJlCg1zdWJzY3JpcHRpb25zGAEgAygLMj8uc3RyZWFtLnZpZGVvLnNmdS5VcGRhdGVTdWJzY3JpcHRpb25zUmVxdWVzdC5TdWJzY3JpcHRpb25zRW50cnlSDXN1YnNjcmlwdGlvbnMSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkGmIKElN1YnNjcmlwdGlvbnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRI2CgV2YWx1ZRgCIAEoCzIgLnN0cmVhbS52aWRlby5zZnUuVmlkZW9EaW1lbnNpb25SBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use sendAnswerRequestDescriptor instead')
const SendAnswerRequest$json = const {
  '1': 'SendAnswerRequest',
  '2': const [
    const {'1': 'peer_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.PeerType', '10': 'peerType'},
    const {'1': 'sdp', '3': 2, '4': 1, '5': 9, '10': 'sdp'},
    const {'1': 'session_id', '3': 4, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `SendAnswerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendAnswerRequestDescriptor = $convert.base64Decode('ChFTZW5kQW5zd2VyUmVxdWVzdBI3CglwZWVyX3R5cGUYASABKA4yGi5zdHJlYW0udmlkZW8uc2Z1LlBlZXJUeXBlUghwZWVyVHlwZRIQCgNzZHAYAiABKAlSA3NkcBIdCgpzZXNzaW9uX2lkGAQgASgJUglzZXNzaW9uSWQ=');
@$core.Deprecated('Use sendAnswerResponseDescriptor instead')
const SendAnswerResponse$json = const {
  '1': 'SendAnswerResponse',
};

/// Descriptor for `SendAnswerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendAnswerResponseDescriptor = $convert.base64Decode('ChJTZW5kQW5zd2VyUmVzcG9uc2U=');
@$core.Deprecated('Use iceCandidateRequestDescriptor instead')
const IceCandidateRequest$json = const {
  '1': 'IceCandidateRequest',
  '2': const [
    const {'1': 'publisher', '3': 1, '4': 1, '5': 8, '10': 'publisher'},
    const {'1': 'candidate', '3': 2, '4': 1, '5': 9, '10': 'candidate'},
    const {'1': 'sdpMid', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'sdpMid', '17': true},
    const {'1': 'sdpMLineIndex', '3': 4, '4': 1, '5': 13, '9': 1, '10': 'sdpMLineIndex', '17': true},
    const {'1': 'usernameFragment', '3': 5, '4': 1, '5': 9, '9': 2, '10': 'usernameFragment', '17': true},
    const {'1': 'session_id', '3': 7, '4': 1, '5': 9, '10': 'sessionId'},
  ],
  '8': const [
    const {'1': '_sdpMid'},
    const {'1': '_sdpMLineIndex'},
    const {'1': '_usernameFragment'},
  ],
};

/// Descriptor for `IceCandidateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iceCandidateRequestDescriptor = $convert.base64Decode('ChNJY2VDYW5kaWRhdGVSZXF1ZXN0EhwKCXB1Ymxpc2hlchgBIAEoCFIJcHVibGlzaGVyEhwKCWNhbmRpZGF0ZRgCIAEoCVIJY2FuZGlkYXRlEhsKBnNkcE1pZBgDIAEoCUgAUgZzZHBNaWSIAQESKQoNc2RwTUxpbmVJbmRleBgEIAEoDUgBUg1zZHBNTGluZUluZGV4iAEBEi8KEHVzZXJuYW1lRnJhZ21lbnQYBSABKAlIAlIQdXNlcm5hbWVGcmFnbWVudIgBARIdCgpzZXNzaW9uX2lkGAcgASgJUglzZXNzaW9uSWRCCQoHX3NkcE1pZEIQCg5fc2RwTUxpbmVJbmRleEITChFfdXNlcm5hbWVGcmFnbWVudA==');
@$core.Deprecated('Use iceCandidateResponseDescriptor instead')
const IceCandidateResponse$json = const {
  '1': 'IceCandidateResponse',
};

/// Descriptor for `IceCandidateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iceCandidateResponseDescriptor = $convert.base64Decode('ChRJY2VDYW5kaWRhdGVSZXNwb25zZQ==');
@$core.Deprecated('Use updateSubscriptionsResponseDescriptor instead')
const UpdateSubscriptionsResponse$json = const {
  '1': 'UpdateSubscriptionsResponse',
};

/// Descriptor for `UpdateSubscriptionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSubscriptionsResponseDescriptor = $convert.base64Decode('ChtVcGRhdGVTdWJzY3JpcHRpb25zUmVzcG9uc2U=');
@$core.Deprecated('Use setPublisherRequestDescriptor instead')
const SetPublisherRequest$json = const {
  '1': 'SetPublisherRequest',
  '2': const [
    const {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `SetPublisherRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setPublisherRequestDescriptor = $convert.base64Decode('ChNTZXRQdWJsaXNoZXJSZXF1ZXN0EhAKA3NkcBgBIAEoCVIDc2RwEh0KCnNlc3Npb25faWQYAyABKAlSCXNlc3Npb25JZA==');
@$core.Deprecated('Use setPublisherResponseDescriptor instead')
const SetPublisherResponse$json = const {
  '1': 'SetPublisherResponse',
  '2': const [
    const {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `SetPublisherResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setPublisherResponseDescriptor = $convert.base64Decode('ChRTZXRQdWJsaXNoZXJSZXNwb25zZRIQCgNzZHAYASABKAlSA3NkcBIdCgpzZXNzaW9uX2lkGAMgASgJUglzZXNzaW9uSWQ=');
@$core.Deprecated('Use joinRequestDescriptor instead')
const JoinRequest$json = const {
  '1': 'JoinRequest',
  '2': const [
    const {'1': 'subscriber_sdp_offer', '3': 1, '4': 1, '5': 9, '10': 'subscriberSdpOffer'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `JoinRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRequestDescriptor = $convert.base64Decode('CgtKb2luUmVxdWVzdBIwChRzdWJzY3JpYmVyX3NkcF9vZmZlchgBIAEoCVISc3Vic2NyaWJlclNkcE9mZmVyEh0KCnNlc3Npb25faWQYAyABKAlSCXNlc3Npb25JZA==');
@$core.Deprecated('Use joinResponseDescriptor instead')
const JoinResponse$json = const {
  '1': 'JoinResponse',
  '2': const [
    const {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
    const {'1': 'call_state', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.CallState', '10': 'callState'},
  ],
};

/// Descriptor for `JoinResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinResponseDescriptor = $convert.base64Decode('CgxKb2luUmVzcG9uc2USEAoDc2RwGAEgASgJUgNzZHASOgoKY2FsbF9zdGF0ZRgCIAEoCzIbLnN0cmVhbS52aWRlby5zZnUuQ2FsbFN0YXRlUgljYWxsU3RhdGU=');
@$core.Deprecated('Use connectRequestDescriptor instead')
const ConnectRequest$json = const {
  '1': 'ConnectRequest',
  '2': const [
    const {'1': 'sdp_offer', '3': 1, '4': 1, '5': 9, '10': 'sdpOffer'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `ConnectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectRequestDescriptor = $convert.base64Decode('Cg5Db25uZWN0UmVxdWVzdBIbCglzZHBfb2ZmZXIYASABKAlSCHNkcE9mZmVyEhQKBXRva2VuGAIgASgJUgV0b2tlbg==');
@$core.Deprecated('Use connectResponseDescriptor instead')
const ConnectResponse$json = const {
  '1': 'ConnectResponse',
  '2': const [
    const {'1': 'sdp_answer', '3': 1, '4': 1, '5': 9, '10': 'sdpAnswer'},
  ],
};

/// Descriptor for `ConnectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectResponseDescriptor = $convert.base64Decode('Cg9Db25uZWN0UmVzcG9uc2USHQoKc2RwX2Fuc3dlchgBIAEoCVIJc2RwQW5zd2Vy');
@$core.Deprecated('Use signalRequestDescriptor instead')
const SignalRequest$json = const {
  '1': 'SignalRequest',
  '2': const [
    const {'1': 'subscribe', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.SubscribeRequest', '9': 0, '10': 'subscribe'},
    const {'1': 'publish', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.PublishRequest', '9': 0, '10': 'publish'},
  ],
  '8': const [
    const {'1': 'event_payload'},
  ],
};

/// Descriptor for `SignalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalRequestDescriptor = $convert.base64Decode('Cg1TaWduYWxSZXF1ZXN0EkIKCXN1YnNjcmliZRgBIAEoCzIiLnN0cmVhbS52aWRlby5zZnUuU3Vic2NyaWJlUmVxdWVzdEgAUglzdWJzY3JpYmUSPAoHcHVibGlzaBgCIAEoCzIgLnN0cmVhbS52aWRlby5zZnUuUHVibGlzaFJlcXVlc3RIAFIHcHVibGlzaEIPCg1ldmVudF9wYXlsb2Fk');
@$core.Deprecated('Use signalEventDescriptor instead')
const SignalEvent$json = const {
  '1': 'SignalEvent',
  '2': const [
    const {'1': 'subscribe', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.SubscribeResponse', '9': 0, '10': 'subscribe'},
    const {'1': 'publish', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.PublishResponse', '9': 0, '10': 'publish'},
  ],
  '8': const [
    const {'1': 'event_payload'},
  ],
};

/// Descriptor for `SignalEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalEventDescriptor = $convert.base64Decode('CgtTaWduYWxFdmVudBJDCglzdWJzY3JpYmUYASABKAsyIy5zdHJlYW0udmlkZW8uc2Z1LlN1YnNjcmliZVJlc3BvbnNlSABSCXN1YnNjcmliZRI9CgdwdWJsaXNoGAIgASgLMiEuc3RyZWFtLnZpZGVvLnNmdS5QdWJsaXNoUmVzcG9uc2VIAFIHcHVibGlzaEIPCg1ldmVudF9wYXlsb2Fk');
@$core.Deprecated('Use subscribeRequestDescriptor instead')
const SubscribeRequest$json = const {
  '1': 'SubscribeRequest',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'sdp_offer', '3': 2, '4': 1, '5': 9, '10': 'sdpOffer'},
    const {'1': 'quality', '3': 3, '4': 1, '5': 9, '10': 'quality'},
  ],
};

/// Descriptor for `SubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeRequestDescriptor = $convert.base64Decode('ChBTdWJzY3JpYmVSZXF1ZXN0EhQKBXRva2VuGAEgASgJUgV0b2tlbhIbCglzZHBfb2ZmZXIYAiABKAlSCHNkcE9mZmVyEhgKB3F1YWxpdHkYAyABKAlSB3F1YWxpdHk=');
@$core.Deprecated('Use subscribeResponseDescriptor instead')
const SubscribeResponse$json = const {
  '1': 'SubscribeResponse',
  '2': const [
    const {'1': 'quality', '3': 2, '4': 1, '5': 9, '10': 'quality'},
  ],
};

/// Descriptor for `SubscribeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeResponseDescriptor = $convert.base64Decode('ChFTdWJzY3JpYmVSZXNwb25zZRIYCgdxdWFsaXR5GAIgASgJUgdxdWFsaXR5');
@$core.Deprecated('Use publishRequestDescriptor instead')
const PublishRequest$json = const {
  '1': 'PublishRequest',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'sdp_offer', '3': 2, '4': 1, '5': 9, '10': 'sdpOffer'},
  ],
};

/// Descriptor for `PublishRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishRequestDescriptor = $convert.base64Decode('Cg5QdWJsaXNoUmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4SGwoJc2RwX29mZmVyGAIgASgJUghzZHBPZmZlcg==');
@$core.Deprecated('Use publishResponseDescriptor instead')
const PublishResponse$json = const {
  '1': 'PublishResponse',
  '2': const [
    const {'1': 'sdp_answer', '3': 2, '4': 1, '5': 9, '10': 'sdpAnswer'},
  ],
};

/// Descriptor for `PublishResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishResponseDescriptor = $convert.base64Decode('Cg9QdWJsaXNoUmVzcG9uc2USHQoKc2RwX2Fuc3dlchgCIAEoCVIJc2RwQW5zd2Vy');
const $core.Map<$core.String, $core.dynamic> SignalServerServiceBase$json = const {
  '1': 'SignalServer',
  '2': const [
    const {'1': 'Join', '2': '.stream.video.sfu.JoinRequest', '3': '.stream.video.sfu.JoinResponse'},
    const {'1': 'SetPublisher', '2': '.stream.video.sfu.SetPublisherRequest', '3': '.stream.video.sfu.SetPublisherResponse'},
    const {'1': 'SendAnswer', '2': '.stream.video.sfu.SendAnswerRequest', '3': '.stream.video.sfu.SendAnswerResponse'},
    const {'1': 'SendIceCandidate', '2': '.stream.video.sfu.IceCandidateRequest', '3': '.stream.video.sfu.IceCandidateResponse'},
    const {'1': 'UpdateSubscriptions', '2': '.stream.video.sfu.UpdateSubscriptionsRequest', '3': '.stream.video.sfu.UpdateSubscriptionsResponse'},
    const {'1': 'UpdateMuteState', '2': '.stream.video.sfu.UpdateMuteStateRequest', '3': '.stream.video.sfu.UpdateMuteStateResponse'},
    const {'1': 'RequestVideoQuality', '2': '.stream.video.sfu.UpdateVideoQualityRequest', '3': '.stream.video.sfu.UpdateVideoQualityResponse'},
  ],
};

@$core.Deprecated('Use signalServerServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> SignalServerServiceBase$messageJson = const {
  '.stream.video.sfu.JoinRequest': JoinRequest$json,
  '.stream.video.sfu.JoinResponse': JoinResponse$json,
  '.stream.video.sfu.CallState': $1.CallState$json,
  '.stream.video.sfu.Participant': $1.Participant$json,
  '.stream.video.sfu.User': $1.User$json,
  '.google.protobuf.Struct': $0.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $0.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $0.Value$json,
  '.google.protobuf.ListValue': $0.ListValue$json,
  '.stream.video.sfu.SetPublisherRequest': SetPublisherRequest$json,
  '.stream.video.sfu.SetPublisherResponse': SetPublisherResponse$json,
  '.stream.video.sfu.SendAnswerRequest': SendAnswerRequest$json,
  '.stream.video.sfu.SendAnswerResponse': SendAnswerResponse$json,
  '.stream.video.sfu.IceCandidateRequest': IceCandidateRequest$json,
  '.stream.video.sfu.IceCandidateResponse': IceCandidateResponse$json,
  '.stream.video.sfu.UpdateSubscriptionsRequest': UpdateSubscriptionsRequest$json,
  '.stream.video.sfu.UpdateSubscriptionsRequest.SubscriptionsEntry': UpdateSubscriptionsRequest_SubscriptionsEntry$json,
  '.stream.video.sfu.VideoDimension': $1.VideoDimension$json,
  '.stream.video.sfu.UpdateSubscriptionsResponse': UpdateSubscriptionsResponse$json,
  '.stream.video.sfu.UpdateMuteStateRequest': UpdateMuteStateRequest$json,
  '.stream.video.sfu.AudioMuteChanged': AudioMuteChanged$json,
  '.stream.video.sfu.VideoMuteChanged': VideoMuteChanged$json,
  '.stream.video.sfu.UpdateMuteStateResponse': UpdateMuteStateResponse$json,
  '.stream.video.sfu.UpdateVideoQualityRequest': UpdateVideoQualityRequest$json,
  '.stream.video.sfu.StreamQuality': $1.StreamQuality$json,
  '.stream.video.sfu.UpdateVideoQualityResponse': UpdateVideoQualityResponse$json,
};

/// Descriptor for `SignalServer`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List signalServerServiceDescriptor = $convert.base64Decode('CgxTaWduYWxTZXJ2ZXISRQoESm9pbhIdLnN0cmVhbS52aWRlby5zZnUuSm9pblJlcXVlc3QaHi5zdHJlYW0udmlkZW8uc2Z1LkpvaW5SZXNwb25zZRJdCgxTZXRQdWJsaXNoZXISJS5zdHJlYW0udmlkZW8uc2Z1LlNldFB1Ymxpc2hlclJlcXVlc3QaJi5zdHJlYW0udmlkZW8uc2Z1LlNldFB1Ymxpc2hlclJlc3BvbnNlElcKClNlbmRBbnN3ZXISIy5zdHJlYW0udmlkZW8uc2Z1LlNlbmRBbnN3ZXJSZXF1ZXN0GiQuc3RyZWFtLnZpZGVvLnNmdS5TZW5kQW5zd2VyUmVzcG9uc2USYQoQU2VuZEljZUNhbmRpZGF0ZRIlLnN0cmVhbS52aWRlby5zZnUuSWNlQ2FuZGlkYXRlUmVxdWVzdBomLnN0cmVhbS52aWRlby5zZnUuSWNlQ2FuZGlkYXRlUmVzcG9uc2UScgoTVXBkYXRlU3Vic2NyaXB0aW9ucxIsLnN0cmVhbS52aWRlby5zZnUuVXBkYXRlU3Vic2NyaXB0aW9uc1JlcXVlc3QaLS5zdHJlYW0udmlkZW8uc2Z1LlVwZGF0ZVN1YnNjcmlwdGlvbnNSZXNwb25zZRJmCg9VcGRhdGVNdXRlU3RhdGUSKC5zdHJlYW0udmlkZW8uc2Z1LlVwZGF0ZU11dGVTdGF0ZVJlcXVlc3QaKS5zdHJlYW0udmlkZW8uc2Z1LlVwZGF0ZU11dGVTdGF0ZVJlc3BvbnNlEnAKE1JlcXVlc3RWaWRlb1F1YWxpdHkSKy5zdHJlYW0udmlkZW8uc2Z1LlVwZGF0ZVZpZGVvUXVhbGl0eVJlcXVlc3QaLC5zdHJlYW0udmlkZW8uc2Z1LlVwZGF0ZVZpZGVvUXVhbGl0eVJlc3BvbnNl');
