//
//  Generated code. Do not modify.
//  source: video/sfu/event/events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../models/models.pb.dart' as $0;
import '../models/models.pbenum.dart' as $0;
import '../signal_rpc/signal.pb.dart' as $1;
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
  callEnded, 
  participantUpdated, 
  participantMigrationComplete, 
  notSet
}

/// SFUEvent is a message that is sent from the SFU to the client.
class SfuEvent extends $pb.GeneratedMessage {
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
    CallEnded? callEnded,
    ParticipantUpdated? participantUpdated,
    ParticipantMigrationComplete? participantMigrationComplete,
  }) {
    final $result = create();
    if (subscriberOffer != null) {
      $result.subscriberOffer = subscriberOffer;
    }
    if (publisherAnswer != null) {
      $result.publisherAnswer = publisherAnswer;
    }
    if (connectionQualityChanged != null) {
      $result.connectionQualityChanged = connectionQualityChanged;
    }
    if (audioLevelChanged != null) {
      $result.audioLevelChanged = audioLevelChanged;
    }
    if (iceTrickle != null) {
      $result.iceTrickle = iceTrickle;
    }
    if (changePublishQuality != null) {
      $result.changePublishQuality = changePublishQuality;
    }
    if (participantJoined != null) {
      $result.participantJoined = participantJoined;
    }
    if (participantLeft != null) {
      $result.participantLeft = participantLeft;
    }
    if (dominantSpeakerChanged != null) {
      $result.dominantSpeakerChanged = dominantSpeakerChanged;
    }
    if (joinResponse != null) {
      $result.joinResponse = joinResponse;
    }
    if (healthCheckResponse != null) {
      $result.healthCheckResponse = healthCheckResponse;
    }
    if (trackPublished != null) {
      $result.trackPublished = trackPublished;
    }
    if (trackUnpublished != null) {
      $result.trackUnpublished = trackUnpublished;
    }
    if (error != null) {
      $result.error = error;
    }
    if (callGrantsUpdated != null) {
      $result.callGrantsUpdated = callGrantsUpdated;
    }
    if (goAway != null) {
      $result.goAway = goAway;
    }
    if (iceRestart != null) {
      $result.iceRestart = iceRestart;
    }
    if (pinsUpdated != null) {
      $result.pinsUpdated = pinsUpdated;
    }
    if (callEnded != null) {
      $result.callEnded = callEnded;
    }
    if (participantUpdated != null) {
      $result.participantUpdated = participantUpdated;
    }
    if (participantMigrationComplete != null) {
      $result.participantMigrationComplete = participantMigrationComplete;
    }
    return $result;
  }
  SfuEvent._() : super();
  factory SfuEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SfuEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

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
    23 : SfuEvent_EventPayload.callEnded,
    24 : SfuEvent_EventPayload.participantUpdated,
    25 : SfuEvent_EventPayload.participantMigrationComplete,
    0 : SfuEvent_EventPayload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SfuEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25])
    ..aOM<SubscriberOffer>(1, _omitFieldNames ? '' : 'subscriberOffer', subBuilder: SubscriberOffer.create)
    ..aOM<PublisherAnswer>(2, _omitFieldNames ? '' : 'publisherAnswer', subBuilder: PublisherAnswer.create)
    ..aOM<ConnectionQualityChanged>(3, _omitFieldNames ? '' : 'connectionQualityChanged', subBuilder: ConnectionQualityChanged.create)
    ..aOM<AudioLevelChanged>(4, _omitFieldNames ? '' : 'audioLevelChanged', subBuilder: AudioLevelChanged.create)
    ..aOM<$0.ICETrickle>(5, _omitFieldNames ? '' : 'iceTrickle', subBuilder: $0.ICETrickle.create)
    ..aOM<ChangePublishQuality>(6, _omitFieldNames ? '' : 'changePublishQuality', subBuilder: ChangePublishQuality.create)
    ..aOM<ParticipantJoined>(10, _omitFieldNames ? '' : 'participantJoined', subBuilder: ParticipantJoined.create)
    ..aOM<ParticipantLeft>(11, _omitFieldNames ? '' : 'participantLeft', subBuilder: ParticipantLeft.create)
    ..aOM<DominantSpeakerChanged>(12, _omitFieldNames ? '' : 'dominantSpeakerChanged', subBuilder: DominantSpeakerChanged.create)
    ..aOM<JoinResponse>(13, _omitFieldNames ? '' : 'joinResponse', subBuilder: JoinResponse.create)
    ..aOM<HealthCheckResponse>(14, _omitFieldNames ? '' : 'healthCheckResponse', subBuilder: HealthCheckResponse.create)
    ..aOM<TrackPublished>(16, _omitFieldNames ? '' : 'trackPublished', subBuilder: TrackPublished.create)
    ..aOM<TrackUnpublished>(17, _omitFieldNames ? '' : 'trackUnpublished', subBuilder: TrackUnpublished.create)
    ..aOM<Error>(18, _omitFieldNames ? '' : 'error', subBuilder: Error.create)
    ..aOM<CallGrantsUpdated>(19, _omitFieldNames ? '' : 'callGrantsUpdated', subBuilder: CallGrantsUpdated.create)
    ..aOM<GoAway>(20, _omitFieldNames ? '' : 'goAway', subBuilder: GoAway.create)
    ..aOM<ICERestart>(21, _omitFieldNames ? '' : 'iceRestart', subBuilder: ICERestart.create)
    ..aOM<PinsChanged>(22, _omitFieldNames ? '' : 'pinsUpdated', subBuilder: PinsChanged.create)
    ..aOM<CallEnded>(23, _omitFieldNames ? '' : 'callEnded', subBuilder: CallEnded.create)
    ..aOM<ParticipantUpdated>(24, _omitFieldNames ? '' : 'participantUpdated', subBuilder: ParticipantUpdated.create)
    ..aOM<ParticipantMigrationComplete>(25, _omitFieldNames ? '' : 'participantMigrationComplete', subBuilder: ParticipantMigrationComplete.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SfuEvent clone() => SfuEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SfuEvent copyWith(void Function(SfuEvent) updates) => super.copyWith((message) => updates(message as SfuEvent)) as SfuEvent;

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

  /// SubscriberOffer sends the SDP offer for establishing the
  /// subscriber PeerConnection.
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

  /// PublisherAnswer sends the SDP answer to the offer sent by
  /// the client for establishing the Publisher PeerConnection.
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

  /// ConnectionQualityChanged is sent to inform the connection
  /// quality of the participants in the call. It does not have
  /// to contain the full list of call participants in it.
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

  /// AudioLevelChanged is sent for change in audio levels of
  /// the participants.
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

  /// ICETrickle contains the ICE candidate required to establish
  /// the ICE transport: part of establishing the PeerConnection
  /// and also for ICE restarts.
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

  /// ChangePublishQuality advises the publisher to switch on/off
  /// various qualities of their video stream based on the subscription.
  /// This is done to save the bandwidth and the CPU of the publisher.
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

  /// ParticipantJoined notifies the client that a new participant
  /// has joined the call. This is not sent for anonymous users.
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

  /// ParticipantLeft notifies the client that a call participant
  /// has left the call. This is not sent for anonymous users.
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

  /// DominantSpeakerChanged notifies the client about the current
  /// dominant speaker. This is required for certain use cases like
  /// the spotlight view.
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

  /// JoinResponse acknowledges a participant successfully joining
  /// the call. This is sent in response to the JoinRequest.
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

  /// HealthCheckResponse is sent in response to the HealthCheckRequest.
  /// It contains the participant count in the call.
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

  /// TrackPublished is sent when a new track (like audio, video, screenshare)
  /// is published by a participant in the call. It is also sent on mute/unmute.
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

  /// TrackUnpublished is sent when a track (like audio, video, screenshare)
  /// is no longer published. It is sent on muting a track or when the participant
  /// is leaving the call.
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

  /// Error is used to communicate any error related to the participant. The
  /// error code and the message explain what went wrong. Whether the participant
  /// can retry is also indicated.
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

  /// CallGrantsUpdated tells what tracks a participant is allowed to publish.
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

  /// GoAway tells the client to migrate away from the SFU it is connected to.
  /// The reason field indicates why this message was sent.
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

  /// ICERestart tells the client to perform ICE restart.
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

  /// PinsChanged is sent the list of pins in the call changes. This event contains the entire list of pins.
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

  /// CallEnded is sent by the SFU to the client to signal that the call has ended.
  /// The reason may specify why the call has ended.
  @$pb.TagNumber(23)
  CallEnded get callEnded => $_getN(18);
  @$pb.TagNumber(23)
  set callEnded(CallEnded v) { setField(23, v); }
  @$pb.TagNumber(23)
  $core.bool hasCallEnded() => $_has(18);
  @$pb.TagNumber(23)
  void clearCallEnded() => clearField(23);
  @$pb.TagNumber(23)
  CallEnded ensureCallEnded() => $_ensure(18);

  /// ParticipantUpdated is sent when user data is updated
  @$pb.TagNumber(24)
  ParticipantUpdated get participantUpdated => $_getN(19);
  @$pb.TagNumber(24)
  set participantUpdated(ParticipantUpdated v) { setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasParticipantUpdated() => $_has(19);
  @$pb.TagNumber(24)
  void clearParticipantUpdated() => clearField(24);
  @$pb.TagNumber(24)
  ParticipantUpdated ensureParticipantUpdated() => $_ensure(19);

  /// ParticipantMigrationComplete is sent when the participant migration is complete
  @$pb.TagNumber(25)
  ParticipantMigrationComplete get participantMigrationComplete => $_getN(20);
  @$pb.TagNumber(25)
  set participantMigrationComplete(ParticipantMigrationComplete v) { setField(25, v); }
  @$pb.TagNumber(25)
  $core.bool hasParticipantMigrationComplete() => $_has(20);
  @$pb.TagNumber(25)
  void clearParticipantMigrationComplete() => clearField(25);
  @$pb.TagNumber(25)
  ParticipantMigrationComplete ensureParticipantMigrationComplete() => $_ensure(20);
}

class ParticipantMigrationComplete extends $pb.GeneratedMessage {
  factory ParticipantMigrationComplete() => create();
  ParticipantMigrationComplete._() : super();
  factory ParticipantMigrationComplete.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParticipantMigrationComplete.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ParticipantMigrationComplete', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParticipantMigrationComplete clone() => ParticipantMigrationComplete()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParticipantMigrationComplete copyWith(void Function(ParticipantMigrationComplete) updates) => super.copyWith((message) => updates(message as ParticipantMigrationComplete)) as ParticipantMigrationComplete;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParticipantMigrationComplete create() => ParticipantMigrationComplete._();
  ParticipantMigrationComplete createEmptyInstance() => create();
  static $pb.PbList<ParticipantMigrationComplete> createRepeated() => $pb.PbList<ParticipantMigrationComplete>();
  @$core.pragma('dart2js:noInline')
  static ParticipantMigrationComplete getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParticipantMigrationComplete>(create);
  static ParticipantMigrationComplete? _defaultInstance;
}

class PinsChanged extends $pb.GeneratedMessage {
  factory PinsChanged({
    $core.Iterable<$0.Pin>? pins,
  }) {
    final $result = create();
    if (pins != null) {
      $result.pins.addAll(pins);
    }
    return $result;
  }
  PinsChanged._() : super();
  factory PinsChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PinsChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PinsChanged', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..pc<$0.Pin>(1, _omitFieldNames ? '' : 'pins', $pb.PbFieldType.PM, subBuilder: $0.Pin.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PinsChanged clone() => PinsChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PinsChanged copyWith(void Function(PinsChanged) updates) => super.copyWith((message) => updates(message as PinsChanged)) as PinsChanged;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PinsChanged create() => PinsChanged._();
  PinsChanged createEmptyInstance() => create();
  static $pb.PbList<PinsChanged> createRepeated() => $pb.PbList<PinsChanged>();
  @$core.pragma('dart2js:noInline')
  static PinsChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PinsChanged>(create);
  static PinsChanged? _defaultInstance;

  /// the list of pins in the call.
  /// Pins are ordered in descending order (most important first).
  @$pb.TagNumber(1)
  $core.List<$0.Pin> get pins => $_getList(0);
}

class Error extends $pb.GeneratedMessage {
  factory Error({
    $0.Error? error,
    $0.WebsocketReconnectStrategy? reconnectStrategy,
  }) {
    final $result = create();
    if (error != null) {
      $result.error = error;
    }
    if (reconnectStrategy != null) {
      $result.reconnectStrategy = reconnectStrategy;
    }
    return $result;
  }
  Error._() : super();
  factory Error.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Error.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Error', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<$0.Error>(4, _omitFieldNames ? '' : 'error', subBuilder: $0.Error.create)
    ..e<$0.WebsocketReconnectStrategy>(5, _omitFieldNames ? '' : 'reconnectStrategy', $pb.PbFieldType.OE, defaultOrMaker: $0.WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_UNSPECIFIED, valueOf: $0.WebsocketReconnectStrategy.valueOf, enumValues: $0.WebsocketReconnectStrategy.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Error clone() => Error()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Error copyWith(void Function(Error) updates) => super.copyWith((message) => updates(message as Error)) as Error;

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

  /// returns the reconnect strategy to be used by the client
  @$pb.TagNumber(5)
  $0.WebsocketReconnectStrategy get reconnectStrategy => $_getN(1);
  @$pb.TagNumber(5)
  set reconnectStrategy($0.WebsocketReconnectStrategy v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasReconnectStrategy() => $_has(1);
  @$pb.TagNumber(5)
  void clearReconnectStrategy() => clearField(5);
}

class ICETrickle extends $pb.GeneratedMessage {
  factory ICETrickle({
    $0.PeerType? peerType,
    $core.String? iceCandidate,
  }) {
    final $result = create();
    if (peerType != null) {
      $result.peerType = peerType;
    }
    if (iceCandidate != null) {
      $result.iceCandidate = iceCandidate;
    }
    return $result;
  }
  ICETrickle._() : super();
  factory ICETrickle.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ICETrickle.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ICETrickle', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..e<$0.PeerType>(1, _omitFieldNames ? '' : 'peerType', $pb.PbFieldType.OE, defaultOrMaker: $0.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED, valueOf: $0.PeerType.valueOf, enumValues: $0.PeerType.values)
    ..aOS(2, _omitFieldNames ? '' : 'iceCandidate')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ICETrickle clone() => ICETrickle()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ICETrickle copyWith(void Function(ICETrickle) updates) => super.copyWith((message) => updates(message as ICETrickle)) as ICETrickle;

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
  factory ICERestart({
    $0.PeerType? peerType,
  }) {
    final $result = create();
    if (peerType != null) {
      $result.peerType = peerType;
    }
    return $result;
  }
  ICERestart._() : super();
  factory ICERestart.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ICERestart.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ICERestart', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..e<$0.PeerType>(1, _omitFieldNames ? '' : 'peerType', $pb.PbFieldType.OE, defaultOrMaker: $0.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED, valueOf: $0.PeerType.valueOf, enumValues: $0.PeerType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ICERestart clone() => ICERestart()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ICERestart copyWith(void Function(ICERestart) updates) => super.copyWith((message) => updates(message as ICERestart)) as ICERestart;

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
  leaveCallRequest, 
  notSet
}

/// SfuRequest is a message that is sent from the client to the SFU.
class SfuRequest extends $pb.GeneratedMessage {
  factory SfuRequest({
    JoinRequest? joinRequest,
    HealthCheckRequest? healthCheckRequest,
    LeaveCallRequest? leaveCallRequest,
  }) {
    final $result = create();
    if (joinRequest != null) {
      $result.joinRequest = joinRequest;
    }
    if (healthCheckRequest != null) {
      $result.healthCheckRequest = healthCheckRequest;
    }
    if (leaveCallRequest != null) {
      $result.leaveCallRequest = leaveCallRequest;
    }
    return $result;
  }
  SfuRequest._() : super();
  factory SfuRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SfuRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, SfuRequest_RequestPayload> _SfuRequest_RequestPayloadByTag = {
    1 : SfuRequest_RequestPayload.joinRequest,
    2 : SfuRequest_RequestPayload.healthCheckRequest,
    3 : SfuRequest_RequestPayload.leaveCallRequest,
    0 : SfuRequest_RequestPayload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SfuRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<JoinRequest>(1, _omitFieldNames ? '' : 'joinRequest', subBuilder: JoinRequest.create)
    ..aOM<HealthCheckRequest>(2, _omitFieldNames ? '' : 'healthCheckRequest', subBuilder: HealthCheckRequest.create)
    ..aOM<LeaveCallRequest>(3, _omitFieldNames ? '' : 'leaveCallRequest', subBuilder: LeaveCallRequest.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SfuRequest clone() => SfuRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SfuRequest copyWith(void Function(SfuRequest) updates) => super.copyWith((message) => updates(message as SfuRequest)) as SfuRequest;

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

  @$pb.TagNumber(3)
  LeaveCallRequest get leaveCallRequest => $_getN(2);
  @$pb.TagNumber(3)
  set leaveCallRequest(LeaveCallRequest v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLeaveCallRequest() => $_has(2);
  @$pb.TagNumber(3)
  void clearLeaveCallRequest() => clearField(3);
  @$pb.TagNumber(3)
  LeaveCallRequest ensureLeaveCallRequest() => $_ensure(2);
}

class LeaveCallRequest extends $pb.GeneratedMessage {
  factory LeaveCallRequest({
    $core.String? sessionId,
    $core.String? reason,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  LeaveCallRequest._() : super();
  factory LeaveCallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LeaveCallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LeaveCallRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LeaveCallRequest clone() => LeaveCallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LeaveCallRequest copyWith(void Function(LeaveCallRequest) updates) => super.copyWith((message) => updates(message as LeaveCallRequest)) as LeaveCallRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaveCallRequest create() => LeaveCallRequest._();
  LeaveCallRequest createEmptyInstance() => create();
  static $pb.PbList<LeaveCallRequest> createRepeated() => $pb.PbList<LeaveCallRequest>();
  @$core.pragma('dart2js:noInline')
  static LeaveCallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaveCallRequest>(create);
  static LeaveCallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => clearField(2);
}

class HealthCheckRequest extends $pb.GeneratedMessage {
  factory HealthCheckRequest() => create();
  HealthCheckRequest._() : super();
  factory HealthCheckRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HealthCheckRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HealthCheckRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HealthCheckRequest clone() => HealthCheckRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HealthCheckRequest copyWith(void Function(HealthCheckRequest) updates) => super.copyWith((message) => updates(message as HealthCheckRequest)) as HealthCheckRequest;

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
  factory HealthCheckResponse({
    $0.ParticipantCount? participantCount,
  }) {
    final $result = create();
    if (participantCount != null) {
      $result.participantCount = participantCount;
    }
    return $result;
  }
  HealthCheckResponse._() : super();
  factory HealthCheckResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HealthCheckResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HealthCheckResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<$0.ParticipantCount>(1, _omitFieldNames ? '' : 'participantCount', subBuilder: $0.ParticipantCount.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HealthCheckResponse clone() => HealthCheckResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HealthCheckResponse copyWith(void Function(HealthCheckResponse) updates) => super.copyWith((message) => updates(message as HealthCheckResponse)) as HealthCheckResponse;

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
  factory TrackPublished({
    $core.String? userId,
    $core.String? sessionId,
    $0.TrackType? type,
    $0.Participant? participant,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (type != null) {
      $result.type = type;
    }
    if (participant != null) {
      $result.participant = participant;
    }
    return $result;
  }
  TrackPublished._() : super();
  factory TrackPublished.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrackPublished.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrackPublished', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..e<$0.TrackType>(3, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: $0.TrackType.TRACK_TYPE_UNSPECIFIED, valueOf: $0.TrackType.valueOf, enumValues: $0.TrackType.values)
    ..aOM<$0.Participant>(4, _omitFieldNames ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrackPublished clone() => TrackPublished()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrackPublished copyWith(void Function(TrackPublished) updates) => super.copyWith((message) => updates(message as TrackPublished)) as TrackPublished;

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

  /// Participant information here is included as an optimisation
  /// for large calls where broadcasting on every participant join
  /// is expensive. You should **NOT** assume that this will always
  /// be available though you can use it to update the participant
  /// list when it is there.
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
  factory TrackUnpublished({
    $core.String? userId,
    $core.String? sessionId,
    $0.TrackType? type,
    $0.TrackUnpublishReason? cause,
    $0.Participant? participant,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (type != null) {
      $result.type = type;
    }
    if (cause != null) {
      $result.cause = cause;
    }
    if (participant != null) {
      $result.participant = participant;
    }
    return $result;
  }
  TrackUnpublished._() : super();
  factory TrackUnpublished.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrackUnpublished.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrackUnpublished', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..e<$0.TrackType>(3, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: $0.TrackType.TRACK_TYPE_UNSPECIFIED, valueOf: $0.TrackType.valueOf, enumValues: $0.TrackType.values)
    ..e<$0.TrackUnpublishReason>(4, _omitFieldNames ? '' : 'cause', $pb.PbFieldType.OE, defaultOrMaker: $0.TrackUnpublishReason.TRACK_UNPUBLISH_REASON_UNSPECIFIED, valueOf: $0.TrackUnpublishReason.valueOf, enumValues: $0.TrackUnpublishReason.values)
    ..aOM<$0.Participant>(5, _omitFieldNames ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrackUnpublished clone() => TrackUnpublished()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrackUnpublished copyWith(void Function(TrackUnpublished) updates) => super.copyWith((message) => updates(message as TrackUnpublished)) as TrackUnpublished;

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

  /// Participant information here is included as an optimisation
  /// for large calls where broadcasting on every participant join
  /// is expensive. You should **NOT** assume that this will always
  /// be available though you can use it to update the participant
  /// list when it is there.
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
  factory JoinRequest({
    $core.String? token,
    $core.String? sessionId,
    $core.String? subscriberSdp,
    $0.ClientDetails? clientDetails,
  @$core.Deprecated('This field is deprecated.')
    Migration? migration,
  @$core.Deprecated('This field is deprecated.')
    $core.bool? fastReconnect,
    ReconnectDetails? reconnectDetails,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (subscriberSdp != null) {
      $result.subscriberSdp = subscriberSdp;
    }
    if (clientDetails != null) {
      $result.clientDetails = clientDetails;
    }
    if (migration != null) {
      // ignore: deprecated_member_use_from_same_package
      $result.migration = migration;
    }
    if (fastReconnect != null) {
      // ignore: deprecated_member_use_from_same_package
      $result.fastReconnect = fastReconnect;
    }
    if (reconnectDetails != null) {
      $result.reconnectDetails = reconnectDetails;
    }
    return $result;
  }
  JoinRequest._() : super();
  factory JoinRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'subscriberSdp')
    ..aOM<$0.ClientDetails>(4, _omitFieldNames ? '' : 'clientDetails', subBuilder: $0.ClientDetails.create)
    ..aOM<Migration>(5, _omitFieldNames ? '' : 'migration', subBuilder: Migration.create)
    ..aOB(6, _omitFieldNames ? '' : 'fastReconnect')
    ..aOM<ReconnectDetails>(7, _omitFieldNames ? '' : 'reconnectDetails', subBuilder: ReconnectDetails.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinRequest clone() => JoinRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinRequest copyWith(void Function(JoinRequest) updates) => super.copyWith((message) => updates(message as JoinRequest)) as JoinRequest;

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

  /// dumb SDP that allow us to extract subscriber's decode codecs
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

  /// Deprecated: use ReconnectDetails instead
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(5)
  Migration get migration => $_getN(4);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(5)
  set migration(Migration v) { setField(5, v); }
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(5)
  $core.bool hasMigration() => $_has(4);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(5)
  void clearMigration() => clearField(5);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(5)
  Migration ensureMigration() => $_ensure(4);

  ///  Fast reconnect flag explicitly indicates that if the participant session
  ///  and the associated state is still present in the SFU, the client is ready
  ///  to restore the PeerConnection with an ICE restart. If the SFU replies with
  ///  "reconnected: true" in its JoinResponse, then it is safe to perform an ICE
  ///  restart or else the existing PeerConnections must be cleaned up.
  ///
  ///  For the SFU, fast_reconnect:false indicates that even if it has the state
  ///  cached, the client state is not in sync and hence it must be cleaned up before
  ///  proceeding further.
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(6)
  $core.bool get fastReconnect => $_getBF(5);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(6)
  set fastReconnect($core.bool v) { $_setBool(5, v); }
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(6)
  $core.bool hasFastReconnect() => $_has(5);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(6)
  void clearFastReconnect() => clearField(6);

  @$pb.TagNumber(7)
  ReconnectDetails get reconnectDetails => $_getN(6);
  @$pb.TagNumber(7)
  set reconnectDetails(ReconnectDetails v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasReconnectDetails() => $_has(6);
  @$pb.TagNumber(7)
  void clearReconnectDetails() => clearField(7);
  @$pb.TagNumber(7)
  ReconnectDetails ensureReconnectDetails() => $_ensure(6);
}

class ReconnectDetails extends $pb.GeneratedMessage {
  factory ReconnectDetails({
    $0.WebsocketReconnectStrategy? strategy,
    $core.Iterable<$0.TrackInfo>? announcedTracks,
    $core.Iterable<$1.TrackSubscriptionDetails>? subscriptions,
    $core.int? reconnectAttempt,
    $core.String? fromSfuId,
    $core.String? previousSessionId,
  }) {
    final $result = create();
    if (strategy != null) {
      $result.strategy = strategy;
    }
    if (announcedTracks != null) {
      $result.announcedTracks.addAll(announcedTracks);
    }
    if (subscriptions != null) {
      $result.subscriptions.addAll(subscriptions);
    }
    if (reconnectAttempt != null) {
      $result.reconnectAttempt = reconnectAttempt;
    }
    if (fromSfuId != null) {
      $result.fromSfuId = fromSfuId;
    }
    if (previousSessionId != null) {
      $result.previousSessionId = previousSessionId;
    }
    return $result;
  }
  ReconnectDetails._() : super();
  factory ReconnectDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReconnectDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReconnectDetails', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..e<$0.WebsocketReconnectStrategy>(1, _omitFieldNames ? '' : 'strategy', $pb.PbFieldType.OE, defaultOrMaker: $0.WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_UNSPECIFIED, valueOf: $0.WebsocketReconnectStrategy.valueOf, enumValues: $0.WebsocketReconnectStrategy.values)
    ..pc<$0.TrackInfo>(3, _omitFieldNames ? '' : 'announcedTracks', $pb.PbFieldType.PM, subBuilder: $0.TrackInfo.create)
    ..pc<$1.TrackSubscriptionDetails>(4, _omitFieldNames ? '' : 'subscriptions', $pb.PbFieldType.PM, subBuilder: $1.TrackSubscriptionDetails.create)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'reconnectAttempt', $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'fromSfuId')
    ..aOS(7, _omitFieldNames ? '' : 'previousSessionId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReconnectDetails clone() => ReconnectDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReconnectDetails copyWith(void Function(ReconnectDetails) updates) => super.copyWith((message) => updates(message as ReconnectDetails)) as ReconnectDetails;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconnectDetails create() => ReconnectDetails._();
  ReconnectDetails createEmptyInstance() => create();
  static $pb.PbList<ReconnectDetails> createRepeated() => $pb.PbList<ReconnectDetails>();
  @$core.pragma('dart2js:noInline')
  static ReconnectDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReconnectDetails>(create);
  static ReconnectDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $0.WebsocketReconnectStrategy get strategy => $_getN(0);
  @$pb.TagNumber(1)
  set strategy($0.WebsocketReconnectStrategy v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStrategy() => $_has(0);
  @$pb.TagNumber(1)
  void clearStrategy() => clearField(1);

  @$pb.TagNumber(3)
  $core.List<$0.TrackInfo> get announcedTracks => $_getList(1);

  @$pb.TagNumber(4)
  $core.List<$1.TrackSubscriptionDetails> get subscriptions => $_getList(2);

  @$pb.TagNumber(5)
  $core.int get reconnectAttempt => $_getIZ(3);
  @$pb.TagNumber(5)
  set reconnectAttempt($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasReconnectAttempt() => $_has(3);
  @$pb.TagNumber(5)
  void clearReconnectAttempt() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get fromSfuId => $_getSZ(4);
  @$pb.TagNumber(6)
  set fromSfuId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasFromSfuId() => $_has(4);
  @$pb.TagNumber(6)
  void clearFromSfuId() => clearField(6);

  /// only set in case of rejoin
  @$pb.TagNumber(7)
  $core.String get previousSessionId => $_getSZ(5);
  @$pb.TagNumber(7)
  set previousSessionId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasPreviousSessionId() => $_has(5);
  @$pb.TagNumber(7)
  void clearPreviousSessionId() => clearField(7);
}

class Migration extends $pb.GeneratedMessage {
  factory Migration({
    $core.String? fromSfuId,
    $core.Iterable<$0.TrackInfo>? announcedTracks,
    $core.Iterable<$1.TrackSubscriptionDetails>? subscriptions,
  }) {
    final $result = create();
    if (fromSfuId != null) {
      $result.fromSfuId = fromSfuId;
    }
    if (announcedTracks != null) {
      $result.announcedTracks.addAll(announcedTracks);
    }
    if (subscriptions != null) {
      $result.subscriptions.addAll(subscriptions);
    }
    return $result;
  }
  Migration._() : super();
  factory Migration.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Migration.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Migration', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromSfuId')
    ..pc<$0.TrackInfo>(2, _omitFieldNames ? '' : 'announcedTracks', $pb.PbFieldType.PM, subBuilder: $0.TrackInfo.create)
    ..pc<$1.TrackSubscriptionDetails>(3, _omitFieldNames ? '' : 'subscriptions', $pb.PbFieldType.PM, subBuilder: $1.TrackSubscriptionDetails.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Migration clone() => Migration()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Migration copyWith(void Function(Migration) updates) => super.copyWith((message) => updates(message as Migration)) as Migration;

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
  factory JoinResponse({
    $0.CallState? callState,
    $core.bool? reconnected,
    $core.int? fastReconnectDeadlineSeconds,
  }) {
    final $result = create();
    if (callState != null) {
      $result.callState = callState;
    }
    if (reconnected != null) {
      $result.reconnected = reconnected;
    }
    if (fastReconnectDeadlineSeconds != null) {
      $result.fastReconnectDeadlineSeconds = fastReconnectDeadlineSeconds;
    }
    return $result;
  }
  JoinResponse._() : super();
  factory JoinResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<$0.CallState>(1, _omitFieldNames ? '' : 'callState', subBuilder: $0.CallState.create)
    ..aOB(2, _omitFieldNames ? '' : 'reconnected')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'fastReconnectDeadlineSeconds', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinResponse clone() => JoinResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinResponse copyWith(void Function(JoinResponse) updates) => super.copyWith((message) => updates(message as JoinResponse)) as JoinResponse;

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

  @$pb.TagNumber(3)
  $core.int get fastReconnectDeadlineSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set fastReconnectDeadlineSeconds($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFastReconnectDeadlineSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearFastReconnectDeadlineSeconds() => clearField(3);
}

/// ParticipantJoined is fired when a user joins a call
class ParticipantJoined extends $pb.GeneratedMessage {
  factory ParticipantJoined({
    $core.String? callCid,
    $0.Participant? participant,
  }) {
    final $result = create();
    if (callCid != null) {
      $result.callCid = callCid;
    }
    if (participant != null) {
      $result.participant = participant;
    }
    return $result;
  }
  ParticipantJoined._() : super();
  factory ParticipantJoined.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParticipantJoined.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ParticipantJoined', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'callCid')
    ..aOM<$0.Participant>(2, _omitFieldNames ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParticipantJoined clone() => ParticipantJoined()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParticipantJoined copyWith(void Function(ParticipantJoined) updates) => super.copyWith((message) => updates(message as ParticipantJoined)) as ParticipantJoined;

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

/// ParticipantJoined is fired when a user leaves a call
class ParticipantLeft extends $pb.GeneratedMessage {
  factory ParticipantLeft({
    $core.String? callCid,
    $0.Participant? participant,
  }) {
    final $result = create();
    if (callCid != null) {
      $result.callCid = callCid;
    }
    if (participant != null) {
      $result.participant = participant;
    }
    return $result;
  }
  ParticipantLeft._() : super();
  factory ParticipantLeft.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParticipantLeft.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ParticipantLeft', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'callCid')
    ..aOM<$0.Participant>(2, _omitFieldNames ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParticipantLeft clone() => ParticipantLeft()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParticipantLeft copyWith(void Function(ParticipantLeft) updates) => super.copyWith((message) => updates(message as ParticipantLeft)) as ParticipantLeft;

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

/// ParticipantUpdated is fired when user data is updated
class ParticipantUpdated extends $pb.GeneratedMessage {
  factory ParticipantUpdated({
    $core.String? callCid,
    $0.Participant? participant,
  }) {
    final $result = create();
    if (callCid != null) {
      $result.callCid = callCid;
    }
    if (participant != null) {
      $result.participant = participant;
    }
    return $result;
  }
  ParticipantUpdated._() : super();
  factory ParticipantUpdated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParticipantUpdated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ParticipantUpdated', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'callCid')
    ..aOM<$0.Participant>(2, _omitFieldNames ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParticipantUpdated clone() => ParticipantUpdated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParticipantUpdated copyWith(void Function(ParticipantUpdated) updates) => super.copyWith((message) => updates(message as ParticipantUpdated)) as ParticipantUpdated;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParticipantUpdated create() => ParticipantUpdated._();
  ParticipantUpdated createEmptyInstance() => create();
  static $pb.PbList<ParticipantUpdated> createRepeated() => $pb.PbList<ParticipantUpdated>();
  @$core.pragma('dart2js:noInline')
  static ParticipantUpdated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParticipantUpdated>(create);
  static ParticipantUpdated? _defaultInstance;

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

/// SubscriberOffer is sent when the SFU adds tracks to a subscription
class SubscriberOffer extends $pb.GeneratedMessage {
  factory SubscriberOffer({
    $core.bool? iceRestart,
    $core.String? sdp,
  }) {
    final $result = create();
    if (iceRestart != null) {
      $result.iceRestart = iceRestart;
    }
    if (sdp != null) {
      $result.sdp = sdp;
    }
    return $result;
  }
  SubscriberOffer._() : super();
  factory SubscriberOffer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubscriberOffer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubscriberOffer', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'iceRestart')
    ..aOS(2, _omitFieldNames ? '' : 'sdp')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubscriberOffer clone() => SubscriberOffer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubscriberOffer copyWith(void Function(SubscriberOffer) updates) => super.copyWith((message) => updates(message as SubscriberOffer)) as SubscriberOffer;

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
  factory PublisherAnswer({
    $core.String? sdp,
  }) {
    final $result = create();
    if (sdp != null) {
      $result.sdp = sdp;
    }
    return $result;
  }
  PublisherAnswer._() : super();
  factory PublisherAnswer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublisherAnswer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PublisherAnswer', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sdp')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PublisherAnswer clone() => PublisherAnswer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PublisherAnswer copyWith(void Function(PublisherAnswer) updates) => super.copyWith((message) => updates(message as PublisherAnswer)) as PublisherAnswer;

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

/// ConnectionQuality is sent to inform about connection quality changes
/// eg. thierry's connection is not good -> render a red icon Zoom style
class ConnectionQualityChanged extends $pb.GeneratedMessage {
  factory ConnectionQualityChanged({
    $core.Iterable<ConnectionQualityInfo>? connectionQualityUpdates,
  }) {
    final $result = create();
    if (connectionQualityUpdates != null) {
      $result.connectionQualityUpdates.addAll(connectionQualityUpdates);
    }
    return $result;
  }
  ConnectionQualityChanged._() : super();
  factory ConnectionQualityChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectionQualityChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConnectionQualityChanged', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..pc<ConnectionQualityInfo>(1, _omitFieldNames ? '' : 'connectionQualityUpdates', $pb.PbFieldType.PM, subBuilder: ConnectionQualityInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectionQualityChanged clone() => ConnectionQualityChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectionQualityChanged copyWith(void Function(ConnectionQualityChanged) updates) => super.copyWith((message) => updates(message as ConnectionQualityChanged)) as ConnectionQualityChanged;

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
  factory ConnectionQualityInfo({
    $core.String? userId,
    $core.String? sessionId,
    $0.ConnectionQuality? connectionQuality,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (connectionQuality != null) {
      $result.connectionQuality = connectionQuality;
    }
    return $result;
  }
  ConnectionQualityInfo._() : super();
  factory ConnectionQualityInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectionQualityInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConnectionQualityInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..e<$0.ConnectionQuality>(3, _omitFieldNames ? '' : 'connectionQuality', $pb.PbFieldType.OE, defaultOrMaker: $0.ConnectionQuality.CONNECTION_QUALITY_UNSPECIFIED, valueOf: $0.ConnectionQuality.valueOf, enumValues: $0.ConnectionQuality.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectionQualityInfo clone() => ConnectionQualityInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectionQualityInfo copyWith(void Function(ConnectionQualityInfo) updates) => super.copyWith((message) => updates(message as ConnectionQualityInfo)) as ConnectionQualityInfo;

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

/// DominantSpeakerChanged is sent by the SFU to notify when there is a new dominant speaker in the call
class DominantSpeakerChanged extends $pb.GeneratedMessage {
  factory DominantSpeakerChanged({
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
  DominantSpeakerChanged._() : super();
  factory DominantSpeakerChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DominantSpeakerChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DominantSpeakerChanged', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DominantSpeakerChanged clone() => DominantSpeakerChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DominantSpeakerChanged copyWith(void Function(DominantSpeakerChanged) updates) => super.copyWith((message) => updates(message as DominantSpeakerChanged)) as DominantSpeakerChanged;

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
  factory AudioLevel({
    $core.String? userId,
    $core.String? sessionId,
    $core.double? level,
    $core.bool? isSpeaking,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (level != null) {
      $result.level = level;
    }
    if (isSpeaking != null) {
      $result.isSpeaking = isSpeaking;
    }
    return $result;
  }
  AudioLevel._() : super();
  factory AudioLevel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioLevel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AudioLevel', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'level', $pb.PbFieldType.OF)
    ..aOB(4, _omitFieldNames ? '' : 'isSpeaking')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioLevel clone() => AudioLevel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioLevel copyWith(void Function(AudioLevel) updates) => super.copyWith((message) => updates(message as AudioLevel)) as AudioLevel;

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

  /// 0.0 means complete silence, 1.0 loudest
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

/// AudioLevelChanged is sent by the SFU to notify about audio levels by user
class AudioLevelChanged extends $pb.GeneratedMessage {
  factory AudioLevelChanged({
    $core.Iterable<AudioLevel>? audioLevels,
  }) {
    final $result = create();
    if (audioLevels != null) {
      $result.audioLevels.addAll(audioLevels);
    }
    return $result;
  }
  AudioLevelChanged._() : super();
  factory AudioLevelChanged.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioLevelChanged.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AudioLevelChanged', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..pc<AudioLevel>(1, _omitFieldNames ? '' : 'audioLevels', $pb.PbFieldType.PM, subBuilder: AudioLevel.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioLevelChanged clone() => AudioLevelChanged()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioLevelChanged copyWith(void Function(AudioLevelChanged) updates) => super.copyWith((message) => updates(message as AudioLevelChanged)) as AudioLevelChanged;

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
  factory AudioMediaRequest({
    $core.int? channelCount,
  }) {
    final $result = create();
    if (channelCount != null) {
      $result.channelCount = channelCount;
    }
    return $result;
  }
  AudioMediaRequest._() : super();
  factory AudioMediaRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioMediaRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AudioMediaRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'channelCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioMediaRequest clone() => AudioMediaRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioMediaRequest copyWith(void Function(AudioMediaRequest) updates) => super.copyWith((message) => updates(message as AudioMediaRequest)) as AudioMediaRequest;

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
  factory AudioSender({
    AudioMediaRequest? mediaRequest,
    $0.Codec? codec,
  }) {
    final $result = create();
    if (mediaRequest != null) {
      $result.mediaRequest = mediaRequest;
    }
    if (codec != null) {
      $result.codec = codec;
    }
    return $result;
  }
  AudioSender._() : super();
  factory AudioSender.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioSender.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AudioSender', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<AudioMediaRequest>(1, _omitFieldNames ? '' : 'mediaRequest', subBuilder: AudioMediaRequest.create)
    ..aOM<$0.Codec>(2, _omitFieldNames ? '' : 'codec', subBuilder: $0.Codec.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioSender clone() => AudioSender()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioSender copyWith(void Function(AudioSender) updates) => super.copyWith((message) => updates(message as AudioSender)) as AudioSender;

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
  factory VideoMediaRequest({
    $core.int? idealHeight,
    $core.int? idealWidth,
    $core.int? idealFrameRate,
  }) {
    final $result = create();
    if (idealHeight != null) {
      $result.idealHeight = idealHeight;
    }
    if (idealWidth != null) {
      $result.idealWidth = idealWidth;
    }
    if (idealFrameRate != null) {
      $result.idealFrameRate = idealFrameRate;
    }
    return $result;
  }
  VideoMediaRequest._() : super();
  factory VideoMediaRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoMediaRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VideoMediaRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'idealHeight', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'idealWidth', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'idealFrameRate', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoMediaRequest clone() => VideoMediaRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoMediaRequest copyWith(void Function(VideoMediaRequest) updates) => super.copyWith((message) => updates(message as VideoMediaRequest)) as VideoMediaRequest;

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

/// VideoLayerSetting is used to specify various parameters of a particular encoding in simulcast.
/// The parameters are specified here - https://developer.mozilla.org/en-US/docs/Web/API/RTCRtpEncodingParameters
/// SDKs use these parameters sent from the server to dynamically adjust these parameters to save CPU, bandwidth
class VideoLayerSetting extends $pb.GeneratedMessage {
  factory VideoLayerSetting({
    $core.String? name,
    $core.bool? active,
    $core.int? maxBitrate,
    $core.double? scaleResolutionDownBy,
    VideoLayerSetting_Priority? priority,
    $0.Codec? codec,
    $core.int? maxFramerate,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (active != null) {
      $result.active = active;
    }
    if (maxBitrate != null) {
      $result.maxBitrate = maxBitrate;
    }
    if (scaleResolutionDownBy != null) {
      $result.scaleResolutionDownBy = scaleResolutionDownBy;
    }
    if (priority != null) {
      $result.priority = priority;
    }
    if (codec != null) {
      $result.codec = codec;
    }
    if (maxFramerate != null) {
      $result.maxFramerate = maxFramerate;
    }
    return $result;
  }
  VideoLayerSetting._() : super();
  factory VideoLayerSetting.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoLayerSetting.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VideoLayerSetting', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOB(2, _omitFieldNames ? '' : 'active')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'maxBitrate', $pb.PbFieldType.O3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'scaleResolutionDownBy', $pb.PbFieldType.OF)
    ..e<VideoLayerSetting_Priority>(5, _omitFieldNames ? '' : 'priority', $pb.PbFieldType.OE, defaultOrMaker: VideoLayerSetting_Priority.PRIORITY_HIGH_UNSPECIFIED, valueOf: VideoLayerSetting_Priority.valueOf, enumValues: VideoLayerSetting_Priority.values)
    ..aOM<$0.Codec>(6, _omitFieldNames ? '' : 'codec', subBuilder: $0.Codec.create)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'maxFramerate', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoLayerSetting clone() => VideoLayerSetting()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoLayerSetting copyWith(void Function(VideoLayerSetting) updates) => super.copyWith((message) => updates(message as VideoLayerSetting)) as VideoLayerSetting;

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

  @$pb.TagNumber(7)
  $core.int get maxFramerate => $_getIZ(6);
  @$pb.TagNumber(7)
  set maxFramerate($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMaxFramerate() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxFramerate() => clearField(7);
}

class VideoSender extends $pb.GeneratedMessage {
  factory VideoSender({
    VideoMediaRequest? mediaRequest,
    $0.Codec? codec,
    $core.Iterable<VideoLayerSetting>? layers,
  }) {
    final $result = create();
    if (mediaRequest != null) {
      $result.mediaRequest = mediaRequest;
    }
    if (codec != null) {
      $result.codec = codec;
    }
    if (layers != null) {
      $result.layers.addAll(layers);
    }
    return $result;
  }
  VideoSender._() : super();
  factory VideoSender.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoSender.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VideoSender', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<VideoMediaRequest>(1, _omitFieldNames ? '' : 'mediaRequest', subBuilder: VideoMediaRequest.create)
    ..aOM<$0.Codec>(2, _omitFieldNames ? '' : 'codec', subBuilder: $0.Codec.create)
    ..pc<VideoLayerSetting>(3, _omitFieldNames ? '' : 'layers', $pb.PbFieldType.PM, subBuilder: VideoLayerSetting.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoSender clone() => VideoSender()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoSender copyWith(void Function(VideoSender) updates) => super.copyWith((message) => updates(message as VideoSender)) as VideoSender;

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

/// sent to users when they need to change the quality of their video
class ChangePublishQuality extends $pb.GeneratedMessage {
  factory ChangePublishQuality({
    $core.Iterable<AudioSender>? audioSenders,
    $core.Iterable<VideoSender>? videoSenders,
  }) {
    final $result = create();
    if (audioSenders != null) {
      $result.audioSenders.addAll(audioSenders);
    }
    if (videoSenders != null) {
      $result.videoSenders.addAll(videoSenders);
    }
    return $result;
  }
  ChangePublishQuality._() : super();
  factory ChangePublishQuality.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChangePublishQuality.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChangePublishQuality', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..pc<AudioSender>(1, _omitFieldNames ? '' : 'audioSenders', $pb.PbFieldType.PM, subBuilder: AudioSender.create)
    ..pc<VideoSender>(2, _omitFieldNames ? '' : 'videoSenders', $pb.PbFieldType.PM, subBuilder: VideoSender.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChangePublishQuality clone() => ChangePublishQuality()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChangePublishQuality copyWith(void Function(ChangePublishQuality) updates) => super.copyWith((message) => updates(message as ChangePublishQuality)) as ChangePublishQuality;

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

///  CallGrants is sent to users when there is a change in the call permissions
///  to publish audio, video or share the screen for a user or a role. This is
///  idempotent and can be sent at any time. Only the current_grants in the latest
///  message should be considered. In other words, this is not dependent on any
///  other message (including previous call_grants_updated message)
///
///  When this message is received, the client (say, React component) should mute
///  the tracks which are not allowed anymore. For example, if the message has
///  grants {audio:true, video:false} while the user is publishing video, then the
///  client component should mute the video track and gray out the video button.
///  This way, the user will not be able to publish video until the permissions
///  are granted again. Also, muting the track on the client side will prevent
///  the SFU from receiving the video track and will save bandwidth.
///
///  In simple words, this is exactly the same as muting a track on the client.
///  Here, instead of the user instructing the client, SFU would be doing it.
class CallGrantsUpdated extends $pb.GeneratedMessage {
  factory CallGrantsUpdated({
    $0.CallGrants? currentGrants,
    $core.String? message,
  }) {
    final $result = create();
    if (currentGrants != null) {
      $result.currentGrants = currentGrants;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  CallGrantsUpdated._() : super();
  factory CallGrantsUpdated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallGrantsUpdated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CallGrantsUpdated', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<$0.CallGrants>(1, _omitFieldNames ? '' : 'currentGrants', subBuilder: $0.CallGrants.create)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallGrantsUpdated clone() => CallGrantsUpdated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallGrantsUpdated copyWith(void Function(CallGrantsUpdated) updates) => super.copyWith((message) => updates(message as CallGrantsUpdated)) as CallGrantsUpdated;

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

/// Go away is sent by the SFU to the client to signal to migrate away from the SFU.
/// The evict reason may specify why the user is being evicted.
class GoAway extends $pb.GeneratedMessage {
  factory GoAway({
    $0.GoAwayReason? reason,
  }) {
    final $result = create();
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  GoAway._() : super();
  factory GoAway.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GoAway.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GoAway', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..e<$0.GoAwayReason>(1, _omitFieldNames ? '' : 'reason', $pb.PbFieldType.OE, defaultOrMaker: $0.GoAwayReason.GO_AWAY_REASON_UNSPECIFIED, valueOf: $0.GoAwayReason.valueOf, enumValues: $0.GoAwayReason.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GoAway clone() => GoAway()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GoAway copyWith(void Function(GoAway) updates) => super.copyWith((message) => updates(message as GoAway)) as GoAway;

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

/// CallEnded is sent by the SFU to the client to signal that the call has ended.
/// The reason may specify why the call has ended.
class CallEnded extends $pb.GeneratedMessage {
  factory CallEnded({
    $0.CallEndedReason? reason,
  }) {
    final $result = create();
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  CallEnded._() : super();
  factory CallEnded.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallEnded.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CallEnded', package: const $pb.PackageName(_omitMessageNames ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..e<$0.CallEndedReason>(1, _omitFieldNames ? '' : 'reason', $pb.PbFieldType.OE, defaultOrMaker: $0.CallEndedReason.CALL_ENDED_REASON_UNSPECIFIED, valueOf: $0.CallEndedReason.valueOf, enumValues: $0.CallEndedReason.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallEnded clone() => CallEnded()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallEnded copyWith(void Function(CallEnded) updates) => super.copyWith((message) => updates(message as CallEnded)) as CallEnded;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CallEnded create() => CallEnded._();
  CallEnded createEmptyInstance() => create();
  static $pb.PbList<CallEnded> createRepeated() => $pb.PbList<CallEnded>();
  @$core.pragma('dart2js:noInline')
  static CallEnded getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallEnded>(create);
  static CallEnded? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CallEndedReason get reason => $_getN(0);
  @$pb.TagNumber(1)
  set reason($0.CallEndedReason v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
