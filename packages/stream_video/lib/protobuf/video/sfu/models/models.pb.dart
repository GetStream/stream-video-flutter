//
//  Generated code. Do not modify.
//  source: video/sfu/models/models.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../../google/protobuf/struct.pb.dart' as $1;
import '../../../google/protobuf/timestamp.pb.dart' as $0;
import 'models.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'models.pbenum.dart';

/// CallState is the current state of the call
/// as seen by an SFU.
class CallState extends $pb.GeneratedMessage {
  factory CallState({
    $core.Iterable<Participant>? participants,
    $0.Timestamp? startedAt,
    ParticipantCount? participantCount,
    $core.Iterable<Pin>? pins,
  }) {
    final $result = create();
    if (participants != null) {
      $result.participants.addAll(participants);
    }
    if (startedAt != null) {
      $result.startedAt = startedAt;
    }
    if (participantCount != null) {
      $result.participantCount = participantCount;
    }
    if (pins != null) {
      $result.pins.addAll(pins);
    }
    return $result;
  }
  CallState._() : super();
  factory CallState.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CallState.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CallState',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..pc<Participant>(
        1, _omitFieldNames ? '' : 'participants', $pb.PbFieldType.PM,
        subBuilder: Participant.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<ParticipantCount>(3, _omitFieldNames ? '' : 'participantCount',
        subBuilder: ParticipantCount.create)
    ..pc<Pin>(4, _omitFieldNames ? '' : 'pins', $pb.PbFieldType.PM,
        subBuilder: Pin.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CallState clone() => CallState()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CallState copyWith(void Function(CallState) updates) =>
      super.copyWith((message) => updates(message as CallState)) as CallState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CallState create() => CallState._();
  CallState createEmptyInstance() => create();
  static $pb.PbList<CallState> createRepeated() => $pb.PbList<CallState>();
  @$core.pragma('dart2js:noInline')
  static CallState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallState>(create);
  static CallState? _defaultInstance;

  /// participants is the list of participants in the call.
  /// In large calls, the list could be truncated in which
  /// case, the list of participants contains fewer participants
  /// than the counts returned in participant_count. Anonymous
  /// participants are **NOT** included in the list.
  @$pb.TagNumber(1)
  $pb.PbList<Participant> get participants => $_getList(0);

  /// started_at is the time the call session actually started.
  @$pb.TagNumber(2)
  $0.Timestamp get startedAt => $_getN(1);
  @$pb.TagNumber(2)
  set startedAt($0.Timestamp v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasStartedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureStartedAt() => $_ensure(1);

  /// participant_count contains the summary of the counts.
  @$pb.TagNumber(3)
  ParticipantCount get participantCount => $_getN(2);
  @$pb.TagNumber(3)
  set participantCount(ParticipantCount v) {
    $_setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasParticipantCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearParticipantCount() => $_clearField(3);
  @$pb.TagNumber(3)
  ParticipantCount ensureParticipantCount() => $_ensure(2);

  /// the list of pins in the call.
  /// Pins are ordered in descending order (most important first).
  @$pb.TagNumber(4)
  $pb.PbList<Pin> get pins => $_getList(3);
}

class ParticipantCount extends $pb.GeneratedMessage {
  factory ParticipantCount({
    $core.int? total,
    $core.int? anonymous,
  }) {
    final $result = create();
    if (total != null) {
      $result.total = total;
    }
    if (anonymous != null) {
      $result.anonymous = anonymous;
    }
    return $result;
  }
  ParticipantCount._() : super();
  factory ParticipantCount.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ParticipantCount.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParticipantCount',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'total', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'anonymous', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ParticipantCount clone() => ParticipantCount()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ParticipantCount copyWith(void Function(ParticipantCount) updates) =>
      super.copyWith((message) => updates(message as ParticipantCount))
          as ParticipantCount;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParticipantCount create() => ParticipantCount._();
  ParticipantCount createEmptyInstance() => create();
  static $pb.PbList<ParticipantCount> createRepeated() =>
      $pb.PbList<ParticipantCount>();
  @$core.pragma('dart2js:noInline')
  static ParticipantCount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParticipantCount>(create);
  static ParticipantCount? _defaultInstance;

  /// Total number of participants in the call including
  /// the anonymous participants.
  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  /// Total number of anonymous participants in the call.
  @$pb.TagNumber(2)
  $core.int get anonymous => $_getIZ(1);
  @$pb.TagNumber(2)
  set anonymous($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAnonymous() => $_has(1);
  @$pb.TagNumber(2)
  void clearAnonymous() => $_clearField(2);
}

class Pin extends $pb.GeneratedMessage {
  factory Pin({
    $core.String? userId,
    $core.String? sessionId,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    return $result;
  }
  Pin._() : super();
  factory Pin.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Pin.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Pin',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Pin clone() => Pin()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Pin copyWith(void Function(Pin) updates) =>
      super.copyWith((message) => updates(message as Pin)) as Pin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Pin create() => Pin._();
  Pin createEmptyInstance() => create();
  static $pb.PbList<Pin> createRepeated() => $pb.PbList<Pin>();
  @$core.pragma('dart2js:noInline')
  static Pin getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Pin>(create);
  static Pin? _defaultInstance;

  /// the user to pin
  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  /// the user sesion_id to pin, if not provided, applies to all sessions
  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

/// those who are online in the call
class Participant extends $pb.GeneratedMessage {
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
    $core.Iterable<$core.String>? roles,
    ParticipantSource? source,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (publishedTracks != null) {
      $result.publishedTracks.addAll(publishedTracks);
    }
    if (joinedAt != null) {
      $result.joinedAt = joinedAt;
    }
    if (trackLookupPrefix != null) {
      $result.trackLookupPrefix = trackLookupPrefix;
    }
    if (connectionQuality != null) {
      $result.connectionQuality = connectionQuality;
    }
    if (isSpeaking != null) {
      $result.isSpeaking = isSpeaking;
    }
    if (isDominantSpeaker != null) {
      $result.isDominantSpeaker = isDominantSpeaker;
    }
    if (audioLevel != null) {
      $result.audioLevel = audioLevel;
    }
    if (name != null) {
      $result.name = name;
    }
    if (image != null) {
      $result.image = image;
    }
    if (custom != null) {
      $result.custom = custom;
    }
    if (roles != null) {
      $result.roles.addAll(roles);
    }
    if (source != null) {
      $result.source = source;
    }
    return $result;
  }
  Participant._() : super();
  factory Participant.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Participant.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Participant',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..pc<TrackType>(
        3, _omitFieldNames ? '' : 'publishedTracks', $pb.PbFieldType.KE,
        valueOf: TrackType.valueOf,
        enumValues: TrackType.values,
        defaultEnumValue: TrackType.TRACK_TYPE_UNSPECIFIED)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'joinedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'trackLookupPrefix')
    ..e<ConnectionQuality>(
        6, _omitFieldNames ? '' : 'connectionQuality', $pb.PbFieldType.OE,
        defaultOrMaker: ConnectionQuality.CONNECTION_QUALITY_UNSPECIFIED,
        valueOf: ConnectionQuality.valueOf,
        enumValues: ConnectionQuality.values)
    ..aOB(7, _omitFieldNames ? '' : 'isSpeaking')
    ..aOB(8, _omitFieldNames ? '' : 'isDominantSpeaker')
    ..a<$core.double>(
        9, _omitFieldNames ? '' : 'audioLevel', $pb.PbFieldType.OF)
    ..aOS(10, _omitFieldNames ? '' : 'name')
    ..aOS(11, _omitFieldNames ? '' : 'image')
    ..aOM<$1.Struct>(12, _omitFieldNames ? '' : 'custom',
        subBuilder: $1.Struct.create)
    ..pPS(13, _omitFieldNames ? '' : 'roles')
    ..e<ParticipantSource>(
        14, _omitFieldNames ? '' : 'source', $pb.PbFieldType.OE,
        defaultOrMaker: ParticipantSource.PARTICIPANT_SOURCE_WEBRTC_UNSPECIFIED,
        valueOf: ParticipantSource.valueOf,
        enumValues: ParticipantSource.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Participant clone() => Participant()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Participant copyWith(void Function(Participant) updates) =>
      super.copyWith((message) => updates(message as Participant))
          as Participant;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Participant create() => Participant._();
  Participant createEmptyInstance() => create();
  static $pb.PbList<Participant> createRepeated() => $pb.PbList<Participant>();
  @$core.pragma('dart2js:noInline')
  static Participant getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Participant>(create);
  static Participant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  /// map of track id to track type
  @$pb.TagNumber(3)
  $pb.PbList<TrackType> get publishedTracks => $_getList(2);

  @$pb.TagNumber(4)
  $0.Timestamp get joinedAt => $_getN(3);
  @$pb.TagNumber(4)
  set joinedAt($0.Timestamp v) {
    $_setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasJoinedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearJoinedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureJoinedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get trackLookupPrefix => $_getSZ(4);
  @$pb.TagNumber(5)
  set trackLookupPrefix($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasTrackLookupPrefix() => $_has(4);
  @$pb.TagNumber(5)
  void clearTrackLookupPrefix() => $_clearField(5);

  @$pb.TagNumber(6)
  ConnectionQuality get connectionQuality => $_getN(5);
  @$pb.TagNumber(6)
  set connectionQuality(ConnectionQuality v) {
    $_setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasConnectionQuality() => $_has(5);
  @$pb.TagNumber(6)
  void clearConnectionQuality() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isSpeaking => $_getBF(6);
  @$pb.TagNumber(7)
  set isSpeaking($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasIsSpeaking() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsSpeaking() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isDominantSpeaker => $_getBF(7);
  @$pb.TagNumber(8)
  set isDominantSpeaker($core.bool v) {
    $_setBool(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasIsDominantSpeaker() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsDominantSpeaker() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get audioLevel => $_getN(8);
  @$pb.TagNumber(9)
  set audioLevel($core.double v) {
    $_setFloat(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasAudioLevel() => $_has(8);
  @$pb.TagNumber(9)
  void clearAudioLevel() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get name => $_getSZ(9);
  @$pb.TagNumber(10)
  set name($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasName() => $_has(9);
  @$pb.TagNumber(10)
  void clearName() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get image => $_getSZ(10);
  @$pb.TagNumber(11)
  set image($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasImage() => $_has(10);
  @$pb.TagNumber(11)
  void clearImage() => $_clearField(11);

  @$pb.TagNumber(12)
  $1.Struct get custom => $_getN(11);
  @$pb.TagNumber(12)
  set custom($1.Struct v) {
    $_setField(12, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasCustom() => $_has(11);
  @$pb.TagNumber(12)
  void clearCustom() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Struct ensureCustom() => $_ensure(11);

  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get roles => $_getList(12);

  @$pb.TagNumber(14)
  ParticipantSource get source => $_getN(13);
  @$pb.TagNumber(14)
  set source(ParticipantSource v) {
    $_setField(14, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasSource() => $_has(13);
  @$pb.TagNumber(14)
  void clearSource() => $_clearField(14);
}

class StreamQuality extends $pb.GeneratedMessage {
  factory StreamQuality({
    VideoQuality? videoQuality,
    $core.String? userId,
  }) {
    final $result = create();
    if (videoQuality != null) {
      $result.videoQuality = videoQuality;
    }
    if (userId != null) {
      $result.userId = userId;
    }
    return $result;
  }
  StreamQuality._() : super();
  factory StreamQuality.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory StreamQuality.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamQuality',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..e<VideoQuality>(
        1, _omitFieldNames ? '' : 'videoQuality', $pb.PbFieldType.OE,
        defaultOrMaker: VideoQuality.VIDEO_QUALITY_LOW_UNSPECIFIED,
        valueOf: VideoQuality.valueOf,
        enumValues: VideoQuality.values)
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  StreamQuality clone() => StreamQuality()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  StreamQuality copyWith(void Function(StreamQuality) updates) =>
      super.copyWith((message) => updates(message as StreamQuality))
          as StreamQuality;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamQuality create() => StreamQuality._();
  StreamQuality createEmptyInstance() => create();
  static $pb.PbList<StreamQuality> createRepeated() =>
      $pb.PbList<StreamQuality>();
  @$core.pragma('dart2js:noInline')
  static StreamQuality getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamQuality>(create);
  static StreamQuality? _defaultInstance;

  @$pb.TagNumber(1)
  VideoQuality get videoQuality => $_getN(0);
  @$pb.TagNumber(1)
  set videoQuality(VideoQuality v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasVideoQuality() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoQuality() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
}

class VideoDimension extends $pb.GeneratedMessage {
  factory VideoDimension({
    $core.int? width,
    $core.int? height,
  }) {
    final $result = create();
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    return $result;
  }
  VideoDimension._() : super();
  factory VideoDimension.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory VideoDimension.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoDimension',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  VideoDimension clone() => VideoDimension()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  VideoDimension copyWith(void Function(VideoDimension) updates) =>
      super.copyWith((message) => updates(message as VideoDimension))
          as VideoDimension;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoDimension create() => VideoDimension._();
  VideoDimension createEmptyInstance() => create();
  static $pb.PbList<VideoDimension> createRepeated() =>
      $pb.PbList<VideoDimension>();
  @$core.pragma('dart2js:noInline')
  static VideoDimension getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoDimension>(create);
  static VideoDimension? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get width => $_getIZ(0);
  @$pb.TagNumber(1)
  set width($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get height => $_getIZ(1);
  @$pb.TagNumber(2)
  set height($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);
}

class VideoLayer extends $pb.GeneratedMessage {
  factory VideoLayer({
    $core.String? rid,
    VideoDimension? videoDimension,
    $core.int? bitrate,
    $core.int? fps,
    VideoQuality? quality,
  }) {
    final $result = create();
    if (rid != null) {
      $result.rid = rid;
    }
    if (videoDimension != null) {
      $result.videoDimension = videoDimension;
    }
    if (bitrate != null) {
      $result.bitrate = bitrate;
    }
    if (fps != null) {
      $result.fps = fps;
    }
    if (quality != null) {
      $result.quality = quality;
    }
    return $result;
  }
  VideoLayer._() : super();
  factory VideoLayer.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory VideoLayer.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoLayer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'rid')
    ..aOM<VideoDimension>(2, _omitFieldNames ? '' : 'videoDimension',
        subBuilder: VideoDimension.create)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'bitrate', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'fps', $pb.PbFieldType.OU3)
    ..e<VideoQuality>(6, _omitFieldNames ? '' : 'quality', $pb.PbFieldType.OE,
        defaultOrMaker: VideoQuality.VIDEO_QUALITY_LOW_UNSPECIFIED,
        valueOf: VideoQuality.valueOf,
        enumValues: VideoQuality.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  VideoLayer clone() => VideoLayer()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  VideoLayer copyWith(void Function(VideoLayer) updates) =>
      super.copyWith((message) => updates(message as VideoLayer)) as VideoLayer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoLayer create() => VideoLayer._();
  VideoLayer createEmptyInstance() => create();
  static $pb.PbList<VideoLayer> createRepeated() => $pb.PbList<VideoLayer>();
  @$core.pragma('dart2js:noInline')
  static VideoLayer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoLayer>(create);
  static VideoLayer? _defaultInstance;

  /// for tracks with a single layer, this should be HIGH
  @$pb.TagNumber(1)
  $core.String get rid => $_getSZ(0);
  @$pb.TagNumber(1)
  set rid($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRid() => $_clearField(1);

  @$pb.TagNumber(2)
  VideoDimension get videoDimension => $_getN(1);
  @$pb.TagNumber(2)
  set videoDimension(VideoDimension v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasVideoDimension() => $_has(1);
  @$pb.TagNumber(2)
  void clearVideoDimension() => $_clearField(2);
  @$pb.TagNumber(2)
  VideoDimension ensureVideoDimension() => $_ensure(1);

  /// target bitrate, server will measure actual
  @$pb.TagNumber(4)
  $core.int get bitrate => $_getIZ(2);
  @$pb.TagNumber(4)
  set bitrate($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasBitrate() => $_has(2);
  @$pb.TagNumber(4)
  void clearBitrate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get fps => $_getIZ(3);
  @$pb.TagNumber(5)
  set fps($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasFps() => $_has(3);
  @$pb.TagNumber(5)
  void clearFps() => $_clearField(5);

  @$pb.TagNumber(6)
  VideoQuality get quality => $_getN(4);
  @$pb.TagNumber(6)
  set quality(VideoQuality v) {
    $_setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasQuality() => $_has(4);
  @$pb.TagNumber(6)
  void clearQuality() => $_clearField(6);
}

/// SubscribeOption represents the configuration options for subscribing to a track.
class SubscribeOption extends $pb.GeneratedMessage {
  factory SubscribeOption({
    TrackType? trackType,
    $core.Iterable<Codec>? codecs,
  }) {
    final $result = create();
    if (trackType != null) {
      $result.trackType = trackType;
    }
    if (codecs != null) {
      $result.codecs.addAll(codecs);
    }
    return $result;
  }
  SubscribeOption._() : super();
  factory SubscribeOption.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SubscribeOption.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeOption',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..e<TrackType>(1, _omitFieldNames ? '' : 'trackType', $pb.PbFieldType.OE,
        defaultOrMaker: TrackType.TRACK_TYPE_UNSPECIFIED,
        valueOf: TrackType.valueOf,
        enumValues: TrackType.values)
    ..pc<Codec>(2, _omitFieldNames ? '' : 'codecs', $pb.PbFieldType.PM,
        subBuilder: Codec.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SubscribeOption clone() => SubscribeOption()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SubscribeOption copyWith(void Function(SubscribeOption) updates) =>
      super.copyWith((message) => updates(message as SubscribeOption))
          as SubscribeOption;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscribeOption create() => SubscribeOption._();
  SubscribeOption createEmptyInstance() => create();
  static $pb.PbList<SubscribeOption> createRepeated() =>
      $pb.PbList<SubscribeOption>();
  @$core.pragma('dart2js:noInline')
  static SubscribeOption getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscribeOption>(create);
  static SubscribeOption? _defaultInstance;

  /// The type of the track being subscribed (e.g., video, screenshare).
  @$pb.TagNumber(1)
  TrackType get trackType => $_getN(0);
  @$pb.TagNumber(1)
  set trackType(TrackType v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTrackType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackType() => $_clearField(1);

  /// The codecs supported by the subscriber for decoding tracks.
  @$pb.TagNumber(2)
  $pb.PbList<Codec> get codecs => $_getList(1);
}

/// PublishOption represents the configuration options for publishing a track.
class PublishOption extends $pb.GeneratedMessage {
  factory PublishOption({
    TrackType? trackType,
    Codec? codec,
    $core.int? bitrate,
    $core.int? fps,
    $core.int? maxSpatialLayers,
    $core.int? maxTemporalLayers,
    VideoDimension? videoDimension,
    $core.int? id,
    $core.bool? useSingleLayer,
  }) {
    final $result = create();
    if (trackType != null) {
      $result.trackType = trackType;
    }
    if (codec != null) {
      $result.codec = codec;
    }
    if (bitrate != null) {
      $result.bitrate = bitrate;
    }
    if (fps != null) {
      $result.fps = fps;
    }
    if (maxSpatialLayers != null) {
      $result.maxSpatialLayers = maxSpatialLayers;
    }
    if (maxTemporalLayers != null) {
      $result.maxTemporalLayers = maxTemporalLayers;
    }
    if (videoDimension != null) {
      $result.videoDimension = videoDimension;
    }
    if (id != null) {
      $result.id = id;
    }
    if (useSingleLayer != null) {
      $result.useSingleLayer = useSingleLayer;
    }
    return $result;
  }
  PublishOption._() : super();
  factory PublishOption.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PublishOption.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishOption',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..e<TrackType>(1, _omitFieldNames ? '' : 'trackType', $pb.PbFieldType.OE,
        defaultOrMaker: TrackType.TRACK_TYPE_UNSPECIFIED,
        valueOf: TrackType.valueOf,
        enumValues: TrackType.values)
    ..aOM<Codec>(2, _omitFieldNames ? '' : 'codec', subBuilder: Codec.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'bitrate', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'fps', $pb.PbFieldType.O3)
    ..a<$core.int>(
        5, _omitFieldNames ? '' : 'maxSpatialLayers', $pb.PbFieldType.O3)
    ..a<$core.int>(
        6, _omitFieldNames ? '' : 'maxTemporalLayers', $pb.PbFieldType.O3)
    ..aOM<VideoDimension>(7, _omitFieldNames ? '' : 'videoDimension',
        subBuilder: VideoDimension.create)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOB(9, _omitFieldNames ? '' : 'useSingleLayer')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PublishOption clone() => PublishOption()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PublishOption copyWith(void Function(PublishOption) updates) =>
      super.copyWith((message) => updates(message as PublishOption))
          as PublishOption;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishOption create() => PublishOption._();
  PublishOption createEmptyInstance() => create();
  static $pb.PbList<PublishOption> createRepeated() =>
      $pb.PbList<PublishOption>();
  @$core.pragma('dart2js:noInline')
  static PublishOption getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishOption>(create);
  static PublishOption? _defaultInstance;

  /// The type of the track being published (e.g., video, screenshare).
  @$pb.TagNumber(1)
  TrackType get trackType => $_getN(0);
  @$pb.TagNumber(1)
  set trackType(TrackType v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTrackType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackType() => $_clearField(1);

  /// The codec to be used for encoding the track (e.g., VP8, VP9, H264).
  @$pb.TagNumber(2)
  Codec get codec => $_getN(1);
  @$pb.TagNumber(2)
  set codec(Codec v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCodec() => $_has(1);
  @$pb.TagNumber(2)
  void clearCodec() => $_clearField(2);
  @$pb.TagNumber(2)
  Codec ensureCodec() => $_ensure(1);

  /// The target bitrate for the published track, in bits per second.
  @$pb.TagNumber(3)
  $core.int get bitrate => $_getIZ(2);
  @$pb.TagNumber(3)
  set bitrate($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasBitrate() => $_has(2);
  @$pb.TagNumber(3)
  void clearBitrate() => $_clearField(3);

  /// The target frames per second (FPS) for video encoding.
  @$pb.TagNumber(4)
  $core.int get fps => $_getIZ(3);
  @$pb.TagNumber(4)
  set fps($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasFps() => $_has(3);
  @$pb.TagNumber(4)
  void clearFps() => $_clearField(4);

  /// The maximum number of spatial layers to send.
  /// - For SVC (e.g., VP9), spatial layers downscale by a factor of 2:
  ///   - 1 layer: full resolution
  ///   - 2 layers: full resolution + half resolution
  ///   - 3 layers: full resolution + half resolution + quarter resolution
  /// - For non-SVC codecs (e.g., VP8/H264), this determines the number of
  ///   encoded resolutions (e.g., quarter, half, full) sent for simulcast.
  @$pb.TagNumber(5)
  $core.int get maxSpatialLayers => $_getIZ(4);
  @$pb.TagNumber(5)
  set maxSpatialLayers($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasMaxSpatialLayers() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxSpatialLayers() => $_clearField(5);

  /// The maximum number of temporal layers for scalable video coding (SVC).
  /// Temporal layers allow varying frame rates for different bandwidths.
  @$pb.TagNumber(6)
  $core.int get maxTemporalLayers => $_getIZ(5);
  @$pb.TagNumber(6)
  set maxTemporalLayers($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasMaxTemporalLayers() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxTemporalLayers() => $_clearField(6);

  /// The dimensions of the video (e.g., width and height in pixels).
  /// Spatial layers are based on this base resolution. For example, if the base
  /// resolution is 1280x720:
  /// - Full resolution (1 layer) = 1280x720
  /// - Half resolution (2 layers) = 640x360
  /// - Quarter resolution (3 layers) = 320x180
  @$pb.TagNumber(7)
  VideoDimension get videoDimension => $_getN(6);
  @$pb.TagNumber(7)
  set videoDimension(VideoDimension v) {
    $_setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasVideoDimension() => $_has(6);
  @$pb.TagNumber(7)
  void clearVideoDimension() => $_clearField(7);
  @$pb.TagNumber(7)
  VideoDimension ensureVideoDimension() => $_ensure(6);

  /// The unique identifier for the publish request.
  /// - This `id` is assigned exclusively by the SFU. Any `id` set by the client
  ///   in the `PublishOption` will be ignored and overwritten by the SFU.
  /// - The primary purpose of this `id` is to uniquely identify each publish
  ///   request, even in scenarios where multiple publish requests for the same
  ///   `track_type` and `codec` are active simultaneously.
  ///   For example:
  ///     - A user may publish two tracks of the same type (e.g., video) and codec
  ///       (e.g., VP9) concurrently.
  /// - This uniqueness ensures that individual requests can be managed
  ///   independently. For instance, an `id` is critical when stopping a specific
  ///   publish request without affecting others.
  @$pb.TagNumber(8)
  $core.int get id => $_getIZ(7);
  @$pb.TagNumber(8)
  set id($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasId() => $_has(7);
  @$pb.TagNumber(8)
  void clearId() => $_clearField(8);

  /// If true, instructs the publisher to send only the highest available simulcast layer,
  /// disabling all lower layers. This applies to simulcast encodings.
  /// For SVC codecs, prefer using the L1T3 (single spatial, 3 temporal layers) mode instead.
  @$pb.TagNumber(9)
  $core.bool get useSingleLayer => $_getBF(8);
  @$pb.TagNumber(9)
  set useSingleLayer($core.bool v) {
    $_setBool(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasUseSingleLayer() => $_has(8);
  @$pb.TagNumber(9)
  void clearUseSingleLayer() => $_clearField(9);
}

class Codec extends $pb.GeneratedMessage {
  factory Codec({
    $core.String? name,
    $core.String? fmtp,
    $core.int? clockRate,
    $core.String? encodingParameters,
    $core.int? payloadType,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (fmtp != null) {
      $result.fmtp = fmtp;
    }
    if (clockRate != null) {
      $result.clockRate = clockRate;
    }
    if (encodingParameters != null) {
      $result.encodingParameters = encodingParameters;
    }
    if (payloadType != null) {
      $result.payloadType = payloadType;
    }
    return $result;
  }
  Codec._() : super();
  factory Codec.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Codec.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Codec',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..aOS(10, _omitFieldNames ? '' : 'name')
    ..aOS(12, _omitFieldNames ? '' : 'fmtp')
    ..a<$core.int>(14, _omitFieldNames ? '' : 'clockRate', $pb.PbFieldType.OU3)
    ..aOS(15, _omitFieldNames ? '' : 'encodingParameters')
    ..a<$core.int>(
        16, _omitFieldNames ? '' : 'payloadType', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Codec clone() => Codec()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Codec copyWith(void Function(Codec) updates) =>
      super.copyWith((message) => updates(message as Codec)) as Codec;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Codec create() => Codec._();
  Codec createEmptyInstance() => create();
  static $pb.PbList<Codec> createRepeated() => $pb.PbList<Codec>();
  @$core.pragma('dart2js:noInline')
  static Codec getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Codec>(create);
  static Codec? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(10)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(10)
  void clearName() => $_clearField(10);

  @$pb.TagNumber(12)
  $core.String get fmtp => $_getSZ(1);
  @$pb.TagNumber(12)
  set fmtp($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasFmtp() => $_has(1);
  @$pb.TagNumber(12)
  void clearFmtp() => $_clearField(12);

  @$pb.TagNumber(14)
  $core.int get clockRate => $_getIZ(2);
  @$pb.TagNumber(14)
  set clockRate($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasClockRate() => $_has(2);
  @$pb.TagNumber(14)
  void clearClockRate() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get encodingParameters => $_getSZ(3);
  @$pb.TagNumber(15)
  set encodingParameters($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasEncodingParameters() => $_has(3);
  @$pb.TagNumber(15)
  void clearEncodingParameters() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get payloadType => $_getIZ(4);
  @$pb.TagNumber(16)
  set payloadType($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasPayloadType() => $_has(4);
  @$pb.TagNumber(16)
  void clearPayloadType() => $_clearField(16);
}

class ICETrickle extends $pb.GeneratedMessage {
  factory ICETrickle({
    PeerType? peerType,
    $core.String? iceCandidate,
    $core.String? sessionId,
  }) {
    final $result = create();
    if (peerType != null) {
      $result.peerType = peerType;
    }
    if (iceCandidate != null) {
      $result.iceCandidate = iceCandidate;
    }
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    return $result;
  }
  ICETrickle._() : super();
  factory ICETrickle.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ICETrickle.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ICETrickle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..e<PeerType>(1, _omitFieldNames ? '' : 'peerType', $pb.PbFieldType.OE,
        defaultOrMaker: PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED,
        valueOf: PeerType.valueOf,
        enumValues: PeerType.values)
    ..aOS(2, _omitFieldNames ? '' : 'iceCandidate')
    ..aOS(3, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ICETrickle clone() => ICETrickle()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ICETrickle copyWith(void Function(ICETrickle) updates) =>
      super.copyWith((message) => updates(message as ICETrickle)) as ICETrickle;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ICETrickle create() => ICETrickle._();
  ICETrickle createEmptyInstance() => create();
  static $pb.PbList<ICETrickle> createRepeated() => $pb.PbList<ICETrickle>();
  @$core.pragma('dart2js:noInline')
  static ICETrickle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ICETrickle>(create);
  static ICETrickle? _defaultInstance;

  @$pb.TagNumber(1)
  PeerType get peerType => $_getN(0);
  @$pb.TagNumber(1)
  set peerType(PeerType v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPeerType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get iceCandidate => $_getSZ(1);
  @$pb.TagNumber(2)
  set iceCandidate($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasIceCandidate() => $_has(1);
  @$pb.TagNumber(2)
  void clearIceCandidate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sessionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sessionId($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionId() => $_clearField(3);
}

class TrackInfo extends $pb.GeneratedMessage {
  factory TrackInfo({
    $core.String? trackId,
    TrackType? trackType,
    $core.Iterable<VideoLayer>? layers,
    $core.String? mid,
    $core.bool? dtx,
    $core.bool? stereo,
    $core.bool? red,
    $core.bool? muted,
    Codec? codec,
    $core.int? publishOptionId,
  }) {
    final $result = create();
    if (trackId != null) {
      $result.trackId = trackId;
    }
    if (trackType != null) {
      $result.trackType = trackType;
    }
    if (layers != null) {
      $result.layers.addAll(layers);
    }
    if (mid != null) {
      $result.mid = mid;
    }
    if (dtx != null) {
      $result.dtx = dtx;
    }
    if (stereo != null) {
      $result.stereo = stereo;
    }
    if (red != null) {
      $result.red = red;
    }
    if (muted != null) {
      $result.muted = muted;
    }
    if (codec != null) {
      $result.codec = codec;
    }
    if (publishOptionId != null) {
      $result.publishOptionId = publishOptionId;
    }
    return $result;
  }
  TrackInfo._() : super();
  factory TrackInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TrackInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrackInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trackId')
    ..e<TrackType>(2, _omitFieldNames ? '' : 'trackType', $pb.PbFieldType.OE,
        defaultOrMaker: TrackType.TRACK_TYPE_UNSPECIFIED,
        valueOf: TrackType.valueOf,
        enumValues: TrackType.values)
    ..pc<VideoLayer>(5, _omitFieldNames ? '' : 'layers', $pb.PbFieldType.PM,
        subBuilder: VideoLayer.create)
    ..aOS(6, _omitFieldNames ? '' : 'mid')
    ..aOB(7, _omitFieldNames ? '' : 'dtx')
    ..aOB(8, _omitFieldNames ? '' : 'stereo')
    ..aOB(9, _omitFieldNames ? '' : 'red')
    ..aOB(10, _omitFieldNames ? '' : 'muted')
    ..aOM<Codec>(11, _omitFieldNames ? '' : 'codec', subBuilder: Codec.create)
    ..a<$core.int>(
        12, _omitFieldNames ? '' : 'publishOptionId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TrackInfo clone() => TrackInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TrackInfo copyWith(void Function(TrackInfo) updates) =>
      super.copyWith((message) => updates(message as TrackInfo)) as TrackInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrackInfo create() => TrackInfo._();
  TrackInfo createEmptyInstance() => create();
  static $pb.PbList<TrackInfo> createRepeated() => $pb.PbList<TrackInfo>();
  @$core.pragma('dart2js:noInline')
  static TrackInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrackInfo>(create);
  static TrackInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTrackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackId() => $_clearField(1);

  @$pb.TagNumber(2)
  TrackType get trackType => $_getN(1);
  @$pb.TagNumber(2)
  set trackType(TrackType v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTrackType() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrackType() => $_clearField(2);

  @$pb.TagNumber(5)
  $pb.PbList<VideoLayer> get layers => $_getList(2);

  @$pb.TagNumber(6)
  $core.String get mid => $_getSZ(3);
  @$pb.TagNumber(6)
  set mid($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasMid() => $_has(3);
  @$pb.TagNumber(6)
  void clearMid() => $_clearField(6);

  /// for audio tracks
  @$pb.TagNumber(7)
  $core.bool get dtx => $_getBF(4);
  @$pb.TagNumber(7)
  set dtx($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasDtx() => $_has(4);
  @$pb.TagNumber(7)
  void clearDtx() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get stereo => $_getBF(5);
  @$pb.TagNumber(8)
  set stereo($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasStereo() => $_has(5);
  @$pb.TagNumber(8)
  void clearStereo() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get red => $_getBF(6);
  @$pb.TagNumber(9)
  set red($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasRed() => $_has(6);
  @$pb.TagNumber(9)
  void clearRed() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get muted => $_getBF(7);
  @$pb.TagNumber(10)
  set muted($core.bool v) {
    $_setBool(7, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasMuted() => $_has(7);
  @$pb.TagNumber(10)
  void clearMuted() => $_clearField(10);

  @$pb.TagNumber(11)
  Codec get codec => $_getN(8);
  @$pb.TagNumber(11)
  set codec(Codec v) {
    $_setField(11, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasCodec() => $_has(8);
  @$pb.TagNumber(11)
  void clearCodec() => $_clearField(11);
  @$pb.TagNumber(11)
  Codec ensureCodec() => $_ensure(8);

  @$pb.TagNumber(12)
  $core.int get publishOptionId => $_getIZ(9);
  @$pb.TagNumber(12)
  set publishOptionId($core.int v) {
    $_setSignedInt32(9, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasPublishOptionId() => $_has(9);
  @$pb.TagNumber(12)
  void clearPublishOptionId() => $_clearField(12);
}

class Error extends $pb.GeneratedMessage {
  factory Error({
    ErrorCode? code,
    $core.String? message,
    $core.bool? shouldRetry,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (shouldRetry != null) {
      $result.shouldRetry = shouldRetry;
    }
    return $result;
  }
  Error._() : super();
  factory Error.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Error.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Error',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..e<ErrorCode>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.OE,
        defaultOrMaker: ErrorCode.ERROR_CODE_UNSPECIFIED,
        valueOf: ErrorCode.valueOf,
        enumValues: ErrorCode.values)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOB(3, _omitFieldNames ? '' : 'shouldRetry')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Error clone() => Error()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Error copyWith(void Function(Error) updates) =>
      super.copyWith((message) => updates(message as Error)) as Error;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Error create() => Error._();
  Error createEmptyInstance() => create();
  static $pb.PbList<Error> createRepeated() => $pb.PbList<Error>();
  @$core.pragma('dart2js:noInline')
  static Error getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Error>(create);
  static Error? _defaultInstance;

  @$pb.TagNumber(1)
  ErrorCode get code => $_getN(0);
  @$pb.TagNumber(1)
  set code(ErrorCode v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get shouldRetry => $_getBF(2);
  @$pb.TagNumber(3)
  set shouldRetry($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasShouldRetry() => $_has(2);
  @$pb.TagNumber(3)
  void clearShouldRetry() => $_clearField(3);
}

class ClientDetails extends $pb.GeneratedMessage {
  factory ClientDetails({
    Sdk? sdk,
    OS? os,
    Browser? browser,
    Device? device,
  }) {
    final $result = create();
    if (sdk != null) {
      $result.sdk = sdk;
    }
    if (os != null) {
      $result.os = os;
    }
    if (browser != null) {
      $result.browser = browser;
    }
    if (device != null) {
      $result.device = device;
    }
    return $result;
  }
  ClientDetails._() : super();
  factory ClientDetails.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ClientDetails.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientDetails',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..aOM<Sdk>(1, _omitFieldNames ? '' : 'sdk', subBuilder: Sdk.create)
    ..aOM<OS>(2, _omitFieldNames ? '' : 'os', subBuilder: OS.create)
    ..aOM<Browser>(3, _omitFieldNames ? '' : 'browser',
        subBuilder: Browser.create)
    ..aOM<Device>(4, _omitFieldNames ? '' : 'device', subBuilder: Device.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ClientDetails clone() => ClientDetails()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ClientDetails copyWith(void Function(ClientDetails) updates) =>
      super.copyWith((message) => updates(message as ClientDetails))
          as ClientDetails;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientDetails create() => ClientDetails._();
  ClientDetails createEmptyInstance() => create();
  static $pb.PbList<ClientDetails> createRepeated() =>
      $pb.PbList<ClientDetails>();
  @$core.pragma('dart2js:noInline')
  static ClientDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientDetails>(create);
  static ClientDetails? _defaultInstance;

  @$pb.TagNumber(1)
  Sdk get sdk => $_getN(0);
  @$pb.TagNumber(1)
  set sdk(Sdk v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSdk() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdk() => $_clearField(1);
  @$pb.TagNumber(1)
  Sdk ensureSdk() => $_ensure(0);

  @$pb.TagNumber(2)
  OS get os => $_getN(1);
  @$pb.TagNumber(2)
  set os(OS v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOs() => $_has(1);
  @$pb.TagNumber(2)
  void clearOs() => $_clearField(2);
  @$pb.TagNumber(2)
  OS ensureOs() => $_ensure(1);

  @$pb.TagNumber(3)
  Browser get browser => $_getN(2);
  @$pb.TagNumber(3)
  set browser(Browser v) {
    $_setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasBrowser() => $_has(2);
  @$pb.TagNumber(3)
  void clearBrowser() => $_clearField(3);
  @$pb.TagNumber(3)
  Browser ensureBrowser() => $_ensure(2);

  @$pb.TagNumber(4)
  Device get device => $_getN(3);
  @$pb.TagNumber(4)
  set device(Device v) {
    $_setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasDevice() => $_has(3);
  @$pb.TagNumber(4)
  void clearDevice() => $_clearField(4);
  @$pb.TagNumber(4)
  Device ensureDevice() => $_ensure(3);
}

class Sdk extends $pb.GeneratedMessage {
  factory Sdk({
    SdkType? type,
    $core.String? major,
    $core.String? minor,
    $core.String? patch,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (major != null) {
      $result.major = major;
    }
    if (minor != null) {
      $result.minor = minor;
    }
    if (patch != null) {
      $result.patch = patch;
    }
    return $result;
  }
  Sdk._() : super();
  factory Sdk.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Sdk.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Sdk',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..e<SdkType>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE,
        defaultOrMaker: SdkType.SDK_TYPE_UNSPECIFIED,
        valueOf: SdkType.valueOf,
        enumValues: SdkType.values)
    ..aOS(2, _omitFieldNames ? '' : 'major')
    ..aOS(3, _omitFieldNames ? '' : 'minor')
    ..aOS(4, _omitFieldNames ? '' : 'patch')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Sdk clone() => Sdk()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Sdk copyWith(void Function(Sdk) updates) =>
      super.copyWith((message) => updates(message as Sdk)) as Sdk;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Sdk create() => Sdk._();
  Sdk createEmptyInstance() => create();
  static $pb.PbList<Sdk> createRepeated() => $pb.PbList<Sdk>();
  @$core.pragma('dart2js:noInline')
  static Sdk getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Sdk>(create);
  static Sdk? _defaultInstance;

  @$pb.TagNumber(1)
  SdkType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(SdkType v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get major => $_getSZ(1);
  @$pb.TagNumber(2)
  set major($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMajor() => $_has(1);
  @$pb.TagNumber(2)
  void clearMajor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get minor => $_getSZ(2);
  @$pb.TagNumber(3)
  set minor($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMinor() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patch => $_getSZ(3);
  @$pb.TagNumber(4)
  set patch($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasPatch() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatch() => $_clearField(4);
}

class OS extends $pb.GeneratedMessage {
  factory OS({
    $core.String? name,
    $core.String? version,
    $core.String? architecture,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (version != null) {
      $result.version = version;
    }
    if (architecture != null) {
      $result.architecture = architecture;
    }
    return $result;
  }
  OS._() : super();
  factory OS.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory OS.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OS',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'architecture')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  OS clone() => OS()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  OS copyWith(void Function(OS) updates) =>
      super.copyWith((message) => updates(message as OS)) as OS;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OS create() => OS._();
  OS createEmptyInstance() => create();
  static $pb.PbList<OS> createRepeated() => $pb.PbList<OS>();
  @$core.pragma('dart2js:noInline')
  static OS getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OS>(create);
  static OS? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get architecture => $_getSZ(2);
  @$pb.TagNumber(3)
  set architecture($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasArchitecture() => $_has(2);
  @$pb.TagNumber(3)
  void clearArchitecture() => $_clearField(3);
}

class Browser extends $pb.GeneratedMessage {
  factory Browser({
    $core.String? name,
    $core.String? version,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (version != null) {
      $result.version = version;
    }
    return $result;
  }
  Browser._() : super();
  factory Browser.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Browser.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Browser',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Browser clone() => Browser()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Browser copyWith(void Function(Browser) updates) =>
      super.copyWith((message) => updates(message as Browser)) as Browser;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Browser create() => Browser._();
  Browser createEmptyInstance() => create();
  static $pb.PbList<Browser> createRepeated() => $pb.PbList<Browser>();
  @$core.pragma('dart2js:noInline')
  static Browser getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Browser>(create);
  static Browser? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

class RTMPIngress extends $pb.GeneratedMessage {
  factory RTMPIngress({
    $core.int? width,
    $core.int? height,
    $core.double? frameRate,
    $core.String? software,
    $core.String? version,
    $core.String? encoder,
    $core.String? remoteAddr,
  }) {
    final $result = create();
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (frameRate != null) {
      $result.frameRate = frameRate;
    }
    if (software != null) {
      $result.software = software;
    }
    if (version != null) {
      $result.version = version;
    }
    if (encoder != null) {
      $result.encoder = encoder;
    }
    if (remoteAddr != null) {
      $result.remoteAddr = remoteAddr;
    }
    return $result;
  }
  RTMPIngress._() : super();
  factory RTMPIngress.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RTMPIngress.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RTMPIngress',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OU3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'frameRate', $pb.PbFieldType.OD)
    ..aOS(4, _omitFieldNames ? '' : 'software')
    ..aOS(5, _omitFieldNames ? '' : 'version')
    ..aOS(6, _omitFieldNames ? '' : 'encoder')
    ..aOS(7, _omitFieldNames ? '' : 'remoteAddr')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  RTMPIngress clone() => RTMPIngress()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  RTMPIngress copyWith(void Function(RTMPIngress) updates) =>
      super.copyWith((message) => updates(message as RTMPIngress))
          as RTMPIngress;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RTMPIngress create() => RTMPIngress._();
  RTMPIngress createEmptyInstance() => create();
  static $pb.PbList<RTMPIngress> createRepeated() => $pb.PbList<RTMPIngress>();
  @$core.pragma('dart2js:noInline')
  static RTMPIngress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RTMPIngress>(create);
  static RTMPIngress? _defaultInstance;

  /// Video dimensions and frame rate
  @$pb.TagNumber(1)
  $core.int get width => $_getIZ(0);
  @$pb.TagNumber(1)
  set width($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get height => $_getIZ(1);
  @$pb.TagNumber(2)
  set height($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get frameRate => $_getN(2);
  @$pb.TagNumber(3)
  set frameRate($core.double v) {
    $_setDouble(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasFrameRate() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrameRate() => $_clearField(3);

  /// Client info
  @$pb.TagNumber(4)
  $core.String get software => $_getSZ(3);
  @$pb.TagNumber(4)
  set software($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSoftware() => $_has(3);
  @$pb.TagNumber(4)
  void clearSoftware() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get version => $_getSZ(4);
  @$pb.TagNumber(5)
  set version($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get encoder => $_getSZ(5);
  @$pb.TagNumber(6)
  set encoder($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasEncoder() => $_has(5);
  @$pb.TagNumber(6)
  void clearEncoder() => $_clearField(6);

  /// Connection info
  @$pb.TagNumber(7)
  $core.String get remoteAddr => $_getSZ(6);
  @$pb.TagNumber(7)
  set remoteAddr($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasRemoteAddr() => $_has(6);
  @$pb.TagNumber(7)
  void clearRemoteAddr() => $_clearField(7);
}

class Device extends $pb.GeneratedMessage {
  factory Device({
    $core.String? name,
    $core.String? version,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (version != null) {
      $result.version = version;
    }
    return $result;
  }
  Device._() : super();
  factory Device.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Device.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Device',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Device clone() => Device()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Device copyWith(void Function(Device) updates) =>
      super.copyWith((message) => updates(message as Device)) as Device;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Device create() => Device._();
  Device createEmptyInstance() => create();
  static $pb.PbList<Device> createRepeated() => $pb.PbList<Device>();
  @$core.pragma('dart2js:noInline')
  static Device getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Device>(create);
  static Device? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

class Call extends $pb.GeneratedMessage {
  factory Call({
    $core.String? type,
    $core.String? id,
    $core.String? createdByUserId,
    $core.String? hostUserId,
    $1.Struct? custom,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (id != null) {
      $result.id = id;
    }
    if (createdByUserId != null) {
      $result.createdByUserId = createdByUserId;
    }
    if (hostUserId != null) {
      $result.hostUserId = hostUserId;
    }
    if (custom != null) {
      $result.custom = custom;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    return $result;
  }
  Call._() : super();
  factory Call.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Call.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Call',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOS(3, _omitFieldNames ? '' : 'createdByUserId')
    ..aOS(4, _omitFieldNames ? '' : 'hostUserId')
    ..aOM<$1.Struct>(5, _omitFieldNames ? '' : 'custom',
        subBuilder: $1.Struct.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Call clone() => Call()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Call copyWith(void Function(Call) updates) =>
      super.copyWith((message) => updates(message as Call)) as Call;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Call create() => Call._();
  Call createEmptyInstance() => create();
  static $pb.PbList<Call> createRepeated() => $pb.PbList<Call>();
  @$core.pragma('dart2js:noInline')
  static Call getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Call>(create);
  static Call? _defaultInstance;

  /// the call type
  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  /// the call id
  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  /// the id of the user that created this call
  @$pb.TagNumber(3)
  $core.String get createdByUserId => $_getSZ(2);
  @$pb.TagNumber(3)
  set createdByUserId($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCreatedByUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedByUserId() => $_clearField(3);

  /// the id of the current host for this call
  @$pb.TagNumber(4)
  $core.String get hostUserId => $_getSZ(3);
  @$pb.TagNumber(4)
  set hostUserId($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasHostUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearHostUserId() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Struct get custom => $_getN(4);
  @$pb.TagNumber(5)
  set custom($1.Struct v) {
    $_setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasCustom() => $_has(4);
  @$pb.TagNumber(5)
  void clearCustom() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Struct ensureCustom() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($0.Timestamp v) {
    $_setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get updatedAt => $_getN(6);
  @$pb.TagNumber(7)
  set updatedAt($0.Timestamp v) {
    $_setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureUpdatedAt() => $_ensure(6);
}

/// CallGrants represents the set of permissions given
/// to the user for the current call.
class CallGrants extends $pb.GeneratedMessage {
  factory CallGrants({
    $core.bool? canPublishAudio,
    $core.bool? canPublishVideo,
    $core.bool? canScreenshare,
  }) {
    final $result = create();
    if (canPublishAudio != null) {
      $result.canPublishAudio = canPublishAudio;
    }
    if (canPublishVideo != null) {
      $result.canPublishVideo = canPublishVideo;
    }
    if (canScreenshare != null) {
      $result.canScreenshare = canScreenshare;
    }
    return $result;
  }
  CallGrants._() : super();
  factory CallGrants.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CallGrants.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CallGrants',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'canPublishAudio')
    ..aOB(2, _omitFieldNames ? '' : 'canPublishVideo')
    ..aOB(3, _omitFieldNames ? '' : 'canScreenshare')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CallGrants clone() => CallGrants()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CallGrants copyWith(void Function(CallGrants) updates) =>
      super.copyWith((message) => updates(message as CallGrants)) as CallGrants;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CallGrants create() => CallGrants._();
  CallGrants createEmptyInstance() => create();
  static $pb.PbList<CallGrants> createRepeated() => $pb.PbList<CallGrants>();
  @$core.pragma('dart2js:noInline')
  static CallGrants getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CallGrants>(create);
  static CallGrants? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get canPublishAudio => $_getBF(0);
  @$pb.TagNumber(1)
  set canPublishAudio($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCanPublishAudio() => $_has(0);
  @$pb.TagNumber(1)
  void clearCanPublishAudio() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get canPublishVideo => $_getBF(1);
  @$pb.TagNumber(2)
  set canPublishVideo($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCanPublishVideo() => $_has(1);
  @$pb.TagNumber(2)
  void clearCanPublishVideo() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get canScreenshare => $_getBF(2);
  @$pb.TagNumber(3)
  set canScreenshare($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCanScreenshare() => $_has(2);
  @$pb.TagNumber(3)
  void clearCanScreenshare() => $_clearField(3);
}

class InputDevices extends $pb.GeneratedMessage {
  factory InputDevices({
    $core.Iterable<$core.String>? availableDevices,
    $core.String? currentDevice,
    $core.bool? isPermitted,
  }) {
    final $result = create();
    if (availableDevices != null) {
      $result.availableDevices.addAll(availableDevices);
    }
    if (currentDevice != null) {
      $result.currentDevice = currentDevice;
    }
    if (isPermitted != null) {
      $result.isPermitted = isPermitted;
    }
    return $result;
  }
  InputDevices._() : super();
  factory InputDevices.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InputDevices.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InputDevices',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'availableDevices')
    ..aOS(2, _omitFieldNames ? '' : 'currentDevice')
    ..aOB(3, _omitFieldNames ? '' : 'isPermitted')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InputDevices clone() => InputDevices()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InputDevices copyWith(void Function(InputDevices) updates) =>
      super.copyWith((message) => updates(message as InputDevices))
          as InputDevices;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InputDevices create() => InputDevices._();
  InputDevices createEmptyInstance() => create();
  static $pb.PbList<InputDevices> createRepeated() =>
      $pb.PbList<InputDevices>();
  @$core.pragma('dart2js:noInline')
  static InputDevices getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InputDevices>(create);
  static InputDevices? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get availableDevices => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get currentDevice => $_getSZ(1);
  @$pb.TagNumber(2)
  set currentDevice($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCurrentDevice() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentDevice() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isPermitted => $_getBF(2);
  @$pb.TagNumber(3)
  set isPermitted($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasIsPermitted() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsPermitted() => $_clearField(3);
}

class AndroidState extends $pb.GeneratedMessage {
  factory AndroidState({
    AndroidThermalState? thermalState,
    $core.bool? isPowerSaverMode,
  }) {
    final $result = create();
    if (thermalState != null) {
      $result.thermalState = thermalState;
    }
    if (isPowerSaverMode != null) {
      $result.isPowerSaverMode = isPowerSaverMode;
    }
    return $result;
  }
  AndroidState._() : super();
  factory AndroidState.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AndroidState.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AndroidState',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..e<AndroidThermalState>(
        1, _omitFieldNames ? '' : 'thermalState', $pb.PbFieldType.OE,
        defaultOrMaker: AndroidThermalState.ANDROID_THERMAL_STATE_UNSPECIFIED,
        valueOf: AndroidThermalState.valueOf,
        enumValues: AndroidThermalState.values)
    ..aOB(2, _omitFieldNames ? '' : 'isPowerSaverMode')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  AndroidState clone() => AndroidState()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  AndroidState copyWith(void Function(AndroidState) updates) =>
      super.copyWith((message) => updates(message as AndroidState))
          as AndroidState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AndroidState create() => AndroidState._();
  AndroidState createEmptyInstance() => create();
  static $pb.PbList<AndroidState> createRepeated() =>
      $pb.PbList<AndroidState>();
  @$core.pragma('dart2js:noInline')
  static AndroidState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AndroidState>(create);
  static AndroidState? _defaultInstance;

  @$pb.TagNumber(1)
  AndroidThermalState get thermalState => $_getN(0);
  @$pb.TagNumber(1)
  set thermalState(AndroidThermalState v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasThermalState() => $_has(0);
  @$pb.TagNumber(1)
  void clearThermalState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isPowerSaverMode => $_getBF(1);
  @$pb.TagNumber(2)
  set isPowerSaverMode($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasIsPowerSaverMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsPowerSaverMode() => $_clearField(2);
}

class AppleState extends $pb.GeneratedMessage {
  factory AppleState({
    AppleThermalState? thermalState,
    $core.bool? isLowPowerModeEnabled,
  }) {
    final $result = create();
    if (thermalState != null) {
      $result.thermalState = thermalState;
    }
    if (isLowPowerModeEnabled != null) {
      $result.isLowPowerModeEnabled = isLowPowerModeEnabled;
    }
    return $result;
  }
  AppleState._() : super();
  factory AppleState.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AppleState.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppleState',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..e<AppleThermalState>(
        1, _omitFieldNames ? '' : 'thermalState', $pb.PbFieldType.OE,
        defaultOrMaker: AppleThermalState.APPLE_THERMAL_STATE_UNSPECIFIED,
        valueOf: AppleThermalState.valueOf,
        enumValues: AppleThermalState.values)
    ..aOB(2, _omitFieldNames ? '' : 'isLowPowerModeEnabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  AppleState clone() => AppleState()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  AppleState copyWith(void Function(AppleState) updates) =>
      super.copyWith((message) => updates(message as AppleState)) as AppleState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppleState create() => AppleState._();
  AppleState createEmptyInstance() => create();
  static $pb.PbList<AppleState> createRepeated() => $pb.PbList<AppleState>();
  @$core.pragma('dart2js:noInline')
  static AppleState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppleState>(create);
  static AppleState? _defaultInstance;

  @$pb.TagNumber(1)
  AppleThermalState get thermalState => $_getN(0);
  @$pb.TagNumber(1)
  set thermalState(AppleThermalState v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasThermalState() => $_has(0);
  @$pb.TagNumber(1)
  void clearThermalState() => $_clearField(1);

  /// https://developer.apple.com/documentation/foundation/processinfo/1617047-islowpowermodeenabled
  @$pb.TagNumber(2)
  $core.bool get isLowPowerModeEnabled => $_getBF(1);
  @$pb.TagNumber(2)
  set isLowPowerModeEnabled($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasIsLowPowerModeEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsLowPowerModeEnabled() => $_clearField(2);
}

/// PerformanceStats represents the encoding/decoding statistics for a track.
class PerformanceStats extends $pb.GeneratedMessage {
  factory PerformanceStats({
    TrackType? trackType,
    Codec? codec,
    $core.double? avgFrameTimeMs,
    $core.double? avgFps,
    VideoDimension? videoDimension,
    $core.int? targetBitrate,
  }) {
    final $result = create();
    if (trackType != null) {
      $result.trackType = trackType;
    }
    if (codec != null) {
      $result.codec = codec;
    }
    if (avgFrameTimeMs != null) {
      $result.avgFrameTimeMs = avgFrameTimeMs;
    }
    if (avgFps != null) {
      $result.avgFps = avgFps;
    }
    if (videoDimension != null) {
      $result.videoDimension = videoDimension;
    }
    if (targetBitrate != null) {
      $result.targetBitrate = targetBitrate;
    }
    return $result;
  }
  PerformanceStats._() : super();
  factory PerformanceStats.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PerformanceStats.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PerformanceStats',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.models'),
      createEmptyInstance: create)
    ..e<TrackType>(1, _omitFieldNames ? '' : 'trackType', $pb.PbFieldType.OE,
        defaultOrMaker: TrackType.TRACK_TYPE_UNSPECIFIED,
        valueOf: TrackType.valueOf,
        enumValues: TrackType.values)
    ..aOM<Codec>(2, _omitFieldNames ? '' : 'codec', subBuilder: Codec.create)
    ..a<$core.double>(
        3, _omitFieldNames ? '' : 'avgFrameTimeMs', $pb.PbFieldType.OF)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'avgFps', $pb.PbFieldType.OF)
    ..aOM<VideoDimension>(5, _omitFieldNames ? '' : 'videoDimension',
        subBuilder: VideoDimension.create)
    ..a<$core.int>(
        6, _omitFieldNames ? '' : 'targetBitrate', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PerformanceStats clone() => PerformanceStats()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PerformanceStats copyWith(void Function(PerformanceStats) updates) =>
      super.copyWith((message) => updates(message as PerformanceStats))
          as PerformanceStats;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PerformanceStats create() => PerformanceStats._();
  PerformanceStats createEmptyInstance() => create();
  static $pb.PbList<PerformanceStats> createRepeated() =>
      $pb.PbList<PerformanceStats>();
  @$core.pragma('dart2js:noInline')
  static PerformanceStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PerformanceStats>(create);
  static PerformanceStats? _defaultInstance;

  /// the type of the track (e.g., video, audio, screen share)
  @$pb.TagNumber(1)
  TrackType get trackType => $_getN(0);
  @$pb.TagNumber(1)
  set trackType(TrackType v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTrackType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackType() => $_clearField(1);

  /// the codec used for the track
  @$pb.TagNumber(2)
  Codec get codec => $_getN(1);
  @$pb.TagNumber(2)
  set codec(Codec v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCodec() => $_has(1);
  @$pb.TagNumber(2)
  void clearCodec() => $_clearField(2);
  @$pb.TagNumber(2)
  Codec ensureCodec() => $_ensure(1);

  /// the average encode/decode time in ms
  @$pb.TagNumber(3)
  $core.double get avgFrameTimeMs => $_getN(2);
  @$pb.TagNumber(3)
  set avgFrameTimeMs($core.double v) {
    $_setFloat(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAvgFrameTimeMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvgFrameTimeMs() => $_clearField(3);

  /// the average fps for the track
  @$pb.TagNumber(4)
  $core.double get avgFps => $_getN(3);
  @$pb.TagNumber(4)
  set avgFps($core.double v) {
    $_setFloat(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasAvgFps() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvgFps() => $_clearField(4);

  /// the track dimensions
  @$pb.TagNumber(5)
  VideoDimension get videoDimension => $_getN(4);
  @$pb.TagNumber(5)
  set videoDimension(VideoDimension v) {
    $_setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasVideoDimension() => $_has(4);
  @$pb.TagNumber(5)
  void clearVideoDimension() => $_clearField(5);
  @$pb.TagNumber(5)
  VideoDimension ensureVideoDimension() => $_ensure(4);

  /// the target bitrate for the track, only for published tracks
  @$pb.TagNumber(6)
  $core.int get targetBitrate => $_getIZ(5);
  @$pb.TagNumber(6)
  set targetBitrate($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasTargetBitrate() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetBitrate() => $_clearField(6);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
