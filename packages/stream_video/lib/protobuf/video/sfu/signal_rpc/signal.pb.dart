///
//  Generated code. Do not modify.
//  source: video/sfu/signal_rpc/signal.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../models/models.pb.dart' as $0;

import '../models/models.pbenum.dart' as $0;

class ICERestartRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ICERestartRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..e<$0.PeerType>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peerType', $pb.PbFieldType.OE, defaultOrMaker: $0.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED, valueOf: $0.PeerType.valueOf, enumValues: $0.PeerType.values)
    ..hasRequiredFields = false
  ;

  ICERestartRequest._() : super();
  factory ICERestartRequest({
    $core.String? sessionId,
    $0.PeerType? peerType,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (peerType != null) {
      _result.peerType = peerType;
    }
    return _result;
  }
  factory ICERestartRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ICERestartRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ICERestartRequest clone() => ICERestartRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ICERestartRequest copyWith(void Function(ICERestartRequest) updates) => super.copyWith((message) => updates(message as ICERestartRequest)) as ICERestartRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ICERestartRequest create() => ICERestartRequest._();
  ICERestartRequest createEmptyInstance() => create();
  static $pb.PbList<ICERestartRequest> createRepeated() => $pb.PbList<ICERestartRequest>();
  @$core.pragma('dart2js:noInline')
  static ICERestartRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ICERestartRequest>(create);
  static ICERestartRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $0.PeerType get peerType => $_getN(1);
  @$pb.TagNumber(2)
  set peerType($0.PeerType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPeerType() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeerType() => clearField(2);
}

class ICERestartResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ICERestartResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..aOM<$0.Error>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error', subBuilder: $0.Error.create)
    ..hasRequiredFields = false
  ;

  ICERestartResponse._() : super();
  factory ICERestartResponse({
    $0.Error? error,
  }) {
    final _result = create();
    if (error != null) {
      _result.error = error;
    }
    return _result;
  }
  factory ICERestartResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ICERestartResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ICERestartResponse clone() => ICERestartResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ICERestartResponse copyWith(void Function(ICERestartResponse) updates) => super.copyWith((message) => updates(message as ICERestartResponse)) as ICERestartResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ICERestartResponse create() => ICERestartResponse._();
  ICERestartResponse createEmptyInstance() => create();
  static $pb.PbList<ICERestartResponse> createRepeated() => $pb.PbList<ICERestartResponse>();
  @$core.pragma('dart2js:noInline')
  static ICERestartResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ICERestartResponse>(create);
  static ICERestartResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(1)
  set error($0.Error v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);
  @$pb.TagNumber(1)
  $0.Error ensureError() => $_ensure(0);
}

class UpdateMuteStatesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateMuteStatesRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..pc<TrackMuteState>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'muteStates', $pb.PbFieldType.PM, subBuilder: TrackMuteState.create)
    ..hasRequiredFields = false
  ;

  UpdateMuteStatesRequest._() : super();
  factory UpdateMuteStatesRequest({
    $core.String? sessionId,
    $core.Iterable<TrackMuteState>? muteStates,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (muteStates != null) {
      _result.muteStates.addAll(muteStates);
    }
    return _result;
  }
  factory UpdateMuteStatesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateMuteStatesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateMuteStatesRequest clone() => UpdateMuteStatesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateMuteStatesRequest copyWith(void Function(UpdateMuteStatesRequest) updates) => super.copyWith((message) => updates(message as UpdateMuteStatesRequest)) as UpdateMuteStatesRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateMuteStatesRequest create() => UpdateMuteStatesRequest._();
  UpdateMuteStatesRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateMuteStatesRequest> createRepeated() => $pb.PbList<UpdateMuteStatesRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateMuteStatesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateMuteStatesRequest>(create);
  static UpdateMuteStatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(3)
  $core.List<TrackMuteState> get muteStates => $_getList(1);
}

class UpdateMuteStatesResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateMuteStatesResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..aOM<$0.Error>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error', subBuilder: $0.Error.create)
    ..hasRequiredFields = false
  ;

  UpdateMuteStatesResponse._() : super();
  factory UpdateMuteStatesResponse({
    $0.Error? error,
  }) {
    final _result = create();
    if (error != null) {
      _result.error = error;
    }
    return _result;
  }
  factory UpdateMuteStatesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateMuteStatesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateMuteStatesResponse clone() => UpdateMuteStatesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateMuteStatesResponse copyWith(void Function(UpdateMuteStatesResponse) updates) => super.copyWith((message) => updates(message as UpdateMuteStatesResponse)) as UpdateMuteStatesResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateMuteStatesResponse create() => UpdateMuteStatesResponse._();
  UpdateMuteStatesResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateMuteStatesResponse> createRepeated() => $pb.PbList<UpdateMuteStatesResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateMuteStatesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateMuteStatesResponse>(create);
  static UpdateMuteStatesResponse? _defaultInstance;

  @$pb.TagNumber(4)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(4)
  set error($0.Error v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(4)
  void clearError() => clearField(4);
  @$pb.TagNumber(4)
  $0.Error ensureError() => $_ensure(0);
}

class TrackMuteState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrackMuteState', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..e<$0.TrackType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trackType', $pb.PbFieldType.OE, defaultOrMaker: $0.TrackType.TRACK_TYPE_UNSPECIFIED, valueOf: $0.TrackType.valueOf, enumValues: $0.TrackType.values)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'muted')
    ..hasRequiredFields = false
  ;

  TrackMuteState._() : super();
  factory TrackMuteState({
    $0.TrackType? trackType,
    $core.bool? muted,
  }) {
    final _result = create();
    if (trackType != null) {
      _result.trackType = trackType;
    }
    if (muted != null) {
      _result.muted = muted;
    }
    return _result;
  }
  factory TrackMuteState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrackMuteState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrackMuteState clone() => TrackMuteState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrackMuteState copyWith(void Function(TrackMuteState) updates) => super.copyWith((message) => updates(message as TrackMuteState)) as TrackMuteState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TrackMuteState create() => TrackMuteState._();
  TrackMuteState createEmptyInstance() => create();
  static $pb.PbList<TrackMuteState> createRepeated() => $pb.PbList<TrackMuteState>();
  @$core.pragma('dart2js:noInline')
  static TrackMuteState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrackMuteState>(create);
  static TrackMuteState? _defaultInstance;

  @$pb.TagNumber(1)
  $0.TrackType get trackType => $_getN(0);
  @$pb.TagNumber(1)
  set trackType($0.TrackType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrackType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackType() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get muted => $_getBF(1);
  @$pb.TagNumber(2)
  set muted($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMuted() => $_has(1);
  @$pb.TagNumber(2)
  void clearMuted() => clearField(2);
}

class AudioMuteChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioMuteChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoMuteChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateSubscriptionsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..pc<TrackSubscriptionDetails>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tracks', $pb.PbFieldType.PM, subBuilder: TrackSubscriptionDetails.create)
    ..hasRequiredFields = false
  ;

  UpdateSubscriptionsRequest._() : super();
  factory UpdateSubscriptionsRequest({
    $core.String? sessionId,
    $core.Iterable<TrackSubscriptionDetails>? tracks,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (tracks != null) {
      _result.tracks.addAll(tracks);
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

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<TrackSubscriptionDetails> get tracks => $_getList(1);
}

class UpdateSubscriptionsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateSubscriptionsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..aOM<$0.Error>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error', subBuilder: $0.Error.create)
    ..hasRequiredFields = false
  ;

  UpdateSubscriptionsResponse._() : super();
  factory UpdateSubscriptionsResponse({
    $0.Error? error,
  }) {
    final _result = create();
    if (error != null) {
      _result.error = error;
    }
    return _result;
  }
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

  @$pb.TagNumber(4)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(4)
  set error($0.Error v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(4)
  void clearError() => clearField(4);
  @$pb.TagNumber(4)
  $0.Error ensureError() => $_ensure(0);
}

class TrackSubscriptionDetails extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrackSubscriptionDetails', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..e<$0.TrackType>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trackType', $pb.PbFieldType.OE, defaultOrMaker: $0.TrackType.TRACK_TYPE_UNSPECIFIED, valueOf: $0.TrackType.valueOf, enumValues: $0.TrackType.values)
    ..aOM<$0.VideoDimension>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dimension', subBuilder: $0.VideoDimension.create)
    ..hasRequiredFields = false
  ;

  TrackSubscriptionDetails._() : super();
  factory TrackSubscriptionDetails({
    $core.String? userId,
    $core.String? sessionId,
    $0.TrackType? trackType,
    $0.VideoDimension? dimension,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (trackType != null) {
      _result.trackType = trackType;
    }
    if (dimension != null) {
      _result.dimension = dimension;
    }
    return _result;
  }
  factory TrackSubscriptionDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrackSubscriptionDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrackSubscriptionDetails clone() => TrackSubscriptionDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrackSubscriptionDetails copyWith(void Function(TrackSubscriptionDetails) updates) => super.copyWith((message) => updates(message as TrackSubscriptionDetails)) as TrackSubscriptionDetails; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TrackSubscriptionDetails create() => TrackSubscriptionDetails._();
  TrackSubscriptionDetails createEmptyInstance() => create();
  static $pb.PbList<TrackSubscriptionDetails> createRepeated() => $pb.PbList<TrackSubscriptionDetails>();
  @$core.pragma('dart2js:noInline')
  static TrackSubscriptionDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrackSubscriptionDetails>(create);
  static TrackSubscriptionDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $0.TrackType get trackType => $_getN(2);
  @$pb.TagNumber(3)
  set trackType($0.TrackType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTrackType() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrackType() => clearField(3);

  @$pb.TagNumber(4)
  $0.VideoDimension get dimension => $_getN(3);
  @$pb.TagNumber(4)
  set dimension($0.VideoDimension v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasDimension() => $_has(3);
  @$pb.TagNumber(4)
  void clearDimension() => clearField(4);
  @$pb.TagNumber(4)
  $0.VideoDimension ensureDimension() => $_ensure(3);
}

class SendAnswerRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendAnswerRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..e<$0.PeerType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peerType', $pb.PbFieldType.OE, defaultOrMaker: $0.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED, valueOf: $0.PeerType.valueOf, enumValues: $0.PeerType.values)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdp')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
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

  @$pb.TagNumber(3)
  $core.String get sessionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sessionId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionId() => clearField(3);
}

class SendAnswerResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendAnswerResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..aOM<$0.Error>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error', subBuilder: $0.Error.create)
    ..hasRequiredFields = false
  ;

  SendAnswerResponse._() : super();
  factory SendAnswerResponse({
    $0.Error? error,
  }) {
    final _result = create();
    if (error != null) {
      _result.error = error;
    }
    return _result;
  }
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

  @$pb.TagNumber(4)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(4)
  set error($0.Error v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(4)
  void clearError() => clearField(4);
  @$pb.TagNumber(4)
  $0.Error ensureError() => $_ensure(0);
}

class ICETrickleResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ICETrickleResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..aOM<$0.Error>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error', subBuilder: $0.Error.create)
    ..hasRequiredFields = false
  ;

  ICETrickleResponse._() : super();
  factory ICETrickleResponse({
    $0.Error? error,
  }) {
    final _result = create();
    if (error != null) {
      _result.error = error;
    }
    return _result;
  }
  factory ICETrickleResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ICETrickleResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ICETrickleResponse clone() => ICETrickleResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ICETrickleResponse copyWith(void Function(ICETrickleResponse) updates) => super.copyWith((message) => updates(message as ICETrickleResponse)) as ICETrickleResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ICETrickleResponse create() => ICETrickleResponse._();
  ICETrickleResponse createEmptyInstance() => create();
  static $pb.PbList<ICETrickleResponse> createRepeated() => $pb.PbList<ICETrickleResponse>();
  @$core.pragma('dart2js:noInline')
  static ICETrickleResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ICETrickleResponse>(create);
  static ICETrickleResponse? _defaultInstance;

  @$pb.TagNumber(4)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(4)
  set error($0.Error v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(4)
  void clearError() => clearField(4);
  @$pb.TagNumber(4)
  $0.Error ensureError() => $_ensure(0);
}

class SetPublisherRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SetPublisherRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdp')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..pc<$0.TrackInfo>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tracks', $pb.PbFieldType.PM, subBuilder: $0.TrackInfo.create)
    ..hasRequiredFields = false
  ;

  SetPublisherRequest._() : super();
  factory SetPublisherRequest({
    $core.String? sdp,
    $core.String? sessionId,
    $core.Iterable<$0.TrackInfo>? tracks,
  }) {
    final _result = create();
    if (sdp != null) {
      _result.sdp = sdp;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (tracks != null) {
      _result.tracks.addAll(tracks);
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

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$0.TrackInfo> get tracks => $_getList(2);
}

class SetPublisherResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SetPublisherResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.signal'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdp')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iceRestart')
    ..aOM<$0.Error>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error', subBuilder: $0.Error.create)
    ..hasRequiredFields = false
  ;

  SetPublisherResponse._() : super();
  factory SetPublisherResponse({
    $core.String? sdp,
    $core.String? sessionId,
    $core.bool? iceRestart,
    $0.Error? error,
  }) {
    final _result = create();
    if (sdp != null) {
      _result.sdp = sdp;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (iceRestart != null) {
      _result.iceRestart = iceRestart;
    }
    if (error != null) {
      _result.error = error;
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

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get iceRestart => $_getBF(2);
  @$pb.TagNumber(3)
  set iceRestart($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIceRestart() => $_has(2);
  @$pb.TagNumber(3)
  void clearIceRestart() => clearField(3);

  @$pb.TagNumber(4)
  $0.Error get error => $_getN(3);
  @$pb.TagNumber(4)
  set error($0.Error v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(3);
  @$pb.TagNumber(4)
  void clearError() => clearField(4);
  @$pb.TagNumber(4)
  $0.Error ensureError() => $_ensure(3);
}

class SignalServerApi {
  $pb.RpcClient _client;
  SignalServerApi(this._client);

  $async.Future<SetPublisherResponse> setPublisher($pb.ClientContext? ctx, SetPublisherRequest request) {
    var emptyResponse = SetPublisherResponse();
    return _client.invoke<SetPublisherResponse>(ctx, 'SignalServer', 'SetPublisher', request, emptyResponse);
  }
  $async.Future<SendAnswerResponse> sendAnswer($pb.ClientContext? ctx, SendAnswerRequest request) {
    var emptyResponse = SendAnswerResponse();
    return _client.invoke<SendAnswerResponse>(ctx, 'SignalServer', 'SendAnswer', request, emptyResponse);
  }
  $async.Future<ICETrickleResponse> iceTrickle($pb.ClientContext? ctx, $0.ICETrickle request) {
    var emptyResponse = ICETrickleResponse();
    return _client.invoke<ICETrickleResponse>(ctx, 'SignalServer', 'IceTrickle', request, emptyResponse);
  }
  $async.Future<UpdateSubscriptionsResponse> updateSubscriptions($pb.ClientContext? ctx, UpdateSubscriptionsRequest request) {
    var emptyResponse = UpdateSubscriptionsResponse();
    return _client.invoke<UpdateSubscriptionsResponse>(ctx, 'SignalServer', 'UpdateSubscriptions', request, emptyResponse);
  }
  $async.Future<UpdateMuteStatesResponse> updateMuteStates($pb.ClientContext? ctx, UpdateMuteStatesRequest request) {
    var emptyResponse = UpdateMuteStatesResponse();
    return _client.invoke<UpdateMuteStatesResponse>(ctx, 'SignalServer', 'UpdateMuteStates', request, emptyResponse);
  }
  $async.Future<ICERestartResponse> iceRestart($pb.ClientContext? ctx, ICERestartRequest request) {
    var emptyResponse = ICERestartResponse();
    return _client.invoke<ICERestartResponse>(ctx, 'SignalServer', 'IceRestart', request, emptyResponse);
  }
}

