///
//  Generated code. Do not modify.
//  source: video_events/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

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
    0 : WebsocketEvent_EventPayload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WebsocketEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
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
}

class Healthcheck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Healthcheck', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientId')
    ..hasRequiredFields = false
  ;

  Healthcheck._() : super();
  factory Healthcheck({
    $core.String? userId,
    $core.String? clientId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (clientId != null) {
      _result.clientId = clientId;
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
}

class AuthPayload extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AuthPayload', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.UserRequest>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', subBuilder: $3.UserRequest.create)
    ..aOM<$3.DeviceRequest>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device', subBuilder: $3.DeviceRequest.create)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..hasRequiredFields = false
  ;

  AuthPayload._() : super();
  factory AuthPayload({
    $3.UserRequest? user,
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
  $3.UserRequest get user => $_getN(0);
  @$pb.TagNumber(1)
  set user($3.UserRequest v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  $3.UserRequest ensureUser() => $_ensure(0);

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
    ..aOM<$3.Participant>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $3.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantInvited._() : super();
  factory ParticipantInvited({
    $3.Participant? participant,
  }) {
    final _result = create();
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
  $3.Participant get participant => $_getN(0);
  @$pb.TagNumber(1)
  set participant($3.Participant v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasParticipant() => $_has(0);
  @$pb.TagNumber(1)
  void clearParticipant() => clearField(1);
  @$pb.TagNumber(1)
  $3.Participant ensureParticipant() => $_ensure(0);
}

class ParticipantUpdated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantUpdated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Participant>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $3.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantUpdated._() : super();
  factory ParticipantUpdated({
    $3.Participant? participant,
  }) {
    final _result = create();
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
  $3.Participant get participant => $_getN(0);
  @$pb.TagNumber(1)
  set participant($3.Participant v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasParticipant() => $_has(0);
  @$pb.TagNumber(1)
  void clearParticipant() => clearField(1);
  @$pb.TagNumber(1)
  $3.Participant ensureParticipant() => $_ensure(0);
}

class ParticipantDeleted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantDeleted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  ParticipantDeleted._() : super();
  factory ParticipantDeleted({
    $core.String? userId,
  }) {
    final _result = create();
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
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);
}

class ParticipantJoined extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantJoined', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Participant>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $3.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantJoined._() : super();
  factory ParticipantJoined({
    $3.Participant? participant,
  }) {
    final _result = create();
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
  $3.Participant get participant => $_getN(0);
  @$pb.TagNumber(1)
  set participant($3.Participant v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasParticipant() => $_has(0);
  @$pb.TagNumber(1)
  void clearParticipant() => clearField(1);
  @$pb.TagNumber(1)
  $3.Participant ensureParticipant() => $_ensure(0);
}

class ParticipantLeft extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantLeft', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Participant>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $3.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantLeft._() : super();
  factory ParticipantLeft({
    $3.Participant? participant,
  }) {
    final _result = create();
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
  $3.Participant get participant => $_getN(0);
  @$pb.TagNumber(1)
  set participant($3.Participant v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasParticipant() => $_has(0);
  @$pb.TagNumber(1)
  void clearParticipant() => clearField(1);
  @$pb.TagNumber(1)
  $3.Participant ensureParticipant() => $_ensure(0);
}

class BroadcastStarted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastStarted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Broadcast>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcast', subBuilder: $3.Broadcast.create)
    ..hasRequiredFields = false
  ;

  BroadcastStarted._() : super();
  factory BroadcastStarted({
    $3.Broadcast? broadcast,
  }) {
    final _result = create();
    if (broadcast != null) {
      _result.broadcast = broadcast;
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
  $3.Broadcast get broadcast => $_getN(0);
  @$pb.TagNumber(1)
  set broadcast($3.Broadcast v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBroadcast() => $_has(0);
  @$pb.TagNumber(1)
  void clearBroadcast() => clearField(1);
  @$pb.TagNumber(1)
  $3.Broadcast ensureBroadcast() => $_ensure(0);
}

class BroadcastEnded extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastEnded', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Broadcast>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcast', subBuilder: $3.Broadcast.create)
    ..hasRequiredFields = false
  ;

  BroadcastEnded._() : super();
  factory BroadcastEnded({
    $3.Broadcast? broadcast,
  }) {
    final _result = create();
    if (broadcast != null) {
      _result.broadcast = broadcast;
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
  $3.Broadcast get broadcast => $_getN(0);
  @$pb.TagNumber(1)
  set broadcast($3.Broadcast v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBroadcast() => $_has(0);
  @$pb.TagNumber(1)
  void clearBroadcast() => clearField(1);
  @$pb.TagNumber(1)
  $3.Broadcast ensureBroadcast() => $_ensure(0);
}

