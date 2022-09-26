///
//  Generated code. Do not modify.
//  source: video/sfu/sfu_signal_rpc/signal.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../sfu_models/models.pb.dart' as $0;

import '../sfu_models/models.pbenum.dart' as $0;

class UpdateVideoQualityRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateVideoQualityRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..pc<$0.StreamQuality>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'streamQualities', $pb.PbFieldType.PM, subBuilder: $0.StreamQuality.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  UpdateVideoQualityRequest._() : super();
  factory UpdateVideoQualityRequest({
    $core.Iterable<$0.StreamQuality>? streamQualities,
    $core.String? sessionId,
  }) {
    final _result = create();
    if (streamQualities != null) {
      _result.streamQualities.addAll(streamQualities);
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    return _result;
  }
  factory UpdateVideoQualityRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateVideoQualityRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateVideoQualityRequest clone() => UpdateVideoQualityRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateVideoQualityRequest copyWith(void Function(UpdateVideoQualityRequest) updates) => super.copyWith((message) => updates(message as UpdateVideoQualityRequest)) as UpdateVideoQualityRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateVideoQualityRequest create() => UpdateVideoQualityRequest._();
  UpdateVideoQualityRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateVideoQualityRequest> createRepeated() => $pb.PbList<UpdateVideoQualityRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateVideoQualityRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateVideoQualityRequest>(create);
  static UpdateVideoQualityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.StreamQuality> get streamQualities => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);
}

class UpdateVideoQualityResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateVideoQualityResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  UpdateVideoQualityResponse._() : super();
  factory UpdateVideoQualityResponse() => create();
  factory UpdateVideoQualityResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateVideoQualityResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateVideoQualityResponse clone() => UpdateVideoQualityResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateVideoQualityResponse copyWith(void Function(UpdateVideoQualityResponse) updates) => super.copyWith((message) => updates(message as UpdateVideoQualityResponse)) as UpdateVideoQualityResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateVideoQualityResponse create() => UpdateVideoQualityResponse._();
  UpdateVideoQualityResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateVideoQualityResponse> createRepeated() => $pb.PbList<UpdateVideoQualityResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateVideoQualityResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateVideoQualityResponse>(create);
  static UpdateVideoQualityResponse? _defaultInstance;
}

enum UpdateMuteStateRequest_Mute {
  audioMuteChanged, 
  videoMuteChanged, 
  notSet
}

