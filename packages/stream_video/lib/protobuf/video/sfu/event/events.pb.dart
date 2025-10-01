// This is a generated file - do not edit.
//
// Generated from video/sfu/event/events.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../models/models.pb.dart' as $0;
import '../signal_rpc/signal.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

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
  changePublishOptions,
  inboundStateNotification,
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
    ChangePublishOptions? changePublishOptions,
    InboundStateNotification? inboundStateNotification,
  }) {
    final result = create();
    if (subscriberOffer != null) result.subscriberOffer = subscriberOffer;
    if (publisherAnswer != null) result.publisherAnswer = publisherAnswer;
    if (connectionQualityChanged != null)
      result.connectionQualityChanged = connectionQualityChanged;
    if (audioLevelChanged != null) result.audioLevelChanged = audioLevelChanged;
    if (iceTrickle != null) result.iceTrickle = iceTrickle;
    if (changePublishQuality != null)
      result.changePublishQuality = changePublishQuality;
    if (participantJoined != null) result.participantJoined = participantJoined;
    if (participantLeft != null) result.participantLeft = participantLeft;
    if (dominantSpeakerChanged != null)
      result.dominantSpeakerChanged = dominantSpeakerChanged;
    if (joinResponse != null) result.joinResponse = joinResponse;
    if (healthCheckResponse != null)
      result.healthCheckResponse = healthCheckResponse;
    if (trackPublished != null) result.trackPublished = trackPublished;
    if (trackUnpublished != null) result.trackUnpublished = trackUnpublished;
    if (error != null) result.error = error;
    if (callGrantsUpdated != null) result.callGrantsUpdated = callGrantsUpdated;
    if (goAway != null) result.goAway = goAway;
    if (iceRestart != null) result.iceRestart = iceRestart;
    if (pinsUpdated != null) result.pinsUpdated = pinsUpdated;
    if (callEnded != null) result.callEnded = callEnded;
    if (participantUpdated != null)
      result.participantUpdated = participantUpdated;
    if (participantMigrationComplete != null)
      result.participantMigrationComplete = participantMigrationComplete;
    if (changePublishOptions != null)
      result.changePublishOptions = changePublishOptions;
    if (inboundStateNotification != null)
      result.inboundStateNotification = inboundStateNotification;
    return result;
  }

  SfuEvent._();

  factory SfuEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SfuEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SfuEvent_EventPayload>
      _SfuEvent_EventPayloadByTag = {
    1: SfuEvent_EventPayload.subscriberOffer,
    2: SfuEvent_EventPayload.publisherAnswer,
    3: SfuEvent_EventPayload.connectionQualityChanged,
    4: SfuEvent_EventPayload.audioLevelChanged,
    5: SfuEvent_EventPayload.iceTrickle,
    6: SfuEvent_EventPayload.changePublishQuality,
    10: SfuEvent_EventPayload.participantJoined,
    11: SfuEvent_EventPayload.participantLeft,
    12: SfuEvent_EventPayload.dominantSpeakerChanged,
    13: SfuEvent_EventPayload.joinResponse,
    14: SfuEvent_EventPayload.healthCheckResponse,
    16: SfuEvent_EventPayload.trackPublished,
    17: SfuEvent_EventPayload.trackUnpublished,
    18: SfuEvent_EventPayload.error,
    19: SfuEvent_EventPayload.callGrantsUpdated,
    20: SfuEvent_EventPayload.goAway,
    21: SfuEvent_EventPayload.iceRestart,
    22: SfuEvent_EventPayload.pinsUpdated,
    23: SfuEvent_EventPayload.callEnded,
    24: SfuEvent_EventPayload.participantUpdated,
    25: SfuEvent_EventPayload.participantMigrationComplete,
    27: SfuEvent_EventPayload.changePublishOptions,
    28: SfuEvent_EventPayload.inboundStateNotification,
    0: SfuEvent_EventPayload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SfuEvent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..oo(0, [
      1,
      2,
      3,
      4,
      5,
      6,
      10,
      11,
      12,
      13,
      14,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      27,
      28
    ])
    ..aOM<SubscriberOffer>(1, _omitFieldNames ? '' : 'subscriberOffer',
        subBuilder: SubscriberOffer.create)
    ..aOM<PublisherAnswer>(2, _omitFieldNames ? '' : 'publisherAnswer',
        subBuilder: PublisherAnswer.create)
    ..aOM<ConnectionQualityChanged>(
        3, _omitFieldNames ? '' : 'connectionQualityChanged',
        subBuilder: ConnectionQualityChanged.create)
    ..aOM<AudioLevelChanged>(4, _omitFieldNames ? '' : 'audioLevelChanged',
        subBuilder: AudioLevelChanged.create)
    ..aOM<$0.ICETrickle>(5, _omitFieldNames ? '' : 'iceTrickle',
        subBuilder: $0.ICETrickle.create)
    ..aOM<ChangePublishQuality>(
        6, _omitFieldNames ? '' : 'changePublishQuality',
        subBuilder: ChangePublishQuality.create)
    ..aOM<ParticipantJoined>(10, _omitFieldNames ? '' : 'participantJoined',
        subBuilder: ParticipantJoined.create)
    ..aOM<ParticipantLeft>(11, _omitFieldNames ? '' : 'participantLeft',
        subBuilder: ParticipantLeft.create)
    ..aOM<DominantSpeakerChanged>(
        12, _omitFieldNames ? '' : 'dominantSpeakerChanged',
        subBuilder: DominantSpeakerChanged.create)
    ..aOM<JoinResponse>(13, _omitFieldNames ? '' : 'joinResponse',
        subBuilder: JoinResponse.create)
    ..aOM<HealthCheckResponse>(14, _omitFieldNames ? '' : 'healthCheckResponse',
        subBuilder: HealthCheckResponse.create)
    ..aOM<TrackPublished>(16, _omitFieldNames ? '' : 'trackPublished',
        subBuilder: TrackPublished.create)
    ..aOM<TrackUnpublished>(17, _omitFieldNames ? '' : 'trackUnpublished',
        subBuilder: TrackUnpublished.create)
    ..aOM<Error>(18, _omitFieldNames ? '' : 'error', subBuilder: Error.create)
    ..aOM<CallGrantsUpdated>(19, _omitFieldNames ? '' : 'callGrantsUpdated',
        subBuilder: CallGrantsUpdated.create)
    ..aOM<GoAway>(20, _omitFieldNames ? '' : 'goAway',
        subBuilder: GoAway.create)
    ..aOM<ICERestart>(21, _omitFieldNames ? '' : 'iceRestart',
        subBuilder: ICERestart.create)
    ..aOM<PinsChanged>(22, _omitFieldNames ? '' : 'pinsUpdated',
        subBuilder: PinsChanged.create)
    ..aOM<CallEnded>(23, _omitFieldNames ? '' : 'callEnded',
        subBuilder: CallEnded.create)
    ..aOM<ParticipantUpdated>(24, _omitFieldNames ? '' : 'participantUpdated',
        subBuilder: ParticipantUpdated.create)
    ..aOM<ParticipantMigrationComplete>(
        25, _omitFieldNames ? '' : 'participantMigrationComplete',
        subBuilder: ParticipantMigrationComplete.create)
    ..aOM<ChangePublishOptions>(
        27, _omitFieldNames ? '' : 'changePublishOptions',
        subBuilder: ChangePublishOptions.create)
    ..aOM<InboundStateNotification>(
        28, _omitFieldNames ? '' : 'inboundStateNotification',
        subBuilder: InboundStateNotification.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SfuEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SfuEvent copyWith(void Function(SfuEvent) updates) =>
      super.copyWith((message) => updates(message as SfuEvent)) as SfuEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SfuEvent create() => SfuEvent._();
  @$core.override
  SfuEvent createEmptyInstance() => create();
  static $pb.PbList<SfuEvent> createRepeated() => $pb.PbList<SfuEvent>();
  @$core.pragma('dart2js:noInline')
  static SfuEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SfuEvent>(create);
  static SfuEvent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  SfuEvent_EventPayload whichEventPayload() =>
      _SfuEvent_EventPayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  void clearEventPayload() => $_clearField($_whichOneof(0));

  /// SubscriberOffer sends the SDP offer for establishing the
  /// subscriber PeerConnection.
  @$pb.TagNumber(1)
  SubscriberOffer get subscriberOffer => $_getN(0);
  @$pb.TagNumber(1)
  set subscriberOffer(SubscriberOffer value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubscriberOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscriberOffer() => $_clearField(1);
  @$pb.TagNumber(1)
  SubscriberOffer ensureSubscriberOffer() => $_ensure(0);

  /// PublisherAnswer sends the SDP answer to the offer sent by
  /// the client for establishing the Publisher PeerConnection.
  @$pb.TagNumber(2)
  PublisherAnswer get publisherAnswer => $_getN(1);
  @$pb.TagNumber(2)
  set publisherAnswer(PublisherAnswer value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPublisherAnswer() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublisherAnswer() => $_clearField(2);
  @$pb.TagNumber(2)
  PublisherAnswer ensurePublisherAnswer() => $_ensure(1);

  /// ConnectionQualityChanged is sent to inform the connection
  /// quality of the participants in the call. It does not have
  /// to contain the full list of call participants in it.
  @$pb.TagNumber(3)
  ConnectionQualityChanged get connectionQualityChanged => $_getN(2);
  @$pb.TagNumber(3)
  set connectionQualityChanged(ConnectionQualityChanged value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasConnectionQualityChanged() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnectionQualityChanged() => $_clearField(3);
  @$pb.TagNumber(3)
  ConnectionQualityChanged ensureConnectionQualityChanged() => $_ensure(2);

  /// AudioLevelChanged is sent for change in audio levels of
  /// the participants.
  @$pb.TagNumber(4)
  AudioLevelChanged get audioLevelChanged => $_getN(3);
  @$pb.TagNumber(4)
  set audioLevelChanged(AudioLevelChanged value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAudioLevelChanged() => $_has(3);
  @$pb.TagNumber(4)
  void clearAudioLevelChanged() => $_clearField(4);
  @$pb.TagNumber(4)
  AudioLevelChanged ensureAudioLevelChanged() => $_ensure(3);

  /// ICETrickle contains the ICE candidate required to establish
  /// the ICE transport: part of establishing the PeerConnection
  /// and also for ICE restarts.
  @$pb.TagNumber(5)
  $0.ICETrickle get iceTrickle => $_getN(4);
  @$pb.TagNumber(5)
  set iceTrickle($0.ICETrickle value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasIceTrickle() => $_has(4);
  @$pb.TagNumber(5)
  void clearIceTrickle() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.ICETrickle ensureIceTrickle() => $_ensure(4);

  /// ChangePublishQuality advises the publisher to switch on/off
  /// various qualities of their video stream based on the subscription.
  /// This is done to save the bandwidth and the CPU of the publisher.
  @$pb.TagNumber(6)
  ChangePublishQuality get changePublishQuality => $_getN(5);
  @$pb.TagNumber(6)
  set changePublishQuality(ChangePublishQuality value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasChangePublishQuality() => $_has(5);
  @$pb.TagNumber(6)
  void clearChangePublishQuality() => $_clearField(6);
  @$pb.TagNumber(6)
  ChangePublishQuality ensureChangePublishQuality() => $_ensure(5);

  /// ParticipantJoined notifies the client that a new participant
  /// has joined the call. This is not sent for anonymous users.
  @$pb.TagNumber(10)
  ParticipantJoined get participantJoined => $_getN(6);
  @$pb.TagNumber(10)
  set participantJoined(ParticipantJoined value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasParticipantJoined() => $_has(6);
  @$pb.TagNumber(10)
  void clearParticipantJoined() => $_clearField(10);
  @$pb.TagNumber(10)
  ParticipantJoined ensureParticipantJoined() => $_ensure(6);

  /// ParticipantLeft notifies the client that a call participant
  /// has left the call. This is not sent for anonymous users.
  @$pb.TagNumber(11)
  ParticipantLeft get participantLeft => $_getN(7);
  @$pb.TagNumber(11)
  set participantLeft(ParticipantLeft value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasParticipantLeft() => $_has(7);
  @$pb.TagNumber(11)
  void clearParticipantLeft() => $_clearField(11);
  @$pb.TagNumber(11)
  ParticipantLeft ensureParticipantLeft() => $_ensure(7);

  /// DominantSpeakerChanged notifies the client about the current
  /// dominant speaker. This is required for certain use cases like
  /// the spotlight view.
  @$pb.TagNumber(12)
  DominantSpeakerChanged get dominantSpeakerChanged => $_getN(8);
  @$pb.TagNumber(12)
  set dominantSpeakerChanged(DominantSpeakerChanged value) =>
      $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDominantSpeakerChanged() => $_has(8);
  @$pb.TagNumber(12)
  void clearDominantSpeakerChanged() => $_clearField(12);
  @$pb.TagNumber(12)
  DominantSpeakerChanged ensureDominantSpeakerChanged() => $_ensure(8);

  /// JoinResponse acknowledges a participant successfully joining
  /// the call. This is sent in response to the JoinRequest.
  @$pb.TagNumber(13)
  JoinResponse get joinResponse => $_getN(9);
  @$pb.TagNumber(13)
  set joinResponse(JoinResponse value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasJoinResponse() => $_has(9);
  @$pb.TagNumber(13)
  void clearJoinResponse() => $_clearField(13);
  @$pb.TagNumber(13)
  JoinResponse ensureJoinResponse() => $_ensure(9);

  /// HealthCheckResponse is sent in response to the HealthCheckRequest.
  /// It contains the participant count in the call.
  @$pb.TagNumber(14)
  HealthCheckResponse get healthCheckResponse => $_getN(10);
  @$pb.TagNumber(14)
  set healthCheckResponse(HealthCheckResponse value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasHealthCheckResponse() => $_has(10);
  @$pb.TagNumber(14)
  void clearHealthCheckResponse() => $_clearField(14);
  @$pb.TagNumber(14)
  HealthCheckResponse ensureHealthCheckResponse() => $_ensure(10);

  /// TrackPublished is sent when a new track (like audio, video, screenshare)
  /// is published by a participant in the call. It is also sent on mute/unmute.
  @$pb.TagNumber(16)
  TrackPublished get trackPublished => $_getN(11);
  @$pb.TagNumber(16)
  set trackPublished(TrackPublished value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasTrackPublished() => $_has(11);
  @$pb.TagNumber(16)
  void clearTrackPublished() => $_clearField(16);
  @$pb.TagNumber(16)
  TrackPublished ensureTrackPublished() => $_ensure(11);

  /// TrackUnpublished is sent when a track (like audio, video, screenshare)
  /// is no longer published. It is sent on muting a track or when the participant
  /// is leaving the call.
  @$pb.TagNumber(17)
  TrackUnpublished get trackUnpublished => $_getN(12);
  @$pb.TagNumber(17)
  set trackUnpublished(TrackUnpublished value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasTrackUnpublished() => $_has(12);
  @$pb.TagNumber(17)
  void clearTrackUnpublished() => $_clearField(17);
  @$pb.TagNumber(17)
  TrackUnpublished ensureTrackUnpublished() => $_ensure(12);

  /// Error is used to communicate any error related to the participant. The
  /// error code and the message explain what went wrong. Whether the participant
  /// can retry is also indicated.
  @$pb.TagNumber(18)
  Error get error => $_getN(13);
  @$pb.TagNumber(18)
  set error(Error value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasError() => $_has(13);
  @$pb.TagNumber(18)
  void clearError() => $_clearField(18);
  @$pb.TagNumber(18)
  Error ensureError() => $_ensure(13);

  /// CallGrantsUpdated tells what tracks a participant is allowed to publish.
  @$pb.TagNumber(19)
  CallGrantsUpdated get callGrantsUpdated => $_getN(14);
  @$pb.TagNumber(19)
  set callGrantsUpdated(CallGrantsUpdated value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasCallGrantsUpdated() => $_has(14);
  @$pb.TagNumber(19)
  void clearCallGrantsUpdated() => $_clearField(19);
  @$pb.TagNumber(19)
  CallGrantsUpdated ensureCallGrantsUpdated() => $_ensure(14);

  /// GoAway tells the client to migrate away from the SFU it is connected to.
  /// The reason field indicates why this message was sent.
  @$pb.TagNumber(20)
  GoAway get goAway => $_getN(15);
  @$pb.TagNumber(20)
  set goAway(GoAway value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasGoAway() => $_has(15);
  @$pb.TagNumber(20)
  void clearGoAway() => $_clearField(20);
  @$pb.TagNumber(20)
  GoAway ensureGoAway() => $_ensure(15);

  /// ICERestart tells the client to perform ICE restart.
  @$pb.TagNumber(21)
  ICERestart get iceRestart => $_getN(16);
  @$pb.TagNumber(21)
  set iceRestart(ICERestart value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasIceRestart() => $_has(16);
  @$pb.TagNumber(21)
  void clearIceRestart() => $_clearField(21);
  @$pb.TagNumber(21)
  ICERestart ensureIceRestart() => $_ensure(16);

  /// PinsChanged is sent the list of pins in the call changes. This event contains the entire list of pins.
  @$pb.TagNumber(22)
  PinsChanged get pinsUpdated => $_getN(17);
  @$pb.TagNumber(22)
  set pinsUpdated(PinsChanged value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasPinsUpdated() => $_has(17);
  @$pb.TagNumber(22)
  void clearPinsUpdated() => $_clearField(22);
  @$pb.TagNumber(22)
  PinsChanged ensurePinsUpdated() => $_ensure(17);

  /// CallEnded is sent by the SFU to the client to signal that the call has ended.
  /// The reason may specify why the call has ended.
  @$pb.TagNumber(23)
  CallEnded get callEnded => $_getN(18);
  @$pb.TagNumber(23)
  set callEnded(CallEnded value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasCallEnded() => $_has(18);
  @$pb.TagNumber(23)
  void clearCallEnded() => $_clearField(23);
  @$pb.TagNumber(23)
  CallEnded ensureCallEnded() => $_ensure(18);

  /// ParticipantUpdated is sent when user data is updated
  @$pb.TagNumber(24)
  ParticipantUpdated get participantUpdated => $_getN(19);
  @$pb.TagNumber(24)
  set participantUpdated(ParticipantUpdated value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasParticipantUpdated() => $_has(19);
  @$pb.TagNumber(24)
  void clearParticipantUpdated() => $_clearField(24);
  @$pb.TagNumber(24)
  ParticipantUpdated ensureParticipantUpdated() => $_ensure(19);

  /// ParticipantMigrationComplete is sent when the participant migration is complete
  @$pb.TagNumber(25)
  ParticipantMigrationComplete get participantMigrationComplete => $_getN(20);
  @$pb.TagNumber(25)
  set participantMigrationComplete(ParticipantMigrationComplete value) =>
      $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasParticipantMigrationComplete() => $_has(20);
  @$pb.TagNumber(25)
  void clearParticipantMigrationComplete() => $_clearField(25);
  @$pb.TagNumber(25)
  ParticipantMigrationComplete ensureParticipantMigrationComplete() =>
      $_ensure(20);

  /// ChangePublishOptions is sent to signal the change in publish options such as a new codec or simulcast layers
  @$pb.TagNumber(27)
  ChangePublishOptions get changePublishOptions => $_getN(21);
  @$pb.TagNumber(27)
  set changePublishOptions(ChangePublishOptions value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasChangePublishOptions() => $_has(21);
  @$pb.TagNumber(27)
  void clearChangePublishOptions() => $_clearField(27);
  @$pb.TagNumber(27)
  ChangePublishOptions ensureChangePublishOptions() => $_ensure(21);

  /// InboundStateNotification
  @$pb.TagNumber(28)
  InboundStateNotification get inboundStateNotification => $_getN(22);
  @$pb.TagNumber(28)
  set inboundStateNotification(InboundStateNotification value) =>
      $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasInboundStateNotification() => $_has(22);
  @$pb.TagNumber(28)
  void clearInboundStateNotification() => $_clearField(28);
  @$pb.TagNumber(28)
  InboundStateNotification ensureInboundStateNotification() => $_ensure(22);
}

class ChangePublishOptions extends $pb.GeneratedMessage {
  factory ChangePublishOptions({
    $core.Iterable<$0.PublishOption>? publishOptions,
    $core.String? reason,
  }) {
    final result = create();
    if (publishOptions != null) result.publishOptions.addAll(publishOptions);
    if (reason != null) result.reason = reason;
    return result;
  }

  ChangePublishOptions._();

  factory ChangePublishOptions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangePublishOptions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangePublishOptions',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..pPM<$0.PublishOption>(1, _omitFieldNames ? '' : 'publishOptions',
        subBuilder: $0.PublishOption.create)
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePublishOptions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePublishOptions copyWith(void Function(ChangePublishOptions) updates) =>
      super.copyWith((message) => updates(message as ChangePublishOptions))
          as ChangePublishOptions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangePublishOptions create() => ChangePublishOptions._();
  @$core.override
  ChangePublishOptions createEmptyInstance() => create();
  static $pb.PbList<ChangePublishOptions> createRepeated() =>
      $pb.PbList<ChangePublishOptions>();
  @$core.pragma('dart2js:noInline')
  static ChangePublishOptions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangePublishOptions>(create);
  static ChangePublishOptions? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.PublishOption> get publishOptions => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class ChangePublishOptionsComplete extends $pb.GeneratedMessage {
  factory ChangePublishOptionsComplete() => create();

  ChangePublishOptionsComplete._();

  factory ChangePublishOptionsComplete.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangePublishOptionsComplete.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangePublishOptionsComplete',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePublishOptionsComplete clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePublishOptionsComplete copyWith(
          void Function(ChangePublishOptionsComplete) updates) =>
      super.copyWith(
              (message) => updates(message as ChangePublishOptionsComplete))
          as ChangePublishOptionsComplete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangePublishOptionsComplete create() =>
      ChangePublishOptionsComplete._();
  @$core.override
  ChangePublishOptionsComplete createEmptyInstance() => create();
  static $pb.PbList<ChangePublishOptionsComplete> createRepeated() =>
      $pb.PbList<ChangePublishOptionsComplete>();
  @$core.pragma('dart2js:noInline')
  static ChangePublishOptionsComplete getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangePublishOptionsComplete>(create);
  static ChangePublishOptionsComplete? _defaultInstance;
}

class ParticipantMigrationComplete extends $pb.GeneratedMessage {
  factory ParticipantMigrationComplete() => create();

  ParticipantMigrationComplete._();

  factory ParticipantMigrationComplete.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParticipantMigrationComplete.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParticipantMigrationComplete',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParticipantMigrationComplete clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParticipantMigrationComplete copyWith(
          void Function(ParticipantMigrationComplete) updates) =>
      super.copyWith(
              (message) => updates(message as ParticipantMigrationComplete))
          as ParticipantMigrationComplete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParticipantMigrationComplete create() =>
      ParticipantMigrationComplete._();
  @$core.override
  ParticipantMigrationComplete createEmptyInstance() => create();
  static $pb.PbList<ParticipantMigrationComplete> createRepeated() =>
      $pb.PbList<ParticipantMigrationComplete>();
  @$core.pragma('dart2js:noInline')
  static ParticipantMigrationComplete getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParticipantMigrationComplete>(create);
  static ParticipantMigrationComplete? _defaultInstance;
}

class PinsChanged extends $pb.GeneratedMessage {
  factory PinsChanged({
    $core.Iterable<$0.Pin>? pins,
  }) {
    final result = create();
    if (pins != null) result.pins.addAll(pins);
    return result;
  }

  PinsChanged._();

  factory PinsChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PinsChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PinsChanged',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..pPM<$0.Pin>(1, _omitFieldNames ? '' : 'pins', subBuilder: $0.Pin.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PinsChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PinsChanged copyWith(void Function(PinsChanged) updates) =>
      super.copyWith((message) => updates(message as PinsChanged))
          as PinsChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PinsChanged create() => PinsChanged._();
  @$core.override
  PinsChanged createEmptyInstance() => create();
  static $pb.PbList<PinsChanged> createRepeated() => $pb.PbList<PinsChanged>();
  @$core.pragma('dart2js:noInline')
  static PinsChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PinsChanged>(create);
  static PinsChanged? _defaultInstance;

  /// the list of pins in the call.
  /// Pins are ordered in descending order (most important first).
  @$pb.TagNumber(1)
  $pb.PbList<$0.Pin> get pins => $_getList(0);
}

class Error extends $pb.GeneratedMessage {
  factory Error({
    $0.Error? error,
    $0.WebsocketReconnectStrategy? reconnectStrategy,
  }) {
    final result = create();
    if (error != null) result.error = error;
    if (reconnectStrategy != null) result.reconnectStrategy = reconnectStrategy;
    return result;
  }

  Error._();

  factory Error.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Error.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Error',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOM<$0.Error>(4, _omitFieldNames ? '' : 'error',
        subBuilder: $0.Error.create)
    ..aE<$0.WebsocketReconnectStrategy>(
        5, _omitFieldNames ? '' : 'reconnectStrategy',
        enumValues: $0.WebsocketReconnectStrategy.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Error clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Error copyWith(void Function(Error) updates) =>
      super.copyWith((message) => updates(message as Error)) as Error;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Error create() => Error._();
  @$core.override
  Error createEmptyInstance() => create();
  static $pb.PbList<Error> createRepeated() => $pb.PbList<Error>();
  @$core.pragma('dart2js:noInline')
  static Error getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Error>(create);
  static Error? _defaultInstance;

  @$pb.TagNumber(4)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(4)
  set error($0.Error value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(4)
  void clearError() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Error ensureError() => $_ensure(0);

  /// returns the reconnect strategy to be used by the client
  @$pb.TagNumber(5)
  $0.WebsocketReconnectStrategy get reconnectStrategy => $_getN(1);
  @$pb.TagNumber(5)
  set reconnectStrategy($0.WebsocketReconnectStrategy value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReconnectStrategy() => $_has(1);
  @$pb.TagNumber(5)
  void clearReconnectStrategy() => $_clearField(5);
}

class ICETrickle extends $pb.GeneratedMessage {
  factory ICETrickle({
    $0.PeerType? peerType,
    $core.String? iceCandidate,
  }) {
    final result = create();
    if (peerType != null) result.peerType = peerType;
    if (iceCandidate != null) result.iceCandidate = iceCandidate;
    return result;
  }

  ICETrickle._();

  factory ICETrickle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ICETrickle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ICETrickle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aE<$0.PeerType>(1, _omitFieldNames ? '' : 'peerType',
        enumValues: $0.PeerType.values)
    ..aOS(2, _omitFieldNames ? '' : 'iceCandidate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ICETrickle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ICETrickle copyWith(void Function(ICETrickle) updates) =>
      super.copyWith((message) => updates(message as ICETrickle)) as ICETrickle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ICETrickle create() => ICETrickle._();
  @$core.override
  ICETrickle createEmptyInstance() => create();
  static $pb.PbList<ICETrickle> createRepeated() => $pb.PbList<ICETrickle>();
  @$core.pragma('dart2js:noInline')
  static ICETrickle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ICETrickle>(create);
  static ICETrickle? _defaultInstance;

  @$pb.TagNumber(1)
  $0.PeerType get peerType => $_getN(0);
  @$pb.TagNumber(1)
  set peerType($0.PeerType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get iceCandidate => $_getSZ(1);
  @$pb.TagNumber(2)
  set iceCandidate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIceCandidate() => $_has(1);
  @$pb.TagNumber(2)
  void clearIceCandidate() => $_clearField(2);
}

class ICERestart extends $pb.GeneratedMessage {
  factory ICERestart({
    $0.PeerType? peerType,
  }) {
    final result = create();
    if (peerType != null) result.peerType = peerType;
    return result;
  }

  ICERestart._();

  factory ICERestart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ICERestart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ICERestart',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aE<$0.PeerType>(1, _omitFieldNames ? '' : 'peerType',
        enumValues: $0.PeerType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ICERestart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ICERestart copyWith(void Function(ICERestart) updates) =>
      super.copyWith((message) => updates(message as ICERestart)) as ICERestart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ICERestart create() => ICERestart._();
  @$core.override
  ICERestart createEmptyInstance() => create();
  static $pb.PbList<ICERestart> createRepeated() => $pb.PbList<ICERestart>();
  @$core.pragma('dart2js:noInline')
  static ICERestart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ICERestart>(create);
  static ICERestart? _defaultInstance;

  @$pb.TagNumber(1)
  $0.PeerType get peerType => $_getN(0);
  @$pb.TagNumber(1)
  set peerType($0.PeerType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerType() => $_clearField(1);
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
    final result = create();
    if (joinRequest != null) result.joinRequest = joinRequest;
    if (healthCheckRequest != null)
      result.healthCheckRequest = healthCheckRequest;
    if (leaveCallRequest != null) result.leaveCallRequest = leaveCallRequest;
    return result;
  }

  SfuRequest._();

  factory SfuRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SfuRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SfuRequest_RequestPayload>
      _SfuRequest_RequestPayloadByTag = {
    1: SfuRequest_RequestPayload.joinRequest,
    2: SfuRequest_RequestPayload.healthCheckRequest,
    3: SfuRequest_RequestPayload.leaveCallRequest,
    0: SfuRequest_RequestPayload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SfuRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<JoinRequest>(1, _omitFieldNames ? '' : 'joinRequest',
        subBuilder: JoinRequest.create)
    ..aOM<HealthCheckRequest>(2, _omitFieldNames ? '' : 'healthCheckRequest',
        subBuilder: HealthCheckRequest.create)
    ..aOM<LeaveCallRequest>(3, _omitFieldNames ? '' : 'leaveCallRequest',
        subBuilder: LeaveCallRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SfuRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SfuRequest copyWith(void Function(SfuRequest) updates) =>
      super.copyWith((message) => updates(message as SfuRequest)) as SfuRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SfuRequest create() => SfuRequest._();
  @$core.override
  SfuRequest createEmptyInstance() => create();
  static $pb.PbList<SfuRequest> createRepeated() => $pb.PbList<SfuRequest>();
  @$core.pragma('dart2js:noInline')
  static SfuRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SfuRequest>(create);
  static SfuRequest? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  SfuRequest_RequestPayload whichRequestPayload() =>
      _SfuRequest_RequestPayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearRequestPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  JoinRequest get joinRequest => $_getN(0);
  @$pb.TagNumber(1)
  set joinRequest(JoinRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJoinRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearJoinRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  JoinRequest ensureJoinRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  HealthCheckRequest get healthCheckRequest => $_getN(1);
  @$pb.TagNumber(2)
  set healthCheckRequest(HealthCheckRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasHealthCheckRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearHealthCheckRequest() => $_clearField(2);
  @$pb.TagNumber(2)
  HealthCheckRequest ensureHealthCheckRequest() => $_ensure(1);

  @$pb.TagNumber(3)
  LeaveCallRequest get leaveCallRequest => $_getN(2);
  @$pb.TagNumber(3)
  set leaveCallRequest(LeaveCallRequest value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLeaveCallRequest() => $_has(2);
  @$pb.TagNumber(3)
  void clearLeaveCallRequest() => $_clearField(3);
  @$pb.TagNumber(3)
  LeaveCallRequest ensureLeaveCallRequest() => $_ensure(2);
}

class LeaveCallRequest extends $pb.GeneratedMessage {
  factory LeaveCallRequest({
    $core.String? sessionId,
    $core.String? reason,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (reason != null) result.reason = reason;
    return result;
  }

  LeaveCallRequest._();

  factory LeaveCallRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LeaveCallRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LeaveCallRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveCallRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveCallRequest copyWith(void Function(LeaveCallRequest) updates) =>
      super.copyWith((message) => updates(message as LeaveCallRequest))
          as LeaveCallRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaveCallRequest create() => LeaveCallRequest._();
  @$core.override
  LeaveCallRequest createEmptyInstance() => create();
  static $pb.PbList<LeaveCallRequest> createRepeated() =>
      $pb.PbList<LeaveCallRequest>();
  @$core.pragma('dart2js:noInline')
  static LeaveCallRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LeaveCallRequest>(create);
  static LeaveCallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class HealthCheckRequest extends $pb.GeneratedMessage {
  factory HealthCheckRequest() => create();

  HealthCheckRequest._();

  factory HealthCheckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HealthCheckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthCheckRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCheckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCheckRequest copyWith(void Function(HealthCheckRequest) updates) =>
      super.copyWith((message) => updates(message as HealthCheckRequest))
          as HealthCheckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HealthCheckRequest create() => HealthCheckRequest._();
  @$core.override
  HealthCheckRequest createEmptyInstance() => create();
  static $pb.PbList<HealthCheckRequest> createRepeated() =>
      $pb.PbList<HealthCheckRequest>();
  @$core.pragma('dart2js:noInline')
  static HealthCheckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HealthCheckRequest>(create);
  static HealthCheckRequest? _defaultInstance;
}

class HealthCheckResponse extends $pb.GeneratedMessage {
  factory HealthCheckResponse({
    $0.ParticipantCount? participantCount,
  }) {
    final result = create();
    if (participantCount != null) result.participantCount = participantCount;
    return result;
  }

  HealthCheckResponse._();

  factory HealthCheckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HealthCheckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthCheckResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOM<$0.ParticipantCount>(1, _omitFieldNames ? '' : 'participantCount',
        subBuilder: $0.ParticipantCount.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCheckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCheckResponse copyWith(void Function(HealthCheckResponse) updates) =>
      super.copyWith((message) => updates(message as HealthCheckResponse))
          as HealthCheckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HealthCheckResponse create() => HealthCheckResponse._();
  @$core.override
  HealthCheckResponse createEmptyInstance() => create();
  static $pb.PbList<HealthCheckResponse> createRepeated() =>
      $pb.PbList<HealthCheckResponse>();
  @$core.pragma('dart2js:noInline')
  static HealthCheckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HealthCheckResponse>(create);
  static HealthCheckResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.ParticipantCount get participantCount => $_getN(0);
  @$pb.TagNumber(1)
  set participantCount($0.ParticipantCount value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasParticipantCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearParticipantCount() => $_clearField(1);
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
    final result = create();
    if (userId != null) result.userId = userId;
    if (sessionId != null) result.sessionId = sessionId;
    if (type != null) result.type = type;
    if (participant != null) result.participant = participant;
    return result;
  }

  TrackPublished._();

  factory TrackPublished.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrackPublished.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrackPublished',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aE<$0.TrackType>(3, _omitFieldNames ? '' : 'type',
        enumValues: $0.TrackType.values)
    ..aOM<$0.Participant>(4, _omitFieldNames ? '' : 'participant',
        subBuilder: $0.Participant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackPublished clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackPublished copyWith(void Function(TrackPublished) updates) =>
      super.copyWith((message) => updates(message as TrackPublished))
          as TrackPublished;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrackPublished create() => TrackPublished._();
  @$core.override
  TrackPublished createEmptyInstance() => create();
  static $pb.PbList<TrackPublished> createRepeated() =>
      $pb.PbList<TrackPublished>();
  @$core.pragma('dart2js:noInline')
  static TrackPublished getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrackPublished>(create);
  static TrackPublished? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.TrackType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type($0.TrackType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  /// Participant information here is included as an optimisation
  /// for large calls where broadcasting on every participant join
  /// is expensive. You should **NOT** assume that this will always
  /// be available though you can use it to update the participant
  /// list when it is there.
  @$pb.TagNumber(4)
  $0.Participant get participant => $_getN(3);
  @$pb.TagNumber(4)
  set participant($0.Participant value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasParticipant() => $_has(3);
  @$pb.TagNumber(4)
  void clearParticipant() => $_clearField(4);
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
    final result = create();
    if (userId != null) result.userId = userId;
    if (sessionId != null) result.sessionId = sessionId;
    if (type != null) result.type = type;
    if (cause != null) result.cause = cause;
    if (participant != null) result.participant = participant;
    return result;
  }

  TrackUnpublished._();

  factory TrackUnpublished.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrackUnpublished.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrackUnpublished',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aE<$0.TrackType>(3, _omitFieldNames ? '' : 'type',
        enumValues: $0.TrackType.values)
    ..aE<$0.TrackUnpublishReason>(4, _omitFieldNames ? '' : 'cause',
        enumValues: $0.TrackUnpublishReason.values)
    ..aOM<$0.Participant>(5, _omitFieldNames ? '' : 'participant',
        subBuilder: $0.Participant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackUnpublished clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackUnpublished copyWith(void Function(TrackUnpublished) updates) =>
      super.copyWith((message) => updates(message as TrackUnpublished))
          as TrackUnpublished;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrackUnpublished create() => TrackUnpublished._();
  @$core.override
  TrackUnpublished createEmptyInstance() => create();
  static $pb.PbList<TrackUnpublished> createRepeated() =>
      $pb.PbList<TrackUnpublished>();
  @$core.pragma('dart2js:noInline')
  static TrackUnpublished getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrackUnpublished>(create);
  static TrackUnpublished? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.TrackType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type($0.TrackType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.TrackUnpublishReason get cause => $_getN(3);
  @$pb.TagNumber(4)
  set cause($0.TrackUnpublishReason value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCause() => $_has(3);
  @$pb.TagNumber(4)
  void clearCause() => $_clearField(4);

  /// Participant information here is included as an optimisation
  /// for large calls where broadcasting on every participant join
  /// is expensive. You should **NOT** assume that this will always
  /// be available though you can use it to update the participant
  /// list when it is there.
  @$pb.TagNumber(5)
  $0.Participant get participant => $_getN(4);
  @$pb.TagNumber(5)
  set participant($0.Participant value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasParticipant() => $_has(4);
  @$pb.TagNumber(5)
  void clearParticipant() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Participant ensureParticipant() => $_ensure(4);
}

class JoinRequest extends $pb.GeneratedMessage {
  factory JoinRequest({
    $core.String? token,
    $core.String? sessionId,
    $core.String? subscriberSdp,
    $0.ClientDetails? clientDetails,
    @$core.Deprecated('This field is deprecated.') Migration? migration,
    @$core.Deprecated('This field is deprecated.') $core.bool? fastReconnect,
    ReconnectDetails? reconnectDetails,
    $core.String? publisherSdp,
    $core.Iterable<$0.PublishOption>? preferredPublishOptions,
    $core.Iterable<$0.SubscribeOption>? preferredSubscribeOptions,
    $core.Iterable<$0.ClientCapability>? capabilities,
    $0.ParticipantSource? source,
    $core.String? unifiedSessionId,
  }) {
    final result = create();
    if (token != null) result.token = token;
    if (sessionId != null) result.sessionId = sessionId;
    if (subscriberSdp != null) result.subscriberSdp = subscriberSdp;
    if (clientDetails != null) result.clientDetails = clientDetails;
    if (migration != null) result.migration = migration;
    if (fastReconnect != null) result.fastReconnect = fastReconnect;
    if (reconnectDetails != null) result.reconnectDetails = reconnectDetails;
    if (publisherSdp != null) result.publisherSdp = publisherSdp;
    if (preferredPublishOptions != null)
      result.preferredPublishOptions.addAll(preferredPublishOptions);
    if (preferredSubscribeOptions != null)
      result.preferredSubscribeOptions.addAll(preferredSubscribeOptions);
    if (capabilities != null) result.capabilities.addAll(capabilities);
    if (source != null) result.source = source;
    if (unifiedSessionId != null) result.unifiedSessionId = unifiedSessionId;
    return result;
  }

  JoinRequest._();

  factory JoinRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'subscriberSdp')
    ..aOM<$0.ClientDetails>(4, _omitFieldNames ? '' : 'clientDetails',
        subBuilder: $0.ClientDetails.create)
    ..aOM<Migration>(5, _omitFieldNames ? '' : 'migration',
        subBuilder: Migration.create)
    ..aOB(6, _omitFieldNames ? '' : 'fastReconnect')
    ..aOM<ReconnectDetails>(7, _omitFieldNames ? '' : 'reconnectDetails',
        subBuilder: ReconnectDetails.create)
    ..aOS(8, _omitFieldNames ? '' : 'publisherSdp')
    ..pPM<$0.PublishOption>(9, _omitFieldNames ? '' : 'preferredPublishOptions',
        subBuilder: $0.PublishOption.create)
    ..pPM<$0.SubscribeOption>(
        10, _omitFieldNames ? '' : 'preferredSubscribeOptions',
        subBuilder: $0.SubscribeOption.create)
    ..pc<$0.ClientCapability>(
        11, _omitFieldNames ? '' : 'capabilities', $pb.PbFieldType.KE,
        valueOf: $0.ClientCapability.valueOf,
        enumValues: $0.ClientCapability.values,
        defaultEnumValue: $0.ClientCapability.CLIENT_CAPABILITY_UNSPECIFIED)
    ..aE<$0.ParticipantSource>(12, _omitFieldNames ? '' : 'source',
        enumValues: $0.ParticipantSource.values)
    ..aOS(13, _omitFieldNames ? '' : 'unifiedSessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRequest copyWith(void Function(JoinRequest) updates) =>
      super.copyWith((message) => updates(message as JoinRequest))
          as JoinRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRequest create() => JoinRequest._();
  @$core.override
  JoinRequest createEmptyInstance() => create();
  static $pb.PbList<JoinRequest> createRepeated() => $pb.PbList<JoinRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinRequest>(create);
  static JoinRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  /// dumb SDP that allow us to extract subscriber's decode codecs
  @$pb.TagNumber(3)
  $core.String get subscriberSdp => $_getSZ(2);
  @$pb.TagNumber(3)
  set subscriberSdp($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubscriberSdp() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubscriberSdp() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.ClientDetails get clientDetails => $_getN(3);
  @$pb.TagNumber(4)
  set clientDetails($0.ClientDetails value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasClientDetails() => $_has(3);
  @$pb.TagNumber(4)
  void clearClientDetails() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.ClientDetails ensureClientDetails() => $_ensure(3);

  /// Deprecated: use ReconnectDetails instead
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(5)
  Migration get migration => $_getN(4);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(5)
  set migration(Migration value) => $_setField(5, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(5)
  $core.bool hasMigration() => $_has(4);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(5)
  void clearMigration() => $_clearField(5);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(5)
  Migration ensureMigration() => $_ensure(4);

  /// Fast reconnect flag explicitly indicates that if the participant session
  /// and the associated state is still present in the SFU, the client is ready
  /// to restore the PeerConnection with an ICE restart. If the SFU replies with
  /// "reconnected: true" in its JoinResponse, then it is safe to perform an ICE
  /// restart or else the existing PeerConnections must be cleaned up.
  ///
  /// For the SFU, fast_reconnect:false indicates that even if it has the state
  /// cached, the client state is not in sync and hence it must be cleaned up before
  /// proceeding further.
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(6)
  $core.bool get fastReconnect => $_getBF(5);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(6)
  set fastReconnect($core.bool value) => $_setBool(5, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(6)
  $core.bool hasFastReconnect() => $_has(5);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(6)
  void clearFastReconnect() => $_clearField(6);

  @$pb.TagNumber(7)
  ReconnectDetails get reconnectDetails => $_getN(6);
  @$pb.TagNumber(7)
  set reconnectDetails(ReconnectDetails value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasReconnectDetails() => $_has(6);
  @$pb.TagNumber(7)
  void clearReconnectDetails() => $_clearField(7);
  @$pb.TagNumber(7)
  ReconnectDetails ensureReconnectDetails() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get publisherSdp => $_getSZ(7);
  @$pb.TagNumber(8)
  set publisherSdp($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPublisherSdp() => $_has(7);
  @$pb.TagNumber(8)
  void clearPublisherSdp() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$0.PublishOption> get preferredPublishOptions => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<$0.SubscribeOption> get preferredSubscribeOptions => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$0.ClientCapability> get capabilities => $_getList(10);

  @$pb.TagNumber(12)
  $0.ParticipantSource get source => $_getN(11);
  @$pb.TagNumber(12)
  set source($0.ParticipantSource value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSource() => $_has(11);
  @$pb.TagNumber(12)
  void clearSource() => $_clearField(12);

  /// user_session id can change during reconnects, this helps us to
  /// identify the user across reconnects and should remain consistent until the user explicitly
  /// disconnects, is kicked or the call is ended.
  @$pb.TagNumber(13)
  $core.String get unifiedSessionId => $_getSZ(12);
  @$pb.TagNumber(13)
  set unifiedSessionId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasUnifiedSessionId() => $_has(12);
  @$pb.TagNumber(13)
  void clearUnifiedSessionId() => $_clearField(13);
}

class ReconnectDetails extends $pb.GeneratedMessage {
  factory ReconnectDetails({
    $0.WebsocketReconnectStrategy? strategy,
    $core.Iterable<$0.TrackInfo>? announcedTracks,
    $core.Iterable<$1.TrackSubscriptionDetails>? subscriptions,
    $core.int? reconnectAttempt,
    $core.String? fromSfuId,
    $core.String? previousSessionId,
    $core.String? reason,
  }) {
    final result = create();
    if (strategy != null) result.strategy = strategy;
    if (announcedTracks != null) result.announcedTracks.addAll(announcedTracks);
    if (subscriptions != null) result.subscriptions.addAll(subscriptions);
    if (reconnectAttempt != null) result.reconnectAttempt = reconnectAttempt;
    if (fromSfuId != null) result.fromSfuId = fromSfuId;
    if (previousSessionId != null) result.previousSessionId = previousSessionId;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReconnectDetails._();

  factory ReconnectDetails.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReconnectDetails.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconnectDetails',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aE<$0.WebsocketReconnectStrategy>(1, _omitFieldNames ? '' : 'strategy',
        enumValues: $0.WebsocketReconnectStrategy.values)
    ..pPM<$0.TrackInfo>(3, _omitFieldNames ? '' : 'announcedTracks',
        subBuilder: $0.TrackInfo.create)
    ..pPM<$1.TrackSubscriptionDetails>(
        4, _omitFieldNames ? '' : 'subscriptions',
        subBuilder: $1.TrackSubscriptionDetails.create)
    ..aI(5, _omitFieldNames ? '' : 'reconnectAttempt',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'fromSfuId')
    ..aOS(7, _omitFieldNames ? '' : 'previousSessionId')
    ..aOS(8, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconnectDetails clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconnectDetails copyWith(void Function(ReconnectDetails) updates) =>
      super.copyWith((message) => updates(message as ReconnectDetails))
          as ReconnectDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconnectDetails create() => ReconnectDetails._();
  @$core.override
  ReconnectDetails createEmptyInstance() => create();
  static $pb.PbList<ReconnectDetails> createRepeated() =>
      $pb.PbList<ReconnectDetails>();
  @$core.pragma('dart2js:noInline')
  static ReconnectDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconnectDetails>(create);
  static ReconnectDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $0.WebsocketReconnectStrategy get strategy => $_getN(0);
  @$pb.TagNumber(1)
  set strategy($0.WebsocketReconnectStrategy value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStrategy() => $_has(0);
  @$pb.TagNumber(1)
  void clearStrategy() => $_clearField(1);

  @$pb.TagNumber(3)
  $pb.PbList<$0.TrackInfo> get announcedTracks => $_getList(1);

  @$pb.TagNumber(4)
  $pb.PbList<$1.TrackSubscriptionDetails> get subscriptions => $_getList(2);

  @$pb.TagNumber(5)
  $core.int get reconnectAttempt => $_getIZ(3);
  @$pb.TagNumber(5)
  set reconnectAttempt($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(5)
  $core.bool hasReconnectAttempt() => $_has(3);
  @$pb.TagNumber(5)
  void clearReconnectAttempt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get fromSfuId => $_getSZ(4);
  @$pb.TagNumber(6)
  set fromSfuId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(6)
  $core.bool hasFromSfuId() => $_has(4);
  @$pb.TagNumber(6)
  void clearFromSfuId() => $_clearField(6);

  /// only set in case of rejoin
  @$pb.TagNumber(7)
  $core.String get previousSessionId => $_getSZ(5);
  @$pb.TagNumber(7)
  set previousSessionId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(7)
  $core.bool hasPreviousSessionId() => $_has(5);
  @$pb.TagNumber(7)
  void clearPreviousSessionId() => $_clearField(7);

  /// the reconnect reason
  @$pb.TagNumber(8)
  $core.String get reason => $_getSZ(6);
  @$pb.TagNumber(8)
  set reason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(8)
  $core.bool hasReason() => $_has(6);
  @$pb.TagNumber(8)
  void clearReason() => $_clearField(8);
}

class Migration extends $pb.GeneratedMessage {
  factory Migration({
    $core.String? fromSfuId,
    $core.Iterable<$0.TrackInfo>? announcedTracks,
    $core.Iterable<$1.TrackSubscriptionDetails>? subscriptions,
  }) {
    final result = create();
    if (fromSfuId != null) result.fromSfuId = fromSfuId;
    if (announcedTracks != null) result.announcedTracks.addAll(announcedTracks);
    if (subscriptions != null) result.subscriptions.addAll(subscriptions);
    return result;
  }

  Migration._();

  factory Migration.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Migration.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Migration',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromSfuId')
    ..pPM<$0.TrackInfo>(2, _omitFieldNames ? '' : 'announcedTracks',
        subBuilder: $0.TrackInfo.create)
    ..pPM<$1.TrackSubscriptionDetails>(
        3, _omitFieldNames ? '' : 'subscriptions',
        subBuilder: $1.TrackSubscriptionDetails.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Migration clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Migration copyWith(void Function(Migration) updates) =>
      super.copyWith((message) => updates(message as Migration)) as Migration;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Migration create() => Migration._();
  @$core.override
  Migration createEmptyInstance() => create();
  static $pb.PbList<Migration> createRepeated() => $pb.PbList<Migration>();
  @$core.pragma('dart2js:noInline')
  static Migration getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Migration>(create);
  static Migration? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromSfuId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromSfuId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromSfuId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromSfuId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$0.TrackInfo> get announcedTracks => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$1.TrackSubscriptionDetails> get subscriptions => $_getList(2);
}

class JoinResponse extends $pb.GeneratedMessage {
  factory JoinResponse({
    $0.CallState? callState,
    $core.bool? reconnected,
    $core.int? fastReconnectDeadlineSeconds,
    $core.Iterable<$0.PublishOption>? publishOptions,
  }) {
    final result = create();
    if (callState != null) result.callState = callState;
    if (reconnected != null) result.reconnected = reconnected;
    if (fastReconnectDeadlineSeconds != null)
      result.fastReconnectDeadlineSeconds = fastReconnectDeadlineSeconds;
    if (publishOptions != null) result.publishOptions.addAll(publishOptions);
    return result;
  }

  JoinResponse._();

  factory JoinResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOM<$0.CallState>(1, _omitFieldNames ? '' : 'callState',
        subBuilder: $0.CallState.create)
    ..aOB(2, _omitFieldNames ? '' : 'reconnected')
    ..aI(3, _omitFieldNames ? '' : 'fastReconnectDeadlineSeconds')
    ..pPM<$0.PublishOption>(4, _omitFieldNames ? '' : 'publishOptions',
        subBuilder: $0.PublishOption.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinResponse copyWith(void Function(JoinResponse) updates) =>
      super.copyWith((message) => updates(message as JoinResponse))
          as JoinResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinResponse create() => JoinResponse._();
  @$core.override
  JoinResponse createEmptyInstance() => create();
  static $pb.PbList<JoinResponse> createRepeated() =>
      $pb.PbList<JoinResponse>();
  @$core.pragma('dart2js:noInline')
  static JoinResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinResponse>(create);
  static JoinResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CallState get callState => $_getN(0);
  @$pb.TagNumber(1)
  set callState($0.CallState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCallState() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.CallState ensureCallState() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get reconnected => $_getBF(1);
  @$pb.TagNumber(2)
  set reconnected($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReconnected() => $_has(1);
  @$pb.TagNumber(2)
  void clearReconnected() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get fastReconnectDeadlineSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set fastReconnectDeadlineSeconds($core.int value) =>
      $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFastReconnectDeadlineSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearFastReconnectDeadlineSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$0.PublishOption> get publishOptions => $_getList(3);
}

/// ParticipantJoined is fired when a user joins a call
class ParticipantJoined extends $pb.GeneratedMessage {
  factory ParticipantJoined({
    $core.String? callCid,
    $0.Participant? participant,
  }) {
    final result = create();
    if (callCid != null) result.callCid = callCid;
    if (participant != null) result.participant = participant;
    return result;
  }

  ParticipantJoined._();

  factory ParticipantJoined.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParticipantJoined.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParticipantJoined',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'callCid')
    ..aOM<$0.Participant>(2, _omitFieldNames ? '' : 'participant',
        subBuilder: $0.Participant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParticipantJoined clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParticipantJoined copyWith(void Function(ParticipantJoined) updates) =>
      super.copyWith((message) => updates(message as ParticipantJoined))
          as ParticipantJoined;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParticipantJoined create() => ParticipantJoined._();
  @$core.override
  ParticipantJoined createEmptyInstance() => create();
  static $pb.PbList<ParticipantJoined> createRepeated() =>
      $pb.PbList<ParticipantJoined>();
  @$core.pragma('dart2js:noInline')
  static ParticipantJoined getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParticipantJoined>(create);
  static ParticipantJoined? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Participant get participant => $_getN(1);
  @$pb.TagNumber(2)
  set participant($0.Participant value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParticipant() => $_has(1);
  @$pb.TagNumber(2)
  void clearParticipant() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Participant ensureParticipant() => $_ensure(1);
}

/// ParticipantJoined is fired when a user leaves a call
class ParticipantLeft extends $pb.GeneratedMessage {
  factory ParticipantLeft({
    $core.String? callCid,
    $0.Participant? participant,
  }) {
    final result = create();
    if (callCid != null) result.callCid = callCid;
    if (participant != null) result.participant = participant;
    return result;
  }

  ParticipantLeft._();

  factory ParticipantLeft.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParticipantLeft.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParticipantLeft',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'callCid')
    ..aOM<$0.Participant>(2, _omitFieldNames ? '' : 'participant',
        subBuilder: $0.Participant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParticipantLeft clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParticipantLeft copyWith(void Function(ParticipantLeft) updates) =>
      super.copyWith((message) => updates(message as ParticipantLeft))
          as ParticipantLeft;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParticipantLeft create() => ParticipantLeft._();
  @$core.override
  ParticipantLeft createEmptyInstance() => create();
  static $pb.PbList<ParticipantLeft> createRepeated() =>
      $pb.PbList<ParticipantLeft>();
  @$core.pragma('dart2js:noInline')
  static ParticipantLeft getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParticipantLeft>(create);
  static ParticipantLeft? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Participant get participant => $_getN(1);
  @$pb.TagNumber(2)
  set participant($0.Participant value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParticipant() => $_has(1);
  @$pb.TagNumber(2)
  void clearParticipant() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Participant ensureParticipant() => $_ensure(1);
}

/// ParticipantUpdated is fired when user data is updated
class ParticipantUpdated extends $pb.GeneratedMessage {
  factory ParticipantUpdated({
    $core.String? callCid,
    $0.Participant? participant,
  }) {
    final result = create();
    if (callCid != null) result.callCid = callCid;
    if (participant != null) result.participant = participant;
    return result;
  }

  ParticipantUpdated._();

  factory ParticipantUpdated.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParticipantUpdated.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParticipantUpdated',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'callCid')
    ..aOM<$0.Participant>(2, _omitFieldNames ? '' : 'participant',
        subBuilder: $0.Participant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParticipantUpdated clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParticipantUpdated copyWith(void Function(ParticipantUpdated) updates) =>
      super.copyWith((message) => updates(message as ParticipantUpdated))
          as ParticipantUpdated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParticipantUpdated create() => ParticipantUpdated._();
  @$core.override
  ParticipantUpdated createEmptyInstance() => create();
  static $pb.PbList<ParticipantUpdated> createRepeated() =>
      $pb.PbList<ParticipantUpdated>();
  @$core.pragma('dart2js:noInline')
  static ParticipantUpdated getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParticipantUpdated>(create);
  static ParticipantUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Participant get participant => $_getN(1);
  @$pb.TagNumber(2)
  set participant($0.Participant value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParticipant() => $_has(1);
  @$pb.TagNumber(2)
  void clearParticipant() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Participant ensureParticipant() => $_ensure(1);
}

/// SubscriberOffer is sent when the SFU adds tracks to a subscription
class SubscriberOffer extends $pb.GeneratedMessage {
  factory SubscriberOffer({
    $core.bool? iceRestart,
    $core.String? sdp,
  }) {
    final result = create();
    if (iceRestart != null) result.iceRestart = iceRestart;
    if (sdp != null) result.sdp = sdp;
    return result;
  }

  SubscriberOffer._();

  factory SubscriberOffer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscriberOffer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscriberOffer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'iceRestart')
    ..aOS(2, _omitFieldNames ? '' : 'sdp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriberOffer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriberOffer copyWith(void Function(SubscriberOffer) updates) =>
      super.copyWith((message) => updates(message as SubscriberOffer))
          as SubscriberOffer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscriberOffer create() => SubscriberOffer._();
  @$core.override
  SubscriberOffer createEmptyInstance() => create();
  static $pb.PbList<SubscriberOffer> createRepeated() =>
      $pb.PbList<SubscriberOffer>();
  @$core.pragma('dart2js:noInline')
  static SubscriberOffer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscriberOffer>(create);
  static SubscriberOffer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get iceRestart => $_getBF(0);
  @$pb.TagNumber(1)
  set iceRestart($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIceRestart() => $_has(0);
  @$pb.TagNumber(1)
  void clearIceRestart() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sdp => $_getSZ(1);
  @$pb.TagNumber(2)
  set sdp($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSdp() => $_has(1);
  @$pb.TagNumber(2)
  void clearSdp() => $_clearField(2);
}

class PublisherAnswer extends $pb.GeneratedMessage {
  factory PublisherAnswer({
    $core.String? sdp,
  }) {
    final result = create();
    if (sdp != null) result.sdp = sdp;
    return result;
  }

  PublisherAnswer._();

  factory PublisherAnswer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublisherAnswer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublisherAnswer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sdp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublisherAnswer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublisherAnswer copyWith(void Function(PublisherAnswer) updates) =>
      super.copyWith((message) => updates(message as PublisherAnswer))
          as PublisherAnswer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublisherAnswer create() => PublisherAnswer._();
  @$core.override
  PublisherAnswer createEmptyInstance() => create();
  static $pb.PbList<PublisherAnswer> createRepeated() =>
      $pb.PbList<PublisherAnswer>();
  @$core.pragma('dart2js:noInline')
  static PublisherAnswer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublisherAnswer>(create);
  static PublisherAnswer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sdp => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdp($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSdp() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdp() => $_clearField(1);
}

/// ConnectionQuality is sent to inform about connection quality changes
/// eg. thierry's connection is not good -> render a red icon Zoom style
class ConnectionQualityChanged extends $pb.GeneratedMessage {
  factory ConnectionQualityChanged({
    $core.Iterable<ConnectionQualityInfo>? connectionQualityUpdates,
  }) {
    final result = create();
    if (connectionQualityUpdates != null)
      result.connectionQualityUpdates.addAll(connectionQualityUpdates);
    return result;
  }

  ConnectionQualityChanged._();

  factory ConnectionQualityChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConnectionQualityChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectionQualityChanged',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..pPM<ConnectionQualityInfo>(
        1, _omitFieldNames ? '' : 'connectionQualityUpdates',
        subBuilder: ConnectionQualityInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectionQualityChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectionQualityChanged copyWith(
          void Function(ConnectionQualityChanged) updates) =>
      super.copyWith((message) => updates(message as ConnectionQualityChanged))
          as ConnectionQualityChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectionQualityChanged create() => ConnectionQualityChanged._();
  @$core.override
  ConnectionQualityChanged createEmptyInstance() => create();
  static $pb.PbList<ConnectionQualityChanged> createRepeated() =>
      $pb.PbList<ConnectionQualityChanged>();
  @$core.pragma('dart2js:noInline')
  static ConnectionQualityChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectionQualityChanged>(create);
  static ConnectionQualityChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ConnectionQualityInfo> get connectionQualityUpdates =>
      $_getList(0);
}

class ConnectionQualityInfo extends $pb.GeneratedMessage {
  factory ConnectionQualityInfo({
    $core.String? userId,
    $core.String? sessionId,
    $0.ConnectionQuality? connectionQuality,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (sessionId != null) result.sessionId = sessionId;
    if (connectionQuality != null) result.connectionQuality = connectionQuality;
    return result;
  }

  ConnectionQualityInfo._();

  factory ConnectionQualityInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConnectionQualityInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectionQualityInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aE<$0.ConnectionQuality>(3, _omitFieldNames ? '' : 'connectionQuality',
        enumValues: $0.ConnectionQuality.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectionQualityInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectionQualityInfo copyWith(
          void Function(ConnectionQualityInfo) updates) =>
      super.copyWith((message) => updates(message as ConnectionQualityInfo))
          as ConnectionQualityInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectionQualityInfo create() => ConnectionQualityInfo._();
  @$core.override
  ConnectionQualityInfo createEmptyInstance() => create();
  static $pb.PbList<ConnectionQualityInfo> createRepeated() =>
      $pb.PbList<ConnectionQualityInfo>();
  @$core.pragma('dart2js:noInline')
  static ConnectionQualityInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectionQualityInfo>(create);
  static ConnectionQualityInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.ConnectionQuality get connectionQuality => $_getN(2);
  @$pb.TagNumber(3)
  set connectionQuality($0.ConnectionQuality value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasConnectionQuality() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnectionQuality() => $_clearField(3);
}

/// DominantSpeakerChanged is sent by the SFU to notify when there is a new dominant speaker in the call
class DominantSpeakerChanged extends $pb.GeneratedMessage {
  factory DominantSpeakerChanged({
    $core.String? userId,
    $core.String? sessionId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  DominantSpeakerChanged._();

  factory DominantSpeakerChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DominantSpeakerChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DominantSpeakerChanged',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DominantSpeakerChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DominantSpeakerChanged copyWith(
          void Function(DominantSpeakerChanged) updates) =>
      super.copyWith((message) => updates(message as DominantSpeakerChanged))
          as DominantSpeakerChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DominantSpeakerChanged create() => DominantSpeakerChanged._();
  @$core.override
  DominantSpeakerChanged createEmptyInstance() => create();
  static $pb.PbList<DominantSpeakerChanged> createRepeated() =>
      $pb.PbList<DominantSpeakerChanged>();
  @$core.pragma('dart2js:noInline')
  static DominantSpeakerChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DominantSpeakerChanged>(create);
  static DominantSpeakerChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

class AudioLevel extends $pb.GeneratedMessage {
  factory AudioLevel({
    $core.String? userId,
    $core.String? sessionId,
    $core.double? level,
    $core.bool? isSpeaking,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (sessionId != null) result.sessionId = sessionId;
    if (level != null) result.level = level;
    if (isSpeaking != null) result.isSpeaking = isSpeaking;
    return result;
  }

  AudioLevel._();

  factory AudioLevel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AudioLevel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AudioLevel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aD(3, _omitFieldNames ? '' : 'level', fieldType: $pb.PbFieldType.OF)
    ..aOB(4, _omitFieldNames ? '' : 'isSpeaking')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioLevel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioLevel copyWith(void Function(AudioLevel) updates) =>
      super.copyWith((message) => updates(message as AudioLevel)) as AudioLevel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AudioLevel create() => AudioLevel._();
  @$core.override
  AudioLevel createEmptyInstance() => create();
  static $pb.PbList<AudioLevel> createRepeated() => $pb.PbList<AudioLevel>();
  @$core.pragma('dart2js:noInline')
  static AudioLevel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AudioLevel>(create);
  static AudioLevel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  /// 0.0 means complete silence, 1.0 loudest
  @$pb.TagNumber(3)
  $core.double get level => $_getN(2);
  @$pb.TagNumber(3)
  set level($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLevel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isSpeaking => $_getBF(3);
  @$pb.TagNumber(4)
  set isSpeaking($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsSpeaking() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsSpeaking() => $_clearField(4);
}

/// AudioLevelChanged is sent by the SFU to notify about audio levels by user
class AudioLevelChanged extends $pb.GeneratedMessage {
  factory AudioLevelChanged({
    $core.Iterable<AudioLevel>? audioLevels,
  }) {
    final result = create();
    if (audioLevels != null) result.audioLevels.addAll(audioLevels);
    return result;
  }

  AudioLevelChanged._();

  factory AudioLevelChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AudioLevelChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AudioLevelChanged',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..pPM<AudioLevel>(1, _omitFieldNames ? '' : 'audioLevels',
        subBuilder: AudioLevel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioLevelChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioLevelChanged copyWith(void Function(AudioLevelChanged) updates) =>
      super.copyWith((message) => updates(message as AudioLevelChanged))
          as AudioLevelChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AudioLevelChanged create() => AudioLevelChanged._();
  @$core.override
  AudioLevelChanged createEmptyInstance() => create();
  static $pb.PbList<AudioLevelChanged> createRepeated() =>
      $pb.PbList<AudioLevelChanged>();
  @$core.pragma('dart2js:noInline')
  static AudioLevelChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AudioLevelChanged>(create);
  static AudioLevelChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AudioLevel> get audioLevels => $_getList(0);
}

class AudioSender extends $pb.GeneratedMessage {
  factory AudioSender({
    $0.Codec? codec,
    $0.TrackType? trackType,
    $core.int? publishOptionId,
  }) {
    final result = create();
    if (codec != null) result.codec = codec;
    if (trackType != null) result.trackType = trackType;
    if (publishOptionId != null) result.publishOptionId = publishOptionId;
    return result;
  }

  AudioSender._();

  factory AudioSender.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AudioSender.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AudioSender',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOM<$0.Codec>(2, _omitFieldNames ? '' : 'codec',
        subBuilder: $0.Codec.create)
    ..aE<$0.TrackType>(3, _omitFieldNames ? '' : 'trackType',
        enumValues: $0.TrackType.values)
    ..aI(4, _omitFieldNames ? '' : 'publishOptionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioSender clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioSender copyWith(void Function(AudioSender) updates) =>
      super.copyWith((message) => updates(message as AudioSender))
          as AudioSender;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AudioSender create() => AudioSender._();
  @$core.override
  AudioSender createEmptyInstance() => create();
  static $pb.PbList<AudioSender> createRepeated() => $pb.PbList<AudioSender>();
  @$core.pragma('dart2js:noInline')
  static AudioSender getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AudioSender>(create);
  static AudioSender? _defaultInstance;

  @$pb.TagNumber(2)
  $0.Codec get codec => $_getN(0);
  @$pb.TagNumber(2)
  set codec($0.Codec value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCodec() => $_has(0);
  @$pb.TagNumber(2)
  void clearCodec() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Codec ensureCodec() => $_ensure(0);

  @$pb.TagNumber(3)
  $0.TrackType get trackType => $_getN(1);
  @$pb.TagNumber(3)
  set trackType($0.TrackType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTrackType() => $_has(1);
  @$pb.TagNumber(3)
  void clearTrackType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get publishOptionId => $_getIZ(2);
  @$pb.TagNumber(4)
  set publishOptionId($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(4)
  $core.bool hasPublishOptionId() => $_has(2);
  @$pb.TagNumber(4)
  void clearPublishOptionId() => $_clearField(4);
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
    $0.Codec? codec,
    $core.int? maxFramerate,
    $core.String? scalabilityMode,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (active != null) result.active = active;
    if (maxBitrate != null) result.maxBitrate = maxBitrate;
    if (scaleResolutionDownBy != null)
      result.scaleResolutionDownBy = scaleResolutionDownBy;
    if (codec != null) result.codec = codec;
    if (maxFramerate != null) result.maxFramerate = maxFramerate;
    if (scalabilityMode != null) result.scalabilityMode = scalabilityMode;
    return result;
  }

  VideoLayerSetting._();

  factory VideoLayerSetting.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VideoLayerSetting.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoLayerSetting',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOB(2, _omitFieldNames ? '' : 'active')
    ..aI(3, _omitFieldNames ? '' : 'maxBitrate')
    ..aD(4, _omitFieldNames ? '' : 'scaleResolutionDownBy',
        fieldType: $pb.PbFieldType.OF)
    ..aOM<$0.Codec>(6, _omitFieldNames ? '' : 'codec',
        subBuilder: $0.Codec.create)
    ..aI(7, _omitFieldNames ? '' : 'maxFramerate',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(8, _omitFieldNames ? '' : 'scalabilityMode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoLayerSetting clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoLayerSetting copyWith(void Function(VideoLayerSetting) updates) =>
      super.copyWith((message) => updates(message as VideoLayerSetting))
          as VideoLayerSetting;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoLayerSetting create() => VideoLayerSetting._();
  @$core.override
  VideoLayerSetting createEmptyInstance() => create();
  static $pb.PbList<VideoLayerSetting> createRepeated() =>
      $pb.PbList<VideoLayerSetting>();
  @$core.pragma('dart2js:noInline')
  static VideoLayerSetting getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoLayerSetting>(create);
  static VideoLayerSetting? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get active => $_getBF(1);
  @$pb.TagNumber(2)
  set active($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActive() => $_has(1);
  @$pb.TagNumber(2)
  void clearActive() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxBitrate => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxBitrate($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxBitrate() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxBitrate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get scaleResolutionDownBy => $_getN(3);
  @$pb.TagNumber(4)
  set scaleResolutionDownBy($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScaleResolutionDownBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearScaleResolutionDownBy() => $_clearField(4);

  @$pb.TagNumber(6)
  $0.Codec get codec => $_getN(4);
  @$pb.TagNumber(6)
  set codec($0.Codec value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCodec() => $_has(4);
  @$pb.TagNumber(6)
  void clearCodec() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Codec ensureCodec() => $_ensure(4);

  @$pb.TagNumber(7)
  $core.int get maxFramerate => $_getIZ(5);
  @$pb.TagNumber(7)
  set maxFramerate($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(7)
  $core.bool hasMaxFramerate() => $_has(5);
  @$pb.TagNumber(7)
  void clearMaxFramerate() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get scalabilityMode => $_getSZ(6);
  @$pb.TagNumber(8)
  set scalabilityMode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(8)
  $core.bool hasScalabilityMode() => $_has(6);
  @$pb.TagNumber(8)
  void clearScalabilityMode() => $_clearField(8);
}

class VideoSender extends $pb.GeneratedMessage {
  factory VideoSender({
    $0.Codec? codec,
    $core.Iterable<VideoLayerSetting>? layers,
    $0.TrackType? trackType,
    $core.int? publishOptionId,
  }) {
    final result = create();
    if (codec != null) result.codec = codec;
    if (layers != null) result.layers.addAll(layers);
    if (trackType != null) result.trackType = trackType;
    if (publishOptionId != null) result.publishOptionId = publishOptionId;
    return result;
  }

  VideoSender._();

  factory VideoSender.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VideoSender.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoSender',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOM<$0.Codec>(2, _omitFieldNames ? '' : 'codec',
        subBuilder: $0.Codec.create)
    ..pPM<VideoLayerSetting>(3, _omitFieldNames ? '' : 'layers',
        subBuilder: VideoLayerSetting.create)
    ..aE<$0.TrackType>(4, _omitFieldNames ? '' : 'trackType',
        enumValues: $0.TrackType.values)
    ..aI(5, _omitFieldNames ? '' : 'publishOptionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoSender clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoSender copyWith(void Function(VideoSender) updates) =>
      super.copyWith((message) => updates(message as VideoSender))
          as VideoSender;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoSender create() => VideoSender._();
  @$core.override
  VideoSender createEmptyInstance() => create();
  static $pb.PbList<VideoSender> createRepeated() => $pb.PbList<VideoSender>();
  @$core.pragma('dart2js:noInline')
  static VideoSender getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoSender>(create);
  static VideoSender? _defaultInstance;

  @$pb.TagNumber(2)
  $0.Codec get codec => $_getN(0);
  @$pb.TagNumber(2)
  set codec($0.Codec value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCodec() => $_has(0);
  @$pb.TagNumber(2)
  void clearCodec() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Codec ensureCodec() => $_ensure(0);

  @$pb.TagNumber(3)
  $pb.PbList<VideoLayerSetting> get layers => $_getList(1);

  @$pb.TagNumber(4)
  $0.TrackType get trackType => $_getN(2);
  @$pb.TagNumber(4)
  set trackType($0.TrackType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTrackType() => $_has(2);
  @$pb.TagNumber(4)
  void clearTrackType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get publishOptionId => $_getIZ(3);
  @$pb.TagNumber(5)
  set publishOptionId($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(5)
  $core.bool hasPublishOptionId() => $_has(3);
  @$pb.TagNumber(5)
  void clearPublishOptionId() => $_clearField(5);
}

/// sent to users when they need to change the quality of their video
class ChangePublishQuality extends $pb.GeneratedMessage {
  factory ChangePublishQuality({
    $core.Iterable<AudioSender>? audioSenders,
    $core.Iterable<VideoSender>? videoSenders,
  }) {
    final result = create();
    if (audioSenders != null) result.audioSenders.addAll(audioSenders);
    if (videoSenders != null) result.videoSenders.addAll(videoSenders);
    return result;
  }

  ChangePublishQuality._();

  factory ChangePublishQuality.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangePublishQuality.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangePublishQuality',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..pPM<AudioSender>(1, _omitFieldNames ? '' : 'audioSenders',
        subBuilder: AudioSender.create)
    ..pPM<VideoSender>(2, _omitFieldNames ? '' : 'videoSenders',
        subBuilder: VideoSender.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePublishQuality clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePublishQuality copyWith(void Function(ChangePublishQuality) updates) =>
      super.copyWith((message) => updates(message as ChangePublishQuality))
          as ChangePublishQuality;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangePublishQuality create() => ChangePublishQuality._();
  @$core.override
  ChangePublishQuality createEmptyInstance() => create();
  static $pb.PbList<ChangePublishQuality> createRepeated() =>
      $pb.PbList<ChangePublishQuality>();
  @$core.pragma('dart2js:noInline')
  static ChangePublishQuality getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangePublishQuality>(create);
  static ChangePublishQuality? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AudioSender> get audioSenders => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<VideoSender> get videoSenders => $_getList(1);
}

/// CallGrants is sent to users when there is a change in the call permissions
/// to publish audio, video or share the screen for a user or a role. This is
/// idempotent and can be sent at any time. Only the current_grants in the latest
/// message should be considered. In other words, this is not dependent on any
/// other message (including previous call_grants_updated message)
///
/// When this message is received, the client (say, React component) should mute
/// the tracks which are not allowed anymore. For example, if the message has
/// grants {audio:true, video:false} while the user is publishing video, then the
/// client component should mute the video track and gray out the video button.
/// This way, the user will not be able to publish video until the permissions
/// are granted again. Also, muting the track on the client side will prevent
/// the SFU from receiving the video track and will save bandwidth.
///
/// In simple words, this is exactly the same as muting a track on the client.
/// Here, instead of the user instructing the client, SFU would be doing it.
class CallGrantsUpdated extends $pb.GeneratedMessage {
  factory CallGrantsUpdated({
    $0.CallGrants? currentGrants,
    $core.String? message,
  }) {
    final result = create();
    if (currentGrants != null) result.currentGrants = currentGrants;
    if (message != null) result.message = message;
    return result;
  }

  CallGrantsUpdated._();

  factory CallGrantsUpdated.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CallGrantsUpdated.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CallGrantsUpdated',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOM<$0.CallGrants>(1, _omitFieldNames ? '' : 'currentGrants',
        subBuilder: $0.CallGrants.create)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CallGrantsUpdated clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CallGrantsUpdated copyWith(void Function(CallGrantsUpdated) updates) =>
      super.copyWith((message) => updates(message as CallGrantsUpdated))
          as CallGrantsUpdated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CallGrantsUpdated create() => CallGrantsUpdated._();
  @$core.override
  CallGrantsUpdated createEmptyInstance() => create();
  static $pb.PbList<CallGrantsUpdated> createRepeated() =>
      $pb.PbList<CallGrantsUpdated>();
  @$core.pragma('dart2js:noInline')
  static CallGrantsUpdated getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CallGrantsUpdated>(create);
  static CallGrantsUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CallGrants get currentGrants => $_getN(0);
  @$pb.TagNumber(1)
  set currentGrants($0.CallGrants value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentGrants() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentGrants() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.CallGrants ensureCurrentGrants() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

/// Go away is sent by the SFU to the client to signal to migrate away from the SFU.
/// The evict reason may specify why the user is being evicted.
class GoAway extends $pb.GeneratedMessage {
  factory GoAway({
    $0.GoAwayReason? reason,
  }) {
    final result = create();
    if (reason != null) result.reason = reason;
    return result;
  }

  GoAway._();

  factory GoAway.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GoAway.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GoAway',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aE<$0.GoAwayReason>(1, _omitFieldNames ? '' : 'reason',
        enumValues: $0.GoAwayReason.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoAway clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoAway copyWith(void Function(GoAway) updates) =>
      super.copyWith((message) => updates(message as GoAway)) as GoAway;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GoAway create() => GoAway._();
  @$core.override
  GoAway createEmptyInstance() => create();
  static $pb.PbList<GoAway> createRepeated() => $pb.PbList<GoAway>();
  @$core.pragma('dart2js:noInline')
  static GoAway getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GoAway>(create);
  static GoAway? _defaultInstance;

  @$pb.TagNumber(1)
  $0.GoAwayReason get reason => $_getN(0);
  @$pb.TagNumber(1)
  set reason($0.GoAwayReason value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);
}

/// CallEnded is sent by the SFU to the client to signal that the call has ended.
/// The reason may specify why the call has ended.
class CallEnded extends $pb.GeneratedMessage {
  factory CallEnded({
    $0.CallEndedReason? reason,
  }) {
    final result = create();
    if (reason != null) result.reason = reason;
    return result;
  }

  CallEnded._();

  factory CallEnded.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CallEnded.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CallEnded',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aE<$0.CallEndedReason>(1, _omitFieldNames ? '' : 'reason',
        enumValues: $0.CallEndedReason.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CallEnded clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CallEnded copyWith(void Function(CallEnded) updates) =>
      super.copyWith((message) => updates(message as CallEnded)) as CallEnded;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CallEnded create() => CallEnded._();
  @$core.override
  CallEnded createEmptyInstance() => create();
  static $pb.PbList<CallEnded> createRepeated() => $pb.PbList<CallEnded>();
  @$core.pragma('dart2js:noInline')
  static CallEnded getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallEnded>(create);
  static CallEnded? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CallEndedReason get reason => $_getN(0);
  @$pb.TagNumber(1)
  set reason($0.CallEndedReason value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);
}

class InboundStateNotification extends $pb.GeneratedMessage {
  factory InboundStateNotification({
    $core.Iterable<InboundVideoState>? inboundVideoStates,
  }) {
    final result = create();
    if (inboundVideoStates != null)
      result.inboundVideoStates.addAll(inboundVideoStates);
    return result;
  }

  InboundStateNotification._();

  factory InboundStateNotification.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InboundStateNotification.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InboundStateNotification',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..pPM<InboundVideoState>(1, _omitFieldNames ? '' : 'inboundVideoStates',
        subBuilder: InboundVideoState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InboundStateNotification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InboundStateNotification copyWith(
          void Function(InboundStateNotification) updates) =>
      super.copyWith((message) => updates(message as InboundStateNotification))
          as InboundStateNotification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InboundStateNotification create() => InboundStateNotification._();
  @$core.override
  InboundStateNotification createEmptyInstance() => create();
  static $pb.PbList<InboundStateNotification> createRepeated() =>
      $pb.PbList<InboundStateNotification>();
  @$core.pragma('dart2js:noInline')
  static InboundStateNotification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InboundStateNotification>(create);
  static InboundStateNotification? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<InboundVideoState> get inboundVideoStates => $_getList(0);
}

class InboundVideoState extends $pb.GeneratedMessage {
  factory InboundVideoState({
    $core.String? userId,
    $core.String? sessionId,
    $0.TrackType? trackType,
    $core.bool? paused,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (sessionId != null) result.sessionId = sessionId;
    if (trackType != null) result.trackType = trackType;
    if (paused != null) result.paused = paused;
    return result;
  }

  InboundVideoState._();

  factory InboundVideoState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InboundVideoState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InboundVideoState',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.event'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aE<$0.TrackType>(3, _omitFieldNames ? '' : 'trackType',
        enumValues: $0.TrackType.values)
    ..aOB(4, _omitFieldNames ? '' : 'paused')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InboundVideoState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InboundVideoState copyWith(void Function(InboundVideoState) updates) =>
      super.copyWith((message) => updates(message as InboundVideoState))
          as InboundVideoState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InboundVideoState create() => InboundVideoState._();
  @$core.override
  InboundVideoState createEmptyInstance() => create();
  static $pb.PbList<InboundVideoState> createRepeated() =>
      $pb.PbList<InboundVideoState>();
  @$core.pragma('dart2js:noInline')
  static InboundVideoState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InboundVideoState>(create);
  static InboundVideoState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.TrackType get trackType => $_getN(2);
  @$pb.TagNumber(3)
  set trackType($0.TrackType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTrackType() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrackType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get paused => $_getBF(3);
  @$pb.TagNumber(4)
  set paused($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPaused() => $_has(3);
  @$pb.TagNumber(4)
  void clearPaused() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
