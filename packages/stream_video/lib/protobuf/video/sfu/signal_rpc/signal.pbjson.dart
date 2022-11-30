///
//  Generated code. Do not modify.
//  source: video/sfu/signal_rpc/signal.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
import '../models/models.pbjson.dart' as $0;

@$core.Deprecated('Use updateVideoQualityRequestDescriptor instead')
const UpdateVideoQualityRequest$json = const {
  '1': 'UpdateVideoQualityRequest',
  '2': const [
    const {'1': 'stream_qualities', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.models.StreamQuality', '10': 'streamQualities'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `UpdateVideoQualityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateVideoQualityRequestDescriptor = $convert.base64Decode('ChlVcGRhdGVWaWRlb1F1YWxpdHlSZXF1ZXN0ElEKEHN0cmVhbV9xdWFsaXRpZXMYASADKAsyJi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5TdHJlYW1RdWFsaXR5Ug9zdHJlYW1RdWFsaXRpZXMSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklk');
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
    const {'1': 'audio_mute_changed', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.signal.AudioMuteChanged', '9': 0, '10': 'audioMuteChanged'},
    const {'1': 'video_mute_changed', '3': 3, '4': 1, '5': 11, '6': '.stream.video.sfu.signal.VideoMuteChanged', '9': 0, '10': 'videoMuteChanged'},
  ],
  '8': const [
    const {'1': 'mute'},
  ],
};

/// Descriptor for `UpdateMuteStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMuteStateRequestDescriptor = $convert.base64Decode('ChZVcGRhdGVNdXRlU3RhdGVSZXF1ZXN0Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZBJZChJhdWRpb19tdXRlX2NoYW5nZWQYAiABKAsyKS5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5BdWRpb011dGVDaGFuZ2VkSABSEGF1ZGlvTXV0ZUNoYW5nZWQSWQoSdmlkZW9fbXV0ZV9jaGFuZ2VkGAMgASgLMikuc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuVmlkZW9NdXRlQ2hhbmdlZEgAUhB2aWRlb011dGVDaGFuZ2VkQgYKBG11dGU=');
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
    const {'1': 'subscriptions', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.signal.UpdateSubscriptionsRequest.SubscriptionsEntry', '10': 'subscriptions'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
  '3': const [UpdateSubscriptionsRequest_SubscriptionsEntry$json],
};

@$core.Deprecated('Use updateSubscriptionsRequestDescriptor instead')
const UpdateSubscriptionsRequest_SubscriptionsEntry$json = const {
  '1': 'SubscriptionsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.VideoDimension', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `UpdateSubscriptionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSubscriptionsRequestDescriptor = $convert.base64Decode('ChpVcGRhdGVTdWJzY3JpcHRpb25zUmVxdWVzdBJsCg1zdWJzY3JpcHRpb25zGAEgAygLMkYuc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuVXBkYXRlU3Vic2NyaXB0aW9uc1JlcXVlc3QuU3Vic2NyaXB0aW9uc0VudHJ5Ug1zdWJzY3JpcHRpb25zEh0KCnNlc3Npb25faWQYAiABKAlSCXNlc3Npb25JZBppChJTdWJzY3JpcHRpb25zRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSPQoFdmFsdWUYAiABKAsyJy5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5WaWRlb0RpbWVuc2lvblIFdmFsdWU6AjgB');
@$core.Deprecated('Use sendAnswerRequestDescriptor instead')
const SendAnswerRequest$json = const {
  '1': 'SendAnswerRequest',
  '2': const [
    const {'1': 'peer_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.PeerType', '10': 'peerType'},
    const {'1': 'sdp', '3': 2, '4': 1, '5': 9, '10': 'sdp'},
    const {'1': 'session_id', '3': 4, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `SendAnswerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendAnswerRequestDescriptor = $convert.base64Decode('ChFTZW5kQW5zd2VyUmVxdWVzdBI+CglwZWVyX3R5cGUYASABKA4yIS5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5QZWVyVHlwZVIIcGVlclR5cGUSEAoDc2RwGAIgASgJUgNzZHASHQoKc2Vzc2lvbl9pZBgEIAEoCVIJc2Vzc2lvbklk');
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
    const {'1': 'sdp_mid', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'sdpMid', '17': true},
    const {'1': 'sdp_mline_index', '3': 4, '4': 1, '5': 13, '9': 1, '10': 'sdpMlineIndex', '17': true},
    const {'1': 'username_fragment', '3': 5, '4': 1, '5': 9, '9': 2, '10': 'usernameFragment', '17': true},
    const {'1': 'session_id', '3': 7, '4': 1, '5': 9, '10': 'sessionId'},
  ],
  '8': const [
    const {'1': '_sdp_mid'},
    const {'1': '_sdp_mline_index'},
    const {'1': '_username_fragment'},
  ],
};

/// Descriptor for `IceCandidateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iceCandidateRequestDescriptor = $convert.base64Decode('ChNJY2VDYW5kaWRhdGVSZXF1ZXN0EhwKCXB1Ymxpc2hlchgBIAEoCFIJcHVibGlzaGVyEhwKCWNhbmRpZGF0ZRgCIAEoCVIJY2FuZGlkYXRlEhwKB3NkcF9taWQYAyABKAlIAFIGc2RwTWlkiAEBEisKD3NkcF9tbGluZV9pbmRleBgEIAEoDUgBUg1zZHBNbGluZUluZGV4iAEBEjAKEXVzZXJuYW1lX2ZyYWdtZW50GAUgASgJSAJSEHVzZXJuYW1lRnJhZ21lbnSIAQESHQoKc2Vzc2lvbl9pZBgHIAEoCVIJc2Vzc2lvbklkQgoKCF9zZHBfbWlkQhIKEF9zZHBfbWxpbmVfaW5kZXhCFAoSX3VzZXJuYW1lX2ZyYWdtZW50');
@$core.Deprecated('Use iCETrickleResponseDescriptor instead')
const ICETrickleResponse$json = const {
  '1': 'ICETrickleResponse',
};

/// Descriptor for `ICETrickleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCETrickleResponseDescriptor = $convert.base64Decode('ChJJQ0VUcmlja2xlUmVzcG9uc2U=');
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
    const {'1': 'subscribe', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.signal.SubscribeRequest', '9': 0, '10': 'subscribe'},
    const {'1': 'publish', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.signal.PublishRequest', '9': 0, '10': 'publish'},
  ],
  '8': const [
    const {'1': 'event_payload'},
  ],
};

/// Descriptor for `SignalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalRequestDescriptor = $convert.base64Decode('Cg1TaWduYWxSZXF1ZXN0EkkKCXN1YnNjcmliZRgBIAEoCzIpLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlN1YnNjcmliZVJlcXVlc3RIAFIJc3Vic2NyaWJlEkMKB3B1Ymxpc2gYAiABKAsyJy5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5QdWJsaXNoUmVxdWVzdEgAUgdwdWJsaXNoQg8KDWV2ZW50X3BheWxvYWQ=');
@$core.Deprecated('Use signalEventDescriptor instead')
const SignalEvent$json = const {
  '1': 'SignalEvent',
  '2': const [
    const {'1': 'subscribe', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.signal.SubscribeResponse', '9': 0, '10': 'subscribe'},
    const {'1': 'publish', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.signal.PublishResponse', '9': 0, '10': 'publish'},
  ],
  '8': const [
    const {'1': 'event_payload'},
  ],
};

/// Descriptor for `SignalEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalEventDescriptor = $convert.base64Decode('CgtTaWduYWxFdmVudBJKCglzdWJzY3JpYmUYASABKAsyKi5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5TdWJzY3JpYmVSZXNwb25zZUgAUglzdWJzY3JpYmUSRAoHcHVibGlzaBgCIAEoCzIoLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlB1Ymxpc2hSZXNwb25zZUgAUgdwdWJsaXNoQg8KDWV2ZW50X3BheWxvYWQ=');
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
    const {'1': 'SetPublisher', '2': '.stream.video.sfu.signal.SetPublisherRequest', '3': '.stream.video.sfu.signal.SetPublisherResponse'},
    const {'1': 'SendAnswer', '2': '.stream.video.sfu.signal.SendAnswerRequest', '3': '.stream.video.sfu.signal.SendAnswerResponse'},
    const {'1': 'IceTrickle', '2': '.stream.video.sfu.models.ICETrickle', '3': '.stream.video.sfu.signal.ICETrickleResponse'},
    const {'1': 'UpdateSubscriptions', '2': '.stream.video.sfu.signal.UpdateSubscriptionsRequest', '3': '.stream.video.sfu.signal.UpdateSubscriptionsResponse'},
    const {'1': 'UpdateMuteState', '2': '.stream.video.sfu.signal.UpdateMuteStateRequest', '3': '.stream.video.sfu.signal.UpdateMuteStateResponse'},
    const {'1': 'RequestVideoQuality', '2': '.stream.video.sfu.signal.UpdateVideoQualityRequest', '3': '.stream.video.sfu.signal.UpdateVideoQualityResponse'},
  ],
};

@$core.Deprecated('Use signalServerServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> SignalServerServiceBase$messageJson = const {
  '.stream.video.sfu.signal.SetPublisherRequest': SetPublisherRequest$json,
  '.stream.video.sfu.signal.SetPublisherResponse': SetPublisherResponse$json,
  '.stream.video.sfu.signal.SendAnswerRequest': SendAnswerRequest$json,
  '.stream.video.sfu.signal.SendAnswerResponse': SendAnswerResponse$json,
  '.stream.video.sfu.models.ICETrickle': $0.ICETrickle$json,
  '.stream.video.sfu.signal.ICETrickleResponse': ICETrickleResponse$json,
  '.stream.video.sfu.signal.UpdateSubscriptionsRequest': UpdateSubscriptionsRequest$json,
  '.stream.video.sfu.signal.UpdateSubscriptionsRequest.SubscriptionsEntry': UpdateSubscriptionsRequest_SubscriptionsEntry$json,
  '.stream.video.sfu.models.VideoDimension': $0.VideoDimension$json,
  '.stream.video.sfu.signal.UpdateSubscriptionsResponse': UpdateSubscriptionsResponse$json,
  '.stream.video.sfu.signal.UpdateMuteStateRequest': UpdateMuteStateRequest$json,
  '.stream.video.sfu.signal.AudioMuteChanged': AudioMuteChanged$json,
  '.stream.video.sfu.signal.VideoMuteChanged': VideoMuteChanged$json,
  '.stream.video.sfu.signal.UpdateMuteStateResponse': UpdateMuteStateResponse$json,
  '.stream.video.sfu.signal.UpdateVideoQualityRequest': UpdateVideoQualityRequest$json,
  '.stream.video.sfu.models.StreamQuality': $0.StreamQuality$json,
  '.stream.video.sfu.signal.UpdateVideoQualityResponse': UpdateVideoQualityResponse$json,
};

/// Descriptor for `SignalServer`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List signalServerServiceDescriptor = $convert.base64Decode('CgxTaWduYWxTZXJ2ZXISawoMU2V0UHVibGlzaGVyEiwuc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuU2V0UHVibGlzaGVyUmVxdWVzdBotLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlNldFB1Ymxpc2hlclJlc3BvbnNlEmUKClNlbmRBbnN3ZXISKi5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5TZW5kQW5zd2VyUmVxdWVzdBorLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlNlbmRBbnN3ZXJSZXNwb25zZRJeCgpJY2VUcmlja2xlEiMuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuSUNFVHJpY2tsZRorLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLklDRVRyaWNrbGVSZXNwb25zZRKAAQoTVXBkYXRlU3Vic2NyaXB0aW9ucxIzLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlVwZGF0ZVN1YnNjcmlwdGlvbnNSZXF1ZXN0GjQuc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuVXBkYXRlU3Vic2NyaXB0aW9uc1Jlc3BvbnNlEnQKD1VwZGF0ZU11dGVTdGF0ZRIvLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlVwZGF0ZU11dGVTdGF0ZVJlcXVlc3QaMC5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5VcGRhdGVNdXRlU3RhdGVSZXNwb25zZRJ+ChNSZXF1ZXN0VmlkZW9RdWFsaXR5EjIuc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuVXBkYXRlVmlkZW9RdWFsaXR5UmVxdWVzdBozLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlVwZGF0ZVZpZGVvUXVhbGl0eVJlc3BvbnNl');
