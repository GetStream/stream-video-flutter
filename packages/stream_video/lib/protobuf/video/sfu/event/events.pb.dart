///
//  Generated code. Do not modify.
//  source: video/sfu/event/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../models/models.pb.dart' as $0;
import '../signal_rpc/signal.pb.dart' as $1;

import '../models/models.pbenum.dart' as $0;
import 'events.pbenum.dart';

export 'events.pbenum.dart';

enum SfuEvent_EventPayload {
  subscriberOffer, 
  publisherAnswer, 
  connectionQualityChanged, 
  audioLevelChanged, 
  iceTrickle, 
  changePublishQuality, 
  participantJoined, 
  participantLeft, 
  dominantSpeakerChanged, 
  joinResponse, 
  healthCheckResponse, 
  trackPublished, 
  trackUnpublished, 
  error, 
  callGrantsUpdated, 
  goAway, 
  iceRestart, 
  pinsUpdated, 
  notSet
}

class SfuEvent extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, SfuEvent_EventPayload> _SfuEvent_EventPayloadByTag = {
    1 : SfuEvent_EventPayload.subscriberOffer,
    2 : SfuEvent_EventPayload.publisherAnswer,
    3 : SfuEvent_EventPayload.connectionQualityChanged,
    4 : SfuEvent_EventPayload.audioLevelChanged,
    5 : SfuEvent_EventPayload.iceTrickle,
    6 : SfuEvent_EventPayload.changePublishQuality,
    10 : SfuEvent_EventPayload.participantJoined,
    11 : SfuEvent_EventPayload.participantLeft,
    12 : SfuEvent_EventPayload.dominantSpeakerChanged,
    13 : SfuEvent_EventPayload.joinResponse,
    14 : SfuEvent_EventPayload.healthCheckResponse,
    16 : SfuEvent_EventPayload.trackPublished,
    17 : SfuEvent_EventPayload.trackUnpublished,
    18 : SfuEvent_EventPayload.error,
    19 : SfuEvent_EventPayload.callGrantsUpdated,
    20 : SfuEvent_EventPayload.goAway,
    21 : SfuEvent_EventPayload.iceRestart,
    22 : SfuEvent_EventPayload.pinsUpdated,
    0 : SfuEvent_EventPayload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SfuEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22])
    ..aOM<SubscriberOffer>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscriberOffer', subBuilder: SubscriberOffer.create)
    ..aOM<PublisherAnswer>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publisherAnswer', subBuilder: PublisherAnswer.create)
    ..aOM<ConnectionQualityChanged>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectionQualityChanged', subBuilder: ConnectionQualityChanged.create)
    ..aOM<AudioLevelChanged>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioLevelChanged', subBuilder: AudioLevelChanged.create)
    ..aOM<$0.ICETrickle>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iceTrickle', subBuilder: $0.ICETrickle.create)
    ..aOM<ChangePublishQuality>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'changePublishQuality', subBuilder: ChangePublishQuality.create)
    ..aOM<ParticipantJoined>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantJoined', subBuilder: ParticipantJoined.create)
    ..aOM<ParticipantLeft>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantLeft', subBuilder: ParticipantLeft.create)
    ..aOM<DominantSpeakerChanged>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dominantSpeakerChanged', subBuilder: DominantSpeakerChanged.create)
    ..aOM<JoinResponse>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'joinResponse', subBuilder: JoinResponse.create)
    ..aOM<HealthCheckResponse>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'healthCheckResponse', subBuilder: HealthCheckResponse.create)
    ..aOM<TrackPublished>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trackPublished', subBuilder: TrackPublished.create)
    ..aOM<TrackUnpublished>(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trackUnpublished', subBuilder: TrackUnpublished.create)
    ..aOM<Error>(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error', subBuilder: Error.create)
    ..aOM<CallGrantsUpdated>(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callGrantsUpdated', subBuilder: CallGrantsUpdated.create)
    ..aOM<GoAway>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'goAway', subBuilder: GoAway.create)
    ..aOM<ICERestart>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iceRestart', subBuilder: ICERestart.create)
    ..aOM<PinsChanged>(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pinsUpdated', subBuilder: PinsChanged.create)
    ..hasRequiredFields = false
  ;

  SfuEvent._() : super();
  factory SfuEvent({
    SubscriberOffer? subscriberOffer,
    PublisherAnswer? publisherAnswer,
    ConnectionQualityChanged? connectionQualityChanged,
    AudioLevelChanged? audioLevelChanged,
    $0.ICETrickle? iceTrickle,
    ChangePublishQuality? changePublishQuality,
    ParticipantJoined? participantJoined,
    ParticipantLeft? participantLeft,
    DominantSpeakerChanged? dominantSpeakerChanged,
    JoinResponse? joinResponse,
    HealthCheckResponse? healthCheckResponse,
    TrackPublished? trackPublished,
    TrackUnpublished? trackUnpublished,
    Error? error,
    CallGrantsUpdated? callGrantsUpdated,
    GoAway? goAway,
    ICERestart? iceRestart,
    PinsChanged? pinsUpdated,
  }) {
    final _result = create();
    if (subscriberOffer != null) {
      _result.subscriberOffer = subscriberOffer;
    }
    if (publisherAnswer != null) {
      _result.publisherAnswer = publisherAnswer;
    }
    if (connectionQualityChanged != null) {
      _result.connectionQualityChanged = connectionQualityChanged;
    }
    if (audioLevelChanged != null) {
      _result.audioLevelChanged = audioLevelChanged;
    }
    if (iceTrickle != null) {
      _result.iceTrickle = iceTrickle;
    }
    if (changePublishQuality != null) {
      _result.changePublishQuality = changePublishQuality;
    }
    if (participantJoined != null) {
      _result.participantJoined = participantJoined;
    }
    if (participantLeft != null) {
      _result.participantLeft = participantLeft;
    }
    if (dominantSpeakerChanged != null) {
      _result.dominantSpeakerChanged = dominantSpeakerChanged;
    }
    if (joinResponse != null) {
      _result.joinResponse = joinResponse;
    }
    if (healthCheckResponse != null) {
      _result.healthCheckResponse = healthCheckResponse;
    }
    if (trackPublished != null) {
      _result.trackPublished = trackPublished;
    }
    if (trackUnpublished != null) {
      _result.trackUnpublished = trackUnpublished;
    }
    if (error != null) {
      _result.error = error;
    }
    if (callGrantsUpdated != null) {
      _result.callGrantsUpdated = callGrantsUpdated;
    }
    if (goAway != null) {
      _result.goAway = goAway;
    }
    if (iceRestart != null) {
      _result.iceRestart = iceRestart;
    }
    if (pinsUpdated != null) {
      _result.pinsUpdated = pinsUpdated;
    }
    return _result;
  }
  factory SfuEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SfuEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SfuEvent clone() => SfuEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SfuEvent copyWith(void Function(SfuEvent) updates) => super.copyWith((message) => updates(message as SfuEvent)) as SfuEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SfuEvent create() => SfuEvent._();
  SfuEvent createEmptyInstance() => create();
  static $pb.PbList<SfuEvent> createRepeated() => $pb.PbList<SfuEvent>();
  @$core.pragma('dart2js:noInline')
  static SfuEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SfuEvent>(create);
  static SfuEvent? _defaultInstance;

  SfuEvent_EventPayload whichEventPayload() => _SfuEvent_EventPayloadByTag[$_whichOneof(0)]!;
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
  PublisherAnswer get publisherAnswer => $_getN(1);
  @$pb.TagNumber(2)
  set publisherAnswer(PublisherAnswer v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPublisherAnswer() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublisherAnswer() => clearField(2);
  @$pb.TagNumber(2)
  PublisherAnswer ensurePublisherAnswer() => $_ensure(1);

  @$pb.TagNumber(3)
  ConnectionQualityChanged get connectionQualityChanged => $_getN(2);
  @$pb.TagNumber(3)
  set connectionQualityChanged(ConnectionQualityChanged v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasConnectionQualityChanged() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnectionQualityChanged() => clearField(3);
  @$pb.TagNumber(3)
  ConnectionQualityChanged ensureConnectionQualityChanged() => $_ensure(2);

  @$pb.TagNumber(4)
  AudioLevelChanged get audioLevelChanged => $_getN(3);
  @$pb.TagNumber(4)
  set audioLevelChanged(AudioLevelChanged v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAudioLevelChanged() => $_has(3);
  @$pb.TagNumber(4)
  void clearAudioLevelChanged() => clearField(4);
  @$pb.TagNumber(4)
  AudioLevelChanged ensureAudioLevelChanged() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.ICETrickle get iceTrickle => $_getN(4);
  @$pb.TagNumber(5)
  set iceTrickle($0.ICETrickle v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasIceTrickle() => $_has(4);
  @$pb.TagNumber(5)
  void clearIceTrickle() => clearField(5);
  @$pb.TagNumber(5)
  $0.ICETrickle ensureIceTrickle() => $_ensure(4);

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

  @$pb.TagNumber(10)
  ParticipantJoined get participantJoined => $_getN(6);
  @$pb.TagNumber(10)
  set participantJoined(ParticipantJoined v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasParticipantJoined() => $_has(6);
  @$pb.TagNumber(10)
  void clearParticipantJoined() => clearField(10);
  @$pb.TagNumber(10)
  ParticipantJoined ensureParticipantJoined() => $_ensure(6);

  @$pb.TagNumber(11)
  ParticipantLeft get participantLeft => $_getN(7);
  @$pb.TagNumber(11)
  set participantLeft(ParticipantLeft v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasParticipantLeft() => $_has(7);
  @$pb.TagNumber(11)
  void clearParticipantLeft() => clearField(11);
  @$pb.TagNumber(11)
  ParticipantLeft ensureParticipantLeft() => $_ensure(7);

  @$pb.TagNumber(12)
  DominantSpeakerChanged get dominantSpeakerChanged => $_getN(8);
  @$pb.TagNumber(12)
  set dominantSpeakerChanged(DominantSpeakerChanged v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasDominantSpeakerChanged() => $_has(8);
  @$pb.TagNumber(12)
  void clearDominantSpeakerChanged() => clearField(12);
  @$pb.TagNumber(12)
  DominantSpeakerChanged ensureDominantSpeakerChanged() => $_ensure(8);

  @$pb.TagNumber(13)
  JoinResponse get joinResponse => $_getN(9);
  @$pb.TagNumber(13)
  set joinResponse(JoinResponse v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasJoinResponse() => $_has(9);
  @$pb.TagNumber(13)
  void clearJoinResponse() => clearField(13);
  @$pb.TagNumber(13)
  JoinResponse ensureJoinResponse() => $_ensure(9);

  @$pb.TagNumber(14)
  HealthCheckResponse get healthCheckResponse => $_getN(10);
  @$pb.TagNumber(14)
  set healthCheckResponse(HealthCheckResponse v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasHealthCheckResponse() => $_has(10);
  @$pb.TagNumber(14)
  void clearHealthCheckResponse() => clearField(14);
  @$pb.TagNumber(14)
  HealthCheckResponse ensureHealthCheckResponse() => $_ensure(10);

  @$pb.TagNumber(16)
  TrackPublished get trackPublished => $_getN(11);
  @$pb.TagNumber(16)
  set trackPublished(TrackPublished v) { setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasTrackPublished() => $_has(11);
  @$pb.TagNumber(16)
  void clearTrackPublished() => clearField(16);
  @$pb.TagNumber(16)
  TrackPublished ensureTrackPublished() => $_ensure(11);

  @$pb.TagNumber(17)
  TrackUnpublished get trackUnpublished => $_getN(12);
  @$pb.TagNumber(17)
  set trackUnpublished(TrackUnpublished v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasTrackUnpublished() => $_has(12);
  @$pb.TagNumber(17)
  void clearTrackUnpublished() => clearField(17);
  @$pb.TagNumber(17)
  TrackUnpublished ensureTrackUnpublished() => $_ensure(12);

  @$pb.TagNumber(18)
  Error get error => $_getN(13);
  @$pb.TagNumber(18)
  set error(Error v) { setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasError() => $_has(13);
  @$pb.TagNumber(18)
  void clearError() => clearField(18);
  @$pb.TagNumber(18)
  Error ensureError() => $_ensure(13);

  @$pb.TagNumber(19)
  CallGrantsUpdated get callGrantsUpdated => $_getN(14);
  @$pb.TagNumber(19)
  set callGrantsUpdated(CallGrantsUpdated v) { setField(19, v); }
  @$pb.TagNumber(19)
  $core.bool hasCallGrantsUpdated() => $_has(14);
  @$pb.TagNumber(19)
  void clearCallGrantsUpdated() => clearField(19);
  @$pb.TagNumber(19)
  CallGrantsUpdated ensureCallGrantsUpdated() => $_ensure(14);

  @$pb.TagNumber(20)
  GoAway get goAway => $_getN(15);
  @$pb.TagNumber(20)
  set goAway(GoAway v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasGoAway() => $_has(15);
  @$pb.TagNumber(20)
  void clearGoAway() => clearField(20);
  @$pb.TagNumber(20)
  GoAway ensureGoAway() => $_ensure(15);

  @$pb.TagNumber(21)
  ICERestart get iceRestart => $_getN(16);
  @$pb.TagNumber(21)
  set iceRestart(ICERestart v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasIceRestart() => $_has(16);
  @$pb.TagNumber(21)
  void clearIceRestart() => clearField(21);
  @$pb.TagNumber(21)
  ICERestart ensureIceRestart() => $_ensure(16);

  @$pb.TagNumber(22)
  PinsChanged get pinsUpdated => $_getN(17);
  @$pb.TagNumber(22)
  set pinsUpdated(PinsChanged v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasPinsUpdated() => $_has(17);
  @$pb.TagNumber(22)
  void clearPinsUpdated() => clearField(22);
  @$pb.TagNumber(22)
  PinsChanged ensurePinsUpdated() => $_ensure(17);
}

class PinsChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PinsChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..pc<$0.Pin>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pins', $pb.PbFieldType.PM, subBuilder: $0.Pin.create)
    ..hasRequiredFields = false
  ;

  PinsChanged._() : super();
  factory PinsChanged({
    $core.Iterable<$0.Pin>? pins,
  }) {
    final _result = create();
    if (pins != null) {
      _result.pins.addAll(pins);
    }
    return _result;
  }
  factory PinsChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PinsChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PinsChanged clone() => PinsChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PinsChanged copyWith(void Function(PinsChanged) updates) => super.copyWith((message) => updates(message as PinsChanged)) as PinsChanged; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PinsChanged create() => PinsChanged._();
  PinsChanged createEmptyInstance() => create();
  static $pb.PbList<PinsChanged> createRepeated() => $pb.PbList<PinsChanged>();
  @$core.pragma('dart2js:noInline')
  static PinsChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PinsChanged>(create);
  static PinsChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.Pin> get pins => $_getList(0);
}

class Error extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Error', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<$0.Error>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error', subBuilder: $0.Error.create)
    ..hasRequiredFields = false
  ;

  Error._() : super();
  factory Error({
    $0.Error? error,
  }) {
    final _result = create();
    if (error != null) {
      _result.error = error;
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

class ICETrickle extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ICETrickle', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..e<$0.PeerType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peerType', $pb.PbFieldType.OE, defaultOrMaker: $0.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED, valueOf: $0.PeerType.valueOf, enumValues: $0.PeerType.values)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iceCandidate')
    ..hasRequiredFields = false
  ;

  ICETrickle._() : super();
  factory ICETrickle({
    $0.PeerType? peerType,
    $core.String? iceCandidate,
  }) {
    final _result = create();
    if (peerType != null) {
      _result.peerType = peerType;
    }
    if (iceCandidate != null) {
      _result.iceCandidate = iceCandidate;
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
  $0.PeerType get peerType => $_getN(0);
  @$pb.TagNumber(1)
  set peerType($0.PeerType v) { setField(1, v); }
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
}

class ICERestart extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ICERestart', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..e<$0.PeerType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peerType', $pb.PbFieldType.OE, defaultOrMaker: $0.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED, valueOf: $0.PeerType.valueOf, enumValues: $0.PeerType.values)
    ..hasRequiredFields = false
  ;

  ICERestart._() : super();
  factory ICERestart({
    $0.PeerType? peerType,
  }) {
    final _result = create();
    if (peerType != null) {
      _result.peerType = peerType;
    }
    return _result;
  }
  factory ICERestart.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ICERestart.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ICERestart clone() => ICERestart()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ICERestart copyWith(void Function(ICERestart) updates) => super.copyWith((message) => updates(message as ICERestart)) as ICERestart; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ICERestart create() => ICERestart._();
  ICERestart createEmptyInstance() => create();
  static $pb.PbList<ICERestart> createRepeated() => $pb.PbList<ICERestart>();
  @$core.pragma('dart2js:noInline')
  static ICERestart getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ICERestart>(create);
  static ICERestart? _defaultInstance;

  @$pb.TagNumber(1)
  $0.PeerType get peerType => $_getN(0);
  @$pb.TagNumber(1)
  set peerType($0.PeerType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeerType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerType() => clearField(1);
}

enum SfuRequest_RequestPayload {
  joinRequest, 
  healthCheckRequest, 
  notSet
}

class SfuRequest extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, SfuRequest_RequestPayload> _SfuRequest_RequestPayloadByTag = {
    1 : SfuRequest_RequestPayload.joinRequest,
    2 : SfuRequest_RequestPayload.healthCheckRequest,
    0 : SfuRequest_RequestPayload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SfuRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<JoinRequest>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'joinRequest', subBuilder: JoinRequest.create)
    ..aOM<HealthCheckRequest>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'healthCheckRequest', subBuilder: HealthCheckRequest.create)
    ..hasRequiredFields = false
  ;

  SfuRequest._() : super();
  factory SfuRequest({
    JoinRequest? joinRequest,
    HealthCheckRequest? healthCheckRequest,
  }) {
    final _result = create();
    if (joinRequest != null) {
      _result.joinRequest = joinRequest;
    }
    if (healthCheckRequest != null) {
      _result.healthCheckRequest = healthCheckRequest;
    }
    return _result;
  }
  factory SfuRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SfuRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SfuRequest clone() => SfuRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SfuRequest copyWith(void Function(SfuRequest) updates) => super.copyWith((message) => updates(message as SfuRequest)) as SfuRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SfuRequest create() => SfuRequest._();
  SfuRequest createEmptyInstance() => create();
  static $pb.PbList<SfuRequest> createRepeated() => $pb.PbList<SfuRequest>();
  @$core.pragma('dart2js:noInline')
  static SfuRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SfuRequest>(create);
  static SfuRequest? _defaultInstance;

  SfuRequest_RequestPayload whichRequestPayload() => _SfuRequest_RequestPayloadByTag[$_whichOneof(0)]!;
  void clearRequestPayload() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  JoinRequest get joinRequest => $_getN(0);
  @$pb.TagNumber(1)
  set joinRequest(JoinRequest v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasJoinRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearJoinRequest() => clearField(1);
  @$pb.TagNumber(1)
  JoinRequest ensureJoinRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  HealthCheckRequest get healthCheckRequest => $_getN(1);
  @$pb.TagNumber(2)
  set healthCheckRequest(HealthCheckRequest v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasHealthCheckRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearHealthCheckRequest() => clearField(2);
  @$pb.TagNumber(2)
  HealthCheckRequest ensureHealthCheckRequest() => $_ensure(1);
}

class HealthCheckRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HealthCheckRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  HealthCheckRequest._() : super();
  factory HealthCheckRequest() => create();
  factory HealthCheckRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HealthCheckRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HealthCheckRequest clone() => HealthCheckRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HealthCheckRequest copyWith(void Function(HealthCheckRequest) updates) => super.copyWith((message) => updates(message as HealthCheckRequest)) as HealthCheckRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HealthCheckRequest create() => HealthCheckRequest._();
  HealthCheckRequest createEmptyInstance() => create();
  static $pb.PbList<HealthCheckRequest> createRepeated() => $pb.PbList<HealthCheckRequest>();
  @$core.pragma('dart2js:noInline')
  static HealthCheckRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HealthCheckRequest>(create);
  static HealthCheckRequest? _defaultInstance;
}

class HealthCheckResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HealthCheckResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<$0.ParticipantCount>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantCount', subBuilder: $0.ParticipantCount.create)
    ..hasRequiredFields = false
  ;

  HealthCheckResponse._() : super();
  factory HealthCheckResponse({
    $0.ParticipantCount? participantCount,
  }) {
    final _result = create();
    if (participantCount != null) {
      _result.participantCount = participantCount;
    }
    return _result;
  }
  factory HealthCheckResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HealthCheckResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HealthCheckResponse clone() => HealthCheckResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HealthCheckResponse copyWith(void Function(HealthCheckResponse) updates) => super.copyWith((message) => updates(message as HealthCheckResponse)) as HealthCheckResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HealthCheckResponse create() => HealthCheckResponse._();
  HealthCheckResponse createEmptyInstance() => create();
  static $pb.PbList<HealthCheckResponse> createRepeated() => $pb.PbList<HealthCheckResponse>();
  @$core.pragma('dart2js:noInline')
  static HealthCheckResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HealthCheckResponse>(create);
  static HealthCheckResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.ParticipantCount get participantCount => $_getN(0);
  @$pb.TagNumber(1)
  set participantCount($0.ParticipantCount v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasParticipantCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearParticipantCount() => clearField(1);
  @$pb.TagNumber(1)
  $0.ParticipantCount ensureParticipantCount() => $_ensure(0);
}

class TrackPublished extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrackPublished', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..e<$0.TrackType>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: $0.TrackType.TRACK_TYPE_UNSPECIFIED, valueOf: $0.TrackType.valueOf, enumValues: $0.TrackType.values)
    ..aOM<$0.Participant>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  TrackPublished._() : super();
  factory TrackPublished({
    $core.String? userId,
    $core.String? sessionId,
    $0.TrackType? type,
    $0.Participant? participant,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (type != null) {
      _result.type = type;
    }
    if (participant != null) {
      _result.participant = participant;
    }
    return _result;
  }
  factory TrackPublished.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrackPublished.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrackPublished clone() => TrackPublished()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrackPublished copyWith(void Function(TrackPublished) updates) => super.copyWith((message) => updates(message as TrackPublished)) as TrackPublished; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TrackPublished create() => TrackPublished._();
  TrackPublished createEmptyInstance() => create();
  static $pb.PbList<TrackPublished> createRepeated() => $pb.PbList<TrackPublished>();
  @$core.pragma('dart2js:noInline')
  static TrackPublished getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrackPublished>(create);
  static TrackPublished? _defaultInstance;

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
  $0.TrackType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type($0.TrackType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => clearField(3);

  @$pb.TagNumber(4)
  $0.Participant get participant => $_getN(3);
  @$pb.TagNumber(4)
  set participant($0.Participant v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasParticipant() => $_has(3);
  @$pb.TagNumber(4)
  void clearParticipant() => clearField(4);
  @$pb.TagNumber(4)
  $0.Participant ensureParticipant() => $_ensure(3);
}

class TrackUnpublished extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrackUnpublished', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..e<$0.TrackType>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: $0.TrackType.TRACK_TYPE_UNSPECIFIED, valueOf: $0.TrackType.valueOf, enumValues: $0.TrackType.values)
    ..e<$0.TrackUnpublishReason>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cause', $pb.PbFieldType.OE, defaultOrMaker: $0.TrackUnpublishReason.TRACK_UNPUBLISH_REASON_UNSPECIFIED, valueOf: $0.TrackUnpublishReason.valueOf, enumValues: $0.TrackUnpublishReason.values)
    ..aOM<$0.Participant>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  TrackUnpublished._() : super();
  factory TrackUnpublished({
    $core.String? userId,
    $core.String? sessionId,
    $0.TrackType? type,
    $0.TrackUnpublishReason? cause,
    $0.Participant? participant,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (type != null) {
      _result.type = type;
    }
    if (cause != null) {
      _result.cause = cause;
    }
    if (participant != null) {
      _result.participant = participant;
    }
    return _result;
  }
  factory TrackUnpublished.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrackUnpublished.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrackUnpublished clone() => TrackUnpublished()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrackUnpublished copyWith(void Function(TrackUnpublished) updates) => super.copyWith((message) => updates(message as TrackUnpublished)) as TrackUnpublished; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TrackUnpublished create() => TrackUnpublished._();
  TrackUnpublished createEmptyInstance() => create();
  static $pb.PbList<TrackUnpublished> createRepeated() => $pb.PbList<TrackUnpublished>();
  @$core.pragma('dart2js:noInline')
  static TrackUnpublished getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrackUnpublished>(create);
  static TrackUnpublished? _defaultInstance;

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
  $0.TrackType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type($0.TrackType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => clearField(3);

  @$pb.TagNumber(4)
  $0.TrackUnpublishReason get cause => $_getN(3);
  @$pb.TagNumber(4)
  set cause($0.TrackUnpublishReason v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCause() => $_has(3);
  @$pb.TagNumber(4)
  void clearCause() => clearField(4);

  @$pb.TagNumber(5)
  $0.Participant get participant => $_getN(4);
  @$pb.TagNumber(5)
  set participant($0.Participant v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasParticipant() => $_has(4);
  @$pb.TagNumber(5)
  void clearParticipant() => clearField(5);
  @$pb.TagNumber(5)
  $0.Participant ensureParticipant() => $_ensure(4);
}

class JoinRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscriberSdp')
    ..aOM<$0.ClientDetails>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientDetails', subBuilder: $0.ClientDetails.create)
    ..aOM<Migration>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'migration', subBuilder: Migration.create)
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fastReconnect')
    ..hasRequiredFields = false
  ;

  JoinRequest._() : super();
  factory JoinRequest({
    $core.String? token,
    $core.String? sessionId,
    $core.String? subscriberSdp,
    $0.ClientDetails? clientDetails,
    Migration? migration,
    $core.bool? fastReconnect,
  }) {
    final _result = create();
    if (token != null) {
      _result.token = token;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (subscriberSdp != null) {
      _result.subscriberSdp = subscriberSdp;
    }
    if (clientDetails != null) {
      _result.clientDetails = clientDetails;
    }
    if (migration != null) {
      _result.migration = migration;
    }
    if (fastReconnect != null) {
      _result.fastReconnect = fastReconnect;
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
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get subscriberSdp => $_getSZ(2);
  @$pb.TagNumber(3)
  set subscriberSdp($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSubscriberSdp() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubscriberSdp() => clearField(3);

  @$pb.TagNumber(4)
  $0.ClientDetails get clientDetails => $_getN(3);
  @$pb.TagNumber(4)
  set clientDetails($0.ClientDetails v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasClientDetails() => $_has(3);
  @$pb.TagNumber(4)
  void clearClientDetails() => clearField(4);
  @$pb.TagNumber(4)
  $0.ClientDetails ensureClientDetails() => $_ensure(3);

  @$pb.TagNumber(5)
  Migration get migration => $_getN(4);
  @$pb.TagNumber(5)
  set migration(Migration v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasMigration() => $_has(4);
  @$pb.TagNumber(5)
  void clearMigration() => clearField(5);
  @$pb.TagNumber(5)
  Migration ensureMigration() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get fastReconnect => $_getBF(5);
  @$pb.TagNumber(6)
  set fastReconnect($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasFastReconnect() => $_has(5);
  @$pb.TagNumber(6)
  void clearFastReconnect() => clearField(6);
}

class Migration extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Migration', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fromSfuId')
    ..pc<$0.TrackInfo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'announcedTracks', $pb.PbFieldType.PM, subBuilder: $0.TrackInfo.create)
    ..pc<$1.TrackSubscriptionDetails>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscriptions', $pb.PbFieldType.PM, subBuilder: $1.TrackSubscriptionDetails.create)
    ..hasRequiredFields = false
  ;

  Migration._() : super();
  factory Migration({
    $core.String? fromSfuId,
    $core.Iterable<$0.TrackInfo>? announcedTracks,
    $core.Iterable<$1.TrackSubscriptionDetails>? subscriptions,
  }) {
    final _result = create();
    if (fromSfuId != null) {
      _result.fromSfuId = fromSfuId;
    }
    if (announcedTracks != null) {
      _result.announcedTracks.addAll(announcedTracks);
    }
    if (subscriptions != null) {
      _result.subscriptions.addAll(subscriptions);
    }
    return _result;
  }
  factory Migration.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Migration.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Migration clone() => Migration()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Migration copyWith(void Function(Migration) updates) => super.copyWith((message) => updates(message as Migration)) as Migration; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Migration create() => Migration._();
  Migration createEmptyInstance() => create();
  static $pb.PbList<Migration> createRepeated() => $pb.PbList<Migration>();
  @$core.pragma('dart2js:noInline')
  static Migration getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Migration>(create);
  static Migration? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromSfuId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromSfuId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFromSfuId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromSfuId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$0.TrackInfo> get announcedTracks => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$1.TrackSubscriptionDetails> get subscriptions => $_getList(2);
}

class JoinResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<$0.CallState>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callState', subBuilder: $0.CallState.create)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'reconnected')
    ..hasRequiredFields = false
  ;

  JoinResponse._() : super();
  factory JoinResponse({
    $0.CallState? callState,
    $core.bool? reconnected,
  }) {
    final _result = create();
    if (callState != null) {
      _result.callState = callState;
    }
    if (reconnected != null) {
      _result.reconnected = reconnected;
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
  $0.CallState get callState => $_getN(0);
  @$pb.TagNumber(1)
  set callState($0.CallState v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallState() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallState() => clearField(1);
  @$pb.TagNumber(1)
  $0.CallState ensureCallState() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get reconnected => $_getBF(1);
  @$pb.TagNumber(2)
  set reconnected($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReconnected() => $_has(1);
  @$pb.TagNumber(2)
  void clearReconnected() => clearField(2);
}

class ParticipantJoined extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantJoined', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..aOM<$0.Participant>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantJoined._() : super();
  factory ParticipantJoined({
    $core.String? callCid,
    $0.Participant? participant,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (participant != null) {
      _result.participant = participant;
    }
    return _result;
  }
  factory ParticipantJoined.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParticipantJoined.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParticipantJoined clone() => ParticipantJoined()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParticipantJoined copyWith(void Function(ParticipantJoined) updates) => super.copyWith((message) => updates(message as ParticipantJoined)) as ParticipantJoined; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ParticipantJoined create() => ParticipantJoined._();
  ParticipantJoined createEmptyInstance() => create();
  static $pb.PbList<ParticipantJoined> createRepeated() => $pb.PbList<ParticipantJoined>();
  @$core.pragma('dart2js:noInline')
  static ParticipantJoined getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParticipantJoined>(create);
  static ParticipantJoined? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

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

class ParticipantLeft extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantLeft', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..aOM<$0.Participant>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantLeft._() : super();
  factory ParticipantLeft({
    $core.String? callCid,
    $0.Participant? participant,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (participant != null) {
      _result.participant = participant;
    }
    return _result;
  }
  factory ParticipantLeft.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParticipantLeft.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParticipantLeft clone() => ParticipantLeft()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParticipantLeft copyWith(void Function(ParticipantLeft) updates) => super.copyWith((message) => updates(message as ParticipantLeft)) as ParticipantLeft; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ParticipantLeft create() => ParticipantLeft._();
  ParticipantLeft createEmptyInstance() => create();
  static $pb.PbList<ParticipantLeft> createRepeated() => $pb.PbList<ParticipantLeft>();
  @$core.pragma('dart2js:noInline')
  static ParticipantLeft getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParticipantLeft>(create);
  static ParticipantLeft? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

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

class SubscriberOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SubscriberOffer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iceRestart')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdp')
    ..hasRequiredFields = false
  ;

  SubscriberOffer._() : super();
  factory SubscriberOffer({
    $core.bool? iceRestart,
    $core.String? sdp,
  }) {
    final _result = create();
    if (iceRestart != null) {
      _result.iceRestart = iceRestart;
    }
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
  $core.bool get iceRestart => $_getBF(0);
  @$pb.TagNumber(1)
  set iceRestart($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIceRestart() => $_has(0);
  @$pb.TagNumber(1)
  void clearIceRestart() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sdp => $_getSZ(1);
  @$pb.TagNumber(2)
  set sdp($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSdp() => $_has(1);
  @$pb.TagNumber(2)
  void clearSdp() => clearField(2);
}

class PublisherAnswer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PublisherAnswer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sdp')
    ..hasRequiredFields = false
  ;

  PublisherAnswer._() : super();
  factory PublisherAnswer({
    $core.String? sdp,
  }) {
    final _result = create();
    if (sdp != null) {
      _result.sdp = sdp;
    }
    return _result;
  }
  factory PublisherAnswer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublisherAnswer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PublisherAnswer clone() => PublisherAnswer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PublisherAnswer copyWith(void Function(PublisherAnswer) updates) => super.copyWith((message) => updates(message as PublisherAnswer)) as PublisherAnswer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PublisherAnswer create() => PublisherAnswer._();
  PublisherAnswer createEmptyInstance() => create();
  static $pb.PbList<PublisherAnswer> createRepeated() => $pb.PbList<PublisherAnswer>();
  @$core.pragma('dart2js:noInline')
  static PublisherAnswer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublisherAnswer>(create);
  static PublisherAnswer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sdp => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdp($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSdp() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdp() => clearField(1);
}

class ConnectionQualityChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectionQualityChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..pc<ConnectionQualityInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectionQualityUpdates', $pb.PbFieldType.PM, subBuilder: ConnectionQualityInfo.create)
    ..hasRequiredFields = false
  ;

  ConnectionQualityChanged._() : super();
  factory ConnectionQualityChanged({
    $core.Iterable<ConnectionQualityInfo>? connectionQualityUpdates,
  }) {
    final _result = create();
    if (connectionQualityUpdates != null) {
      _result.connectionQualityUpdates.addAll(connectionQualityUpdates);
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
  $core.List<ConnectionQualityInfo> get connectionQualityUpdates => $_getList(0);
}

class ConnectionQualityInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectionQualityInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..e<$0.ConnectionQuality>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectionQuality', $pb.PbFieldType.OE, defaultOrMaker: $0.ConnectionQuality.CONNECTION_QUALITY_UNSPECIFIED, valueOf: $0.ConnectionQuality.valueOf, enumValues: $0.ConnectionQuality.values)
    ..hasRequiredFields = false
  ;

  ConnectionQualityInfo._() : super();
  factory ConnectionQualityInfo({
    $core.String? userId,
    $core.String? sessionId,
    $0.ConnectionQuality? connectionQuality,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (connectionQuality != null) {
      _result.connectionQuality = connectionQuality;
    }
    return _result;
  }
  factory ConnectionQualityInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectionQualityInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectionQualityInfo clone() => ConnectionQualityInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectionQualityInfo copyWith(void Function(ConnectionQualityInfo) updates) => super.copyWith((message) => updates(message as ConnectionQualityInfo)) as ConnectionQualityInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectionQualityInfo create() => ConnectionQualityInfo._();
  ConnectionQualityInfo createEmptyInstance() => create();
  static $pb.PbList<ConnectionQualityInfo> createRepeated() => $pb.PbList<ConnectionQualityInfo>();
  @$core.pragma('dart2js:noInline')
  static ConnectionQualityInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectionQualityInfo>(create);
  static ConnectionQualityInfo? _defaultInstance;

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
  $0.ConnectionQuality get connectionQuality => $_getN(2);
  @$pb.TagNumber(3)
  set connectionQuality($0.ConnectionQuality v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasConnectionQuality() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnectionQuality() => clearField(3);
}

class DominantSpeakerChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DominantSpeakerChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  DominantSpeakerChanged._() : super();
  factory DominantSpeakerChanged({
    $core.String? userId,
    $core.String? sessionId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
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

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);
}

class AudioLevel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioLevel', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'level', $pb.PbFieldType.OF)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isSpeaking')
    ..hasRequiredFields = false
  ;

  AudioLevel._() : super();
  factory AudioLevel({
    $core.String? userId,
    $core.String? sessionId,
    $core.double? level,
    $core.bool? isSpeaking,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (level != null) {
      _result.level = level;
    }
    if (isSpeaking != null) {
      _result.isSpeaking = isSpeaking;
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
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get level => $_getN(2);
  @$pb.TagNumber(3)
  set level($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLevel() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isSpeaking => $_getBF(3);
  @$pb.TagNumber(4)
  set isSpeaking($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsSpeaking() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsSpeaking() => clearField(4);
}

class AudioLevelChanged extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioLevelChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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

class AudioMediaRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioMediaRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioSender', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<AudioMediaRequest>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mediaRequest', subBuilder: AudioMediaRequest.create)
    ..aOM<$0.Codec>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'codec', subBuilder: $0.Codec.create)
    ..hasRequiredFields = false
  ;

  AudioSender._() : super();
  factory AudioSender({
    AudioMediaRequest? mediaRequest,
    $0.Codec? codec,
  }) {
    final _result = create();
    if (mediaRequest != null) {
      _result.mediaRequest = mediaRequest;
    }
    if (codec != null) {
      _result.codec = codec;
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
}

class VideoMediaRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoMediaRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoLayerSetting', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoSender', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChangePublishQuality', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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

class CallGrantsUpdated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallGrantsUpdated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<$0.CallGrants>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentGrants', subBuilder: $0.CallGrants.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  CallGrantsUpdated._() : super();
  factory CallGrantsUpdated({
    $0.CallGrants? currentGrants,
    $core.String? message,
  }) {
    final _result = create();
    if (currentGrants != null) {
      _result.currentGrants = currentGrants;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory CallGrantsUpdated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallGrantsUpdated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallGrantsUpdated clone() => CallGrantsUpdated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallGrantsUpdated copyWith(void Function(CallGrantsUpdated) updates) => super.copyWith((message) => updates(message as CallGrantsUpdated)) as CallGrantsUpdated; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallGrantsUpdated create() => CallGrantsUpdated._();
  CallGrantsUpdated createEmptyInstance() => create();
  static $pb.PbList<CallGrantsUpdated> createRepeated() => $pb.PbList<CallGrantsUpdated>();
  @$core.pragma('dart2js:noInline')
  static CallGrantsUpdated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallGrantsUpdated>(create);
  static CallGrantsUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CallGrants get currentGrants => $_getN(0);
  @$pb.TagNumber(1)
  set currentGrants($0.CallGrants v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCurrentGrants() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentGrants() => clearField(1);
  @$pb.TagNumber(1)
  $0.CallGrants ensureCurrentGrants() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class GoAway extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GoAway', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..e<$0.GoAwayReason>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'reason', $pb.PbFieldType.OE, defaultOrMaker: $0.GoAwayReason.GO_AWAY_REASON_UNSPECIFIED, valueOf: $0.GoAwayReason.valueOf, enumValues: $0.GoAwayReason.values)
    ..hasRequiredFields = false
  ;

  GoAway._() : super();
  factory GoAway({
    $0.GoAwayReason? reason,
  }) {
    final _result = create();
    if (reason != null) {
      _result.reason = reason;
    }
    return _result;
  }
  factory GoAway.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GoAway.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GoAway clone() => GoAway()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GoAway copyWith(void Function(GoAway) updates) => super.copyWith((message) => updates(message as GoAway)) as GoAway; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GoAway create() => GoAway._();
  GoAway createEmptyInstance() => create();
  static $pb.PbList<GoAway> createRepeated() => $pb.PbList<GoAway>();
  @$core.pragma('dart2js:noInline')
  static GoAway getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GoAway>(create);
  static GoAway? _defaultInstance;

  @$pb.TagNumber(1)
  $0.GoAwayReason get reason => $_getN(0);
  @$pb.TagNumber(1)
  set reason($0.GoAwayReason v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => clearField(1);
}

