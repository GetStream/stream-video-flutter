///
//  Generated code. Do not modify.
//  source: video/coordinator/stat_v1/stat.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../../google/protobuf/duration.pb.dart' as $0;
import '../../../google/protobuf/timestamp.pb.dart' as $1;

import 'stat.pbenum.dart';

export 'stat.pbenum.dart';

class ParticipantConnected extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ParticipantConnected',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.stat_v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  ParticipantConnected._() : super();
  factory ParticipantConnected() => create();
  factory ParticipantConnected.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ParticipantConnected.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ParticipantConnected clone() =>
      ParticipantConnected()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ParticipantConnected copyWith(void Function(ParticipantConnected) updates) =>
      super.copyWith((message) => updates(message as ParticipantConnected))
          as ParticipantConnected; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ParticipantConnected create() => ParticipantConnected._();
  ParticipantConnected createEmptyInstance() => create();
  static $pb.PbList<ParticipantConnected> createRepeated() =>
      $pb.PbList<ParticipantConnected>();
  @$core.pragma('dart2js:noInline')
  static ParticipantConnected getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParticipantConnected>(create);
  static ParticipantConnected? _defaultInstance;
}

class ParticipantDisconnected extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ParticipantDisconnected',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.stat_v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  ParticipantDisconnected._() : super();
  factory ParticipantDisconnected() => create();
  factory ParticipantDisconnected.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ParticipantDisconnected.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ParticipantDisconnected clone() =>
      ParticipantDisconnected()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ParticipantDisconnected copyWith(
          void Function(ParticipantDisconnected) updates) =>
      super.copyWith((message) => updates(message as ParticipantDisconnected))
          as ParticipantDisconnected; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ParticipantDisconnected create() => ParticipantDisconnected._();
  ParticipantDisconnected createEmptyInstance() => create();
  static $pb.PbList<ParticipantDisconnected> createRepeated() =>
      $pb.PbList<ParticipantDisconnected>();
  @$core.pragma('dart2js:noInline')
  static ParticipantDisconnected getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParticipantDisconnected>(create);
  static ParticipantDisconnected? _defaultInstance;
}