class UpdateMuteStateRequest extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, UpdateMuteStateRequest_Mute> _UpdateMuteStateRequest_MuteByTag = {
    2 : UpdateMuteStateRequest_Mute.audioMuteChanged,
    3 : UpdateMuteStateRequest_Mute.videoMuteChanged,
    0 : UpdateMuteStateRequest_Mute.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateMuteStateRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..aOM<AudioMuteChanged>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioMuteChanged', subBuilder: AudioMuteChanged.create)
    ..aOM<VideoMuteChanged>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'videoMuteChanged', subBuilder: VideoMuteChanged.create)
    ..hasRequiredFields = false
  ;

  UpdateMuteStateRequest._() : super();
  factory UpdateMuteStateRequest({
    $core.String? sessionId,
    AudioMuteChanged? audioMuteChanged,
    VideoMuteChanged? videoMuteChanged,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (audioMuteChanged != null) {
      _result.audioMuteChanged = audioMuteChanged;
    }
    if (videoMuteChanged != null) {
      _result.videoMuteChanged = videoMuteChanged;
    }
    return _result;
  }
  factory UpdateMuteStateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateMuteStateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateMuteStateRequest clone() => UpdateMuteStateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateMuteStateRequest copyWith(void Function(UpdateMuteStateRequest) updates) => super.copyWith((message) => updates(message as UpdateMuteStateRequest)) as UpdateMuteStateRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateMuteStateRequest create() => UpdateMuteStateRequest._();
  UpdateMuteStateRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateMuteStateRequest> createRepeated() => $pb.PbList<UpdateMuteStateRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateMuteStateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateMuteStateRequest>(create);
  static UpdateMuteStateRequest? _defaultInstance;

  UpdateMuteStateRequest_Mute whichMute() => _UpdateMuteStateRequest_MuteByTag[$_whichOneof(0)]!;
  void clearMute() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  AudioMuteChanged get audioMuteChanged => $_getN(1);
  @$pb.TagNumber(2)
  set audioMuteChanged(AudioMuteChanged v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAudioMuteChanged() => $_has(1);
  @$pb.TagNumber(2)
  void clearAudioMuteChanged() => clearField(2);
  @$pb.TagNumber(2)
  AudioMuteChanged ensureAudioMuteChanged() => $_ensure(1);

  @$pb.TagNumber(3)
  VideoMuteChanged get videoMuteChanged => $_getN(2);
  @$pb.TagNumber(3)
  set videoMuteChanged(VideoMuteChanged v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasVideoMuteChanged() => $_has(2);
  @$pb.TagNumber(3)
  void clearVideoMuteChanged() => clearField(3);
  @$pb.TagNumber(3)
  VideoMuteChanged ensureVideoMuteChanged() => $_ensure(2);
}

class UpdateMuteStateResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateMuteStateResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  UpdateMuteStateResponse._() : super();
  factory UpdateMuteStateResponse() => create();
  factory UpdateMuteStateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateMuteStateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateMuteStateResponse clone() => UpdateMuteStateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateMuteStateResponse copyWith(void Function(UpdateMuteStateResponse) updates) => super.copyWith((message) => updates(message as UpdateMuteStateResponse)) as UpdateMuteStateResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateMuteStateResponse create() => UpdateMuteStateResponse._();
  UpdateMuteStateResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateMuteStateResponse> createRepeated() => $pb.PbList<UpdateMuteStateResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateMuteStateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateMuteStateResponse>(create);
  static UpdateMuteStateResponse? _defaultInstance;
}

class AudioMuteChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioMuteChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'muted')
    ..hasRequiredFields = false
  ;

  AudioMuteChanged._() : super();
  factory AudioMuteChanged({
    $core.bool? muted,
  }) {
    final _result = create();
    if (muted != null) {
      _result.muted = muted;
    }
    return _result;
  }
  factory AudioMuteChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioMuteChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioMuteChanged clone() => AudioMuteChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioMuteChanged copyWith(void Function(AudioMuteChanged) updates) => super.copyWith((message) => updates(message as AudioMuteChanged)) as AudioMuteChanged; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AudioMuteChanged create() => AudioMuteChanged._();
  AudioMuteChanged createEmptyInstance() => create();
  static $pb.PbList<AudioMuteChanged> createRepeated() => $pb.PbList<AudioMuteChanged>();
  @$core.pragma('dart2js:noInline')
  static AudioMuteChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AudioMuteChanged>(create);
  static AudioMuteChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get muted => $_getBF(0);
  @$pb.TagNumber(1)
  set muted($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMuted() => $_has(0);
  @$pb.TagNumber(1)
  void clearMuted() => clearField(1);
}

class VideoMuteChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoMuteChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'muted')
    ..hasRequiredFields = false
  ;

  VideoMuteChanged._() : super();
  factory VideoMuteChanged({
    $core.bool? muted,
  }) {
    final _result = create();
    if (muted != null) {
      _result.muted = muted;
    }
    return _result;
  }
  factory VideoMuteChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoMuteChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoMuteChanged clone() => VideoMuteChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoMuteChanged copyWith(void Function(VideoMuteChanged) updates) => super.copyWith((message) => updates(message as VideoMuteChanged)) as VideoMuteChanged; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoMuteChanged create() => VideoMuteChanged._();
  VideoMuteChanged createEmptyInstance() => create();
  static $pb.PbList<VideoMuteChanged> createRepeated() => $pb.PbList<VideoMuteChanged>();
  @$core.pragma('dart2js:noInline')
  static VideoMuteChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoMuteChanged>(create);
  static VideoMuteChanged? _defaultInstance;

  @$pb.TagNumber(2)
  $core.bool get muted => $_getBF(0);
  @$pb.TagNumber(2)
  set muted($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasMuted() => $_has(0);
  @$pb.TagNumber(2)
  void clearMuted() => clearField(2);
}

class UpdateSubscriptionsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateSubscriptionsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..m<$core.String, $0.VideoDimension>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscriptions', entryClassName: 'UpdateSubscriptionsRequest.SubscriptionsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $0.VideoDimension.create, packageName: const $pb.PackageName('stream.video.sfu'))
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  UpdateSubscriptionsRequest._() : super();
  factory UpdateSubscriptionsRequest({
    $core.Map<$core.String, $0.VideoDimension>? subscriptions,
    $core.String? sessionId,
  }) {
    final _result = create();
    if (subscriptions != null) {
      _result.subscriptions.addAll(subscriptions);
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    return _result;
  }
  factory UpdateSubscriptionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateSubscriptionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateSubscriptionsRequest clone() => UpdateSubscriptionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateSubscriptionsRequest copyWith(void Function(UpdateSubscriptionsRequest) updates) => super.copyWith((message) => updates(message as UpdateSubscriptionsRequest)) as UpdateSubscriptionsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateSubscriptionsRequest create() => UpdateSubscriptionsRequest._();
  UpdateSubscriptionsRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateSubscriptionsRequest> createRepeated() => $pb.PbList<UpdateSubscriptionsRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateSubscriptionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateSubscriptionsRequest>(create);
  static UpdateSubscriptionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, $0.VideoDimension> get subscriptions => $_getMap(0);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);
}

class SendAnswerRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendAnswerRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..e<$0.PeerType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peerType', $pb.PbFieldType.OE, defaultOrMaker: $0.PeerType.PUBLISHER, valueOf: $0.PeerType.valueOf, enumValues: $0.PeerType.values)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdp')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  SendAnswerRequest._() : super();
  factory SendAnswerRequest({
    $0.PeerType? peerType,
    $core.String? sdp,
    $core.String? sessionId,
  }) {
    final _result = create();
    if (peerType != null) {
      _result.peerType = peerType;
    }
    if (sdp != null) {
      _result.sdp = sdp;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    return _result;
  }
  factory SendAnswerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SendAnswerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SendAnswerRequest clone() => SendAnswerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SendAnswerRequest copyWith(void Function(SendAnswerRequest) updates) => super.copyWith((message) => updates(message as SendAnswerRequest)) as SendAnswerRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SendAnswerRequest create() => SendAnswerRequest._();
  SendAnswerRequest createEmptyInstance() => create();
  static $pb.PbList<SendAnswerRequest> createRepeated() => $pb.PbList<SendAnswerRequest>();
  @$core.pragma('dart2js:noInline')
  static SendAnswerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendAnswerRequest>(create);
  static SendAnswerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.PeerType get peerType => $_getN(0);
  @$pb.TagNumber(1)
  set peerType($0.PeerType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeerType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sdp => $_getSZ(1);
  @$pb.TagNumber(2)
  set sdp($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSdp() => $_has(1);
  @$pb.TagNumber(2)
  void clearSdp() => clearField(2);

  @$pb.TagNumber(4)
  $core.String get sessionId => $_getSZ(2);
  @$pb.TagNumber(4)
  set sessionId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(4)
  void clearSessionId() => clearField(4);
}

class SendAnswerResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendAnswerResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  SendAnswerResponse._() : super();
  factory SendAnswerResponse() => create();
  factory SendAnswerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SendAnswerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SendAnswerResponse clone() => SendAnswerResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SendAnswerResponse copyWith(void Function(SendAnswerResponse) updates) => super.copyWith((message) => updates(message as SendAnswerResponse)) as SendAnswerResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SendAnswerResponse create() => SendAnswerResponse._();
  SendAnswerResponse createEmptyInstance() => create();
  static $pb.PbList<SendAnswerResponse> createRepeated() => $pb.PbList<SendAnswerResponse>();
  @$core.pragma('dart2js:noInline')
  static SendAnswerResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendAnswerResponse>(create);
  static SendAnswerResponse? _defaultInstance;
}

class IceCandidateRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IceCandidateRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publisher')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'candidate')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdpMid', protoName: 'sdpMid')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdpMLineIndex', $pb.PbFieldType.OU3, protoName: 'sdpMLineIndex')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'usernameFragment', protoName: 'usernameFragment')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  IceCandidateRequest._() : super();
  factory IceCandidateRequest({
    $core.bool? publisher,
    $core.String? candidate,
    $core.String? sdpMid,
    $core.int? sdpMLineIndex,
    $core.String? usernameFragment,
    $core.String? sessionId,
  }) {
    final _result = create();
    if (publisher != null) {
      _result.publisher = publisher;
    }
    if (candidate != null) {
      _result.candidate = candidate;
    }
    if (sdpMid != null) {
      _result.sdpMid = sdpMid;
    }
    if (sdpMLineIndex != null) {
      _result.sdpMLineIndex = sdpMLineIndex;
    }
    if (usernameFragment != null) {
      _result.usernameFragment = usernameFragment;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    return _result;
  }
  factory IceCandidateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IceCandidateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IceCandidateRequest clone() => IceCandidateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IceCandidateRequest copyWith(void Function(IceCandidateRequest) updates) => super.copyWith((message) => updates(message as IceCandidateRequest)) as IceCandidateRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IceCandidateRequest create() => IceCandidateRequest._();
  IceCandidateRequest createEmptyInstance() => create();
  static $pb.PbList<IceCandidateRequest> createRepeated() => $pb.PbList<IceCandidateRequest>();
  @$core.pragma('dart2js:noInline')
  static IceCandidateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IceCandidateRequest>(create);
  static IceCandidateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get publisher => $_getBF(0);
  @$pb.TagNumber(1)
  set publisher($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPublisher() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublisher() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get candidate => $_getSZ(1);
  @$pb.TagNumber(2)
  set candidate($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCandidate() => $_has(1);
  @$pb.TagNumber(2)
  void clearCandidate() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sdpMid => $_getSZ(2);
  @$pb.TagNumber(3)
  set sdpMid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSdpMid() => $_has(2);
  @$pb.TagNumber(3)
  void clearSdpMid() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get sdpMLineIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set sdpMLineIndex($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSdpMLineIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearSdpMLineIndex() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get usernameFragment => $_getSZ(4);
  @$pb.TagNumber(5)
  set usernameFragment($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUsernameFragment() => $_has(4);
  @$pb.TagNumber(5)
  void clearUsernameFragment() => clearField(5);

  @$pb.TagNumber(7)
  $core.String get sessionId => $_getSZ(5);
  @$pb.TagNumber(7)
  set sessionId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasSessionId() => $_has(5);
  @$pb.TagNumber(7)
  void clearSessionId() => clearField(7);
}

class IceCandidateResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'IceCandidateResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  IceCandidateResponse._() : super();
  factory IceCandidateResponse() => create();
  factory IceCandidateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IceCandidateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IceCandidateResponse clone() => IceCandidateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IceCandidateResponse copyWith(void Function(IceCandidateResponse) updates) => super.copyWith((message) => updates(message as IceCandidateResponse)) as IceCandidateResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IceCandidateResponse create() => IceCandidateResponse._();
  IceCandidateResponse createEmptyInstance() => create();
  static $pb.PbList<IceCandidateResponse> createRepeated() => $pb.PbList<IceCandidateResponse>();
  @$core.pragma('dart2js:noInline')
  static IceCandidateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IceCandidateResponse>(create);
  static IceCandidateResponse? _defaultInstance;
}

class UpdateSubscriptionsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateSubscriptionsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  UpdateSubscriptionsResponse._() : super();
  factory UpdateSubscriptionsResponse() => create();
  factory UpdateSubscriptionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateSubscriptionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateSubscriptionsResponse clone() => UpdateSubscriptionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateSubscriptionsResponse copyWith(void Function(UpdateSubscriptionsResponse) updates) => super.copyWith((message) => updates(message as UpdateSubscriptionsResponse)) as UpdateSubscriptionsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateSubscriptionsResponse create() => UpdateSubscriptionsResponse._();
  UpdateSubscriptionsResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateSubscriptionsResponse> createRepeated() => $pb.PbList<UpdateSubscriptionsResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateSubscriptionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateSubscriptionsResponse>(create);
  static UpdateSubscriptionsResponse? _defaultInstance;
}

class SetPublisherRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SetPublisherRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdp')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  SetPublisherRequest._() : super();
  factory SetPublisherRequest({
    $core.String? sdp,
    $core.String? sessionId,
  }) {
    final _result = create();
    if (sdp != null) {
      _result.sdp = sdp;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    return _result;
  }
  factory SetPublisherRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SetPublisherRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SetPublisherRequest clone() => SetPublisherRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SetPublisherRequest copyWith(void Function(SetPublisherRequest) updates) => super.copyWith((message) => updates(message as SetPublisherRequest)) as SetPublisherRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SetPublisherRequest create() => SetPublisherRequest._();
  SetPublisherRequest createEmptyInstance() => create();
  static $pb.PbList<SetPublisherRequest> createRepeated() => $pb.PbList<SetPublisherRequest>();
  @$core.pragma('dart2js:noInline')
  static SetPublisherRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetPublisherRequest>(create);
  static SetPublisherRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sdp => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdp($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSdp() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdp() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(3)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(3)
  void clearSessionId() => clearField(3);
}

class SetPublisherResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SetPublisherResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdp')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  SetPublisherResponse._() : super();
  factory SetPublisherResponse({
    $core.String? sdp,
    $core.String? sessionId,
  }) {
    final _result = create();
    if (sdp != null) {
      _result.sdp = sdp;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    return _result;
  }
  factory SetPublisherResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SetPublisherResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SetPublisherResponse clone() => SetPublisherResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SetPublisherResponse copyWith(void Function(SetPublisherResponse) updates) => super.copyWith((message) => updates(message as SetPublisherResponse)) as SetPublisherResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SetPublisherResponse create() => SetPublisherResponse._();
  SetPublisherResponse createEmptyInstance() => create();
  static $pb.PbList<SetPublisherResponse> createRepeated() => $pb.PbList<SetPublisherResponse>();
  @$core.pragma('dart2js:noInline')
  static SetPublisherResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetPublisherResponse>(create);
  static SetPublisherResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sdp => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdp($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSdp() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdp() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(3)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(3)
  void clearSessionId() => clearField(3);
}

class JoinRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscriberSdpOffer')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..aOM<$0.CodecSettings>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'codecSettings', subBuilder: $0.CodecSettings.create)
    ..hasRequiredFields = false
  ;

  JoinRequest._() : super();
  factory JoinRequest({
    $core.String? subscriberSdpOffer,
    $core.String? sessionId,
    $0.CodecSettings? codecSettings,
  }) {
    final _result = create();
    if (subscriberSdpOffer != null) {
      _result.subscriberSdpOffer = subscriberSdpOffer;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (codecSettings != null) {
      _result.codecSettings = codecSettings;
    }
    return _result;
  }
  factory JoinRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinRequest clone() => JoinRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinRequest copyWith(void Function(JoinRequest) updates) => super.copyWith((message) => updates(message as JoinRequest)) as JoinRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static JoinRequest create() => JoinRequest._();
  JoinRequest createEmptyInstance() => create();
  static $pb.PbList<JoinRequest> createRepeated() => $pb.PbList<JoinRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinRequest>(create);
  static JoinRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subscriberSdpOffer => $_getSZ(0);
  @$pb.TagNumber(1)
  set subscriberSdpOffer($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSubscriberSdpOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscriberSdpOffer() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(3)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(3)
  void clearSessionId() => clearField(3);

  @$pb.TagNumber(4)
  $0.CodecSettings get codecSettings => $_getN(2);
  @$pb.TagNumber(4)
  set codecSettings($0.CodecSettings v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCodecSettings() => $_has(2);
  @$pb.TagNumber(4)
  void clearCodecSettings() => clearField(4);
  @$pb.TagNumber(4)
  $0.CodecSettings ensureCodecSettings() => $_ensure(2);
}

class JoinResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdp')
    ..aOM<$0.CallState>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callState', subBuilder: $0.CallState.create)
    ..hasRequiredFields = false
  ;

  JoinResponse._() : super();
  factory JoinResponse({
    $core.String? sdp,
    $0.CallState? callState,
  }) {
    final _result = create();
    if (sdp != null) {
      _result.sdp = sdp;
    }
    if (callState != null) {
      _result.callState = callState;
    }
    return _result;
  }
  factory JoinResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinResponse clone() => JoinResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinResponse copyWith(void Function(JoinResponse) updates) => super.copyWith((message) => updates(message as JoinResponse)) as JoinResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static JoinResponse create() => JoinResponse._();
  JoinResponse createEmptyInstance() => create();
  static $pb.PbList<JoinResponse> createRepeated() => $pb.PbList<JoinResponse>();
  @$core.pragma('dart2js:noInline')
  static JoinResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinResponse>(create);
  static JoinResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sdp => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdp($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSdp() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdp() => clearField(1);

  @$pb.TagNumber(2)
  $0.CallState get callState => $_getN(1);
  @$pb.TagNumber(2)
  set callState($0.CallState v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCallState() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallState() => clearField(2);
  @$pb.TagNumber(2)
  $0.CallState ensureCallState() => $_ensure(1);
}

class ConnectRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdpOffer')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..hasRequiredFields = false
  ;

  ConnectRequest._() : super();
  factory ConnectRequest({
    $core.String? sdpOffer,
    $core.String? token,
  }) {
    final _result = create();
    if (sdpOffer != null) {
      _result.sdpOffer = sdpOffer;
    }
    if (token != null) {
      _result.token = token;
    }
    return _result;
  }
  factory ConnectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectRequest clone() => ConnectRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectRequest copyWith(void Function(ConnectRequest) updates) => super.copyWith((message) => updates(message as ConnectRequest)) as ConnectRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectRequest create() => ConnectRequest._();
  ConnectRequest createEmptyInstance() => create();
  static $pb.PbList<ConnectRequest> createRepeated() => $pb.PbList<ConnectRequest>();
  @$core.pragma('dart2js:noInline')
  static ConnectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectRequest>(create);
  static ConnectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sdpOffer => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdpOffer($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSdpOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdpOffer() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);
}

class ConnectResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdpAnswer')
    ..hasRequiredFields = false
  ;

  ConnectResponse._() : super();
  factory ConnectResponse({
    $core.String? sdpAnswer,
  }) {
    final _result = create();
    if (sdpAnswer != null) {
      _result.sdpAnswer = sdpAnswer;
    }
    return _result;
  }
  factory ConnectResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectResponse clone() => ConnectResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectResponse copyWith(void Function(ConnectResponse) updates) => super.copyWith((message) => updates(message as ConnectResponse)) as ConnectResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectResponse create() => ConnectResponse._();
  ConnectResponse createEmptyInstance() => create();
  static $pb.PbList<ConnectResponse> createRepeated() => $pb.PbList<ConnectResponse>();
  @$core.pragma('dart2js:noInline')
  static ConnectResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectResponse>(create);
  static ConnectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sdpAnswer => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdpAnswer($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSdpAnswer() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdpAnswer() => clearField(1);
}

enum SignalRequest_EventPayload {
  subscribe, 
  publish, 
  notSet
}

class SignalRequest extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, SignalRequest_EventPayload> _SignalRequest_EventPayloadByTag = {
    1 : SignalRequest_EventPayload.subscribe,
    2 : SignalRequest_EventPayload.publish,
    0 : SignalRequest_EventPayload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SignalRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<SubscribeRequest>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscribe', subBuilder: SubscribeRequest.create)
    ..aOM<PublishRequest>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publish', subBuilder: PublishRequest.create)
    ..hasRequiredFields = false
  ;

  SignalRequest._() : super();
  factory SignalRequest({
    SubscribeRequest? subscribe,
    PublishRequest? publish,
  }) {
    final _result = create();
    if (subscribe != null) {
      _result.subscribe = subscribe;
    }
    if (publish != null) {
      _result.publish = publish;
    }
    return _result;
  }
  factory SignalRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignalRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignalRequest clone() => SignalRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignalRequest copyWith(void Function(SignalRequest) updates) => super.copyWith((message) => updates(message as SignalRequest)) as SignalRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SignalRequest create() => SignalRequest._();
  SignalRequest createEmptyInstance() => create();
  static $pb.PbList<SignalRequest> createRepeated() => $pb.PbList<SignalRequest>();
  @$core.pragma('dart2js:noInline')
  static SignalRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignalRequest>(create);
  static SignalRequest? _defaultInstance;

  SignalRequest_EventPayload whichEventPayload() => _SignalRequest_EventPayloadByTag[$_whichOneof(0)]!;
  void clearEventPayload() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SubscribeRequest get subscribe => $_getN(0);
  @$pb.TagNumber(1)
  set subscribe(SubscribeRequest v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSubscribe() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscribe() => clearField(1);
  @$pb.TagNumber(1)
  SubscribeRequest ensureSubscribe() => $_ensure(0);

  @$pb.TagNumber(2)
  PublishRequest get publish => $_getN(1);
  @$pb.TagNumber(2)
  set publish(PublishRequest v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPublish() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublish() => clearField(2);
  @$pb.TagNumber(2)
  PublishRequest ensurePublish() => $_ensure(1);
}

enum SignalEvent_EventPayload {
  subscribe, 
  publish, 
  notSet
}

class SignalEvent extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, SignalEvent_EventPayload> _SignalEvent_EventPayloadByTag = {
    1 : SignalEvent_EventPayload.subscribe,
    2 : SignalEvent_EventPayload.publish,
    0 : SignalEvent_EventPayload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SignalEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<SubscribeResponse>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscribe', subBuilder: SubscribeResponse.create)
    ..aOM<PublishResponse>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publish', subBuilder: PublishResponse.create)
    ..hasRequiredFields = false
  ;

  SignalEvent._() : super();
  factory SignalEvent({
    SubscribeResponse? subscribe,
    PublishResponse? publish,
  }) {
    final _result = create();
    if (subscribe != null) {
      _result.subscribe = subscribe;
    }
    if (publish != null) {
      _result.publish = publish;
    }
    return _result;
  }
  factory SignalEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignalEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignalEvent clone() => SignalEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignalEvent copyWith(void Function(SignalEvent) updates) => super.copyWith((message) => updates(message as SignalEvent)) as SignalEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SignalEvent create() => SignalEvent._();
  SignalEvent createEmptyInstance() => create();
  static $pb.PbList<SignalEvent> createRepeated() => $pb.PbList<SignalEvent>();
  @$core.pragma('dart2js:noInline')
  static SignalEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignalEvent>(create);
  static SignalEvent? _defaultInstance;

  SignalEvent_EventPayload whichEventPayload() => _SignalEvent_EventPayloadByTag[$_whichOneof(0)]!;
  void clearEventPayload() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SubscribeResponse get subscribe => $_getN(0);
  @$pb.TagNumber(1)
  set subscribe(SubscribeResponse v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSubscribe() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscribe() => clearField(1);
  @$pb.TagNumber(1)
  SubscribeResponse ensureSubscribe() => $_ensure(0);

  @$pb.TagNumber(2)
  PublishResponse get publish => $_getN(1);
  @$pb.TagNumber(2)
  set publish(PublishResponse v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPublish() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublish() => clearField(2);
  @$pb.TagNumber(2)
  PublishResponse ensurePublish() => $_ensure(1);
}

class SubscribeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SubscribeRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdpOffer')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quality')
    ..hasRequiredFields = false
  ;

  SubscribeRequest._() : super();
  factory SubscribeRequest({
    $core.String? token,
    $core.String? sdpOffer,
    $core.String? quality,
  }) {
    final _result = create();
    if (token != null) {
      _result.token = token;
    }
    if (sdpOffer != null) {
      _result.sdpOffer = sdpOffer;
    }
    if (quality != null) {
      _result.quality = quality;
    }
    return _result;
  }
  factory SubscribeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubscribeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubscribeRequest clone() => SubscribeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubscribeRequest copyWith(void Function(SubscribeRequest) updates) => super.copyWith((message) => updates(message as SubscribeRequest)) as SubscribeRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest create() => SubscribeRequest._();
  SubscribeRequest createEmptyInstance() => create();
  static $pb.PbList<SubscribeRequest> createRepeated() => $pb.PbList<SubscribeRequest>();
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscribeRequest>(create);
  static SubscribeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sdpOffer => $_getSZ(1);
  @$pb.TagNumber(2)
  set sdpOffer($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSdpOffer() => $_has(1);
  @$pb.TagNumber(2)
  void clearSdpOffer() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get quality => $_getSZ(2);
  @$pb.TagNumber(3)
  set quality($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasQuality() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuality() => clearField(3);
}

class SubscribeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SubscribeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quality')
    ..hasRequiredFields = false
  ;

  SubscribeResponse._() : super();
  factory SubscribeResponse({
    $core.String? quality,
  }) {
    final _result = create();
    if (quality != null) {
      _result.quality = quality;
    }
    return _result;
  }
  factory SubscribeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubscribeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubscribeResponse clone() => SubscribeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubscribeResponse copyWith(void Function(SubscribeResponse) updates) => super.copyWith((message) => updates(message as SubscribeResponse)) as SubscribeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SubscribeResponse create() => SubscribeResponse._();
  SubscribeResponse createEmptyInstance() => create();
  static $pb.PbList<SubscribeResponse> createRepeated() => $pb.PbList<SubscribeResponse>();
  @$core.pragma('dart2js:noInline')
  static SubscribeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscribeResponse>(create);
  static SubscribeResponse? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get quality => $_getSZ(0);
  @$pb.TagNumber(2)
  set quality($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasQuality() => $_has(0);
  @$pb.TagNumber(2)
  void clearQuality() => clearField(2);
}

class PublishRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PublishRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdpOffer')
    ..hasRequiredFields = false
  ;

  PublishRequest._() : super();
  factory PublishRequest({
    $core.String? token,
    $core.String? sdpOffer,
  }) {
    final _result = create();
    if (token != null) {
      _result.token = token;
    }
    if (sdpOffer != null) {
      _result.sdpOffer = sdpOffer;
    }
    return _result;
  }
  factory PublishRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublishRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PublishRequest clone() => PublishRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PublishRequest copyWith(void Function(PublishRequest) updates) => super.copyWith((message) => updates(message as PublishRequest)) as PublishRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PublishRequest create() => PublishRequest._();
  PublishRequest createEmptyInstance() => create();
  static $pb.PbList<PublishRequest> createRepeated() => $pb.PbList<PublishRequest>();
  @$core.pragma('dart2js:noInline')
  static PublishRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublishRequest>(create);
  static PublishRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sdpOffer => $_getSZ(1);
  @$pb.TagNumber(2)
  set sdpOffer($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSdpOffer() => $_has(1);
  @$pb.TagNumber(2)
  void clearSdpOffer() => clearField(2);
}

class PublishResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PublishResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu'), createEmptyInstance: create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdpAnswer')
    ..hasRequiredFields = false
  ;

  PublishResponse._() : super();
  factory PublishResponse({
    $core.String? sdpAnswer,
  }) {
    final _result = create();
    if (sdpAnswer != null) {
      _result.sdpAnswer = sdpAnswer;
    }
    return _result;
  }
  factory PublishResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublishResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PublishResponse clone() => PublishResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PublishResponse copyWith(void Function(PublishResponse) updates) => super.copyWith((message) => updates(message as PublishResponse)) as PublishResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PublishResponse create() => PublishResponse._();
  PublishResponse createEmptyInstance() => create();
  static $pb.PbList<PublishResponse> createRepeated() => $pb.PbList<PublishResponse>();
  @$core.pragma('dart2js:noInline')
  static PublishResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublishResponse>(create);
  static PublishResponse? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get sdpAnswer => $_getSZ(0);
  @$pb.TagNumber(2)
  set sdpAnswer($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasSdpAnswer() => $_has(0);
  @$pb.TagNumber(2)
  void clearSdpAnswer() => clearField(2);
}

class SignalServerApi {
  $pb.RpcClient _client;
  SignalServerApi(this._client);

  $async.Future<JoinResponse> join($pb.ClientContext? ctx, JoinRequest request) {
    var emptyResponse = JoinResponse();
    return _client.invoke<JoinResponse>(ctx, 'SignalServer', 'Join', request, emptyResponse);
  }
  $async.Future<SetPublisherResponse> setPublisher($pb.ClientContext? ctx, SetPublisherRequest request) {
    var emptyResponse = SetPublisherResponse();
    return _client.invoke<SetPublisherResponse>(ctx, 'SignalServer', 'SetPublisher', request, emptyResponse);
  }
  $async.Future<SendAnswerResponse> sendAnswer($pb.ClientContext? ctx, SendAnswerRequest request) {
    var emptyResponse = SendAnswerResponse();
    return _client.invoke<SendAnswerResponse>(ctx, 'SignalServer', 'SendAnswer', request, emptyResponse);
  }
  $async.Future<IceCandidateResponse> sendIceCandidate($pb.ClientContext? ctx, IceCandidateRequest request) {
    var emptyResponse = IceCandidateResponse();
    return _client.invoke<IceCandidateResponse>(ctx, 'SignalServer', 'SendIceCandidate', request, emptyResponse);
  }
  $async.Future<UpdateSubscriptionsResponse> updateSubscriptions($pb.ClientContext? ctx, UpdateSubscriptionsRequest request) {
    var emptyResponse = UpdateSubscriptionsResponse();
    return _client.invoke<UpdateSubscriptionsResponse>(ctx, 'SignalServer', 'UpdateSubscriptions', request, emptyResponse);
  }
  $async.Future<UpdateMuteStateResponse> updateMuteState($pb.ClientContext? ctx, UpdateMuteStateRequest request) {
    var emptyResponse = UpdateMuteStateResponse();
    return _client.invoke<UpdateMuteStateResponse>(ctx, 'SignalServer', 'UpdateMuteState', request, emptyResponse);
  }
  $async.Future<UpdateVideoQualityResponse> requestVideoQuality($pb.ClientContext? ctx, UpdateVideoQualityRequest request) {
    var emptyResponse = UpdateVideoQualityResponse();
    return _client.invoke<UpdateVideoQualityResponse>(ctx, 'SignalServer', 'RequestVideoQuality', request, emptyResponse);
  }
}

