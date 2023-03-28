///
//  Generated code. Do not modify.
//  source: video/sfu/models/models.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../../google/protobuf/timestamp.pb.dart' as $0;
import '../../../google/protobuf/struct.pb.dart' as $1;

import 'models.pbenum.dart';

export 'models.pbenum.dart';

class CallState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallState', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.models'), createEmptyInstance: create)
    ..pc<Participant>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participants', $pb.PbFieldType.PM, subBuilder: Participant.create)
    ..hasRequiredFields = false
  ;

  CallState._() : super();
  factory CallState({
    $core.Iterable<Participant>? participants,
  }) {
    final _result = create();
    if (participants != null) {
      _result.participants.addAll(participants);
    }
    return _result;
  }
  factory CallState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallState clone() => CallState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallState copyWith(void Function(CallState) updates) => super.copyWith((message) => updates(message as CallState)) as CallState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallState create() => CallState._();
  CallState createEmptyInstance() => create();
  static $pb.PbList<CallState> createRepeated() => $pb.PbList<CallState>();
  @$core.pragma('dart2js:noInline')
  static CallState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallState>(create);
  static CallState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Participant> get participants => $_getList(0);
}

class Participant extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Participant', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.models'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..pc<TrackType>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publishedTracks', $pb.PbFieldType.KE, valueOf: TrackType.valueOf, enumValues: TrackType.values, defaultEnumValue: TrackType.TRACK_TYPE_UNSPECIFIED)
    ..aOM<$0.Timestamp>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'joinedAt', subBuilder: $0.Timestamp.create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trackLookupPrefix')
    ..e<ConnectionQuality>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectionQuality', $pb.PbFieldType.OE, defaultOrMaker: ConnectionQuality.CONNECTION_QUALITY_UNSPECIFIED, valueOf: ConnectionQuality.valueOf, enumValues: ConnectionQuality.values)
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isSpeaking')
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isDominantSpeaker')
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioLevel', $pb.PbFieldType.OF)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'image')
    ..aOM<$1.Struct>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'custom', subBuilder: $1.Struct.create)
    ..hasRequiredFields = false
  ;

  Participant._() : super();
  factory Participant({
    $core.String? userId,
    $core.String? sessionId,
    $core.Iterable<TrackType>? publishedTracks,
    $0.Timestamp? joinedAt,
    $core.String? trackLookupPrefix,
    ConnectionQuality? connectionQuality,
    $core.bool? isSpeaking,
    $core.bool? isDominantSpeaker,
    $core.double? audioLevel,
    $core.String? name,
    $core.String? image,
    $1.Struct? custom,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (publishedTracks != null) {
      _result.publishedTracks.addAll(publishedTracks);
    }
    if (joinedAt != null) {
      _result.joinedAt = joinedAt;
    }
    if (trackLookupPrefix != null) {
      _result.trackLookupPrefix = trackLookupPrefix;
    }
    if (connectionQuality != null) {
      _result.connectionQuality = connectionQuality;
    }
    if (isSpeaking != null) {
      _result.isSpeaking = isSpeaking;
    }
    if (isDominantSpeaker != null) {
      _result.isDominantSpeaker = isDominantSpeaker;
    }
    if (audioLevel != null) {
      _result.audioLevel = audioLevel;
    }
    if (name != null) {
      _result.name = name;
    }
    if (image != null) {
      _result.image = image;
    }
    if (custom != null) {
      _result.custom = custom;
    }
    return _result;
  }
  factory Participant.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Participant.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Participant clone() => Participant()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Participant copyWith(void Function(Participant) updates) => super.copyWith((message) => updates(message as Participant)) as Participant; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Participant create() => Participant._();
  Participant createEmptyInstance() => create();
  static $pb.PbList<Participant> createRepeated() => $pb.PbList<Participant>();
  @$core.pragma('dart2js:noInline')
  static Participant getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Participant>(create);
  static Participant? _defaultInstance;

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
  $core.List<TrackType> get publishedTracks => $_getList(2);

  @$pb.TagNumber(4)
  $0.Timestamp get joinedAt => $_getN(3);
  @$pb.TagNumber(4)
  set joinedAt($0.Timestamp v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasJoinedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearJoinedAt() => clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureJoinedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get trackLookupPrefix => $_getSZ(4);
  @$pb.TagNumber(5)
  set trackLookupPrefix($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTrackLookupPrefix() => $_has(4);
  @$pb.TagNumber(5)
  void clearTrackLookupPrefix() => clearField(5);

  @$pb.TagNumber(6)
  ConnectionQuality get connectionQuality => $_getN(5);
  @$pb.TagNumber(6)
  set connectionQuality(ConnectionQuality v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasConnectionQuality() => $_has(5);
  @$pb.TagNumber(6)
  void clearConnectionQuality() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isSpeaking => $_getBF(6);
  @$pb.TagNumber(7)
  set isSpeaking($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIsSpeaking() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsSpeaking() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isDominantSpeaker => $_getBF(7);
  @$pb.TagNumber(8)
  set isDominantSpeaker($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasIsDominantSpeaker() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsDominantSpeaker() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get audioLevel => $_getN(8);
  @$pb.TagNumber(9)
  set audioLevel($core.double v) { $_setFloat(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasAudioLevel() => $_has(8);
  @$pb.TagNumber(9)
  void clearAudioLevel() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get name => $_getSZ(9);
  @$pb.TagNumber(10)
  set name($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasName() => $_has(9);
  @$pb.TagNumber(10)
  void clearName() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get image => $_getSZ(10);
  @$pb.TagNumber(11)
  set image($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasImage() => $_has(10);
  @$pb.TagNumber(11)
  void clearImage() => clearField(11);

  @$pb.TagNumber(12)
  $1.Struct get custom => $_getN(11);
  @$pb.TagNumber(12)
  set custom($1.Struct v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasCustom() => $_has(11);
  @$pb.TagNumber(12)
  void clearCustom() => clearField(12);
  @$pb.TagNumber(12)
  $1.Struct ensureCustom() => $_ensure(11);
}

class StreamQuality extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StreamQuality', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.models'), createEmptyInstance: create)
    ..e<VideoQuality>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'videoQuality', $pb.PbFieldType.OE, defaultOrMaker: VideoQuality.VIDEO_QUALITY_LOW_UNSPECIFIED, valueOf: VideoQuality.valueOf, enumValues: VideoQuality.values)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  StreamQuality._() : super();
  factory StreamQuality({
    VideoQuality? videoQuality,
    $core.String? userId,
  }) {
    final _result = create();
    if (videoQuality != null) {
      _result.videoQuality = videoQuality;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory StreamQuality.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StreamQuality.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StreamQuality clone() => StreamQuality()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StreamQuality copyWith(void Function(StreamQuality) updates) => super.copyWith((message) => updates(message as StreamQuality)) as StreamQuality; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StreamQuality create() => StreamQuality._();
  StreamQuality createEmptyInstance() => create();
  static $pb.PbList<StreamQuality> createRepeated() => $pb.PbList<StreamQuality>();
  @$core.pragma('dart2js:noInline')
  static StreamQuality getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StreamQuality>(create);
  static StreamQuality? _defaultInstance;

  @$pb.TagNumber(1)
  VideoQuality get videoQuality => $_getN(0);
  @$pb.TagNumber(1)
  set videoQuality(VideoQuality v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasVideoQuality() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoQuality() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);
}

class VideoDimension extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoDimension', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.models'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'width', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'height', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  VideoDimension._() : super();
  factory VideoDimension({
    $core.int? width,
    $core.int? height,
  }) {
    final _result = create();
    if (width != null) {
      _result.width = width;
    }
    if (height != null) {
      _result.height = height;
    }
    return _result;
  }
  factory VideoDimension.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoDimension.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoDimension clone() => VideoDimension()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoDimension copyWith(void Function(VideoDimension) updates) => super.copyWith((message) => updates(message as VideoDimension)) as VideoDimension; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoDimension create() => VideoDimension._();
  VideoDimension createEmptyInstance() => create();
  static $pb.PbList<VideoDimension> createRepeated() => $pb.PbList<VideoDimension>();
  @$core.pragma('dart2js:noInline')
  static VideoDimension getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoDimension>(create);
  static VideoDimension? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get width => $_getIZ(0);
  @$pb.TagNumber(1)
  set width($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get height => $_getIZ(1);
  @$pb.TagNumber(2)
  set height($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => clearField(2);
}

class VideoLayer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoLayer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.models'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rid')
    ..aOM<VideoDimension>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'videoDimension', subBuilder: VideoDimension.create)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bitrate', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fps', $pb.PbFieldType.OU3)
    ..e<VideoQuality>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quality', $pb.PbFieldType.OE, defaultOrMaker: VideoQuality.VIDEO_QUALITY_LOW_UNSPECIFIED, valueOf: VideoQuality.valueOf, enumValues: VideoQuality.values)
    ..hasRequiredFields = false
  ;

  VideoLayer._() : super();
  factory VideoLayer({
    $core.String? rid,
    VideoDimension? videoDimension,
    $core.int? bitrate,
    $core.int? fps,
    VideoQuality? quality,
  }) {
    final _result = create();
    if (rid != null) {
      _result.rid = rid;
    }
    if (videoDimension != null) {
      _result.videoDimension = videoDimension;
    }
    if (bitrate != null) {
      _result.bitrate = bitrate;
    }
    if (fps != null) {
      _result.fps = fps;
    }
    if (quality != null) {
      _result.quality = quality;
    }
    return _result;
  }
  factory VideoLayer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoLayer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoLayer clone() => VideoLayer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoLayer copyWith(void Function(VideoLayer) updates) => super.copyWith((message) => updates(message as VideoLayer)) as VideoLayer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoLayer create() => VideoLayer._();
  VideoLayer createEmptyInstance() => create();
  static $pb.PbList<VideoLayer> createRepeated() => $pb.PbList<VideoLayer>();
  @$core.pragma('dart2js:noInline')
  static VideoLayer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoLayer>(create);
  static VideoLayer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rid => $_getSZ(0);
  @$pb.TagNumber(1)
  set rid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRid() => clearField(1);

  @$pb.TagNumber(2)
  VideoDimension get videoDimension => $_getN(1);
  @$pb.TagNumber(2)
  set videoDimension(VideoDimension v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasVideoDimension() => $_has(1);
  @$pb.TagNumber(2)
  void clearVideoDimension() => clearField(2);
  @$pb.TagNumber(2)
  VideoDimension ensureVideoDimension() => $_ensure(1);

  @$pb.TagNumber(4)
  $core.int get bitrate => $_getIZ(2);
  @$pb.TagNumber(4)
  set bitrate($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasBitrate() => $_has(2);
  @$pb.TagNumber(4)
  void clearBitrate() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get fps => $_getIZ(3);
  @$pb.TagNumber(5)
  set fps($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasFps() => $_has(3);
  @$pb.TagNumber(5)
  void clearFps() => clearField(5);

  @$pb.TagNumber(6)
  VideoQuality get quality => $_getN(4);
  @$pb.TagNumber(6)
  set quality(VideoQuality v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasQuality() => $_has(4);
  @$pb.TagNumber(6)
  void clearQuality() => clearField(6);
}

class Codec extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Codec', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.models'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'payloadType', $pb.PbFieldType.OU3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fmtpLine')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clockRate', $pb.PbFieldType.OU3)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encodingParameters')
    ..pPS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'feedbacks')
    ..hasRequiredFields = false
  ;

  Codec._() : super();
  factory Codec({
    $core.int? payloadType,
    $core.String? name,
    $core.String? fmtpLine,
    $core.int? clockRate,
    $core.String? encodingParameters,
    $core.Iterable<$core.String>? feedbacks,
  }) {
    final _result = create();
    if (payloadType != null) {
      _result.payloadType = payloadType;
    }
    if (name != null) {
      _result.name = name;
    }
    if (fmtpLine != null) {
      _result.fmtpLine = fmtpLine;
    }
    if (clockRate != null) {
      _result.clockRate = clockRate;
    }
    if (encodingParameters != null) {
      _result.encodingParameters = encodingParameters;
    }
    if (feedbacks != null) {
      _result.feedbacks.addAll(feedbacks);
    }
    return _result;
  }
  factory Codec.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Codec.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Codec clone() => Codec()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Codec copyWith(void Function(Codec) updates) => super.copyWith((message) => updates(message as Codec)) as Codec; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Codec create() => Codec._();
  Codec createEmptyInstance() => create();
  static $pb.PbList<Codec> createRepeated() => $pb.PbList<Codec>();
  @$core.pragma('dart2js:noInline')
  static Codec getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Codec>(create);
  static Codec? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get payloadType => $_getIZ(0);
  @$pb.TagNumber(1)
  set payloadType($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayloadType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayloadType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get fmtpLine => $_getSZ(2);
  @$pb.TagNumber(3)
  set fmtpLine($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFmtpLine() => $_has(2);
  @$pb.TagNumber(3)
  void clearFmtpLine() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get clockRate => $_getIZ(3);
  @$pb.TagNumber(4)
  set clockRate($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasClockRate() => $_has(3);
  @$pb.TagNumber(4)
  void clearClockRate() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get encodingParameters => $_getSZ(4);
  @$pb.TagNumber(5)
  set encodingParameters($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEncodingParameters() => $_has(4);
  @$pb.TagNumber(5)
  void clearEncodingParameters() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.String> get feedbacks => $_getList(5);
}

class ICETrickle extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ICETrickle', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.models'), createEmptyInstance: create)
    ..e<PeerType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peerType', $pb.PbFieldType.OE, defaultOrMaker: PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED, valueOf: PeerType.valueOf, enumValues: PeerType.values)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iceCandidate')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  ICETrickle._() : super();
  factory ICETrickle({
    PeerType? peerType,
    $core.String? iceCandidate,
    $core.String? sessionId,
  }) {
    final _result = create();
    if (peerType != null) {
      _result.peerType = peerType;
    }
    if (iceCandidate != null) {
      _result.iceCandidate = iceCandidate;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    return _result;
  }
  factory ICETrickle.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ICETrickle.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ICETrickle clone() => ICETrickle()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ICETrickle copyWith(void Function(ICETrickle) updates) => super.copyWith((message) => updates(message as ICETrickle)) as ICETrickle; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ICETrickle create() => ICETrickle._();
  ICETrickle createEmptyInstance() => create();
  static $pb.PbList<ICETrickle> createRepeated() => $pb.PbList<ICETrickle>();
  @$core.pragma('dart2js:noInline')
  static ICETrickle getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ICETrickle>(create);
  static ICETrickle? _defaultInstance;

  @$pb.TagNumber(1)
  PeerType get peerType => $_getN(0);
  @$pb.TagNumber(1)
  set peerType(PeerType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeerType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iceCandidate => $_getSZ(1);
  @$pb.TagNumber(2)
  set iceCandidate($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIceCandidate() => $_has(1);
  @$pb.TagNumber(2)
  void clearIceCandidate() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sessionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sessionId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionId() => clearField(3);
}

class TrackInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrackInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.models'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trackId')
    ..e<TrackType>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trackType', $pb.PbFieldType.OE, defaultOrMaker: TrackType.TRACK_TYPE_UNSPECIFIED, valueOf: TrackType.valueOf, enumValues: TrackType.values)
    ..pc<VideoLayer>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'layers', $pb.PbFieldType.PM, subBuilder: VideoLayer.create)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mid')
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dtx')
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stereo')
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'red')
    ..hasRequiredFields = false
  ;

  TrackInfo._() : super();
  factory TrackInfo({
    $core.String? trackId,
    TrackType? trackType,
    $core.Iterable<VideoLayer>? layers,
    $core.String? mid,
    $core.bool? dtx,
    $core.bool? stereo,
    $core.bool? red,
  }) {
    final _result = create();
    if (trackId != null) {
      _result.trackId = trackId;
    }
    if (trackType != null) {
      _result.trackType = trackType;
    }
    if (layers != null) {
      _result.layers.addAll(layers);
    }
    if (mid != null) {
      _result.mid = mid;
    }
    if (dtx != null) {
      _result.dtx = dtx;
    }
    if (stereo != null) {
      _result.stereo = stereo;
    }
    if (red != null) {
      _result.red = red;
    }
    return _result;
  }
  factory TrackInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrackInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrackInfo clone() => TrackInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrackInfo copyWith(void Function(TrackInfo) updates) => super.copyWith((message) => updates(message as TrackInfo)) as TrackInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TrackInfo create() => TrackInfo._();
  TrackInfo createEmptyInstance() => create();
  static $pb.PbList<TrackInfo> createRepeated() => $pb.PbList<TrackInfo>();
  @$core.pragma('dart2js:noInline')
  static TrackInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrackInfo>(create);
  static TrackInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackId() => clearField(1);

  @$pb.TagNumber(2)
  TrackType get trackType => $_getN(1);
  @$pb.TagNumber(2)
  set trackType(TrackType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTrackType() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrackType() => clearField(2);

  @$pb.TagNumber(5)
  $core.List<VideoLayer> get layers => $_getList(2);

  @$pb.TagNumber(6)
  $core.String get mid => $_getSZ(3);
  @$pb.TagNumber(6)
  set mid($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(6)
  $core.bool hasMid() => $_has(3);
  @$pb.TagNumber(6)
  void clearMid() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get dtx => $_getBF(4);
  @$pb.TagNumber(7)
  set dtx($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(7)
  $core.bool hasDtx() => $_has(4);
  @$pb.TagNumber(7)
  void clearDtx() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get stereo => $_getBF(5);
  @$pb.TagNumber(8)
  set stereo($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(8)
  $core.bool hasStereo() => $_has(5);
  @$pb.TagNumber(8)
  void clearStereo() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get red => $_getBF(6);
  @$pb.TagNumber(9)
  set red($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(9)
  $core.bool hasRed() => $_has(6);
  @$pb.TagNumber(9)
  void clearRed() => clearField(9);
}

class Call extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Call', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.models'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdByUserId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hostUserId')
    ..aOM<$1.Struct>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'custom', subBuilder: $1.Struct.create)
    ..aOM<$0.Timestamp>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  Call._() : super();
  factory Call({
    $core.String? type,
    $core.String? id,
    $core.String? createdByUserId,
    $core.String? hostUserId,
    $1.Struct? custom,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (id != null) {
      _result.id = id;
    }
    if (createdByUserId != null) {
      _result.createdByUserId = createdByUserId;
    }
    if (hostUserId != null) {
      _result.hostUserId = hostUserId;
    }
    if (custom != null) {
      _result.custom = custom;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    return _result;
  }
  factory Call.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Call.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Call clone() => Call()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Call copyWith(void Function(Call) updates) => super.copyWith((message) => updates(message as Call)) as Call; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Call create() => Call._();
  Call createEmptyInstance() => create();
  static $pb.PbList<Call> createRepeated() => $pb.PbList<Call>();
  @$core.pragma('dart2js:noInline')
  static Call getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Call>(create);
  static Call? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get createdByUserId => $_getSZ(2);
  @$pb.TagNumber(3)
  set createdByUserId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCreatedByUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedByUserId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get hostUserId => $_getSZ(3);
  @$pb.TagNumber(4)
  set hostUserId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHostUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearHostUserId() => clearField(4);

  @$pb.TagNumber(5)
  $1.Struct get custom => $_getN(4);
  @$pb.TagNumber(5)
  set custom($1.Struct v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCustom() => $_has(4);
  @$pb.TagNumber(5)
  void clearCustom() => clearField(5);
  @$pb.TagNumber(5)
  $1.Struct ensureCustom() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($0.Timestamp v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get updatedAt => $_getN(6);
  @$pb.TagNumber(7)
  set updatedAt($0.Timestamp v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureUpdatedAt() => $_ensure(6);
}

class Error extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Error', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.models'), createEmptyInstance: create)
    ..e<ErrorCode>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code', $pb.PbFieldType.OE, defaultOrMaker: ErrorCode.ERROR_CODE_UNSPECIFIED, valueOf: ErrorCode.valueOf, enumValues: ErrorCode.values)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'shouldRetry')
    ..hasRequiredFields = false
  ;

  Error._() : super();
  factory Error({
    ErrorCode? code,
    $core.String? message,
    $core.bool? shouldRetry,
  }) {
    final _result = create();
    if (code != null) {
      _result.code = code;
    }
    if (message != null) {
      _result.message = message;
    }
    if (shouldRetry != null) {
      _result.shouldRetry = shouldRetry;
    }
    return _result;
  }
  factory Error.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Error.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Error clone() => Error()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Error copyWith(void Function(Error) updates) => super.copyWith((message) => updates(message as Error)) as Error; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Error create() => Error._();
  Error createEmptyInstance() => create();
  static $pb.PbList<Error> createRepeated() => $pb.PbList<Error>();
  @$core.pragma('dart2js:noInline')
  static Error getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Error>(create);
  static Error? _defaultInstance;

  @$pb.TagNumber(1)
  ErrorCode get code => $_getN(0);
  @$pb.TagNumber(1)
  set code(ErrorCode v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get shouldRetry => $_getBF(2);
  @$pb.TagNumber(3)
  set shouldRetry($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasShouldRetry() => $_has(2);
  @$pb.TagNumber(3)
  void clearShouldRetry() => clearField(3);
}

class ClientDetails extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ClientDetails', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.models'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'os')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'browser')
    ..hasRequiredFields = false
  ;

  ClientDetails._() : super();
  factory ClientDetails({
    $core.int? version,
    $core.String? os,
    $core.String? browser,
  }) {
    final _result = create();
    if (version != null) {
      _result.version = version;
    }
    if (os != null) {
      _result.os = os;
    }
    if (browser != null) {
      _result.browser = browser;
    }
    return _result;
  }
  factory ClientDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClientDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClientDetails clone() => ClientDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClientDetails copyWith(void Function(ClientDetails) updates) => super.copyWith((message) => updates(message as ClientDetails)) as ClientDetails; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClientDetails create() => ClientDetails._();
  ClientDetails createEmptyInstance() => create();
  static $pb.PbList<ClientDetails> createRepeated() => $pb.PbList<ClientDetails>();
  @$core.pragma('dart2js:noInline')
  static ClientDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClientDetails>(create);
  static ClientDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get os => $_getSZ(1);
  @$pb.TagNumber(2)
  set os($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOs() => $_has(1);
  @$pb.TagNumber(2)
  void clearOs() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get browser => $_getSZ(2);
  @$pb.TagNumber(3)
  set browser($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBrowser() => $_has(2);
  @$pb.TagNumber(3)
  void clearBrowser() => clearField(3);
}