class Freeze extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Freeze',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.stat_v1'),
      createEmptyInstance: create)
    ..e<MediaType>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'mediaType',
        $pb.PbFieldType.OE,
        defaultOrMaker: MediaType.MEDIA_TYPE_UNSPECIFIED,
        valueOf: MediaType.valueOf,
        enumValues: MediaType.values)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'peerId')
    ..aOM<$0.Duration>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'duration',
        subBuilder: $0.Duration.create)
    ..hasRequiredFields = false;

  Freeze._() : super();
  factory Freeze({
    MediaType? mediaType,
    $core.String? peerId,
    $0.Duration? duration,
  }) {
    final _result = create();
    if (mediaType != null) {
      _result.mediaType = mediaType;
    }
    if (peerId != null) {
      _result.peerId = peerId;
    }
    if (duration != null) {
      _result.duration = duration;
    }
    return _result;
  }
  factory Freeze.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Freeze.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Freeze clone() => Freeze()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Freeze copyWith(void Function(Freeze) updates) =>
      super.copyWith((message) => updates(message as Freeze))
          as Freeze; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Freeze create() => Freeze._();
  Freeze createEmptyInstance() => create();
  static $pb.PbList<Freeze> createRepeated() => $pb.PbList<Freeze>();
  @$core.pragma('dart2js:noInline')
  static Freeze getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Freeze>(create);
  static Freeze? _defaultInstance;

  @$pb.TagNumber(1)
  MediaType get mediaType => $_getN(0);
  @$pb.TagNumber(1)
  set mediaType(MediaType v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMediaType() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get peerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set peerId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPeerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeerId() => clearField(2);

  @$pb.TagNumber(3)
  $0.Duration get duration => $_getN(2);
  @$pb.TagNumber(3)
  set duration($0.Duration v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => clearField(3);
  @$pb.TagNumber(3)
  $0.Duration ensureDuration() => $_ensure(2);
}

class MediaStateChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'MediaStateChanged',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.stat_v1'),
      createEmptyInstance: create)
    ..e<MediaType>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'mediaType',
        $pb.PbFieldType.OE,
        defaultOrMaker: MediaType.MEDIA_TYPE_UNSPECIFIED,
        valueOf: MediaType.valueOf,
        enumValues: MediaType.values)
    ..e<MediaStateChange>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'change',
        $pb.PbFieldType.OE,
        defaultOrMaker: MediaStateChange.MEDIA_STATE_CHANGE_UNSPECIFIED,
        valueOf: MediaStateChange.valueOf,
        enumValues: MediaStateChange.values)
    ..e<MediaDirection>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'direction',
        $pb.PbFieldType.OE,
        defaultOrMaker: MediaDirection.MEDIA_DIRECTION_UNSPECIFIED,
        valueOf: MediaDirection.valueOf,
        enumValues: MediaDirection.values)
    ..e<MediaStateChangeReason>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'reason',
        $pb.PbFieldType.OE,
        defaultOrMaker:
            MediaStateChangeReason.MEDIA_STATE_CHANGE_REASON_UNSPECIFIED,
        valueOf: MediaStateChangeReason.valueOf,
        enumValues: MediaStateChangeReason.values)
    ..hasRequiredFields = false;

  MediaStateChanged._() : super();
  factory MediaStateChanged({
    MediaType? mediaType,
    MediaStateChange? change,
    MediaDirection? direction,
    MediaStateChangeReason? reason,
  }) {
    final _result = create();
    if (mediaType != null) {
      _result.mediaType = mediaType;
    }
    if (change != null) {
      _result.change = change;
    }
    if (direction != null) {
      _result.direction = direction;
    }
    if (reason != null) {
      _result.reason = reason;
    }
    return _result;
  }
  factory MediaStateChanged.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory MediaStateChanged.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MediaStateChanged clone() => MediaStateChanged()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MediaStateChanged copyWith(void Function(MediaStateChanged) updates) =>
      super.copyWith((message) => updates(message as MediaStateChanged))
          as MediaStateChanged; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MediaStateChanged create() => MediaStateChanged._();
  MediaStateChanged createEmptyInstance() => create();
  static $pb.PbList<MediaStateChanged> createRepeated() =>
      $pb.PbList<MediaStateChanged>();
  @$core.pragma('dart2js:noInline')
  static MediaStateChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaStateChanged>(create);
  static MediaStateChanged? _defaultInstance;

  @$pb.TagNumber(1)
  MediaType get mediaType => $_getN(0);
  @$pb.TagNumber(1)
  set mediaType(MediaType v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMediaType() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaType() => clearField(1);

  @$pb.TagNumber(2)
  MediaStateChange get change => $_getN(1);
  @$pb.TagNumber(2)
  set change(MediaStateChange v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasChange() => $_has(1);
  @$pb.TagNumber(2)
  void clearChange() => clearField(2);

  @$pb.TagNumber(3)
  MediaDirection get direction => $_getN(2);
  @$pb.TagNumber(3)
  set direction(MediaDirection v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDirection() => $_has(2);
  @$pb.TagNumber(3)
  void clearDirection() => clearField(3);

  @$pb.TagNumber(4)
  MediaStateChangeReason get reason => $_getN(3);
  @$pb.TagNumber(4)
  set reason(MediaStateChangeReason v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => clearField(4);
}

enum TimelineEvent_Event {
  participantConnected,
  participantDisconnected,
  mediaStateChanged,
  freeze_5,
  notSet
}

class TimelineEvent extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, TimelineEvent_Event>
      _TimelineEvent_EventByTag = {
    2: TimelineEvent_Event.participantConnected,
    3: TimelineEvent_Event.participantDisconnected,
    4: TimelineEvent_Event.mediaStateChanged,
    5: TimelineEvent_Event.freeze_5,
    0: TimelineEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'TimelineEvent',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.stat_v1'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5])
    ..aOM<$1.Timestamp>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timestamp',
        subBuilder: $1.Timestamp.create)
    ..aOM<ParticipantConnected>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'participantConnected',
        subBuilder: ParticipantConnected.create)
    ..aOM<ParticipantDisconnected>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'participantDisconnected',
        subBuilder: ParticipantDisconnected.create)
    ..aOM<MediaStateChanged>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'mediaStateChanged',
        subBuilder: MediaStateChanged.create)
    ..aOM<Freeze>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'freeze',
        subBuilder: Freeze.create)
    ..hasRequiredFields = false;

  TimelineEvent._() : super();
  factory TimelineEvent({
    $1.Timestamp? timestamp,
    ParticipantConnected? participantConnected,
    ParticipantDisconnected? participantDisconnected,
    MediaStateChanged? mediaStateChanged,
    Freeze? freeze_5,
  }) {
    final _result = create();
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (participantConnected != null) {
      _result.participantConnected = participantConnected;
    }
    if (participantDisconnected != null) {
      _result.participantDisconnected = participantDisconnected;
    }
    if (mediaStateChanged != null) {
      _result.mediaStateChanged = mediaStateChanged;
    }
    if (freeze_5 != null) {
      _result.freeze_5 = freeze_5;
    }
    return _result;
  }
  factory TimelineEvent.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TimelineEvent.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TimelineEvent clone() => TimelineEvent()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TimelineEvent copyWith(void Function(TimelineEvent) updates) =>
      super.copyWith((message) => updates(message as TimelineEvent))
          as TimelineEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TimelineEvent create() => TimelineEvent._();
  TimelineEvent createEmptyInstance() => create();
  static $pb.PbList<TimelineEvent> createRepeated() =>
      $pb.PbList<TimelineEvent>();
  @$core.pragma('dart2js:noInline')
  static TimelineEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TimelineEvent>(create);
  static TimelineEvent? _defaultInstance;

  TimelineEvent_Event whichEvent() =>
      _TimelineEvent_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $1.Timestamp get timestamp => $_getN(0);
  @$pb.TagNumber(1)
  set timestamp($1.Timestamp v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => clearField(1);
  @$pb.TagNumber(1)
  $1.Timestamp ensureTimestamp() => $_ensure(0);

  @$pb.TagNumber(2)
  ParticipantConnected get participantConnected => $_getN(1);
  @$pb.TagNumber(2)
  set participantConnected(ParticipantConnected v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasParticipantConnected() => $_has(1);
  @$pb.TagNumber(2)
  void clearParticipantConnected() => clearField(2);
  @$pb.TagNumber(2)
  ParticipantConnected ensureParticipantConnected() => $_ensure(1);

  @$pb.TagNumber(3)
  ParticipantDisconnected get participantDisconnected => $_getN(2);
  @$pb.TagNumber(3)
  set participantDisconnected(ParticipantDisconnected v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasParticipantDisconnected() => $_has(2);
  @$pb.TagNumber(3)
  void clearParticipantDisconnected() => clearField(3);
  @$pb.TagNumber(3)
  ParticipantDisconnected ensureParticipantDisconnected() => $_ensure(2);

  @$pb.TagNumber(4)
  MediaStateChanged get mediaStateChanged => $_getN(3);
  @$pb.TagNumber(4)
  set mediaStateChanged(MediaStateChanged v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMediaStateChanged() => $_has(3);
  @$pb.TagNumber(4)
  void clearMediaStateChanged() => clearField(4);
  @$pb.TagNumber(4)
  MediaStateChanged ensureMediaStateChanged() => $_ensure(3);

  @$pb.TagNumber(5)
  Freeze get freeze_5 => $_getN(4);
  @$pb.TagNumber(5)
  set freeze_5(Freeze v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasFreeze_5() => $_has(4);
  @$pb.TagNumber(5)
  void clearFreeze_5() => clearField(5);
  @$pb.TagNumber(5)
  Freeze ensureFreeze_5() => $_ensure(4);
}

class CallParticipantTimeline extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'CallParticipantTimeline',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.stat_v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'userId')
    ..pc<TimelineEvent>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'events',
        $pb.PbFieldType.PM,
        subBuilder: TimelineEvent.create)
    ..hasRequiredFields = false;

  CallParticipantTimeline._() : super();
  factory CallParticipantTimeline({
    $core.String? userId,
    $core.Iterable<TimelineEvent>? events,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (events != null) {
      _result.events.addAll(events);
    }
    return _result;
  }
  factory CallParticipantTimeline.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CallParticipantTimeline.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CallParticipantTimeline clone() =>
      CallParticipantTimeline()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CallParticipantTimeline copyWith(
          void Function(CallParticipantTimeline) updates) =>
      super.copyWith((message) => updates(message as CallParticipantTimeline))
          as CallParticipantTimeline; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallParticipantTimeline create() => CallParticipantTimeline._();
  CallParticipantTimeline createEmptyInstance() => create();
  static $pb.PbList<CallParticipantTimeline> createRepeated() =>
      $pb.PbList<CallParticipantTimeline>();
  @$core.pragma('dart2js:noInline')
  static CallParticipantTimeline getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CallParticipantTimeline>(create);
  static CallParticipantTimeline? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<TimelineEvent> get events => $_getList(1);
}

class Session extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Session',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.stat_v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sessionId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'callId')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'callType')
    ..aOM<$1.Timestamp>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'start',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'end',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  Session._() : super();
  factory Session({
    $core.String? sessionId,
    $core.String? callId,
    $core.String? callType,
    $1.Timestamp? start,
    $1.Timestamp? end,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (callId != null) {
      _result.callId = callId;
    }
    if (callType != null) {
      _result.callType = callType;
    }
    if (start != null) {
      _result.start = start;
    }
    if (end != null) {
      _result.end = end;
    }
    return _result;
  }
  factory Session.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Session.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Session clone() => Session()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Session copyWith(void Function(Session) updates) =>
      super.copyWith((message) => updates(message as Session))
          as Session; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Session create() => Session._();
  Session createEmptyInstance() => create();
  static $pb.PbList<Session> createRepeated() => $pb.PbList<Session>();
  @$core.pragma('dart2js:noInline')
  static Session getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Session>(create);
  static Session? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get callId => $_getSZ(1);
  @$pb.TagNumber(2)
  set callId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get callType => $_getSZ(2);
  @$pb.TagNumber(3)
  set callType($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCallType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCallType() => clearField(3);

  @$pb.TagNumber(4)
  $1.Timestamp get start => $_getN(3);
  @$pb.TagNumber(4)
  set start($1.Timestamp v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasStart() => $_has(3);
  @$pb.TagNumber(4)
  void clearStart() => clearField(4);
  @$pb.TagNumber(4)
  $1.Timestamp ensureStart() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.Timestamp get end => $_getN(4);
  @$pb.TagNumber(5)
  set end($1.Timestamp v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasEnd() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnd() => clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureEnd() => $_ensure(4);
}
