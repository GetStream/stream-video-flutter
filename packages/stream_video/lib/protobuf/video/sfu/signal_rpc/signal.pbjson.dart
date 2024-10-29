//
//  Generated code. Do not modify.
//  source: video/sfu/signal_rpc/signal.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../models/models.pbjson.dart' as $0;

@$core.Deprecated('Use startNoiseCancellationRequestDescriptor instead')
const StartNoiseCancellationRequest$json = {
  '1': 'StartNoiseCancellationRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `StartNoiseCancellationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startNoiseCancellationRequestDescriptor = $convert.base64Decode(
    'Ch1TdGFydE5vaXNlQ2FuY2VsbGF0aW9uUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZX'
    'NzaW9uSWQ=');

@$core.Deprecated('Use startNoiseCancellationResponseDescriptor instead')
const StartNoiseCancellationResponse$json = {
  '1': 'StartNoiseCancellationResponse',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `StartNoiseCancellationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startNoiseCancellationResponseDescriptor = $convert.base64Decode(
    'Ch5TdGFydE5vaXNlQ2FuY2VsbGF0aW9uUmVzcG9uc2USNAoFZXJyb3IYASABKAsyHi5zdHJlYW'
    '0udmlkZW8uc2Z1Lm1vZGVscy5FcnJvclIFZXJyb3I=');

@$core.Deprecated('Use stopNoiseCancellationRequestDescriptor instead')
const StopNoiseCancellationRequest$json = {
  '1': 'StopNoiseCancellationRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `StopNoiseCancellationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopNoiseCancellationRequestDescriptor = $convert.base64Decode(
    'ChxTdG9wTm9pc2VDYW5jZWxsYXRpb25SZXF1ZXN0Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3'
    'Npb25JZA==');

@$core.Deprecated('Use stopNoiseCancellationResponseDescriptor instead')
const StopNoiseCancellationResponse$json = {
  '1': 'StopNoiseCancellationResponse',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `StopNoiseCancellationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopNoiseCancellationResponseDescriptor = $convert.base64Decode(
    'Ch1TdG9wTm9pc2VDYW5jZWxsYXRpb25SZXNwb25zZRI0CgVlcnJvchgBIAEoCzIeLnN0cmVhbS'
    '52aWRlby5zZnUubW9kZWxzLkVycm9yUgVlcnJvcg==');

@$core.Deprecated('Use sendStatsRequestDescriptor instead')
const SendStatsRequest$json = {
  '1': 'SendStatsRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'subscriber_stats', '3': 2, '4': 1, '5': 9, '10': 'subscriberStats'},
    {'1': 'publisher_stats', '3': 3, '4': 1, '5': 9, '10': 'publisherStats'},
    {'1': 'webrtc_version', '3': 4, '4': 1, '5': 9, '10': 'webrtcVersion'},
    {'1': 'sdk', '3': 5, '4': 1, '5': 9, '10': 'sdk'},
    {'1': 'sdk_version', '3': 6, '4': 1, '5': 9, '10': 'sdkVersion'},
  ],
};

/// Descriptor for `SendStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendStatsRequestDescriptor = $convert.base64Decode(
    'ChBTZW5kU3RhdHNSZXF1ZXN0Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZBIpChBzdW'
    'JzY3JpYmVyX3N0YXRzGAIgASgJUg9zdWJzY3JpYmVyU3RhdHMSJwoPcHVibGlzaGVyX3N0YXRz'
    'GAMgASgJUg5wdWJsaXNoZXJTdGF0cxIlCg53ZWJydGNfdmVyc2lvbhgEIAEoCVINd2VicnRjVm'
    'Vyc2lvbhIQCgNzZGsYBSABKAlSA3NkaxIfCgtzZGtfdmVyc2lvbhgGIAEoCVIKc2RrVmVyc2lv'
    'bg==');

@$core.Deprecated('Use sendStatsResponseDescriptor instead')
const SendStatsResponse$json = {
  '1': 'SendStatsResponse',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `SendStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendStatsResponseDescriptor = $convert.base64Decode(
    'ChFTZW5kU3RhdHNSZXNwb25zZRI0CgVlcnJvchgBIAEoCzIeLnN0cmVhbS52aWRlby5zZnUubW'
    '9kZWxzLkVycm9yUgVlcnJvcg==');

@$core.Deprecated('Use iCERestartRequestDescriptor instead')
const ICERestartRequest$json = {
  '1': 'ICERestartRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'peer_type', '3': 2, '4': 1, '5': 14, '6': '.stream.video.sfu.models.PeerType', '10': 'peerType'},
  ],
};

/// Descriptor for `ICERestartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCERestartRequestDescriptor = $convert.base64Decode(
    'ChFJQ0VSZXN0YXJ0UmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSPgoJcG'
    'Vlcl90eXBlGAIgASgOMiEuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuUGVlclR5cGVSCHBlZXJU'
    'eXBl');

@$core.Deprecated('Use iCERestartResponseDescriptor instead')
const ICERestartResponse$json = {
  '1': 'ICERestartResponse',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `ICERestartResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCERestartResponseDescriptor = $convert.base64Decode(
    'ChJJQ0VSZXN0YXJ0UmVzcG9uc2USNAoFZXJyb3IYASABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm'
    '1vZGVscy5FcnJvclIFZXJyb3I=');

@$core.Deprecated('Use updateMuteStatesRequestDescriptor instead')
const UpdateMuteStatesRequest$json = {
  '1': 'UpdateMuteStatesRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'mute_states', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.signal.TrackMuteState', '10': 'muteStates'},
  ],
};

/// Descriptor for `UpdateMuteStatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMuteStatesRequestDescriptor = $convert.base64Decode(
    'ChdVcGRhdGVNdXRlU3RhdGVzUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSW'
    'QSSAoLbXV0ZV9zdGF0ZXMYAyADKAsyJy5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5UcmFja011'
    'dGVTdGF0ZVIKbXV0ZVN0YXRlcw==');

@$core.Deprecated('Use updateMuteStatesResponseDescriptor instead')
const UpdateMuteStatesResponse$json = {
  '1': 'UpdateMuteStatesResponse',
  '2': [
    {'1': 'error', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `UpdateMuteStatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMuteStatesResponseDescriptor = $convert.base64Decode(
    'ChhVcGRhdGVNdXRlU3RhdGVzUmVzcG9uc2USNAoFZXJyb3IYBCABKAsyHi5zdHJlYW0udmlkZW'
    '8uc2Z1Lm1vZGVscy5FcnJvclIFZXJyb3I=');

@$core.Deprecated('Use trackMuteStateDescriptor instead')
const TrackMuteState$json = {
  '1': 'TrackMuteState',
  '2': [
    {'1': 'track_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.TrackType', '10': 'trackType'},
    {'1': 'muted', '3': 2, '4': 1, '5': 8, '10': 'muted'},
  ],
};

/// Descriptor for `TrackMuteState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackMuteStateDescriptor = $convert.base64Decode(
    'Cg5UcmFja011dGVTdGF0ZRJBCgp0cmFja190eXBlGAEgASgOMiIuc3RyZWFtLnZpZGVvLnNmdS'
    '5tb2RlbHMuVHJhY2tUeXBlUgl0cmFja1R5cGUSFAoFbXV0ZWQYAiABKAhSBW11dGVk');

@$core.Deprecated('Use audioMuteChangedDescriptor instead')
const AudioMuteChanged$json = {
  '1': 'AudioMuteChanged',
  '2': [
    {'1': 'muted', '3': 1, '4': 1, '5': 8, '10': 'muted'},
  ],
};

/// Descriptor for `AudioMuteChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioMuteChangedDescriptor = $convert.base64Decode(
    'ChBBdWRpb011dGVDaGFuZ2VkEhQKBW11dGVkGAEgASgIUgVtdXRlZA==');

@$core.Deprecated('Use videoMuteChangedDescriptor instead')
const VideoMuteChanged$json = {
  '1': 'VideoMuteChanged',
  '2': [
    {'1': 'muted', '3': 2, '4': 1, '5': 8, '10': 'muted'},
  ],
};

/// Descriptor for `VideoMuteChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoMuteChangedDescriptor = $convert.base64Decode(
    'ChBWaWRlb011dGVDaGFuZ2VkEhQKBW11dGVkGAIgASgIUgVtdXRlZA==');

@$core.Deprecated('Use updateSubscriptionsRequestDescriptor instead')
const UpdateSubscriptionsRequest$json = {
  '1': 'UpdateSubscriptionsRequest',
  '2': [
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'tracks', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.signal.TrackSubscriptionDetails', '10': 'tracks'},
  ],
};

/// Descriptor for `UpdateSubscriptionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSubscriptionsRequestDescriptor = $convert.base64Decode(
    'ChpVcGRhdGVTdWJzY3JpcHRpb25zUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAIgASgJUglzZXNzaW'
    '9uSWQSSQoGdHJhY2tzGAMgAygLMjEuc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuVHJhY2tTdWJz'
    'Y3JpcHRpb25EZXRhaWxzUgZ0cmFja3M=');

@$core.Deprecated('Use updateSubscriptionsResponseDescriptor instead')
const UpdateSubscriptionsResponse$json = {
  '1': 'UpdateSubscriptionsResponse',
  '2': [
    {'1': 'error', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `UpdateSubscriptionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSubscriptionsResponseDescriptor = $convert.base64Decode(
    'ChtVcGRhdGVTdWJzY3JpcHRpb25zUmVzcG9uc2USNAoFZXJyb3IYBCABKAsyHi5zdHJlYW0udm'
    'lkZW8uc2Z1Lm1vZGVscy5FcnJvclIFZXJyb3I=');

@$core.Deprecated('Use trackSubscriptionDetailsDescriptor instead')
const TrackSubscriptionDetails$json = {
  '1': 'TrackSubscriptionDetails',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'track_type', '3': 3, '4': 1, '5': 14, '6': '.stream.video.sfu.models.TrackType', '10': 'trackType'},
    {'1': 'dimension', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.VideoDimension', '10': 'dimension'},
  ],
};

/// Descriptor for `TrackSubscriptionDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackSubscriptionDetailsDescriptor = $convert.base64Decode(
    'ChhUcmFja1N1YnNjcmlwdGlvbkRldGFpbHMSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEh0KCn'
    'Nlc3Npb25faWQYAiABKAlSCXNlc3Npb25JZBJBCgp0cmFja190eXBlGAMgASgOMiIuc3RyZWFt'
    'LnZpZGVvLnNmdS5tb2RlbHMuVHJhY2tUeXBlUgl0cmFja1R5cGUSRQoJZGltZW5zaW9uGAQgAS'
    'gLMicuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuVmlkZW9EaW1lbnNpb25SCWRpbWVuc2lvbg==');

@$core.Deprecated('Use sendAnswerRequestDescriptor instead')
const SendAnswerRequest$json = {
  '1': 'SendAnswerRequest',
  '2': [
    {'1': 'peer_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.PeerType', '10': 'peerType'},
    {'1': 'sdp', '3': 2, '4': 1, '5': 9, '10': 'sdp'},
    {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `SendAnswerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendAnswerRequestDescriptor = $convert.base64Decode(
    'ChFTZW5kQW5zd2VyUmVxdWVzdBI+CglwZWVyX3R5cGUYASABKA4yIS5zdHJlYW0udmlkZW8uc2'
    'Z1Lm1vZGVscy5QZWVyVHlwZVIIcGVlclR5cGUSEAoDc2RwGAIgASgJUgNzZHASHQoKc2Vzc2lv'
    'bl9pZBgDIAEoCVIJc2Vzc2lvbklk');

@$core.Deprecated('Use sendAnswerResponseDescriptor instead')
const SendAnswerResponse$json = {
  '1': 'SendAnswerResponse',
  '2': [
    {'1': 'error', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `SendAnswerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendAnswerResponseDescriptor = $convert.base64Decode(
    'ChJTZW5kQW5zd2VyUmVzcG9uc2USNAoFZXJyb3IYBCABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm'
    '1vZGVscy5FcnJvclIFZXJyb3I=');

@$core.Deprecated('Use iCETrickleResponseDescriptor instead')
const ICETrickleResponse$json = {
  '1': 'ICETrickleResponse',
  '2': [
    {'1': 'error', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `ICETrickleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCETrickleResponseDescriptor = $convert.base64Decode(
    'ChJJQ0VUcmlja2xlUmVzcG9uc2USNAoFZXJyb3IYBCABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm'
    '1vZGVscy5FcnJvclIFZXJyb3I=');

@$core.Deprecated('Use setPublisherRequestDescriptor instead')
const SetPublisherRequest$json = {
  '1': 'SetPublisherRequest',
  '2': [
    {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'tracks', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.models.TrackInfo', '10': 'tracks'},
  ],
};

/// Descriptor for `SetPublisherRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setPublisherRequestDescriptor = $convert.base64Decode(
    'ChNTZXRQdWJsaXNoZXJSZXF1ZXN0EhAKA3NkcBgBIAEoCVIDc2RwEh0KCnNlc3Npb25faWQYAi'
    'ABKAlSCXNlc3Npb25JZBI6CgZ0cmFja3MYAyADKAsyIi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVs'
    'cy5UcmFja0luZm9SBnRyYWNrcw==');

@$core.Deprecated('Use setPublisherResponseDescriptor instead')
const SetPublisherResponse$json = {
  '1': 'SetPublisherResponse',
  '2': [
    {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'ice_restart', '3': 3, '4': 1, '5': 8, '10': 'iceRestart'},
    {'1': 'error', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Error', '10': 'error'},
  ],
};

/// Descriptor for `SetPublisherResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setPublisherResponseDescriptor = $convert.base64Decode(
    'ChRTZXRQdWJsaXNoZXJSZXNwb25zZRIQCgNzZHAYASABKAlSA3NkcBIdCgpzZXNzaW9uX2lkGA'
    'IgASgJUglzZXNzaW9uSWQSHwoLaWNlX3Jlc3RhcnQYAyABKAhSCmljZVJlc3RhcnQSNAoFZXJy'
    'b3IYBCABKAsyHi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5FcnJvclIFZXJyb3I=');

const $core.Map<$core.String, $core.dynamic> SignalServerServiceBase$json = {
  '1': 'SignalServer',
  '2': [
    {'1': 'SetPublisher', '2': '.stream.video.sfu.signal.SetPublisherRequest', '3': '.stream.video.sfu.signal.SetPublisherResponse'},
    {'1': 'SendAnswer', '2': '.stream.video.sfu.signal.SendAnswerRequest', '3': '.stream.video.sfu.signal.SendAnswerResponse'},
    {'1': 'IceTrickle', '2': '.stream.video.sfu.models.ICETrickle', '3': '.stream.video.sfu.signal.ICETrickleResponse'},
    {'1': 'UpdateSubscriptions', '2': '.stream.video.sfu.signal.UpdateSubscriptionsRequest', '3': '.stream.video.sfu.signal.UpdateSubscriptionsResponse'},
    {'1': 'UpdateMuteStates', '2': '.stream.video.sfu.signal.UpdateMuteStatesRequest', '3': '.stream.video.sfu.signal.UpdateMuteStatesResponse'},
    {'1': 'IceRestart', '2': '.stream.video.sfu.signal.ICERestartRequest', '3': '.stream.video.sfu.signal.ICERestartResponse'},
    {'1': 'SendStats', '2': '.stream.video.sfu.signal.SendStatsRequest', '3': '.stream.video.sfu.signal.SendStatsResponse'},
    {'1': 'StartNoiseCancellation', '2': '.stream.video.sfu.signal.StartNoiseCancellationRequest', '3': '.stream.video.sfu.signal.StartNoiseCancellationResponse'},
    {'1': 'StopNoiseCancellation', '2': '.stream.video.sfu.signal.StopNoiseCancellationRequest', '3': '.stream.video.sfu.signal.StopNoiseCancellationResponse'},
  ],
};

@$core.Deprecated('Use signalServerServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> SignalServerServiceBase$messageJson = {
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
  '.stream.video.sfu.signal.SendStatsRequest': SendStatsRequest$json,
  '.stream.video.sfu.signal.SendStatsResponse': SendStatsResponse$json,
  '.stream.video.sfu.signal.StartNoiseCancellationRequest': StartNoiseCancellationRequest$json,
  '.stream.video.sfu.signal.StartNoiseCancellationResponse': StartNoiseCancellationResponse$json,
  '.stream.video.sfu.signal.StopNoiseCancellationRequest': StopNoiseCancellationRequest$json,
  '.stream.video.sfu.signal.StopNoiseCancellationResponse': StopNoiseCancellationResponse$json,
};

/// Descriptor for `SignalServer`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List signalServerServiceDescriptor = $convert.base64Decode(
    'CgxTaWduYWxTZXJ2ZXISawoMU2V0UHVibGlzaGVyEiwuc3RyZWFtLnZpZGVvLnNmdS5zaWduYW'
    'wuU2V0UHVibGlzaGVyUmVxdWVzdBotLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlNldFB1Ymxp'
    'c2hlclJlc3BvbnNlEmUKClNlbmRBbnN3ZXISKi5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5TZW'
    '5kQW5zd2VyUmVxdWVzdBorLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlNlbmRBbnN3ZXJSZXNw'
    'b25zZRJeCgpJY2VUcmlja2xlEiMuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuSUNFVHJpY2tsZR'
    'orLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLklDRVRyaWNrbGVSZXNwb25zZRKAAQoTVXBkYXRl'
    'U3Vic2NyaXB0aW9ucxIzLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlVwZGF0ZVN1YnNjcmlwdG'
    'lvbnNSZXF1ZXN0GjQuc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuVXBkYXRlU3Vic2NyaXB0aW9u'
    'c1Jlc3BvbnNlEncKEFVwZGF0ZU11dGVTdGF0ZXMSMC5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC'
    '5VcGRhdGVNdXRlU3RhdGVzUmVxdWVzdBoxLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlVwZGF0'
    'ZU11dGVTdGF0ZXNSZXNwb25zZRJlCgpJY2VSZXN0YXJ0Eiouc3RyZWFtLnZpZGVvLnNmdS5zaW'
    'duYWwuSUNFUmVzdGFydFJlcXVlc3QaKy5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5JQ0VSZXN0'
    'YXJ0UmVzcG9uc2USYgoJU2VuZFN0YXRzEikuc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuU2VuZF'
    'N0YXRzUmVxdWVzdBoqLnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlNlbmRTdGF0c1Jlc3BvbnNl'
    'EokBChZTdGFydE5vaXNlQ2FuY2VsbGF0aW9uEjYuc3RyZWFtLnZpZGVvLnNmdS5zaWduYWwuU3'
    'RhcnROb2lzZUNhbmNlbGxhdGlvblJlcXVlc3QaNy5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5T'
    'dGFydE5vaXNlQ2FuY2VsbGF0aW9uUmVzcG9uc2UShgEKFVN0b3BOb2lzZUNhbmNlbGxhdGlvbh'
    'I1LnN0cmVhbS52aWRlby5zZnUuc2lnbmFsLlN0b3BOb2lzZUNhbmNlbGxhdGlvblJlcXVlc3Qa'
    'Ni5zdHJlYW0udmlkZW8uc2Z1LnNpZ25hbC5TdG9wTm9pc2VDYW5jZWxsYXRpb25SZXNwb25zZQ'
    '==');

