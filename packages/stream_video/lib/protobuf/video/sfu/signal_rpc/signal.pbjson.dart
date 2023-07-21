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

@$core.Deprecated('Use iCERestartRequestDescriptor instead')
const ICERestartRequest$json = const {
  '1': 'ICERestartRequest',
  '2': const [
    const {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'peer_type', '3': 2, '4': 1, '5': 14, '6': '.stream.video.sfu.models.PeerType', '10': 'peerType'},
  ],
};

/// Descriptor for `ICERestartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCERestartRequestDescriptor = $convert.base64Decode('ChFJQ0VSZXN0YXJ0UmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSPgoJcGVlcl90eXBlGAIgASgOMiEuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuUGVlclR5cGVSCHBlZXJUeXBl');
@$core.Deprecated('Use iCERestartResponseDescriptor instead')
const ICERestartResponse$json = const {
  '1': 'ICERestartResponse',
  '2': const [
    const {'1': 'error', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `ICERestartResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCERestartResponseDescriptor = $convert.base64Decode('ChJJQ0VSZXN0YXJ0UmVzcG9uc2USNAoFZXJyb3IYASABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5FcnJvclIFZXJyb3I=');
@$core.Deprecated('Use updateMuteStatesRequestDescriptor instead')
const UpdateMuteStatesRequest$json = const {
  '1': 'UpdateMuteStatesRequest',
  '2': const [
    const {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'mute_states', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.signal.TrackMuteState', '10': 'muteStates'},
  ],
};

/// Descriptor for `UpdateMuteStatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMuteStatesRequestDescriptor = $convert.base64Decode('ChdVcGRhdGVNdXRlU3RhdGVzUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSSAoLbXV0ZV9zdGF0ZXMYAyADKAsyJy5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5UcmFja011dGVTdGF0ZVIKbXV0ZVN0YXRlcw==');
@$core.Deprecated('Use updateMuteStatesResponseDescriptor instead')
const UpdateMuteStatesResponse$json = const {
  '1': 'UpdateMuteStatesResponse',
  '2': const [
    const {'1': 'error', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `UpdateMuteStatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMuteStatesResponseDescriptor = $convert.base64Decode('ChhVcGRhdGVNdXRlU3RhdGVzUmVzcG9uc2USNAoFZXJyb3IYBCABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5FcnJvclIFZXJyb3I=');
@$core.Deprecated('Use trackMuteStateDescriptor instead')
const TrackMuteState$json = const {
  '1': 'TrackMuteState',
  '2': const [
    const {'1': 'track_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.TrackType', '10': 'trackType'},
    const {'1': 'muted', '3': 2, '4': 1, '5': 8, '10': 'muted'},
  ],
};

/// Descriptor for `TrackMuteState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackMuteStateDescriptor = $convert.base64Decode('Cg5UcmFja011dGVTdGF0ZRJBCgp0cmFja190eXBlGAEgASgOMiIuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuVHJhY2tUeXBlUgl0cmFja1R5cGUSFAoFbXV0ZWQYAiABKAhSBW11dGVk');
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
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'tracks', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.signal.TrackSubscriptionDetails', '10': 'tracks'},
  ],
};

/// Descriptor for `UpdateSubscriptionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSubscriptionsRequestDescriptor = $convert.base64Decode('ChpVcGRhdGVTdWJzY3JpcHRpb25zUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAIgASgJUglzZXNzaW9uSWQSSQoGdHJhY2tzGAMgAygLMjEuc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuVHJhY2tTdWJzY3JpcHRpb25EZXRhaWxzUgZ0cmFja3M=');
@$core.Deprecated('Use updateSubscriptionsResponseDescriptor instead')
const UpdateSubscriptionsResponse$json = const {
  '1': 'UpdateSubscriptionsResponse',
  '2': const [
    const {'1': 'error', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `UpdateSubscriptionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSubscriptionsResponseDescriptor = $convert.base64Decode('ChtVcGRhdGVTdWJzY3JpcHRpb25zUmVzcG9uc2USNAoFZXJyb3IYBCABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5FcnJvclIFZXJyb3I=');
@$core.Deprecated('Use trackSubscriptionDetailsDescriptor instead')
const TrackSubscriptionDetails$json = const {
  '1': 'TrackSubscriptionDetails',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'track_type', '3': 3, '4': 1, '5': 14, '6': '.stream.video.sfu.models.TrackType', '10': 'trackType'},
    const {'1': 'dimension', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.VideoDimension', '10': 'dimension'},
  ],
};

/// Descriptor for `TrackSubscriptionDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackSubscriptionDetailsDescriptor = $convert.base64Decode('ChhUcmFja1N1YnNjcmlwdGlvbkRldGFpbHMSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEh0KCnNlc3Npb25faWQYAiABKAlSCXNlc3Npb25JZBJBCgp0cmFja190eXBlGAMgASgOMiIuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuVHJhY2tUeXBlUgl0cmFja1R5cGUSRQoJZGltZW5zaW9uGAQgASgLMicuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuVmlkZW9EaW1lbnNpb25SCWRpbWVuc2lvbg==');
@$core.Deprecated('Use sendAnswerRequestDescriptor instead')
const SendAnswerRequest$json = const {
  '1': 'SendAnswerRequest',
  '2': const [
    const {'1': 'peer_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.PeerType', '10': 'peerType'},
    const {'1': 'sdp', '3': 2, '4': 1, '5': 9, '10': 'sdp'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `SendAnswerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendAnswerRequestDescriptor = $convert.base64Decode('ChFTZW5kQW5zd2VyUmVxdWVzdBI+CglwZWVyX3R5cGUYASABKA4yIS5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5QZWVyVHlwZVIIcGVlclR5cGUSEAoDc2RwGAIgASgJUgNzZHASHQoKc2Vzc2lvbl9pZBgDIAEoCVIJc2Vzc2lvbklk');
@$core.Deprecated('Use sendAnswerResponseDescriptor instead')
const SendAnswerResponse$json = const {
  '1': 'SendAnswerResponse',
  '2': const [
    const {'1': 'error', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `SendAnswerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendAnswerResponseDescriptor = $convert.base64Decode('ChJTZW5kQW5zd2VyUmVzcG9uc2USNAoFZXJyb3IYBCABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5FcnJvclIFZXJyb3I=');
@$core.Deprecated('Use iCETrickleResponseDescriptor instead')
const ICETrickleResponse$json = const {
  '1': 'ICETrickleResponse',
  '2': const [
    const {'1': 'error', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `ICETrickleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCETrickleResponseDescriptor = $convert.base64Decode('ChJJQ0VUcmlja2xlUmVzcG9uc2USNAoFZXJyb3IYBCABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5FcnJvclIFZXJyb3I=');
@$core.Deprecated('Use setPublisherRequestDescriptor instead')
const SetPublisherRequest$json = const {
  '1': 'SetPublisherRequest',
  '2': const [
    const {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'tracks', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.models.TrackInfo', '10': 'tracks'},
  ],
};

/// Descriptor for `SetPublisherRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setPublisherRequestDescriptor = $convert.base64Decode('ChNTZXRQdWJsaXNoZXJSZXF1ZXN0EhAKA3NkcBgBIAEoCVIDc2RwEh0KCnNlc3Npb25faWQYAiABKAlSCXNlc3Npb25JZBI6CgZ0cmFja3MYAyADKAsyIi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5UcmFja0luZm9SBnRyYWNrcw==');
@$core.Deprecated('Use setPublisherResponseDescriptor instead')
const SetPublisherResponse$json = const {
  '1': 'SetPublisherResponse',
  '2': const [
    const {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'ice_restart', '3': 3, '4': 1, '5': 8, '10': 'iceRestart'},
    const {'1': 'error', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `SetPublisherResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setPublisherResponseDescriptor = $convert.base64Decode('ChRTZXRQdWJsaXNoZXJSZXNwb25zZRIQCgNzZHAYASABKAlSA3NkcBIdCgpzZXNzaW9uX2lkGAIgASgJUglzZXNzaW9uSWQSHwoLaWNlX3Jlc3RhcnQYAyABKAhSCmljZVJlc3RhcnQSNAoFZXJyb3IYBCABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5FcnJvclIFZXJyb3I=');
const $core.Map<$core.String, $core.dynamic> SignalServerServiceBase$json = const {
  '1': 'SignalServer',
  '2': const [
    const {'1': 'SetPublisher', '2': '.stream.video.sfu.signal.SetPublisherRequest', '3': '.stream.video.sfu.signal.SetPublisherResponse'},
    const {'1': 'SendAnswer', '2': '.stream.video.sfu.signal.SendAnswerRequest', '3': '.stream.video.sfu.signal.SendAnswerResponse'},
    const {'1': 'IceTrickle', '2': '.stream.video.sfu.models.ICETrickle', '3': '.stream.video.sfu.signal.ICETrickleResponse'},
    const {'1': 'UpdateSubscriptions', '2': '.stream.video.sfu.signal.UpdateSubscriptionsRequest', '3': '.stream.video.sfu.signal.UpdateSubscriptionsResponse'},
    const {'1': 'UpdateMuteStates', '2': '.stream.video.sfu.signal.UpdateMuteStatesRequest', '3': '.stream.video.sfu.signal.UpdateMuteStatesResponse'},
    const {'1': 'IceRestart', '2': '.stream.video.sfu.signal.ICERestartRequest', '3': '.stream.video.sfu.signal.ICERestartResponse'},
  ],
};

@$core.Deprecated('Use signalServerServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> SignalServerServiceBase$messageJson = const {
  '.stream.video.sfu.signal.SetPublisherRequest': SetPublisherRequest$json,
  '.stream.video.sfu.models.TrackInfo': $0.TrackInfo$json,
  '.stream.video.sfu.models.VideoLayer': $0.VideoLayer$json,
  '.stream.video.sfu.models.VideoDimension': $0.VideoDimension$json,
  '.stream.video.sfu.signal.SetPublisherResponse': SetPublisherResponse$json,
  '.stream.video.sfu.models.Error': $0.Error$json,
  '.stream.video.sfu.signal.SendAnswerRequest': SendAnswerRequest$json,
  '.stream.video.sfu.signal.SendAnswerResponse': SendAnswerResponse$json,
  '.stream.video.sfu.models.ICETrickle': $0.ICETrickle$json,
  '.stream.video.sfu.signal.ICETrickleResponse': ICETrickleResponse$json,
  '.stream.video.sfu.signal.UpdateSubscriptionsRequest': UpdateSubscriptionsRequest$json,
  '.stream.video.sfu.signal.TrackSubscriptionDetails': TrackSubscriptionDetails$json,
  '.stream.video.sfu.signal.UpdateSubscriptionsResponse': UpdateSubscriptionsResponse$json,
  '.stream.video.sfu.signal.UpdateMuteStatesRequest': UpdateMuteStatesRequest$json,
  '.stream.video.sfu.signal.TrackMuteState': TrackMuteState$json,
  '.stream.video.sfu.signal.UpdateMuteStatesResponse': UpdateMuteStatesResponse$json,
  '.stream.video.sfu.signal.ICERestartRequest': ICERestartRequest$json,
  '.stream.video.sfu.signal.ICERestartResponse': ICERestartResponse$json,
};

/// Descriptor for `SignalServer`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List signalServerServiceDescriptor = $convert.base64Decode('CgxTaWduYWxTZXJ2ZXISawoMU2V0UHVibGlzaGVyEiwuc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuU2V0UHVibGlzaGVyUmVxdWVzdBotLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlNldFB1Ymxpc2hlclJlc3BvbnNlEmUKClNlbmRBbnN3ZXISKi5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5TZW5kQW5zd2VyUmVxdWVzdBorLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlNlbmRBbnN3ZXJSZXNwb25zZRJeCgpJY2VUcmlja2xlEiMuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuSUNFVHJpY2tsZRorLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLklDRVRyaWNrbGVSZXNwb25zZRKAAQoTVXBkYXRlU3Vic2NyaXB0aW9ucxIzLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlVwZGF0ZVN1YnNjcmlwdGlvbnNSZXF1ZXN0GjQuc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuVXBkYXRlU3Vic2NyaXB0aW9uc1Jlc3BvbnNlEncKEFVwZGF0ZU11dGVTdGF0ZXMSMC5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5VcGRhdGVNdXRlU3RhdGVzUmVxdWVzdBoxLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlVwZGF0ZU11dGVTdGF0ZXNSZXNwb25zZRJlCgpJY2VSZXN0YXJ0Eiouc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuSUNFUmVzdGFydFJlcXVlc3QaKy5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5JQ0VSZXN0YXJ0UmVzcG9uc2U=');
