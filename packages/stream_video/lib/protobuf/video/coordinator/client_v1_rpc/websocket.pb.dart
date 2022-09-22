///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/websocket.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../event_v1/event.pb.dart' as $10;
import '../user_v1/user.pb.dart' as $1;
import '../call_v1/call.pb.dart' as $0;
import '../push_v1/push.pb.dart' as $6;

enum WebsocketEvent_Event {
  healthcheck, 
  callCreated, 
  callUpdated, 
  callDeleted, 
  callMembersUpdated, 
  callMembersDeleted, 
  callStarted, 
  callEnded, 
  userUpdated, 
  notSet
}

class WebsocketEvent extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, WebsocketEvent_Event> _WebsocketEvent_EventByTag = {
    20 : WebsocketEvent_Event.healthcheck,
    30 : WebsocketEvent_Event.callCreated,
    31 : WebsocketEvent_Event.callUpdated,
    32 : WebsocketEvent_Event.callDeleted,
    33 : WebsocketEvent_Event.callMembersUpdated,
    34 : WebsocketEvent_Event.callMembersDeleted,
    35 : WebsocketEvent_Event.callStarted,
    36 : WebsocketEvent_Event.callEnded,
    40 : WebsocketEvent_Event.userUpdated,
    0 : WebsocketEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WebsocketEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..oo(0, [20, 30, 31, 32, 33, 34, 35, 36, 40])
    ..m<$core.String, $1.User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'users', entryClassName: 'WebsocketEvent.UsersEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $1.User.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..m<$core.String, $0.Call>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calls', entryClassName: 'WebsocketEvent.CallsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $0.Call.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..m<$core.String, $0.CallDetails>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callDetails', entryClassName: 'WebsocketEvent.CallDetailsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $0.CallDetails.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..aOM<WebsocketHealthcheck>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'healthcheck', subBuilder: WebsocketHealthcheck.create)
    ..aOM<$10.CallCreated>(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCreated', subBuilder: $10.CallCreated.create)
    ..aOM<$10.CallUpdated>(31, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callUpdated', subBuilder: $10.CallUpdated.create)
    ..aOM<$10.CallDeleted>(32, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callDeleted', subBuilder: $10.CallDeleted.create)
    ..aOM<$10.CallMembersUpdated>(33, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callMembersUpdated', subBuilder: $10.CallMembersUpdated.create)
    ..aOM<$10.CallMembersDeleted>(34, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callMembersDeleted', subBuilder: $10.CallMembersDeleted.create)
    ..aOM<$10.CallStarted>(35, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callStarted', subBuilder: $10.CallStarted.create)
    ..aOM<$10.CallEnded>(36, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callEnded', subBuilder: $10.CallEnded.create)
    ..aOM<$10.UserUpdated>(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userUpdated', subBuilder: $10.UserUpdated.create)
    ..hasRequiredFields = false
  ;

  WebsocketEvent._() : super();
  factory WebsocketEvent({
    $core.Map<$core.String, $1.User>? users,
    $core.Map<$core.String, $0.Call>? calls,
    $core.Map<$core.String, $0.CallDetails>? callDetails,
    WebsocketHealthcheck? healthcheck,
    $10.CallCreated? callCreated,
    $10.CallUpdated? callUpdated,
    $10.CallDeleted? callDeleted,
    $10.CallMembersUpdated? callMembersUpdated,
    $10.CallMembersDeleted? callMembersDeleted,
    $10.CallStarted? callStarted,
    $10.CallEnded? callEnded,
    $10.UserUpdated? userUpdated,
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
    if (callDeleted != null) {
      _result.callDeleted = callDeleted;
    }
    if (callMembersUpdated != null) {
      _result.callMembersUpdated = callMembersUpdated;
    }
    if (callMembersDeleted != null) {
      _result.callMembersDeleted = callMembersDeleted;
    }
    if (callStarted != null) {
      _result.callStarted = callStarted;
    }
    if (callEnded != null) {
      _result.callEnded = callEnded;
    }
    if (userUpdated != null) {
      _result.userUpdated = userUpdated;
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

  @$pb.TagNumber(30)
  $10.CallCreated get callCreated => $_getN(4);
  @$pb.TagNumber(30)
  set callCreated($10.CallCreated v) { setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasCallCreated() => $_has(4);
  @$pb.TagNumber(30)
  void clearCallCreated() => clearField(30);
  @$pb.TagNumber(30)
  $10.CallCreated ensureCallCreated() => $_ensure(4);

  @$pb.TagNumber(31)
  $10.CallUpdated get callUpdated => $_getN(5);
  @$pb.TagNumber(31)
  set callUpdated($10.CallUpdated v) { setField(31, v); }
  @$pb.TagNumber(31)
  $core.bool hasCallUpdated() => $_has(5);
  @$pb.TagNumber(31)
  void clearCallUpdated() => clearField(31);
  @$pb.TagNumber(31)
  $10.CallUpdated ensureCallUpdated() => $_ensure(5);

  @$pb.TagNumber(32)
  $10.CallDeleted get callDeleted => $_getN(6);
  @$pb.TagNumber(32)
  set callDeleted($10.CallDeleted v) { setField(32, v); }
  @$pb.TagNumber(32)
  $core.bool hasCallDeleted() => $_has(6);
  @$pb.TagNumber(32)
  void clearCallDeleted() => clearField(32);
  @$pb.TagNumber(32)
  $10.CallDeleted ensureCallDeleted() => $_ensure(6);

  @$pb.TagNumber(33)
  $10.CallMembersUpdated get callMembersUpdated => $_getN(7);
  @$pb.TagNumber(33)
  set callMembersUpdated($10.CallMembersUpdated v) { setField(33, v); }
  @$pb.TagNumber(33)
  $core.bool hasCallMembersUpdated() => $_has(7);
  @$pb.TagNumber(33)
  void clearCallMembersUpdated() => clearField(33);
  @$pb.TagNumber(33)
  $10.CallMembersUpdated ensureCallMembersUpdated() => $_ensure(7);

  @$pb.TagNumber(34)
  $10.CallMembersDeleted get callMembersDeleted => $_getN(8);
  @$pb.TagNumber(34)
  set callMembersDeleted($10.CallMembersDeleted v) { setField(34, v); }
  @$pb.TagNumber(34)
  $core.bool hasCallMembersDeleted() => $_has(8);
  @$pb.TagNumber(34)
  void clearCallMembersDeleted() => clearField(34);
  @$pb.TagNumber(34)
  $10.CallMembersDeleted ensureCallMembersDeleted() => $_ensure(8);

  @$pb.TagNumber(35)
  $10.CallStarted get callStarted => $_getN(9);
  @$pb.TagNumber(35)
  set callStarted($10.CallStarted v) { setField(35, v); }
  @$pb.TagNumber(35)
  $core.bool hasCallStarted() => $_has(9);
  @$pb.TagNumber(35)
  void clearCallStarted() => clearField(35);
  @$pb.TagNumber(35)
  $10.CallStarted ensureCallStarted() => $_ensure(9);

  @$pb.TagNumber(36)
  $10.CallEnded get callEnded => $_getN(10);
  @$pb.TagNumber(36)
  set callEnded($10.CallEnded v) { setField(36, v); }
  @$pb.TagNumber(36)
  $core.bool hasCallEnded() => $_has(10);
  @$pb.TagNumber(36)
  void clearCallEnded() => clearField(36);
  @$pb.TagNumber(36)
  $10.CallEnded ensureCallEnded() => $_ensure(10);

  @$pb.TagNumber(40)
  $10.UserUpdated get userUpdated => $_getN(11);
  @$pb.TagNumber(40)
  set userUpdated($10.UserUpdated v) { setField(40, v); }
  @$pb.TagNumber(40)
  $core.bool hasUserUpdated() => $_has(11);
  @$pb.TagNumber(40)
  void clearUserUpdated() => clearField(40);
  @$pb.TagNumber(40)
  $10.UserUpdated ensureUserUpdated() => $_ensure(11);
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
    ..aOM<$6.DeviceInput>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device', subBuilder: $6.DeviceInput.create)
    ..hasRequiredFields = false
  ;

  WebsocketAuthRequest._() : super();
  factory WebsocketAuthRequest({
    $core.String? apiKey,
    $core.String? token,
    $1.UserInput? user,
    $6.DeviceInput? device,
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
  $6.DeviceInput get device => $_getN(3);
  @$pb.TagNumber(4)
  set device($6.DeviceInput v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasDevice() => $_has(3);
  @$pb.TagNumber(4)
  void clearDevice() => clearField(4);
  @$pb.TagNumber(4)
  $6.DeviceInput ensureDevice() => $_ensure(3);
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

