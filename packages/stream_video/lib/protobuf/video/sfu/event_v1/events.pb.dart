///
//  Generated code. Do not modify.
//  source: video/sfu/event_v1/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../models_v1/models.pb.dart' as $0;

import '../models_v1/models.pbenum.dart' as $0;
import 'events.pbenum.dart';

export 'events.pbenum.dart';

enum Event_EventPayload {
  subscriberOffer, 
  connectionQualityChanged, 
  audioLevelChanged, 
  subscriberCandidate, 
  publisherCandidate, 
  changePublishQuality, 
  muteStateChanged, 
  videoQualityChanged, 
  participantConnected, 
  participantDisconnected, 
  dominantSpeakerChanged, 
  localDeviceChange, 
  notSet
}

class Event extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Event_EventPayload> _Event_EventPayloadByTag = {
    1 : Event_EventPayload.subscriberOffer,
    2 : Event_EventPayload.connectionQualityChanged,
    3 : Event_EventPayload.audioLevelChanged,
    4 : Event_EventPayload.subscriberCandidate,
    5 : Event_EventPayload.publisherCandidate,
    6 : Event_EventPayload.changePublishQuality,
    7 : Event_EventPayload.muteStateChanged,
    8 : Event_EventPayload.videoQualityChanged,
    9 : Event_EventPayload.participantConnected,
    10 : Event_EventPayload.participantDisconnected,
    11 : Event_EventPayload.dominantSpeakerChanged,
    12 : Event_EventPayload.localDeviceChange,
    0 : Event_EventPayload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Event', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
    ..aOM<SubscriberOffer>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscriberOffer', subBuilder: SubscriberOffer.create)
    ..aOM<ConnectionQualityChanged>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectionQualityChanged', subBuilder: ConnectionQualityChanged.create)
    ..aOM<AudioLevelChanged>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioLevelChanged', subBuilder: AudioLevelChanged.create)
    ..aOM<ICECandidateTrickle>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscriberCandidate', subBuilder: ICECandidateTrickle.create)
    ..aOM<ICECandidateTrickle>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publisherCandidate', subBuilder: ICECandidateTrickle.create)
    ..aOM<ChangePublishQuality>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'changePublishQuality', subBuilder: ChangePublishQuality.create)
    ..aOM<MuteStateChanged>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'muteStateChanged', subBuilder: MuteStateChanged.create)
    ..aOM<VideoQualityChanged>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'videoQualityChanged', subBuilder: VideoQualityChanged.create)
    ..aOM<ParticipantConnected>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantConnected', subBuilder: ParticipantConnected.create)
    ..aOM<ParticipantDisconnected>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantDisconnected', subBuilder: ParticipantDisconnected.create)
    ..aOM<DominantSpeakerChanged>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dominantSpeakerChanged', subBuilder: DominantSpeakerChanged.create)
    ..aOM<LocalDeviceChanged>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localDeviceChange', subBuilder: LocalDeviceChanged.create)
    ..hasRequiredFields = false
  ;

  Event._() : super();
  factory Event({
    SubscriberOffer? subscriberOffer,
    ConnectionQualityChanged? connectionQualityChanged,
    AudioLevelChanged? audioLevelChanged,
    ICECandidateTrickle? subscriberCandidate,
    ICECandidateTrickle? publisherCandidate,
    ChangePublishQuality? changePublishQuality,
    MuteStateChanged? muteStateChanged,
    VideoQualityChanged? videoQualityChanged,
    ParticipantConnected? participantConnected,
    ParticipantDisconnected? participantDisconnected,
    DominantSpeakerChanged? dominantSpeakerChanged,
    LocalDeviceChanged? localDeviceChange,
  }) {
    final _result = create();
    if (subscriberOffer != null) {
      _result.subscriberOffer = subscriberOffer;
    }
    if (connectionQualityChanged != null) {
      _result.connectionQualityChanged = connectionQualityChanged;
    }
    if (audioLevelChanged != null) {
      _result.audioLevelChanged = audioLevelChanged;
    }
    if (subscriberCandidate != null) {
      _result.subscriberCandidate = subscriberCandidate;
    }
    if (publisherCandidate != null) {
      _result.publisherCandidate = publisherCandidate;
    }
    if (changePublishQuality != null) {
      _result.changePublishQuality = changePublishQuality;
    }
    if (muteStateChanged != null) {
      _result.muteStateChanged = muteStateChanged;
    }
    if (videoQualityChanged != null) {
      _result.videoQualityChanged = videoQualityChanged;
    }
    if (participantConnected != null) {
      _result.participantConnected = participantConnected;
    }
    if (participantDisconnected != null) {
      _result.participantDisconnected = participantDisconnected;
    }
    if (dominantSpeakerChanged != null) {
      _result.dominantSpeakerChanged = dominantSpeakerChanged;
    }
    if (localDeviceChange != null) {
      _result.localDeviceChange = localDeviceChange;
    }
    return _result;
  }
  factory Event.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Event.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Event clone() => Event()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Event copyWith(void Function(Event) updates) => super.copyWith((message) => updates(message as Event)) as Event; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Event create() => Event._();
  Event createEmptyInstance() => create();
  static $pb.PbList<Event> createRepeated() => $pb.PbList<Event>();
  @$core.pragma('dart2js:noInline')
  static Event getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Event>(create);
  static Event? _defaultInstance;

  Event_EventPayload whichEventPayload() => _Event_EventPayloadByTag[$_whichOneof(0)]!;
  void clearEventPayload() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SubscriberOffer get subscriberOffer => $_getN(0);
  @$pb.TagNumber(1)
  set subscriberOffer(SubscriberOffer v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSubscriberOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscriberOffer() => clearField(1);
  @$pb.TagNumber(1)
  SubscriberOffer ensureSubscriberOffer() => $_ensure(0);

  @$pb.TagNumber(2)
  ConnectionQualityChanged get connectionQualityChanged => $_getN(1);
  @$pb.TagNumber(2)
  set connectionQualityChanged(ConnectionQualityChanged v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasConnectionQualityChanged() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectionQualityChanged() => clearField(2);
  @$pb.TagNumber(2)
  ConnectionQualityChanged ensureConnectionQualityChanged() => $_ensure(1);

  @$pb.TagNumber(3)
  AudioLevelChanged get audioLevelChanged => $_getN(2);
  @$pb.TagNumber(3)
  set audioLevelChanged(AudioLevelChanged v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAudioLevelChanged() => $_has(2);
  @$pb.TagNumber(3)
  void clearAudioLevelChanged() => clearField(3);
  @$pb.TagNumber(3)
  AudioLevelChanged ensureAudioLevelChanged() => $_ensure(2);

  @$pb.TagNumber(4)
  ICECandidateTrickle get subscriberCandidate => $_getN(3);
  @$pb.TagNumber(4)
  set subscriberCandidate(ICECandidateTrickle v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSubscriberCandidate() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubscriberCandidate() => clearField(4);
  @$pb.TagNumber(4)
  ICECandidateTrickle ensureSubscriberCandidate() => $_ensure(3);

  @$pb.TagNumber(5)
  ICECandidateTrickle get publisherCandidate => $_getN(4);
  @$pb.TagNumber(5)
  set publisherCandidate(ICECandidateTrickle v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasPublisherCandidate() => $_has(4);
  @$pb.TagNumber(5)
  void clearPublisherCandidate() => clearField(5);
  @$pb.TagNumber(5)
  ICECandidateTrickle ensurePublisherCandidate() => $_ensure(4);

  @$pb.TagNumber(6)
  ChangePublishQuality get changePublishQuality => $_getN(5);
  @$pb.TagNumber(6)
  set changePublishQuality(ChangePublishQuality v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasChangePublishQuality() => $_has(5);
  @$pb.TagNumber(6)
  void clearChangePublishQuality() => clearField(6);
  @$pb.TagNumber(6)
  ChangePublishQuality ensureChangePublishQuality() => $_ensure(5);

  @$pb.TagNumber(7)
  MuteStateChanged get muteStateChanged => $_getN(6);
  @$pb.TagNumber(7)
  set muteStateChanged(MuteStateChanged v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasMuteStateChanged() => $_has(6);
  @$pb.TagNumber(7)
  void clearMuteStateChanged() => clearField(7);
  @$pb.TagNumber(7)
  MuteStateChanged ensureMuteStateChanged() => $_ensure(6);

  @$pb.TagNumber(8)
  VideoQualityChanged get videoQualityChanged => $_getN(7);
  @$pb.TagNumber(8)
  set videoQualityChanged(VideoQualityChanged v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasVideoQualityChanged() => $_has(7);
  @$pb.TagNumber(8)
  void clearVideoQualityChanged() => clearField(8);
  @$pb.TagNumber(8)
  VideoQualityChanged ensureVideoQualityChanged() => $_ensure(7);

  @$pb.TagNumber(9)
  ParticipantConnected get participantConnected => $_getN(8);
  @$pb.TagNumber(9)
  set participantConnected(ParticipantConnected v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasParticipantConnected() => $_has(8);
  @$pb.TagNumber(9)
  void clearParticipantConnected() => clearField(9);
  @$pb.TagNumber(9)
  ParticipantConnected ensureParticipantConnected() => $_ensure(8);

  @$pb.TagNumber(10)
  ParticipantDisconnected get participantDisconnected => $_getN(9);
  @$pb.TagNumber(10)
  set participantDisconnected(ParticipantDisconnected v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasParticipantDisconnected() => $_has(9);
  @$pb.TagNumber(10)
  void clearParticipantDisconnected() => clearField(10);
  @$pb.TagNumber(10)
  ParticipantDisconnected ensureParticipantDisconnected() => $_ensure(9);

  @$pb.TagNumber(11)
  DominantSpeakerChanged get dominantSpeakerChanged => $_getN(10);
  @$pb.TagNumber(11)
  set dominantSpeakerChanged(DominantSpeakerChanged v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasDominantSpeakerChanged() => $_has(10);
  @$pb.TagNumber(11)
  void clearDominantSpeakerChanged() => clearField(11);
  @$pb.TagNumber(11)
  DominantSpeakerChanged ensureDominantSpeakerChanged() => $_ensure(10);

  @$pb.TagNumber(12)
  LocalDeviceChanged get localDeviceChange => $_getN(11);
  @$pb.TagNumber(12)
  set localDeviceChange(LocalDeviceChanged v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasLocalDeviceChange() => $_has(11);
  @$pb.TagNumber(12)
  void clearLocalDeviceChange() => clearField(12);
  @$pb.TagNumber(12)
  LocalDeviceChanged ensureLocalDeviceChange() => $_ensure(11);
}

class ParticipantConnected extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantConnected', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..aOM<$0.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $0.Call.create)
    ..aOM<$0.Participant>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantConnected._() : super();
  factory ParticipantConnected({
    $0.Call? call,
    $0.Participant? participant,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (participant != null) {
      _result.participant = participant;
    }
    return _result;
  }
  factory ParticipantConnected.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParticipantConnected.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParticipantConnected clone() => ParticipantConnected()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParticipantConnected copyWith(void Function(ParticipantConnected) updates) => super.copyWith((message) => updates(message as ParticipantConnected)) as ParticipantConnected; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ParticipantConnected create() => ParticipantConnected._();
  ParticipantConnected createEmptyInstance() => create();
  static $pb.PbList<ParticipantConnected> createRepeated() => $pb.PbList<ParticipantConnected>();
  @$core.pragma('dart2js:noInline')
  static ParticipantConnected getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParticipantConnected>(create);
  static ParticipantConnected? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($0.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $0.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Participant get participant => $_getN(1);
  @$pb.TagNumber(2)
  set participant($0.Participant v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasParticipant() => $_has(1);
  @$pb.TagNumber(2)
  void clearParticipant() => clearField(2);
  @$pb.TagNumber(2)
  $0.Participant ensureParticipant() => $_ensure(1);
}

class ParticipantDisconnected extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantDisconnected', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..aOM<$0.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $0.Call.create)
    ..aOM<$0.Participant>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantDisconnected._() : super();
  factory ParticipantDisconnected({
    $0.Call? call,
    $0.Participant? participant,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (participant != null) {
      _result.participant = participant;
    }
    return _result;
  }
  factory ParticipantDisconnected.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParticipantDisconnected.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParticipantDisconnected clone() => ParticipantDisconnected()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParticipantDisconnected copyWith(void Function(ParticipantDisconnected) updates) => super.copyWith((message) => updates(message as ParticipantDisconnected)) as ParticipantDisconnected; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ParticipantDisconnected create() => ParticipantDisconnected._();
  ParticipantDisconnected createEmptyInstance() => create();
  static $pb.PbList<ParticipantDisconnected> createRepeated() => $pb.PbList<ParticipantDisconnected>();
  @$core.pragma('dart2js:noInline')
  static ParticipantDisconnected getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParticipantDisconnected>(create);
  static ParticipantDisconnected? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($0.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $0.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Participant get participant => $_getN(1);
  @$pb.TagNumber(2)
  set participant($0.Participant v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasParticipant() => $_has(1);
  @$pb.TagNumber(2)
  void clearParticipant() => clearField(2);
  @$pb.TagNumber(2)
  $0.Participant ensureParticipant() => $_ensure(1);
}

class MuteStateChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MuteStateChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..aOM<$0.Participant>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $0.Participant.create)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioMuted')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'videoMuted')
    ..hasRequiredFields = false
  ;

  MuteStateChanged._() : super();
  factory MuteStateChanged({
    $0.Participant? participant,
    $core.bool? audioMuted,
    $core.bool? videoMuted,
  }) {
    final _result = create();
    if (participant != null) {
      _result.participant = participant;
    }
    if (audioMuted != null) {
      _result.audioMuted = audioMuted;
    }
    if (videoMuted != null) {
      _result.videoMuted = videoMuted;
    }
    return _result;
  }
  factory MuteStateChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MuteStateChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MuteStateChanged clone() => MuteStateChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MuteStateChanged copyWith(void Function(MuteStateChanged) updates) => super.copyWith((message) => updates(message as MuteStateChanged)) as MuteStateChanged; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MuteStateChanged create() => MuteStateChanged._();
  MuteStateChanged createEmptyInstance() => create();
  static $pb.PbList<MuteStateChanged> createRepeated() => $pb.PbList<MuteStateChanged>();
  @$core.pragma('dart2js:noInline')
  static MuteStateChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MuteStateChanged>(create);
  static MuteStateChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Participant get participant => $_getN(0);
  @$pb.TagNumber(1)
  set participant($0.Participant v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasParticipant() => $_has(0);
  @$pb.TagNumber(1)
  void clearParticipant() => clearField(1);
  @$pb.TagNumber(1)
  $0.Participant ensureParticipant() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get audioMuted => $_getBF(1);
  @$pb.TagNumber(2)
  set audioMuted($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAudioMuted() => $_has(1);
  @$pb.TagNumber(2)
  void clearAudioMuted() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get videoMuted => $_getBF(2);
  @$pb.TagNumber(3)
  set videoMuted($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVideoMuted() => $_has(2);
  @$pb.TagNumber(3)
  void clearVideoMuted() => clearField(3);
}

class VideoQualityChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoQualityChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..pc<$0.StreamQuality>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'streamQualities', $pb.PbFieldType.PM, subBuilder: $0.StreamQuality.create)
    ..hasRequiredFields = false
  ;

  VideoQualityChanged._() : super();
  factory VideoQualityChanged({
    $core.Iterable<$0.StreamQuality>? streamQualities,
  }) {
    final _result = create();
    if (streamQualities != null) {
      _result.streamQualities.addAll(streamQualities);
    }
    return _result;
  }
  factory VideoQualityChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoQualityChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoQualityChanged clone() => VideoQualityChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoQualityChanged copyWith(void Function(VideoQualityChanged) updates) => super.copyWith((message) => updates(message as VideoQualityChanged)) as VideoQualityChanged; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoQualityChanged create() => VideoQualityChanged._();
  VideoQualityChanged createEmptyInstance() => create();
  static $pb.PbList<VideoQualityChanged> createRepeated() => $pb.PbList<VideoQualityChanged>();
  @$core.pragma('dart2js:noInline')
  static VideoQualityChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoQualityChanged>(create);
  static VideoQualityChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.StreamQuality> get streamQualities => $_getList(0);
}

class SubscriberOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SubscriberOffer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdp')
    ..hasRequiredFields = false
  ;

  SubscriberOffer._() : super();
  factory SubscriberOffer({
    $core.String? sdp,
  }) {
    final _result = create();
    if (sdp != null) {
      _result.sdp = sdp;
    }
    return _result;
  }
  factory SubscriberOffer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubscriberOffer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubscriberOffer clone() => SubscriberOffer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubscriberOffer copyWith(void Function(SubscriberOffer) updates) => super.copyWith((message) => updates(message as SubscriberOffer)) as SubscriberOffer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SubscriberOffer create() => SubscriberOffer._();
  SubscriberOffer createEmptyInstance() => create();
  static $pb.PbList<SubscriberOffer> createRepeated() => $pb.PbList<SubscriberOffer>();
  @$core.pragma('dart2js:noInline')
  static SubscriberOffer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscriberOffer>(create);
  static SubscriberOffer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sdp => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdp($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSdp() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdp() => clearField(1);
}

class LocalDeviceChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalDeviceChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..hasRequiredFields = false
  ;

  LocalDeviceChanged._() : super();
  factory LocalDeviceChanged({
    $core.String? type,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    return _result;
  }
  factory LocalDeviceChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalDeviceChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalDeviceChanged clone() => LocalDeviceChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalDeviceChanged copyWith(void Function(LocalDeviceChanged) updates) => super.copyWith((message) => updates(message as LocalDeviceChanged)) as LocalDeviceChanged; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalDeviceChanged create() => LocalDeviceChanged._();
  LocalDeviceChanged createEmptyInstance() => create();
  static $pb.PbList<LocalDeviceChanged> createRepeated() => $pb.PbList<LocalDeviceChanged>();
  @$core.pragma('dart2js:noInline')
  static LocalDeviceChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalDeviceChanged>(create);
  static LocalDeviceChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);
}

class ICECandidateTrickle extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ICECandidateTrickle', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'candidate')
    ..hasRequiredFields = false
  ;

  ICECandidateTrickle._() : super();
  factory ICECandidateTrickle({
    $core.String? candidate,
  }) {
    final _result = create();
    if (candidate != null) {
      _result.candidate = candidate;
    }
    return _result;
  }
  factory ICECandidateTrickle.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ICECandidateTrickle.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ICECandidateTrickle clone() => ICECandidateTrickle()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ICECandidateTrickle copyWith(void Function(ICECandidateTrickle) updates) => super.copyWith((message) => updates(message as ICECandidateTrickle)) as ICECandidateTrickle; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ICECandidateTrickle create() => ICECandidateTrickle._();
  ICECandidateTrickle createEmptyInstance() => create();
  static $pb.PbList<ICECandidateTrickle> createRepeated() => $pb.PbList<ICECandidateTrickle>();
  @$core.pragma('dart2js:noInline')
  static ICECandidateTrickle getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ICECandidateTrickle>(create);
  static ICECandidateTrickle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get candidate => $_getSZ(0);
  @$pb.TagNumber(1)
  set candidate($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCandidate() => $_has(0);
  @$pb.TagNumber(1)
  void clearCandidate() => clearField(1);
}

class ConnectionQualityChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectionQualityChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..e<$0.ConnectionQuality>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectionQuality', $pb.PbFieldType.OE, defaultOrMaker: $0.ConnectionQuality.CONNECTION_QUALITY_BAD_UNSPECIFIED, valueOf: $0.ConnectionQuality.valueOf, enumValues: $0.ConnectionQuality.values)
    ..hasRequiredFields = false
  ;

  ConnectionQualityChanged._() : super();
  factory ConnectionQualityChanged({
    $core.String? userId,
    $0.ConnectionQuality? connectionQuality,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (connectionQuality != null) {
      _result.connectionQuality = connectionQuality;
    }
    return _result;
  }
  factory ConnectionQualityChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectionQualityChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectionQualityChanged clone() => ConnectionQualityChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectionQualityChanged copyWith(void Function(ConnectionQualityChanged) updates) => super.copyWith((message) => updates(message as ConnectionQualityChanged)) as ConnectionQualityChanged; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectionQualityChanged create() => ConnectionQualityChanged._();
  ConnectionQualityChanged createEmptyInstance() => create();
  static $pb.PbList<ConnectionQualityChanged> createRepeated() => $pb.PbList<ConnectionQualityChanged>();
  @$core.pragma('dart2js:noInline')
  static ConnectionQualityChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectionQualityChanged>(create);
  static ConnectionQualityChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $0.ConnectionQuality get connectionQuality => $_getN(1);
  @$pb.TagNumber(2)
  set connectionQuality($0.ConnectionQuality v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasConnectionQuality() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectionQuality() => clearField(2);
}

class DominantSpeakerChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DominantSpeakerChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  DominantSpeakerChanged._() : super();
  factory DominantSpeakerChanged({
    $core.String? userId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory DominantSpeakerChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DominantSpeakerChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DominantSpeakerChanged clone() => DominantSpeakerChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DominantSpeakerChanged copyWith(void Function(DominantSpeakerChanged) updates) => super.copyWith((message) => updates(message as DominantSpeakerChanged)) as DominantSpeakerChanged; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DominantSpeakerChanged create() => DominantSpeakerChanged._();
  DominantSpeakerChanged createEmptyInstance() => create();
  static $pb.PbList<DominantSpeakerChanged> createRepeated() => $pb.PbList<DominantSpeakerChanged>();
  @$core.pragma('dart2js:noInline')
  static DominantSpeakerChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DominantSpeakerChanged>(create);
  static DominantSpeakerChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);
}

class AudioLevelChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioLevelChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..pc<AudioLevel>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioLevels', $pb.PbFieldType.PM, subBuilder: AudioLevel.create)
    ..hasRequiredFields = false
  ;

  AudioLevelChanged._() : super();
  factory AudioLevelChanged({
    $core.Iterable<AudioLevel>? audioLevels,
  }) {
    final _result = create();
    if (audioLevels != null) {
      _result.audioLevels.addAll(audioLevels);
    }
    return _result;
  }
  factory AudioLevelChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioLevelChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioLevelChanged clone() => AudioLevelChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioLevelChanged copyWith(void Function(AudioLevelChanged) updates) => super.copyWith((message) => updates(message as AudioLevelChanged)) as AudioLevelChanged; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AudioLevelChanged create() => AudioLevelChanged._();
  AudioLevelChanged createEmptyInstance() => create();
  static $pb.PbList<AudioLevelChanged> createRepeated() => $pb.PbList<AudioLevelChanged>();
  @$core.pragma('dart2js:noInline')
  static AudioLevelChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AudioLevelChanged>(create);
  static AudioLevelChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<AudioLevel> get audioLevels => $_getList(0);
}

class AudioLevel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioLevel', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'level', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  AudioLevel._() : super();
  factory AudioLevel({
    $core.String? userId,
    $core.double? level,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (level != null) {
      _result.level = level;
    }
    return _result;
  }
  factory AudioLevel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioLevel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioLevel clone() => AudioLevel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioLevel copyWith(void Function(AudioLevel) updates) => super.copyWith((message) => updates(message as AudioLevel)) as AudioLevel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AudioLevel create() => AudioLevel._();
  AudioLevel createEmptyInstance() => create();
  static $pb.PbList<AudioLevel> createRepeated() => $pb.PbList<AudioLevel>();
  @$core.pragma('dart2js:noInline')
  static AudioLevel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AudioLevel>(create);
  static AudioLevel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get level => $_getN(1);
  @$pb.TagNumber(2)
  set level($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLevel() => clearField(2);
}

class AudioLayerSetting extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioLayerSetting', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  AudioLayerSetting._() : super();
  factory AudioLayerSetting() => create();
  factory AudioLayerSetting.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioLayerSetting.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioLayerSetting clone() => AudioLayerSetting()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioLayerSetting copyWith(void Function(AudioLayerSetting) updates) => super.copyWith((message) => updates(message as AudioLayerSetting)) as AudioLayerSetting; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AudioLayerSetting create() => AudioLayerSetting._();
  AudioLayerSetting createEmptyInstance() => create();
  static $pb.PbList<AudioLayerSetting> createRepeated() => $pb.PbList<AudioLayerSetting>();
  @$core.pragma('dart2js:noInline')
  static AudioLayerSetting getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AudioLayerSetting>(create);
  static AudioLayerSetting? _defaultInstance;
}

class AudioMediaRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioMediaRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'channelCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  AudioMediaRequest._() : super();
  factory AudioMediaRequest({
    $core.int? channelCount,
  }) {
    final _result = create();
    if (channelCount != null) {
      _result.channelCount = channelCount;
    }
    return _result;
  }
  factory AudioMediaRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioMediaRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioMediaRequest clone() => AudioMediaRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioMediaRequest copyWith(void Function(AudioMediaRequest) updates) => super.copyWith((message) => updates(message as AudioMediaRequest)) as AudioMediaRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AudioMediaRequest create() => AudioMediaRequest._();
  AudioMediaRequest createEmptyInstance() => create();
  static $pb.PbList<AudioMediaRequest> createRepeated() => $pb.PbList<AudioMediaRequest>();
  @$core.pragma('dart2js:noInline')
  static AudioMediaRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AudioMediaRequest>(create);
  static AudioMediaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get channelCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set channelCount($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChannelCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelCount() => clearField(1);
}

class AudioSender extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioSender', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..aOM<AudioMediaRequest>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mediaRequest', subBuilder: AudioMediaRequest.create)
    ..aOM<$0.Codec>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'codec', subBuilder: $0.Codec.create)
    ..pc<AudioLayerSetting>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'layers', $pb.PbFieldType.PM, subBuilder: AudioLayerSetting.create)
    ..hasRequiredFields = false
  ;

  AudioSender._() : super();
  factory AudioSender({
    AudioMediaRequest? mediaRequest,
    $0.Codec? codec,
    $core.Iterable<AudioLayerSetting>? layers,
  }) {
    final _result = create();
    if (mediaRequest != null) {
      _result.mediaRequest = mediaRequest;
    }
    if (codec != null) {
      _result.codec = codec;
    }
    if (layers != null) {
      _result.layers.addAll(layers);
    }
    return _result;
  }
  factory AudioSender.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioSender.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioSender clone() => AudioSender()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioSender copyWith(void Function(AudioSender) updates) => super.copyWith((message) => updates(message as AudioSender)) as AudioSender; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AudioSender create() => AudioSender._();
  AudioSender createEmptyInstance() => create();
  static $pb.PbList<AudioSender> createRepeated() => $pb.PbList<AudioSender>();
  @$core.pragma('dart2js:noInline')
  static AudioSender getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AudioSender>(create);
  static AudioSender? _defaultInstance;

  @$pb.TagNumber(1)
  AudioMediaRequest get mediaRequest => $_getN(0);
  @$pb.TagNumber(1)
  set mediaRequest(AudioMediaRequest v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMediaRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaRequest() => clearField(1);
  @$pb.TagNumber(1)
  AudioMediaRequest ensureMediaRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Codec get codec => $_getN(1);
  @$pb.TagNumber(2)
  set codec($0.Codec v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCodec() => $_has(1);
  @$pb.TagNumber(2)
  void clearCodec() => clearField(2);
  @$pb.TagNumber(2)
  $0.Codec ensureCodec() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<AudioLayerSetting> get layers => $_getList(2);
}

class VideoMediaRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoMediaRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'idealHeight', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'idealWidth', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'idealFrameRate', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  VideoMediaRequest._() : super();
  factory VideoMediaRequest({
    $core.int? idealHeight,
    $core.int? idealWidth,
    $core.int? idealFrameRate,
  }) {
    final _result = create();
    if (idealHeight != null) {
      _result.idealHeight = idealHeight;
    }
    if (idealWidth != null) {
      _result.idealWidth = idealWidth;
    }
    if (idealFrameRate != null) {
      _result.idealFrameRate = idealFrameRate;
    }
    return _result;
  }
  factory VideoMediaRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoMediaRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoMediaRequest clone() => VideoMediaRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoMediaRequest copyWith(void Function(VideoMediaRequest) updates) => super.copyWith((message) => updates(message as VideoMediaRequest)) as VideoMediaRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoMediaRequest create() => VideoMediaRequest._();
  VideoMediaRequest createEmptyInstance() => create();
  static $pb.PbList<VideoMediaRequest> createRepeated() => $pb.PbList<VideoMediaRequest>();
  @$core.pragma('dart2js:noInline')
  static VideoMediaRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoMediaRequest>(create);
  static VideoMediaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get idealHeight => $_getIZ(0);
  @$pb.TagNumber(1)
  set idealHeight($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIdealHeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdealHeight() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get idealWidth => $_getIZ(1);
  @$pb.TagNumber(2)
  set idealWidth($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIdealWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdealWidth() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get idealFrameRate => $_getIZ(2);
  @$pb.TagNumber(3)
  set idealFrameRate($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIdealFrameRate() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdealFrameRate() => clearField(3);
}

class VideoLayerSetting extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoLayerSetting', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'active')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxBitrate', $pb.PbFieldType.O3)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scaleResolutionDownBy', $pb.PbFieldType.OF)
    ..e<VideoLayerSetting_Priority>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'priority', $pb.PbFieldType.OE, defaultOrMaker: VideoLayerSetting_Priority.PRIORITY_HIGH_UNSPECIFIED, valueOf: VideoLayerSetting_Priority.valueOf, enumValues: VideoLayerSetting_Priority.values)
    ..aOM<$0.Codec>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'codec', subBuilder: $0.Codec.create)
    ..hasRequiredFields = false
  ;

  VideoLayerSetting._() : super();
  factory VideoLayerSetting({
    $core.String? name,
    $core.bool? active,
    $core.int? maxBitrate,
    $core.double? scaleResolutionDownBy,
    VideoLayerSetting_Priority? priority,
    $0.Codec? codec,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (active != null) {
      _result.active = active;
    }
    if (maxBitrate != null) {
      _result.maxBitrate = maxBitrate;
    }
    if (scaleResolutionDownBy != null) {
      _result.scaleResolutionDownBy = scaleResolutionDownBy;
    }
    if (priority != null) {
      _result.priority = priority;
    }
    if (codec != null) {
      _result.codec = codec;
    }
    return _result;
  }
  factory VideoLayerSetting.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoLayerSetting.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoLayerSetting clone() => VideoLayerSetting()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoLayerSetting copyWith(void Function(VideoLayerSetting) updates) => super.copyWith((message) => updates(message as VideoLayerSetting)) as VideoLayerSetting; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoLayerSetting create() => VideoLayerSetting._();
  VideoLayerSetting createEmptyInstance() => create();
  static $pb.PbList<VideoLayerSetting> createRepeated() => $pb.PbList<VideoLayerSetting>();
  @$core.pragma('dart2js:noInline')
  static VideoLayerSetting getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoLayerSetting>(create);
  static VideoLayerSetting? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get active => $_getBF(1);
  @$pb.TagNumber(2)
  set active($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasActive() => $_has(1);
  @$pb.TagNumber(2)
  void clearActive() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxBitrate => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxBitrate($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxBitrate() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxBitrate() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get scaleResolutionDownBy => $_getN(3);
  @$pb.TagNumber(4)
  set scaleResolutionDownBy($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasScaleResolutionDownBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearScaleResolutionDownBy() => clearField(4);

  @$pb.TagNumber(5)
  VideoLayerSetting_Priority get priority => $_getN(4);
  @$pb.TagNumber(5)
  set priority(VideoLayerSetting_Priority v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasPriority() => $_has(4);
  @$pb.TagNumber(5)
  void clearPriority() => clearField(5);

  @$pb.TagNumber(6)
  $0.Codec get codec => $_getN(5);
  @$pb.TagNumber(6)
  set codec($0.Codec v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCodec() => $_has(5);
  @$pb.TagNumber(6)
  void clearCodec() => clearField(6);
  @$pb.TagNumber(6)
  $0.Codec ensureCodec() => $_ensure(5);
}

class VideoSender extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoSender', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..aOM<VideoMediaRequest>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mediaRequest', subBuilder: VideoMediaRequest.create)
    ..aOM<$0.Codec>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'codec', subBuilder: $0.Codec.create)
    ..pc<VideoLayerSetting>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'layers', $pb.PbFieldType.PM, subBuilder: VideoLayerSetting.create)
    ..hasRequiredFields = false
  ;

  VideoSender._() : super();
  factory VideoSender({
    VideoMediaRequest? mediaRequest,
    $0.Codec? codec,
    $core.Iterable<VideoLayerSetting>? layers,
  }) {
    final _result = create();
    if (mediaRequest != null) {
      _result.mediaRequest = mediaRequest;
    }
    if (codec != null) {
      _result.codec = codec;
    }
    if (layers != null) {
      _result.layers.addAll(layers);
    }
    return _result;
  }
  factory VideoSender.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoSender.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoSender clone() => VideoSender()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoSender copyWith(void Function(VideoSender) updates) => super.copyWith((message) => updates(message as VideoSender)) as VideoSender; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoSender create() => VideoSender._();
  VideoSender createEmptyInstance() => create();
  static $pb.PbList<VideoSender> createRepeated() => $pb.PbList<VideoSender>();
  @$core.pragma('dart2js:noInline')
  static VideoSender getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoSender>(create);
  static VideoSender? _defaultInstance;

  @$pb.TagNumber(1)
  VideoMediaRequest get mediaRequest => $_getN(0);
  @$pb.TagNumber(1)
  set mediaRequest(VideoMediaRequest v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMediaRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaRequest() => clearField(1);
  @$pb.TagNumber(1)
  VideoMediaRequest ensureMediaRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Codec get codec => $_getN(1);
  @$pb.TagNumber(2)
  set codec($0.Codec v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCodec() => $_has(1);
  @$pb.TagNumber(2)
  void clearCodec() => clearField(2);
  @$pb.TagNumber(2)
  $0.Codec ensureCodec() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<VideoLayerSetting> get layers => $_getList(2);
}

class ChangePublishQuality extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChangePublishQuality', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event_v1'), createEmptyInstance: create)
    ..pc<AudioSender>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioSenders', $pb.PbFieldType.PM, subBuilder: AudioSender.create)
    ..pc<VideoSender>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'videoSenders', $pb.PbFieldType.PM, subBuilder: VideoSender.create)
    ..hasRequiredFields = false
  ;

  ChangePublishQuality._() : super();
  factory ChangePublishQuality({
    $core.Iterable<AudioSender>? audioSenders,
    $core.Iterable<VideoSender>? videoSenders,
  }) {
    final _result = create();
    if (audioSenders != null) {
      _result.audioSenders.addAll(audioSenders);
    }
    if (videoSenders != null) {
      _result.videoSenders.addAll(videoSenders);
    }
    return _result;
  }
  factory ChangePublishQuality.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChangePublishQuality.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChangePublishQuality clone() => ChangePublishQuality()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChangePublishQuality copyWith(void Function(ChangePublishQuality) updates) => super.copyWith((message) => updates(message as ChangePublishQuality)) as ChangePublishQuality; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChangePublishQuality create() => ChangePublishQuality._();
  ChangePublishQuality createEmptyInstance() => create();
  static $pb.PbList<ChangePublishQuality> createRepeated() => $pb.PbList<ChangePublishQuality>();
  @$core.pragma('dart2js:noInline')
  static ChangePublishQuality getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChangePublishQuality>(create);
  static ChangePublishQuality? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<AudioSender> get audioSenders => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<VideoSender> get videoSenders => $_getList(1);
}

