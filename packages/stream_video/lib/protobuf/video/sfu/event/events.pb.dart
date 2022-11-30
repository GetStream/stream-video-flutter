///
//  Generated code. Do not modify.
//  source: video/sfu/event/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../models/models.pb.dart' as $0;

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
  localDeviceChange, 
  muteStateChanged, 
  videoQualityChanged, 
  participantJoined, 
  participantLeft, 
  dominantSpeakerChanged, 
  joinResponse, 
  healthCheckResponse, 
  callEnded, 
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
    7 : SfuEvent_EventPayload.localDeviceChange,
    8 : SfuEvent_EventPayload.muteStateChanged,
    9 : SfuEvent_EventPayload.videoQualityChanged,
    10 : SfuEvent_EventPayload.participantJoined,
    11 : SfuEvent_EventPayload.participantLeft,
    12 : SfuEvent_EventPayload.dominantSpeakerChanged,
    13 : SfuEvent_EventPayload.joinResponse,
    14 : SfuEvent_EventPayload.healthCheckResponse,
    15 : SfuEvent_EventPayload.callEnded,
    0 : SfuEvent_EventPayload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SfuEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
    ..aOM<SubscriberOffer>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscriberOffer', subBuilder: SubscriberOffer.create)
    ..aOM<PublisherAnswer>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publisherAnswer', subBuilder: PublisherAnswer.create)
    ..aOM<ConnectionQualityChanged>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectionQualityChanged', subBuilder: ConnectionQualityChanged.create)
    ..aOM<AudioLevelChanged>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioLevelChanged', subBuilder: AudioLevelChanged.create)
    ..aOM<$0.ICETrickle>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iceTrickle', subBuilder: $0.ICETrickle.create)
    ..aOM<ChangePublishQuality>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'changePublishQuality', subBuilder: ChangePublishQuality.create)
    ..aOM<LocalDeviceChange>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localDeviceChange', subBuilder: LocalDeviceChange.create)
    ..aOM<MuteStateChanged>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'muteStateChanged', subBuilder: MuteStateChanged.create)
    ..aOM<VideoQualityChanged>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'videoQualityChanged', subBuilder: VideoQualityChanged.create)
    ..aOM<ParticipantJoined>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantJoined', subBuilder: ParticipantJoined.create)
    ..aOM<ParticipantLeft>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantLeft', subBuilder: ParticipantLeft.create)
    ..aOM<DominantSpeakerChanged>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dominantSpeakerChanged', subBuilder: DominantSpeakerChanged.create)
    ..aOM<JoinResponse>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'joinResponse', subBuilder: JoinResponse.create)
    ..aOM<HealthCheckResponse>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'healthCheckResponse', subBuilder: HealthCheckResponse.create)
    ..aOM<CallEnded>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callEnded', subBuilder: CallEnded.create)
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
    LocalDeviceChange? localDeviceChange,
    MuteStateChanged? muteStateChanged,
    VideoQualityChanged? videoQualityChanged,
    ParticipantJoined? participantJoined,
    ParticipantLeft? participantLeft,
    DominantSpeakerChanged? dominantSpeakerChanged,
    JoinResponse? joinResponse,
    HealthCheckResponse? healthCheckResponse,
    CallEnded? callEnded,
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
    if (localDeviceChange != null) {
      _result.localDeviceChange = localDeviceChange;
    }
    if (muteStateChanged != null) {
      _result.muteStateChanged = muteStateChanged;
    }
    if (videoQualityChanged != null) {
      _result.videoQualityChanged = videoQualityChanged;
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
    if (callEnded != null) {
      _result.callEnded = callEnded;
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

  @$pb.TagNumber(7)
  LocalDeviceChange get localDeviceChange => $_getN(6);
  @$pb.TagNumber(7)
  set localDeviceChange(LocalDeviceChange v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasLocalDeviceChange() => $_has(6);
  @$pb.TagNumber(7)
  void clearLocalDeviceChange() => clearField(7);
  @$pb.TagNumber(7)
  LocalDeviceChange ensureLocalDeviceChange() => $_ensure(6);

  @$pb.TagNumber(8)
  MuteStateChanged get muteStateChanged => $_getN(7);
  @$pb.TagNumber(8)
  set muteStateChanged(MuteStateChanged v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasMuteStateChanged() => $_has(7);
  @$pb.TagNumber(8)
  void clearMuteStateChanged() => clearField(8);
  @$pb.TagNumber(8)
  MuteStateChanged ensureMuteStateChanged() => $_ensure(7);

  @$pb.TagNumber(9)
  VideoQualityChanged get videoQualityChanged => $_getN(8);
  @$pb.TagNumber(9)
  set videoQualityChanged(VideoQualityChanged v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasVideoQualityChanged() => $_has(8);
  @$pb.TagNumber(9)
  void clearVideoQualityChanged() => clearField(9);
  @$pb.TagNumber(9)
  VideoQualityChanged ensureVideoQualityChanged() => $_ensure(8);

  @$pb.TagNumber(10)
  ParticipantJoined get participantJoined => $_getN(9);
  @$pb.TagNumber(10)
  set participantJoined(ParticipantJoined v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasParticipantJoined() => $_has(9);
  @$pb.TagNumber(10)
  void clearParticipantJoined() => clearField(10);
  @$pb.TagNumber(10)
  ParticipantJoined ensureParticipantJoined() => $_ensure(9);

  @$pb.TagNumber(11)
  ParticipantLeft get participantLeft => $_getN(10);
  @$pb.TagNumber(11)
  set participantLeft(ParticipantLeft v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasParticipantLeft() => $_has(10);
  @$pb.TagNumber(11)
  void clearParticipantLeft() => clearField(11);
  @$pb.TagNumber(11)
  ParticipantLeft ensureParticipantLeft() => $_ensure(10);

  @$pb.TagNumber(12)
  DominantSpeakerChanged get dominantSpeakerChanged => $_getN(11);
  @$pb.TagNumber(12)
  set dominantSpeakerChanged(DominantSpeakerChanged v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasDominantSpeakerChanged() => $_has(11);
  @$pb.TagNumber(12)
  void clearDominantSpeakerChanged() => clearField(12);
  @$pb.TagNumber(12)
  DominantSpeakerChanged ensureDominantSpeakerChanged() => $_ensure(11);

  @$pb.TagNumber(13)
  JoinResponse get joinResponse => $_getN(12);
  @$pb.TagNumber(13)
  set joinResponse(JoinResponse v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasJoinResponse() => $_has(12);
  @$pb.TagNumber(13)
  void clearJoinResponse() => clearField(13);
  @$pb.TagNumber(13)
  JoinResponse ensureJoinResponse() => $_ensure(12);

  @$pb.TagNumber(14)
  HealthCheckResponse get healthCheckResponse => $_getN(13);
  @$pb.TagNumber(14)
  set healthCheckResponse(HealthCheckResponse v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasHealthCheckResponse() => $_has(13);
  @$pb.TagNumber(14)
  void clearHealthCheckResponse() => clearField(14);
  @$pb.TagNumber(14)
  HealthCheckResponse ensureHealthCheckResponse() => $_ensure(13);

  @$pb.TagNumber(15)
  CallEnded get callEnded => $_getN(14);
  @$pb.TagNumber(15)
  set callEnded(CallEnded v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasCallEnded() => $_has(14);
  @$pb.TagNumber(15)
  void clearCallEnded() => clearField(15);
  @$pb.TagNumber(15)
  CallEnded ensureCallEnded() => $_ensure(14);
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
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  HealthCheckRequest._() : super();
  factory HealthCheckRequest({
    $core.String? sessionId,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    return _result;
  }
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

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);
}

class HealthCheckResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HealthCheckResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..hasRequiredFields = false
  ;

  HealthCheckResponse._() : super();
  factory HealthCheckResponse({
    $core.String? sessionId,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
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
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);
}

class JoinRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publish')
    ..aOM<$0.CodecSettings>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'codecSettings', subBuilder: $0.CodecSettings.create)
    ..hasRequiredFields = false
  ;

  JoinRequest._() : super();
  factory JoinRequest({
    $core.String? token,
    $core.String? sessionId,
    $core.bool? publish,
    $0.CodecSettings? codecSettings,
  }) {
    final _result = create();
    if (token != null) {
      _result.token = token;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (publish != null) {
      _result.publish = publish;
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
  $core.bool get publish => $_getBF(2);
  @$pb.TagNumber(3)
  set publish($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPublish() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublish() => clearField(3);

  @$pb.TagNumber(4)
  $0.CodecSettings get codecSettings => $_getN(3);
  @$pb.TagNumber(4)
  set codecSettings($0.CodecSettings v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCodecSettings() => $_has(3);
  @$pb.TagNumber(4)
  void clearCodecSettings() => clearField(4);
  @$pb.TagNumber(4)
  $0.CodecSettings ensureCodecSettings() => $_ensure(3);
}

class JoinResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<$0.CallState>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callState', subBuilder: $0.CallState.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ownSessionId')
    ..hasRequiredFields = false
  ;

  JoinResponse._() : super();
  factory JoinResponse({
    $0.CallState? callState,
    $core.String? ownSessionId,
  }) {
    final _result = create();
    if (callState != null) {
      _result.callState = callState;
    }
    if (ownSessionId != null) {
      _result.ownSessionId = ownSessionId;
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
  $core.String get ownSessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ownSessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOwnSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwnSessionId() => clearField(2);
}

class ParticipantJoined extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantJoined', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<$0.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $0.Call.create)
    ..aOM<$0.Participant>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantJoined._() : super();
  factory ParticipantJoined({
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

class ParticipantLeft extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantLeft', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOM<$0.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $0.Call.create)
    ..aOM<$0.Participant>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $0.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantLeft._() : super();
  factory ParticipantLeft({
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MuteStateChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioMuted')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'videoMuted')
    ..hasRequiredFields = false
  ;

  MuteStateChanged._() : super();
  factory MuteStateChanged({
    $core.String? userId,
    $core.bool? audioMuted,
    $core.bool? videoMuted,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
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
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoQualityChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SubscriberOffer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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

class LocalDeviceChange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalDeviceChange', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..hasRequiredFields = false
  ;

  LocalDeviceChange._() : super();
  factory LocalDeviceChange({
    $core.String? type,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    return _result;
  }
  factory LocalDeviceChange.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalDeviceChange.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalDeviceChange clone() => LocalDeviceChange()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalDeviceChange copyWith(void Function(LocalDeviceChange) updates) => super.copyWith((message) => updates(message as LocalDeviceChange)) as LocalDeviceChange; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalDeviceChange create() => LocalDeviceChange._();
  LocalDeviceChange createEmptyInstance() => create();
  static $pb.PbList<LocalDeviceChange> createRepeated() => $pb.PbList<LocalDeviceChange>();
  @$core.pragma('dart2js:noInline')
  static LocalDeviceChange getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalDeviceChange>(create);
  static LocalDeviceChange? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ICECandidateTrickle', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectionQualityChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DominantSpeakerChanged', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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

class CallEnded extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallEnded', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  CallEnded._() : super();
  factory CallEnded({
    $core.String? message,
  }) {
    final _result = create();
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory CallEnded.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallEnded.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallEnded clone() => CallEnded()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallEnded copyWith(void Function(CallEnded) updates) => super.copyWith((message) => updates(message as CallEnded)) as CallEnded; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallEnded create() => CallEnded._();
  CallEnded createEmptyInstance() => create();
  static $pb.PbList<CallEnded> createRepeated() => $pb.PbList<CallEnded>();
  @$core.pragma('dart2js:noInline')
  static CallEnded getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallEnded>(create);
  static CallEnded? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);
}

class AudioLevel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioLevel', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioLayerSetting', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.sfu.event'), createEmptyInstance: create)
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

