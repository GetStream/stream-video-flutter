///
//  Generated code. Do not modify.
//  source: video_events/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../video_coordinator_rpc/coordinator_service.pb.dart' as $5;
import '../video_models/models.pb.dart' as $3;

enum WebsocketEvent_EventPayload {
  healthCheck, 
  callRinging, 
  callCreated, 
  callUpdated, 
  callEnded, 
  callDeleted, 
  userUpdated, 
  participantInvited, 
  participantUpdated, 
  participantDeleted, 
  participantJoined, 
  participantLeft, 
  broadcastStarted, 
  broadcastEnded, 
  authPayload, 
  audioMuted, 
  audioUnmuted, 
  videoStarted, 
  videoStopped, 
  screenshareStarted, 
  screenshareStopped, 
  recordingStarted, 
  recordingStopped, 
  notSet
}

class WebsocketEvent extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, WebsocketEvent_EventPayload> _WebsocketEvent_EventPayloadByTag = {
    1 : WebsocketEvent_EventPayload.healthCheck,
    2 : WebsocketEvent_EventPayload.callRinging,
    3 : WebsocketEvent_EventPayload.callCreated,
    4 : WebsocketEvent_EventPayload.callUpdated,
    5 : WebsocketEvent_EventPayload.callEnded,
    6 : WebsocketEvent_EventPayload.callDeleted,
    7 : WebsocketEvent_EventPayload.userUpdated,
    8 : WebsocketEvent_EventPayload.participantInvited,
    9 : WebsocketEvent_EventPayload.participantUpdated,
    10 : WebsocketEvent_EventPayload.participantDeleted,
    11 : WebsocketEvent_EventPayload.participantJoined,
    12 : WebsocketEvent_EventPayload.participantLeft,
    13 : WebsocketEvent_EventPayload.broadcastStarted,
    14 : WebsocketEvent_EventPayload.broadcastEnded,
    15 : WebsocketEvent_EventPayload.authPayload,
    16 : WebsocketEvent_EventPayload.audioMuted,
    17 : WebsocketEvent_EventPayload.audioUnmuted,
    18 : WebsocketEvent_EventPayload.videoStarted,
    19 : WebsocketEvent_EventPayload.videoStopped,
    20 : WebsocketEvent_EventPayload.screenshareStarted,
    21 : WebsocketEvent_EventPayload.screenshareStopped,
    22 : WebsocketEvent_EventPayload.recordingStarted,
    23 : WebsocketEvent_EventPayload.recordingStopped,
    0 : WebsocketEvent_EventPayload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WebsocketEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23])
    ..aOM<Healthcheck>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'healthCheck', subBuilder: Healthcheck.create)
    ..aOM<CallRinging>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callRinging', subBuilder: CallRinging.create)
    ..aOM<CallCreated>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCreated', subBuilder: CallCreated.create)
    ..aOM<CallUpdated>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callUpdated', subBuilder: CallUpdated.create)
    ..aOM<CallEnded>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callEnded', subBuilder: CallEnded.create)
    ..aOM<CallDeleted>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callDeleted', subBuilder: CallDeleted.create)
    ..aOM<UserUpdated>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userUpdated', subBuilder: UserUpdated.create)
    ..aOM<ParticipantInvited>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantInvited', subBuilder: ParticipantInvited.create)
    ..aOM<ParticipantUpdated>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantUpdated', subBuilder: ParticipantUpdated.create)
    ..aOM<ParticipantDeleted>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantDeleted', subBuilder: ParticipantDeleted.create)
    ..aOM<ParticipantJoined>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantJoined', subBuilder: ParticipantJoined.create)
    ..aOM<ParticipantLeft>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantLeft', subBuilder: ParticipantLeft.create)
    ..aOM<BroadcastStarted>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcastStarted', subBuilder: BroadcastStarted.create)
    ..aOM<BroadcastEnded>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcastEnded', subBuilder: BroadcastEnded.create)
    ..aOM<AuthPayload>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'authPayload', subBuilder: AuthPayload.create)
    ..aOM<AudioMuted>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioMuted', subBuilder: AudioMuted.create)
    ..aOM<AudioUnmuted>(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioUnmuted', subBuilder: AudioUnmuted.create)
    ..aOM<VideoStarted>(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'videoStarted', subBuilder: VideoStarted.create)
    ..aOM<VideoStopped>(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'videoStopped', subBuilder: VideoStopped.create)
    ..aOM<ScreenshareStarted>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'screenshareStarted', subBuilder: ScreenshareStarted.create)
    ..aOM<ScreenshareStopped>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'screenshareStopped', subBuilder: ScreenshareStopped.create)
    ..aOM<RecordingStarted>(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recordingStarted', subBuilder: RecordingStarted.create)
    ..aOM<RecordingStopped>(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recordingStopped', subBuilder: RecordingStopped.create)
    ..hasRequiredFields = false
  ;

  WebsocketEvent._() : super();
  factory WebsocketEvent({
    Healthcheck? healthCheck,
    CallRinging? callRinging,
    CallCreated? callCreated,
    CallUpdated? callUpdated,
    CallEnded? callEnded,
    CallDeleted? callDeleted,
    UserUpdated? userUpdated,
    ParticipantInvited? participantInvited,
    ParticipantUpdated? participantUpdated,
    ParticipantDeleted? participantDeleted,
    ParticipantJoined? participantJoined,
    ParticipantLeft? participantLeft,
    BroadcastStarted? broadcastStarted,
    BroadcastEnded? broadcastEnded,
    AuthPayload? authPayload,
    AudioMuted? audioMuted,
    AudioUnmuted? audioUnmuted,
    VideoStarted? videoStarted,
    VideoStopped? videoStopped,
    ScreenshareStarted? screenshareStarted,
    ScreenshareStopped? screenshareStopped,
    RecordingStarted? recordingStarted,
    RecordingStopped? recordingStopped,
  }) {
    final _result = create();
    if (healthCheck != null) {
      _result.healthCheck = healthCheck;
    }
    if (callRinging != null) {
      _result.callRinging = callRinging;
    }
    if (callCreated != null) {
      _result.callCreated = callCreated;
    }
    if (callUpdated != null) {
      _result.callUpdated = callUpdated;
    }
    if (callEnded != null) {
      _result.callEnded = callEnded;
    }
    if (callDeleted != null) {
      _result.callDeleted = callDeleted;
    }
    if (userUpdated != null) {
      _result.userUpdated = userUpdated;
    }
    if (participantInvited != null) {
      _result.participantInvited = participantInvited;
    }
    if (participantUpdated != null) {
      _result.participantUpdated = participantUpdated;
    }
    if (participantDeleted != null) {
      _result.participantDeleted = participantDeleted;
    }
    if (participantJoined != null) {
      _result.participantJoined = participantJoined;
    }
    if (participantLeft != null) {
      _result.participantLeft = participantLeft;
    }
    if (broadcastStarted != null) {
      _result.broadcastStarted = broadcastStarted;
    }
    if (broadcastEnded != null) {
      _result.broadcastEnded = broadcastEnded;
    }
    if (authPayload != null) {
      _result.authPayload = authPayload;
    }
    if (audioMuted != null) {
      _result.audioMuted = audioMuted;
    }
    if (audioUnmuted != null) {
      _result.audioUnmuted = audioUnmuted;
    }
    if (videoStarted != null) {
      _result.videoStarted = videoStarted;
    }
    if (videoStopped != null) {
      _result.videoStopped = videoStopped;
    }
    if (screenshareStarted != null) {
      _result.screenshareStarted = screenshareStarted;
    }
    if (screenshareStopped != null) {
      _result.screenshareStopped = screenshareStopped;
    }
    if (recordingStarted != null) {
      _result.recordingStarted = recordingStarted;
    }
    if (recordingStopped != null) {
      _result.recordingStopped = recordingStopped;
    }
    return _result;
  }
  factory WebsocketEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WebsocketEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WebsocketEvent clone() => WebsocketEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WebsocketEvent copyWith(void Function(WebsocketEvent) updates) => super.copyWith((message) => updates(message as WebsocketEvent)) as WebsocketEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WebsocketEvent create() => WebsocketEvent._();
  WebsocketEvent createEmptyInstance() => create();
  static $pb.PbList<WebsocketEvent> createRepeated() => $pb.PbList<WebsocketEvent>();
  @$core.pragma('dart2js:noInline')
  static WebsocketEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WebsocketEvent>(create);
  static WebsocketEvent? _defaultInstance;

  WebsocketEvent_EventPayload whichEventPayload() => _WebsocketEvent_EventPayloadByTag[$_whichOneof(0)]!;
  void clearEventPayload() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Healthcheck get healthCheck => $_getN(0);
  @$pb.TagNumber(1)
  set healthCheck(Healthcheck v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHealthCheck() => $_has(0);
  @$pb.TagNumber(1)
  void clearHealthCheck() => clearField(1);
  @$pb.TagNumber(1)
  Healthcheck ensureHealthCheck() => $_ensure(0);

  @$pb.TagNumber(2)
  CallRinging get callRinging => $_getN(1);
  @$pb.TagNumber(2)
  set callRinging(CallRinging v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCallRinging() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallRinging() => clearField(2);
  @$pb.TagNumber(2)
  CallRinging ensureCallRinging() => $_ensure(1);

  @$pb.TagNumber(3)
  CallCreated get callCreated => $_getN(2);
  @$pb.TagNumber(3)
  set callCreated(CallCreated v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCallCreated() => $_has(2);
  @$pb.TagNumber(3)
  void clearCallCreated() => clearField(3);
  @$pb.TagNumber(3)
  CallCreated ensureCallCreated() => $_ensure(2);

  @$pb.TagNumber(4)
  CallUpdated get callUpdated => $_getN(3);
  @$pb.TagNumber(4)
  set callUpdated(CallUpdated v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCallUpdated() => $_has(3);
  @$pb.TagNumber(4)
  void clearCallUpdated() => clearField(4);
  @$pb.TagNumber(4)
  CallUpdated ensureCallUpdated() => $_ensure(3);

  @$pb.TagNumber(5)
  CallEnded get callEnded => $_getN(4);
  @$pb.TagNumber(5)
  set callEnded(CallEnded v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCallEnded() => $_has(4);
  @$pb.TagNumber(5)
  void clearCallEnded() => clearField(5);
  @$pb.TagNumber(5)
  CallEnded ensureCallEnded() => $_ensure(4);

  @$pb.TagNumber(6)
  CallDeleted get callDeleted => $_getN(5);
  @$pb.TagNumber(6)
  set callDeleted(CallDeleted v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCallDeleted() => $_has(5);
  @$pb.TagNumber(6)
  void clearCallDeleted() => clearField(6);
  @$pb.TagNumber(6)
  CallDeleted ensureCallDeleted() => $_ensure(5);

  @$pb.TagNumber(7)
  UserUpdated get userUpdated => $_getN(6);
  @$pb.TagNumber(7)
  set userUpdated(UserUpdated v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasUserUpdated() => $_has(6);
  @$pb.TagNumber(7)
  void clearUserUpdated() => clearField(7);
  @$pb.TagNumber(7)
  UserUpdated ensureUserUpdated() => $_ensure(6);

  @$pb.TagNumber(8)
  ParticipantInvited get participantInvited => $_getN(7);
  @$pb.TagNumber(8)
  set participantInvited(ParticipantInvited v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasParticipantInvited() => $_has(7);
  @$pb.TagNumber(8)
  void clearParticipantInvited() => clearField(8);
  @$pb.TagNumber(8)
  ParticipantInvited ensureParticipantInvited() => $_ensure(7);

  @$pb.TagNumber(9)
  ParticipantUpdated get participantUpdated => $_getN(8);
  @$pb.TagNumber(9)
  set participantUpdated(ParticipantUpdated v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasParticipantUpdated() => $_has(8);
  @$pb.TagNumber(9)
  void clearParticipantUpdated() => clearField(9);
  @$pb.TagNumber(9)
  ParticipantUpdated ensureParticipantUpdated() => $_ensure(8);

  @$pb.TagNumber(10)
  ParticipantDeleted get participantDeleted => $_getN(9);
  @$pb.TagNumber(10)
  set participantDeleted(ParticipantDeleted v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasParticipantDeleted() => $_has(9);
  @$pb.TagNumber(10)
  void clearParticipantDeleted() => clearField(10);
  @$pb.TagNumber(10)
  ParticipantDeleted ensureParticipantDeleted() => $_ensure(9);

  @$pb.TagNumber(11)
  ParticipantJoined get participantJoined => $_getN(10);
  @$pb.TagNumber(11)
  set participantJoined(ParticipantJoined v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasParticipantJoined() => $_has(10);
  @$pb.TagNumber(11)
  void clearParticipantJoined() => clearField(11);
  @$pb.TagNumber(11)
  ParticipantJoined ensureParticipantJoined() => $_ensure(10);

  @$pb.TagNumber(12)
  ParticipantLeft get participantLeft => $_getN(11);
  @$pb.TagNumber(12)
  set participantLeft(ParticipantLeft v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasParticipantLeft() => $_has(11);
  @$pb.TagNumber(12)
  void clearParticipantLeft() => clearField(12);
  @$pb.TagNumber(12)
  ParticipantLeft ensureParticipantLeft() => $_ensure(11);

  @$pb.TagNumber(13)
  BroadcastStarted get broadcastStarted => $_getN(12);
  @$pb.TagNumber(13)
  set broadcastStarted(BroadcastStarted v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasBroadcastStarted() => $_has(12);
  @$pb.TagNumber(13)
  void clearBroadcastStarted() => clearField(13);
  @$pb.TagNumber(13)
  BroadcastStarted ensureBroadcastStarted() => $_ensure(12);

  @$pb.TagNumber(14)
  BroadcastEnded get broadcastEnded => $_getN(13);
  @$pb.TagNumber(14)
  set broadcastEnded(BroadcastEnded v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasBroadcastEnded() => $_has(13);
  @$pb.TagNumber(14)
  void clearBroadcastEnded() => clearField(14);
  @$pb.TagNumber(14)
  BroadcastEnded ensureBroadcastEnded() => $_ensure(13);

  @$pb.TagNumber(15)
  AuthPayload get authPayload => $_getN(14);
  @$pb.TagNumber(15)
  set authPayload(AuthPayload v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasAuthPayload() => $_has(14);
  @$pb.TagNumber(15)
  void clearAuthPayload() => clearField(15);
  @$pb.TagNumber(15)
  AuthPayload ensureAuthPayload() => $_ensure(14);

  @$pb.TagNumber(16)
  AudioMuted get audioMuted => $_getN(15);
  @$pb.TagNumber(16)
  set audioMuted(AudioMuted v) { setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasAudioMuted() => $_has(15);
  @$pb.TagNumber(16)
  void clearAudioMuted() => clearField(16);
  @$pb.TagNumber(16)
  AudioMuted ensureAudioMuted() => $_ensure(15);

  @$pb.TagNumber(17)
  AudioUnmuted get audioUnmuted => $_getN(16);
  @$pb.TagNumber(17)
  set audioUnmuted(AudioUnmuted v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasAudioUnmuted() => $_has(16);
  @$pb.TagNumber(17)
  void clearAudioUnmuted() => clearField(17);
  @$pb.TagNumber(17)
  AudioUnmuted ensureAudioUnmuted() => $_ensure(16);

  @$pb.TagNumber(18)
  VideoStarted get videoStarted => $_getN(17);
  @$pb.TagNumber(18)
  set videoStarted(VideoStarted v) { setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasVideoStarted() => $_has(17);
  @$pb.TagNumber(18)
  void clearVideoStarted() => clearField(18);
  @$pb.TagNumber(18)
  VideoStarted ensureVideoStarted() => $_ensure(17);

  @$pb.TagNumber(19)
  VideoStopped get videoStopped => $_getN(18);
  @$pb.TagNumber(19)
  set videoStopped(VideoStopped v) { setField(19, v); }
  @$pb.TagNumber(19)
  $core.bool hasVideoStopped() => $_has(18);
  @$pb.TagNumber(19)
  void clearVideoStopped() => clearField(19);
  @$pb.TagNumber(19)
  VideoStopped ensureVideoStopped() => $_ensure(18);

  @$pb.TagNumber(20)
  ScreenshareStarted get screenshareStarted => $_getN(19);
  @$pb.TagNumber(20)
  set screenshareStarted(ScreenshareStarted v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasScreenshareStarted() => $_has(19);
  @$pb.TagNumber(20)
  void clearScreenshareStarted() => clearField(20);
  @$pb.TagNumber(20)
  ScreenshareStarted ensureScreenshareStarted() => $_ensure(19);

  @$pb.TagNumber(21)
  ScreenshareStopped get screenshareStopped => $_getN(20);
  @$pb.TagNumber(21)
  set screenshareStopped(ScreenshareStopped v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasScreenshareStopped() => $_has(20);
  @$pb.TagNumber(21)
  void clearScreenshareStopped() => clearField(21);
  @$pb.TagNumber(21)
  ScreenshareStopped ensureScreenshareStopped() => $_ensure(20);

  @$pb.TagNumber(22)
  RecordingStarted get recordingStarted => $_getN(21);
  @$pb.TagNumber(22)
  set recordingStarted(RecordingStarted v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasRecordingStarted() => $_has(21);
  @$pb.TagNumber(22)
  void clearRecordingStarted() => clearField(22);
  @$pb.TagNumber(22)
  RecordingStarted ensureRecordingStarted() => $_ensure(21);

  @$pb.TagNumber(23)
  RecordingStopped get recordingStopped => $_getN(22);
  @$pb.TagNumber(23)
  set recordingStopped(RecordingStopped v) { setField(23, v); }
  @$pb.TagNumber(23)
  $core.bool hasRecordingStopped() => $_has(22);
  @$pb.TagNumber(23)
  void clearRecordingStopped() => clearField(23);
  @$pb.TagNumber(23)
  RecordingStopped ensureRecordingStopped() => $_ensure(22);
}

class Healthcheck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Healthcheck', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'video')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audio')
    ..hasRequiredFields = false
  ;

  Healthcheck._() : super();
  factory Healthcheck({
    $core.String? userId,
    $core.String? clientId,
    $core.String? callType,
    $core.String? callId,
    $core.bool? video,
    $core.bool? audio,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (clientId != null) {
      _result.clientId = clientId;
    }
    if (callType != null) {
      _result.callType = callType;
    }
    if (callId != null) {
      _result.callId = callId;
    }
    if (video != null) {
      _result.video = video;
    }
    if (audio != null) {
      _result.audio = audio;
    }
    return _result;
  }
  factory Healthcheck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Healthcheck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Healthcheck clone() => Healthcheck()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Healthcheck copyWith(void Function(Healthcheck) updates) => super.copyWith((message) => updates(message as Healthcheck)) as Healthcheck; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Healthcheck create() => Healthcheck._();
  Healthcheck createEmptyInstance() => create();
  static $pb.PbList<Healthcheck> createRepeated() => $pb.PbList<Healthcheck>();
  @$core.pragma('dart2js:noInline')
  static Healthcheck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Healthcheck>(create);
  static Healthcheck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasClientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get callType => $_getSZ(2);
  @$pb.TagNumber(3)
  set callType($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCallType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCallType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get callId => $_getSZ(3);
  @$pb.TagNumber(4)
  set callId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCallId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCallId() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get video => $_getBF(4);
  @$pb.TagNumber(5)
  set video($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVideo() => $_has(4);
  @$pb.TagNumber(5)
  void clearVideo() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get audio => $_getBF(5);
  @$pb.TagNumber(6)
  set audio($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAudio() => $_has(5);
  @$pb.TagNumber(6)
  void clearAudio() => clearField(6);
}

class AuthPayload extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AuthPayload', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$5.CreateUserRequest>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', subBuilder: $5.CreateUserRequest.create)
    ..aOM<$3.DeviceRequest>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device', subBuilder: $3.DeviceRequest.create)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..hasRequiredFields = false
  ;

  AuthPayload._() : super();
  factory AuthPayload({
    $5.CreateUserRequest? user,
    $3.DeviceRequest? device,
    $core.String? token,
  }) {
    final _result = create();
    if (user != null) {
      _result.user = user;
    }
    if (device != null) {
      _result.device = device;
    }
    if (token != null) {
      _result.token = token;
    }
    return _result;
  }
  factory AuthPayload.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthPayload.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthPayload clone() => AuthPayload()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthPayload copyWith(void Function(AuthPayload) updates) => super.copyWith((message) => updates(message as AuthPayload)) as AuthPayload; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AuthPayload create() => AuthPayload._();
  AuthPayload createEmptyInstance() => create();
  static $pb.PbList<AuthPayload> createRepeated() => $pb.PbList<AuthPayload>();
  @$core.pragma('dart2js:noInline')
  static AuthPayload getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthPayload>(create);
  static AuthPayload? _defaultInstance;

  @$pb.TagNumber(1)
  $5.CreateUserRequest get user => $_getN(0);
  @$pb.TagNumber(1)
  set user($5.CreateUserRequest v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  $5.CreateUserRequest ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $3.DeviceRequest get device => $_getN(1);
  @$pb.TagNumber(2)
  set device($3.DeviceRequest v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDevice() => $_has(1);
  @$pb.TagNumber(2)
  void clearDevice() => clearField(2);
  @$pb.TagNumber(2)
  $3.DeviceRequest ensureDevice() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get token => $_getSZ(2);
  @$pb.TagNumber(3)
  set token($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearToken() => clearField(3);
}

class CallRinging extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallRinging', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..hasRequiredFields = false
  ;

  CallRinging._() : super();
  factory CallRinging({
    $3.Call? call,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    return _result;
  }
  factory CallRinging.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallRinging.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallRinging clone() => CallRinging()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallRinging copyWith(void Function(CallRinging) updates) => super.copyWith((message) => updates(message as CallRinging)) as CallRinging; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallRinging create() => CallRinging._();
  CallRinging createEmptyInstance() => create();
  static $pb.PbList<CallRinging> createRepeated() => $pb.PbList<CallRinging>();
  @$core.pragma('dart2js:noInline')
  static CallRinging getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallRinging>(create);
  static CallRinging? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);
}

class CallCreated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallCreated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..hasRequiredFields = false
  ;

  CallCreated._() : super();
  factory CallCreated({
    $3.Call? call,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    return _result;
  }
  factory CallCreated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallCreated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallCreated clone() => CallCreated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallCreated copyWith(void Function(CallCreated) updates) => super.copyWith((message) => updates(message as CallCreated)) as CallCreated; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallCreated create() => CallCreated._();
  CallCreated createEmptyInstance() => create();
  static $pb.PbList<CallCreated> createRepeated() => $pb.PbList<CallCreated>();
  @$core.pragma('dart2js:noInline')
  static CallCreated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallCreated>(create);
  static CallCreated? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);
}

class CallUpdated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallUpdated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..hasRequiredFields = false
  ;

  CallUpdated._() : super();
  factory CallUpdated({
    $3.Call? call,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    return _result;
  }
  factory CallUpdated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallUpdated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallUpdated clone() => CallUpdated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallUpdated copyWith(void Function(CallUpdated) updates) => super.copyWith((message) => updates(message as CallUpdated)) as CallUpdated; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallUpdated create() => CallUpdated._();
  CallUpdated createEmptyInstance() => create();
  static $pb.PbList<CallUpdated> createRepeated() => $pb.PbList<CallUpdated>();
  @$core.pragma('dart2js:noInline')
  static CallUpdated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallUpdated>(create);
  static CallUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);
}

class CallEnded extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallEnded', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..hasRequiredFields = false
  ;

  CallEnded._() : super();
  factory CallEnded({
    $3.Call? call,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
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
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);
}

class CallDeleted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallDeleted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..hasRequiredFields = false
  ;

  CallDeleted._() : super();
  factory CallDeleted({
    $3.Call? call,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    return _result;
  }
  factory CallDeleted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallDeleted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallDeleted clone() => CallDeleted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallDeleted copyWith(void Function(CallDeleted) updates) => super.copyWith((message) => updates(message as CallDeleted)) as CallDeleted; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallDeleted create() => CallDeleted._();
  CallDeleted createEmptyInstance() => create();
  static $pb.PbList<CallDeleted> createRepeated() => $pb.PbList<CallDeleted>();
  @$core.pragma('dart2js:noInline')
  static CallDeleted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallDeleted>(create);
  static CallDeleted? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);
}

enum AudioMuted_Target {
  userId, 
  allUsers, 
  notSet
}

class AudioMuted extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, AudioMuted_Target> _AudioMuted_TargetByTag = {
    2 : AudioMuted_Target.userId,
    3 : AudioMuted_Target.allUsers,
    0 : AudioMuted_Target.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioMuted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'allUsers')
    ..hasRequiredFields = false
  ;

  AudioMuted._() : super();
  factory AudioMuted({
    $3.Call? call,
    $core.String? userId,
    $core.bool? allUsers,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    if (allUsers != null) {
      _result.allUsers = allUsers;
    }
    return _result;
  }
  factory AudioMuted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioMuted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioMuted clone() => AudioMuted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioMuted copyWith(void Function(AudioMuted) updates) => super.copyWith((message) => updates(message as AudioMuted)) as AudioMuted; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AudioMuted create() => AudioMuted._();
  AudioMuted createEmptyInstance() => create();
  static $pb.PbList<AudioMuted> createRepeated() => $pb.PbList<AudioMuted>();
  @$core.pragma('dart2js:noInline')
  static AudioMuted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AudioMuted>(create);
  static AudioMuted? _defaultInstance;

  AudioMuted_Target whichTarget() => _AudioMuted_TargetByTag[$_whichOneof(0)]!;
  void clearTarget() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get allUsers => $_getBF(2);
  @$pb.TagNumber(3)
  set allUsers($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAllUsers() => $_has(2);
  @$pb.TagNumber(3)
  void clearAllUsers() => clearField(3);
}

class AudioUnmuted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AudioUnmuted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  AudioUnmuted._() : super();
  factory AudioUnmuted({
    $3.Call? call,
    $core.String? userId,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory AudioUnmuted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioUnmuted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioUnmuted clone() => AudioUnmuted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioUnmuted copyWith(void Function(AudioUnmuted) updates) => super.copyWith((message) => updates(message as AudioUnmuted)) as AudioUnmuted; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AudioUnmuted create() => AudioUnmuted._();
  AudioUnmuted createEmptyInstance() => create();
  static $pb.PbList<AudioUnmuted> createRepeated() => $pb.PbList<AudioUnmuted>();
  @$core.pragma('dart2js:noInline')
  static AudioUnmuted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AudioUnmuted>(create);
  static AudioUnmuted? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);
}

class VideoStarted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoStarted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  VideoStarted._() : super();
  factory VideoStarted({
    $3.Call? call,
    $core.String? userId,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory VideoStarted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoStarted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoStarted clone() => VideoStarted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoStarted copyWith(void Function(VideoStarted) updates) => super.copyWith((message) => updates(message as VideoStarted)) as VideoStarted; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoStarted create() => VideoStarted._();
  VideoStarted createEmptyInstance() => create();
  static $pb.PbList<VideoStarted> createRepeated() => $pb.PbList<VideoStarted>();
  @$core.pragma('dart2js:noInline')
  static VideoStarted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoStarted>(create);
  static VideoStarted? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);
}

class VideoStopped extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoStopped', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  VideoStopped._() : super();
  factory VideoStopped({
    $3.Call? call,
    $core.String? userId,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory VideoStopped.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoStopped.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoStopped clone() => VideoStopped()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoStopped copyWith(void Function(VideoStopped) updates) => super.copyWith((message) => updates(message as VideoStopped)) as VideoStopped; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoStopped create() => VideoStopped._();
  VideoStopped createEmptyInstance() => create();
  static $pb.PbList<VideoStopped> createRepeated() => $pb.PbList<VideoStopped>();
  @$core.pragma('dart2js:noInline')
  static VideoStopped getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoStopped>(create);
  static VideoStopped? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);
}

class ScreenshareStarted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScreenshareStarted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  ScreenshareStarted._() : super();
  factory ScreenshareStarted({
    $3.Call? call,
    $core.String? userId,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory ScreenshareStarted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScreenshareStarted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScreenshareStarted clone() => ScreenshareStarted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScreenshareStarted copyWith(void Function(ScreenshareStarted) updates) => super.copyWith((message) => updates(message as ScreenshareStarted)) as ScreenshareStarted; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScreenshareStarted create() => ScreenshareStarted._();
  ScreenshareStarted createEmptyInstance() => create();
  static $pb.PbList<ScreenshareStarted> createRepeated() => $pb.PbList<ScreenshareStarted>();
  @$core.pragma('dart2js:noInline')
  static ScreenshareStarted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScreenshareStarted>(create);
  static ScreenshareStarted? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);
}

class ScreenshareStopped extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScreenshareStopped', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  ScreenshareStopped._() : super();
  factory ScreenshareStopped({
    $3.Call? call,
    $core.String? userId,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory ScreenshareStopped.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScreenshareStopped.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScreenshareStopped clone() => ScreenshareStopped()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScreenshareStopped copyWith(void Function(ScreenshareStopped) updates) => super.copyWith((message) => updates(message as ScreenshareStopped)) as ScreenshareStopped; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScreenshareStopped create() => ScreenshareStopped._();
  ScreenshareStopped createEmptyInstance() => create();
  static $pb.PbList<ScreenshareStopped> createRepeated() => $pb.PbList<ScreenshareStopped>();
  @$core.pragma('dart2js:noInline')
  static ScreenshareStopped getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScreenshareStopped>(create);
  static ScreenshareStopped? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);
}

class RecordingStarted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecordingStarted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..hasRequiredFields = false
  ;

  RecordingStarted._() : super();
  factory RecordingStarted({
    $3.Call? call,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    return _result;
  }
  factory RecordingStarted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecordingStarted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecordingStarted clone() => RecordingStarted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecordingStarted copyWith(void Function(RecordingStarted) updates) => super.copyWith((message) => updates(message as RecordingStarted)) as RecordingStarted; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RecordingStarted create() => RecordingStarted._();
  RecordingStarted createEmptyInstance() => create();
  static $pb.PbList<RecordingStarted> createRepeated() => $pb.PbList<RecordingStarted>();
  @$core.pragma('dart2js:noInline')
  static RecordingStarted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecordingStarted>(create);
  static RecordingStarted? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);
}

class RecordingStopped extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecordingStopped', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..hasRequiredFields = false
  ;

  RecordingStopped._() : super();
  factory RecordingStopped({
    $3.Call? call,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    return _result;
  }
  factory RecordingStopped.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecordingStopped.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecordingStopped clone() => RecordingStopped()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecordingStopped copyWith(void Function(RecordingStopped) updates) => super.copyWith((message) => updates(message as RecordingStopped)) as RecordingStopped; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RecordingStopped create() => RecordingStopped._();
  RecordingStopped createEmptyInstance() => create();
  static $pb.PbList<RecordingStopped> createRepeated() => $pb.PbList<RecordingStopped>();
  @$core.pragma('dart2js:noInline')
  static RecordingStopped getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecordingStopped>(create);
  static RecordingStopped? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);
}

class UserUpdated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UserUpdated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', subBuilder: $3.User.create)
    ..hasRequiredFields = false
  ;

  UserUpdated._() : super();
  factory UserUpdated({
    $3.User? user,
  }) {
    final _result = create();
    if (user != null) {
      _result.user = user;
    }
    return _result;
  }
  factory UserUpdated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserUpdated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserUpdated clone() => UserUpdated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserUpdated copyWith(void Function(UserUpdated) updates) => super.copyWith((message) => updates(message as UserUpdated)) as UserUpdated; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UserUpdated create() => UserUpdated._();
  UserUpdated createEmptyInstance() => create();
  static $pb.PbList<UserUpdated> createRepeated() => $pb.PbList<UserUpdated>();
  @$core.pragma('dart2js:noInline')
  static UserUpdated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserUpdated>(create);
  static UserUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  $3.User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user($3.User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  $3.User ensureUser() => $_ensure(0);
}

class ParticipantInvited extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantInvited', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOM<$3.Participant>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $3.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantInvited._() : super();
  factory ParticipantInvited({
    $3.Call? call,
    $3.Participant? participant,
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
  factory ParticipantInvited.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParticipantInvited.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParticipantInvited clone() => ParticipantInvited()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParticipantInvited copyWith(void Function(ParticipantInvited) updates) => super.copyWith((message) => updates(message as ParticipantInvited)) as ParticipantInvited; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ParticipantInvited create() => ParticipantInvited._();
  ParticipantInvited createEmptyInstance() => create();
  static $pb.PbList<ParticipantInvited> createRepeated() => $pb.PbList<ParticipantInvited>();
  @$core.pragma('dart2js:noInline')
  static ParticipantInvited getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParticipantInvited>(create);
  static ParticipantInvited? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $3.Participant get participant => $_getN(1);
  @$pb.TagNumber(2)
  set participant($3.Participant v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasParticipant() => $_has(1);
  @$pb.TagNumber(2)
  void clearParticipant() => clearField(2);
  @$pb.TagNumber(2)
  $3.Participant ensureParticipant() => $_ensure(1);
}

class ParticipantUpdated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantUpdated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOM<$3.Participant>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $3.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantUpdated._() : super();
  factory ParticipantUpdated({
    $3.Call? call,
    $3.Participant? participant,
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
  factory ParticipantUpdated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParticipantUpdated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParticipantUpdated clone() => ParticipantUpdated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParticipantUpdated copyWith(void Function(ParticipantUpdated) updates) => super.copyWith((message) => updates(message as ParticipantUpdated)) as ParticipantUpdated; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ParticipantUpdated create() => ParticipantUpdated._();
  ParticipantUpdated createEmptyInstance() => create();
  static $pb.PbList<ParticipantUpdated> createRepeated() => $pb.PbList<ParticipantUpdated>();
  @$core.pragma('dart2js:noInline')
  static ParticipantUpdated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParticipantUpdated>(create);
  static ParticipantUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $3.Participant get participant => $_getN(1);
  @$pb.TagNumber(2)
  set participant($3.Participant v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasParticipant() => $_has(1);
  @$pb.TagNumber(2)
  void clearParticipant() => clearField(2);
  @$pb.TagNumber(2)
  $3.Participant ensureParticipant() => $_ensure(1);
}

class ParticipantDeleted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantDeleted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  ParticipantDeleted._() : super();
  factory ParticipantDeleted({
    $3.Call? call,
    $core.String? userId,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory ParticipantDeleted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParticipantDeleted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParticipantDeleted clone() => ParticipantDeleted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParticipantDeleted copyWith(void Function(ParticipantDeleted) updates) => super.copyWith((message) => updates(message as ParticipantDeleted)) as ParticipantDeleted; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ParticipantDeleted create() => ParticipantDeleted._();
  ParticipantDeleted createEmptyInstance() => create();
  static $pb.PbList<ParticipantDeleted> createRepeated() => $pb.PbList<ParticipantDeleted>();
  @$core.pragma('dart2js:noInline')
  static ParticipantDeleted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParticipantDeleted>(create);
  static ParticipantDeleted? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);
}

class ParticipantJoined extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantJoined', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOM<$3.Participant>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $3.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantJoined._() : super();
  factory ParticipantJoined({
    $3.Call? call,
    $3.Participant? participant,
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
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $3.Participant get participant => $_getN(1);
  @$pb.TagNumber(2)
  set participant($3.Participant v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasParticipant() => $_has(1);
  @$pb.TagNumber(2)
  void clearParticipant() => clearField(2);
  @$pb.TagNumber(2)
  $3.Participant ensureParticipant() => $_ensure(1);
}

class ParticipantLeft extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantLeft', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOM<$3.Participant>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $3.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantLeft._() : super();
  factory ParticipantLeft({
    $3.Call? call,
    $3.Participant? participant,
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
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $3.Participant get participant => $_getN(1);
  @$pb.TagNumber(2)
  set participant($3.Participant v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasParticipant() => $_has(1);
  @$pb.TagNumber(2)
  void clearParticipant() => clearField(2);
  @$pb.TagNumber(2)
  $3.Participant ensureParticipant() => $_ensure(1);
}

class BroadcastStarted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastStarted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..hasRequiredFields = false
  ;

  BroadcastStarted._() : super();
  factory BroadcastStarted({
    $3.Call? call,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    return _result;
  }
  factory BroadcastStarted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BroadcastStarted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BroadcastStarted clone() => BroadcastStarted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BroadcastStarted copyWith(void Function(BroadcastStarted) updates) => super.copyWith((message) => updates(message as BroadcastStarted)) as BroadcastStarted; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BroadcastStarted create() => BroadcastStarted._();
  BroadcastStarted createEmptyInstance() => create();
  static $pb.PbList<BroadcastStarted> createRepeated() => $pb.PbList<BroadcastStarted>();
  @$core.pragma('dart2js:noInline')
  static BroadcastStarted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BroadcastStarted>(create);
  static BroadcastStarted? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);
}

class BroadcastEnded extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastEnded', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..hasRequiredFields = false
  ;

  BroadcastEnded._() : super();
  factory BroadcastEnded({
    $3.Call? call,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    return _result;
  }
  factory BroadcastEnded.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BroadcastEnded.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BroadcastEnded clone() => BroadcastEnded()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BroadcastEnded copyWith(void Function(BroadcastEnded) updates) => super.copyWith((message) => updates(message as BroadcastEnded)) as BroadcastEnded; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BroadcastEnded create() => BroadcastEnded._();
  BroadcastEnded createEmptyInstance() => create();
  static $pb.PbList<BroadcastEnded> createRepeated() => $pb.PbList<BroadcastEnded>();
  @$core.pragma('dart2js:noInline')
  static BroadcastEnded getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BroadcastEnded>(create);
  static BroadcastEnded? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.Call ensureCall() => $_ensure(0);
}

