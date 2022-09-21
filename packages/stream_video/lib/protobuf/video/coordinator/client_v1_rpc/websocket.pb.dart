///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/websocket.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../event_v1/event.pb.dart' as $12;
import '../user_v1/user.pb.dart' as $1;
import '../call_v1/call.pb.dart' as $0;
import '../push_v1/push.pb.dart' as $9;

enum WebsocketEvent_Event {
  healthcheck, 
  callCreated, 
  callUpdated, 
  callEnded, 
  callDeleted, 
  callRinging, 
  userUpdated, 
  broadcastStarted, 
  broadcastEnded, 
  recordingStarted, 
  recordingStopped, 
  callMembersUpdated, 
  callMembersDeleted, 
  notSet
}

class WebsocketEvent extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, WebsocketEvent_Event> _WebsocketEvent_EventByTag = {
    20 : WebsocketEvent_Event.healthcheck,
    21 : WebsocketEvent_Event.callCreated,
    22 : WebsocketEvent_Event.callUpdated,
    23 : WebsocketEvent_Event.callEnded,
    24 : WebsocketEvent_Event.callDeleted,
    25 : WebsocketEvent_Event.callRinging,
    26 : WebsocketEvent_Event.userUpdated,
    27 : WebsocketEvent_Event.broadcastStarted,
    28 : WebsocketEvent_Event.broadcastEnded,
    29 : WebsocketEvent_Event.recordingStarted,
    30 : WebsocketEvent_Event.recordingStopped,
    31 : WebsocketEvent_Event.callMembersUpdated,
    32 : WebsocketEvent_Event.callMembersDeleted,
    0 : WebsocketEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WebsocketEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..oo(0, [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32])
    ..m<$core.String, $1.User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'users', entryClassName: 'WebsocketEvent.UsersEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $1.User.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..m<$core.String, $0.Call>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calls', entryClassName: 'WebsocketEvent.CallsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $0.Call.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..m<$core.String, $0.CallDetails>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callDetails', entryClassName: 'WebsocketEvent.CallDetailsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $0.CallDetails.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..aOM<WebsocketHealthcheck>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'healthcheck', subBuilder: WebsocketHealthcheck.create)
    ..aOM<$12.CallCreated>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCreated', subBuilder: $12.CallCreated.create)
    ..aOM<$12.CallUpdated>(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callUpdated', subBuilder: $12.CallUpdated.create)
    ..aOM<$12.CallEnded>(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callEnded', subBuilder: $12.CallEnded.create)
    ..aOM<$12.CallDeleted>(24, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callDeleted', subBuilder: $12.CallDeleted.create)
    ..aOM<$12.CallRinging>(25, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callRinging', subBuilder: $12.CallRinging.create)
    ..aOM<$12.UserUpdated>(26, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userUpdated', subBuilder: $12.UserUpdated.create)
    ..aOM<$12.BroadcastStarted>(27, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcastStarted', subBuilder: $12.BroadcastStarted.create)
    ..aOM<$12.BroadcastEnded>(28, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcastEnded', subBuilder: $12.BroadcastEnded.create)
    ..aOM<$12.RecordingStarted>(29, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recordingStarted', subBuilder: $12.RecordingStarted.create)
    ..aOM<$12.RecordingStopped>(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recordingStopped', subBuilder: $12.RecordingStopped.create)
    ..aOM<$12.CallMembersUpdated>(31, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callMembersUpdated', subBuilder: $12.CallMembersUpdated.create)
    ..aOM<$12.CallMembersDeleted>(32, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callMembersDeleted', subBuilder: $12.CallMembersDeleted.create)
    ..hasRequiredFields = false
  ;

  WebsocketEvent._() : super();
  factory WebsocketEvent({
    $core.Map<$core.String, $1.User>? users,
    $core.Map<$core.String, $0.Call>? calls,
    $core.Map<$core.String, $0.CallDetails>? callDetails,
    WebsocketHealthcheck? healthcheck,
    $12.CallCreated? callCreated,
    $12.CallUpdated? callUpdated,
    $12.CallEnded? callEnded,
    $12.CallDeleted? callDeleted,
    $12.CallRinging? callRinging,
    $12.UserUpdated? userUpdated,
    $12.BroadcastStarted? broadcastStarted,
    $12.BroadcastEnded? broadcastEnded,
    $12.RecordingStarted? recordingStarted,
    $12.RecordingStopped? recordingStopped,
    $12.CallMembersUpdated? callMembersUpdated,
    $12.CallMembersDeleted? callMembersDeleted,
  }) {
    final _result = create();
    if (users != null) {
      _result.users.addAll(users);
    }
    if (calls != null) {
      _result.calls.addAll(calls);
    }
    if (callDetails != null) {
      _result.callDetails.addAll(callDetails);
    }
    if (healthcheck != null) {
      _result.healthcheck = healthcheck;
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
    if (callRinging != null) {
      _result.callRinging = callRinging;
    }
    if (userUpdated != null) {
      _result.userUpdated = userUpdated;
    }
    if (broadcastStarted != null) {
      _result.broadcastStarted = broadcastStarted;
    }
    if (broadcastEnded != null) {
      _result.broadcastEnded = broadcastEnded;
    }
    if (recordingStarted != null) {
      _result.recordingStarted = recordingStarted;
    }
    if (recordingStopped != null) {
      _result.recordingStopped = recordingStopped;
    }
    if (callMembersUpdated != null) {
      _result.callMembersUpdated = callMembersUpdated;
    }
    if (callMembersDeleted != null) {
      _result.callMembersDeleted = callMembersDeleted;
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

  WebsocketEvent_Event whichEvent() => _WebsocketEvent_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.Map<$core.String, $1.User> get users => $_getMap(0);

  @$pb.TagNumber(2)
  $core.Map<$core.String, $0.Call> get calls => $_getMap(1);

  @$pb.TagNumber(3)
  $core.Map<$core.String, $0.CallDetails> get callDetails => $_getMap(2);

  @$pb.TagNumber(20)
  WebsocketHealthcheck get healthcheck => $_getN(3);
  @$pb.TagNumber(20)
  set healthcheck(WebsocketHealthcheck v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasHealthcheck() => $_has(3);
  @$pb.TagNumber(20)
  void clearHealthcheck() => clearField(20);
  @$pb.TagNumber(20)
  WebsocketHealthcheck ensureHealthcheck() => $_ensure(3);

  @$pb.TagNumber(21)
  $12.CallCreated get callCreated => $_getN(4);
  @$pb.TagNumber(21)
  set callCreated($12.CallCreated v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasCallCreated() => $_has(4);
  @$pb.TagNumber(21)
  void clearCallCreated() => clearField(21);
  @$pb.TagNumber(21)
  $12.CallCreated ensureCallCreated() => $_ensure(4);

  @$pb.TagNumber(22)
  $12.CallUpdated get callUpdated => $_getN(5);
  @$pb.TagNumber(22)
  set callUpdated($12.CallUpdated v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasCallUpdated() => $_has(5);
  @$pb.TagNumber(22)
  void clearCallUpdated() => clearField(22);
  @$pb.TagNumber(22)
  $12.CallUpdated ensureCallUpdated() => $_ensure(5);

  @$pb.TagNumber(23)
  $12.CallEnded get callEnded => $_getN(6);
  @$pb.TagNumber(23)
  set callEnded($12.CallEnded v) { setField(23, v); }
  @$pb.TagNumber(23)
  $core.bool hasCallEnded() => $_has(6);
  @$pb.TagNumber(23)
  void clearCallEnded() => clearField(23);
  @$pb.TagNumber(23)
  $12.CallEnded ensureCallEnded() => $_ensure(6);

  @$pb.TagNumber(24)
  $12.CallDeleted get callDeleted => $_getN(7);
  @$pb.TagNumber(24)
  set callDeleted($12.CallDeleted v) { setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasCallDeleted() => $_has(7);
  @$pb.TagNumber(24)
  void clearCallDeleted() => clearField(24);
  @$pb.TagNumber(24)
  $12.CallDeleted ensureCallDeleted() => $_ensure(7);

  @$pb.TagNumber(25)
  $12.CallRinging get callRinging => $_getN(8);
  @$pb.TagNumber(25)
  set callRinging($12.CallRinging v) { setField(25, v); }
  @$pb.TagNumber(25)
  $core.bool hasCallRinging() => $_has(8);
  @$pb.TagNumber(25)
  void clearCallRinging() => clearField(25);
  @$pb.TagNumber(25)
  $12.CallRinging ensureCallRinging() => $_ensure(8);

  @$pb.TagNumber(26)
  $12.UserUpdated get userUpdated => $_getN(9);
  @$pb.TagNumber(26)
  set userUpdated($12.UserUpdated v) { setField(26, v); }
  @$pb.TagNumber(26)
  $core.bool hasUserUpdated() => $_has(9);
  @$pb.TagNumber(26)
  void clearUserUpdated() => clearField(26);
  @$pb.TagNumber(26)
  $12.UserUpdated ensureUserUpdated() => $_ensure(9);

  @$pb.TagNumber(27)
  $12.BroadcastStarted get broadcastStarted => $_getN(10);
  @$pb.TagNumber(27)
  set broadcastStarted($12.BroadcastStarted v) { setField(27, v); }
  @$pb.TagNumber(27)
  $core.bool hasBroadcastStarted() => $_has(10);
  @$pb.TagNumber(27)
  void clearBroadcastStarted() => clearField(27);
  @$pb.TagNumber(27)
  $12.BroadcastStarted ensureBroadcastStarted() => $_ensure(10);

  @$pb.TagNumber(28)
  $12.BroadcastEnded get broadcastEnded => $_getN(11);
  @$pb.TagNumber(28)
  set broadcastEnded($12.BroadcastEnded v) { setField(28, v); }
  @$pb.TagNumber(28)
  $core.bool hasBroadcastEnded() => $_has(11);
  @$pb.TagNumber(28)
  void clearBroadcastEnded() => clearField(28);
  @$pb.TagNumber(28)
  $12.BroadcastEnded ensureBroadcastEnded() => $_ensure(11);

  @$pb.TagNumber(29)
  $12.RecordingStarted get recordingStarted => $_getN(12);
  @$pb.TagNumber(29)
  set recordingStarted($12.RecordingStarted v) { setField(29, v); }
  @$pb.TagNumber(29)
  $core.bool hasRecordingStarted() => $_has(12);
  @$pb.TagNumber(29)
  void clearRecordingStarted() => clearField(29);
  @$pb.TagNumber(29)
  $12.RecordingStarted ensureRecordingStarted() => $_ensure(12);

  @$pb.TagNumber(30)
  $12.RecordingStopped get recordingStopped => $_getN(13);
  @$pb.TagNumber(30)
  set recordingStopped($12.RecordingStopped v) { setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasRecordingStopped() => $_has(13);
  @$pb.TagNumber(30)
  void clearRecordingStopped() => clearField(30);
  @$pb.TagNumber(30)
  $12.RecordingStopped ensureRecordingStopped() => $_ensure(13);

  @$pb.TagNumber(31)
  $12.CallMembersUpdated get callMembersUpdated => $_getN(14);
  @$pb.TagNumber(31)
  set callMembersUpdated($12.CallMembersUpdated v) { setField(31, v); }
  @$pb.TagNumber(31)
  $core.bool hasCallMembersUpdated() => $_has(14);
  @$pb.TagNumber(31)
  void clearCallMembersUpdated() => clearField(31);
  @$pb.TagNumber(31)
  $12.CallMembersUpdated ensureCallMembersUpdated() => $_ensure(14);

  @$pb.TagNumber(32)
  $12.CallMembersDeleted get callMembersDeleted => $_getN(15);
  @$pb.TagNumber(32)
  set callMembersDeleted($12.CallMembersDeleted v) { setField(32, v); }
  @$pb.TagNumber(32)
  $core.bool hasCallMembersDeleted() => $_has(15);
  @$pb.TagNumber(32)
  void clearCallMembersDeleted() => clearField(32);
  @$pb.TagNumber(32)
  $12.CallMembersDeleted ensureCallMembersDeleted() => $_ensure(15);
}

enum WebsocketClientEvent_Event {
  healthcheck, 
  authRequest, 
  notSet
}

class WebsocketClientEvent extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, WebsocketClientEvent_Event> _WebsocketClientEvent_EventByTag = {
    1 : WebsocketClientEvent_Event.healthcheck,
    2 : WebsocketClientEvent_Event.authRequest,
    0 : WebsocketClientEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WebsocketClientEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<WebsocketHealthcheck>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'healthcheck', subBuilder: WebsocketHealthcheck.create)
    ..aOM<WebsocketAuthRequest>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'authRequest', subBuilder: WebsocketAuthRequest.create)
    ..hasRequiredFields = false
  ;

  WebsocketClientEvent._() : super();
  factory WebsocketClientEvent({
    WebsocketHealthcheck? healthcheck,
    WebsocketAuthRequest? authRequest,
  }) {
    final _result = create();
    if (healthcheck != null) {
      _result.healthcheck = healthcheck;
    }
    if (authRequest != null) {
      _result.authRequest = authRequest;
    }
    return _result;
  }
  factory WebsocketClientEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WebsocketClientEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WebsocketClientEvent clone() => WebsocketClientEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WebsocketClientEvent copyWith(void Function(WebsocketClientEvent) updates) => super.copyWith((message) => updates(message as WebsocketClientEvent)) as WebsocketClientEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WebsocketClientEvent create() => WebsocketClientEvent._();
  WebsocketClientEvent createEmptyInstance() => create();
  static $pb.PbList<WebsocketClientEvent> createRepeated() => $pb.PbList<WebsocketClientEvent>();
  @$core.pragma('dart2js:noInline')
  static WebsocketClientEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WebsocketClientEvent>(create);
  static WebsocketClientEvent? _defaultInstance;

  WebsocketClientEvent_Event whichEvent() => _WebsocketClientEvent_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  WebsocketHealthcheck get healthcheck => $_getN(0);
  @$pb.TagNumber(1)
  set healthcheck(WebsocketHealthcheck v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHealthcheck() => $_has(0);
  @$pb.TagNumber(1)
  void clearHealthcheck() => clearField(1);
  @$pb.TagNumber(1)
  WebsocketHealthcheck ensureHealthcheck() => $_ensure(0);

  @$pb.TagNumber(2)
  WebsocketAuthRequest get authRequest => $_getN(1);
  @$pb.TagNumber(2)
  set authRequest(WebsocketAuthRequest v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthRequest() => clearField(2);
  @$pb.TagNumber(2)
  WebsocketAuthRequest ensureAuthRequest() => $_ensure(1);
}

class WebsocketAuthRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WebsocketAuthRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'apiKey')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..aOM<$1.UserInput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', subBuilder: $1.UserInput.create)
    ..aOM<$9.DeviceInput>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device', subBuilder: $9.DeviceInput.create)
    ..hasRequiredFields = false
  ;

  WebsocketAuthRequest._() : super();
  factory WebsocketAuthRequest({
    $core.String? apiKey,
    $core.String? token,
    $1.UserInput? user,
    $9.DeviceInput? device,
  }) {
    final _result = create();
    if (apiKey != null) {
      _result.apiKey = apiKey;
    }
    if (token != null) {
      _result.token = token;
    }
    if (user != null) {
      _result.user = user;
    }
    if (device != null) {
      _result.device = device;
    }
    return _result;
  }
  factory WebsocketAuthRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WebsocketAuthRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WebsocketAuthRequest clone() => WebsocketAuthRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WebsocketAuthRequest copyWith(void Function(WebsocketAuthRequest) updates) => super.copyWith((message) => updates(message as WebsocketAuthRequest)) as WebsocketAuthRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WebsocketAuthRequest create() => WebsocketAuthRequest._();
  WebsocketAuthRequest createEmptyInstance() => create();
  static $pb.PbList<WebsocketAuthRequest> createRepeated() => $pb.PbList<WebsocketAuthRequest>();
  @$core.pragma('dart2js:noInline')
  static WebsocketAuthRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WebsocketAuthRequest>(create);
  static WebsocketAuthRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get apiKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set apiKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasApiKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearApiKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $1.UserInput get user => $_getN(2);
  @$pb.TagNumber(3)
  set user($1.UserInput v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearUser() => clearField(3);
  @$pb.TagNumber(3)
  $1.UserInput ensureUser() => $_ensure(2);

  @$pb.TagNumber(4)
  $9.DeviceInput get device => $_getN(3);
  @$pb.TagNumber(4)
  set device($9.DeviceInput v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasDevice() => $_has(3);
  @$pb.TagNumber(4)
  void clearDevice() => clearField(4);
  @$pb.TagNumber(4)
  $9.DeviceInput ensureDevice() => $_ensure(3);
}

class WebsocketHealthcheck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WebsocketHealthcheck', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'video')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audio')
    ..hasRequiredFields = false
  ;

  WebsocketHealthcheck._() : super();
  factory WebsocketHealthcheck({
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
  factory WebsocketHealthcheck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WebsocketHealthcheck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WebsocketHealthcheck clone() => WebsocketHealthcheck()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WebsocketHealthcheck copyWith(void Function(WebsocketHealthcheck) updates) => super.copyWith((message) => updates(message as WebsocketHealthcheck)) as WebsocketHealthcheck; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WebsocketHealthcheck create() => WebsocketHealthcheck._();
  WebsocketHealthcheck createEmptyInstance() => create();
  static $pb.PbList<WebsocketHealthcheck> createRepeated() => $pb.PbList<WebsocketHealthcheck>();
  @$core.pragma('dart2js:noInline')
  static WebsocketHealthcheck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WebsocketHealthcheck>(create);
  static WebsocketHealthcheck? _defaultInstance;

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

