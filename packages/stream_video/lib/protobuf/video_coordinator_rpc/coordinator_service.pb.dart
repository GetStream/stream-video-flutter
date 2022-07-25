///
//  Generated code. Do not modify.
//  source: video_coordinator_rpc/coordinator_service.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../video_models/models.pb.dart' as $3;
import '../google/protobuf/struct.pb.dart' as $2;
import '../google/protobuf/wrappers.pb.dart' as $4;

import 'coordinator_service.pbenum.dart';

export 'coordinator_service.pbenum.dart';

class GetCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..hasRequiredFields = false
  ;

  GetCallRequest._() : super();
  factory GetCallRequest({
    $core.String? id,
    $core.String? type,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (type != null) {
      _result.type = type;
    }
    return _result;
  }
  factory GetCallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCallRequest clone() => GetCallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCallRequest copyWith(void Function(GetCallRequest) updates) => super.copyWith((message) => updates(message as GetCallRequest)) as GetCallRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCallRequest create() => GetCallRequest._();
  GetCallRequest createEmptyInstance() => create();
  static $pb.PbList<GetCallRequest> createRepeated() => $pb.PbList<GetCallRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCallRequest>(create);
  static GetCallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);
}

class GetCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOM<$3.CallState>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callState', subBuilder: $3.CallState.create)
    ..hasRequiredFields = false
  ;

  GetCallResponse._() : super();
  factory GetCallResponse({
    $3.Call? call,
    $3.CallState? callState,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (callState != null) {
      _result.callState = callState;
    }
    return _result;
  }
  factory GetCallResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCallResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCallResponse clone() => GetCallResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCallResponse copyWith(void Function(GetCallResponse) updates) => super.copyWith((message) => updates(message as GetCallResponse)) as GetCallResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCallResponse create() => GetCallResponse._();
  GetCallResponse createEmptyInstance() => create();
  static $pb.PbList<GetCallResponse> createRepeated() => $pb.PbList<GetCallResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCallResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCallResponse>(create);
  static GetCallResponse? _defaultInstance;

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
  $3.CallState get callState => $_getN(1);
  @$pb.TagNumber(2)
  set callState($3.CallState v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCallState() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallState() => clearField(2);
  @$pb.TagNumber(2)
  $3.CallState ensureCallState() => $_ensure(1);
}

class CreateOrUpdateCallsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateOrUpdateCallsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..pc<CreateCallRequest>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calls', $pb.PbFieldType.PM, subBuilder: CreateCallRequest.create)
    ..hasRequiredFields = false
  ;

  CreateOrUpdateCallsRequest._() : super();
  factory CreateOrUpdateCallsRequest({
    $core.Iterable<CreateCallRequest>? calls,
  }) {
    final _result = create();
    if (calls != null) {
      _result.calls.addAll(calls);
    }
    return _result;
  }
  factory CreateOrUpdateCallsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateOrUpdateCallsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateOrUpdateCallsRequest clone() => CreateOrUpdateCallsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateOrUpdateCallsRequest copyWith(void Function(CreateOrUpdateCallsRequest) updates) => super.copyWith((message) => updates(message as CreateOrUpdateCallsRequest)) as CreateOrUpdateCallsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateOrUpdateCallsRequest create() => CreateOrUpdateCallsRequest._();
  CreateOrUpdateCallsRequest createEmptyInstance() => create();
  static $pb.PbList<CreateOrUpdateCallsRequest> createRepeated() => $pb.PbList<CreateOrUpdateCallsRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateOrUpdateCallsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateOrUpdateCallsRequest>(create);
  static CreateOrUpdateCallsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<CreateCallRequest> get calls => $_getList(0);
}

class CreateOrUpdateCallsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateOrUpdateCallsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..pc<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calls', $pb.PbFieldType.PM, subBuilder: $3.Call.create)
    ..hasRequiredFields = false
  ;

  CreateOrUpdateCallsResponse._() : super();
  factory CreateOrUpdateCallsResponse({
    $core.Iterable<$3.Call>? calls,
  }) {
    final _result = create();
    if (calls != null) {
      _result.calls.addAll(calls);
    }
    return _result;
  }
  factory CreateOrUpdateCallsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateOrUpdateCallsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateOrUpdateCallsResponse clone() => CreateOrUpdateCallsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateOrUpdateCallsResponse copyWith(void Function(CreateOrUpdateCallsResponse) updates) => super.copyWith((message) => updates(message as CreateOrUpdateCallsResponse)) as CreateOrUpdateCallsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateOrUpdateCallsResponse create() => CreateOrUpdateCallsResponse._();
  CreateOrUpdateCallsResponse createEmptyInstance() => create();
  static $pb.PbList<CreateOrUpdateCallsResponse> createRepeated() => $pb.PbList<CreateOrUpdateCallsResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateOrUpdateCallsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateOrUpdateCallsResponse>(create);
  static CreateOrUpdateCallsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.Call> get calls => $_getList(0);
}

class CreateCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOM<$2.Struct>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'custom', subBuilder: $2.Struct.create)
    ..pPS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantIds')
    ..aOM<$4.BoolValue>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hlsBroadcast', subBuilder: $4.BoolValue.create)
    ..aOM<$3.RTMPOptions>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rtmp', subBuilder: $3.RTMPOptions.create)
    ..aOM<$4.BoolValue>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transcribe', subBuilder: $4.BoolValue.create)
    ..aOM<$3.TranscribeOptions>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transcribeOptions', subBuilder: $3.TranscribeOptions.create)
    ..aOM<$4.BoolValue>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recording', subBuilder: $4.BoolValue.create)
    ..aOM<$4.BoolValue>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notify', subBuilder: $4.BoolValue.create)
    ..hasRequiredFields = false
  ;

  CreateCallRequest._() : super();
  factory CreateCallRequest({
    $core.String? type,
    $core.String? id,
    $2.Struct? custom,
    $core.Iterable<$core.String>? participantIds,
    $4.BoolValue? hlsBroadcast,
    $3.RTMPOptions? rtmp,
    $4.BoolValue? transcribe,
    $3.TranscribeOptions? transcribeOptions,
    $4.BoolValue? recording,
    $4.BoolValue? notify,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (id != null) {
      _result.id = id;
    }
    if (custom != null) {
      _result.custom = custom;
    }
    if (participantIds != null) {
      _result.participantIds.addAll(participantIds);
    }
    if (hlsBroadcast != null) {
      _result.hlsBroadcast = hlsBroadcast;
    }
    if (rtmp != null) {
      _result.rtmp = rtmp;
    }
    if (transcribe != null) {
      _result.transcribe = transcribe;
    }
    if (transcribeOptions != null) {
      _result.transcribeOptions = transcribeOptions;
    }
    if (recording != null) {
      _result.recording = recording;
    }
    if (notify != null) {
      _result.notify = notify;
    }
    return _result;
  }
  factory CreateCallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateCallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateCallRequest clone() => CreateCallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateCallRequest copyWith(void Function(CreateCallRequest) updates) => super.copyWith((message) => updates(message as CreateCallRequest)) as CreateCallRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateCallRequest create() => CreateCallRequest._();
  CreateCallRequest createEmptyInstance() => create();
  static $pb.PbList<CreateCallRequest> createRepeated() => $pb.PbList<CreateCallRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateCallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateCallRequest>(create);
  static CreateCallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $2.Struct get custom => $_getN(2);
  @$pb.TagNumber(3)
  set custom($2.Struct v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCustom() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustom() => clearField(3);
  @$pb.TagNumber(3)
  $2.Struct ensureCustom() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<$core.String> get participantIds => $_getList(3);

  @$pb.TagNumber(6)
  $4.BoolValue get hlsBroadcast => $_getN(4);
  @$pb.TagNumber(6)
  set hlsBroadcast($4.BoolValue v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasHlsBroadcast() => $_has(4);
  @$pb.TagNumber(6)
  void clearHlsBroadcast() => clearField(6);
  @$pb.TagNumber(6)
  $4.BoolValue ensureHlsBroadcast() => $_ensure(4);

  @$pb.TagNumber(7)
  $3.RTMPOptions get rtmp => $_getN(5);
  @$pb.TagNumber(7)
  set rtmp($3.RTMPOptions v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasRtmp() => $_has(5);
  @$pb.TagNumber(7)
  void clearRtmp() => clearField(7);
  @$pb.TagNumber(7)
  $3.RTMPOptions ensureRtmp() => $_ensure(5);

  @$pb.TagNumber(8)
  $4.BoolValue get transcribe => $_getN(6);
  @$pb.TagNumber(8)
  set transcribe($4.BoolValue v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasTranscribe() => $_has(6);
  @$pb.TagNumber(8)
  void clearTranscribe() => clearField(8);
  @$pb.TagNumber(8)
  $4.BoolValue ensureTranscribe() => $_ensure(6);

  @$pb.TagNumber(9)
  $3.TranscribeOptions get transcribeOptions => $_getN(7);
  @$pb.TagNumber(9)
  set transcribeOptions($3.TranscribeOptions v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasTranscribeOptions() => $_has(7);
  @$pb.TagNumber(9)
  void clearTranscribeOptions() => clearField(9);
  @$pb.TagNumber(9)
  $3.TranscribeOptions ensureTranscribeOptions() => $_ensure(7);

  @$pb.TagNumber(10)
  $4.BoolValue get recording => $_getN(8);
  @$pb.TagNumber(10)
  set recording($4.BoolValue v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasRecording() => $_has(8);
  @$pb.TagNumber(10)
  void clearRecording() => clearField(10);
  @$pb.TagNumber(10)
  $4.BoolValue ensureRecording() => $_ensure(8);

  @$pb.TagNumber(11)
  $4.BoolValue get notify => $_getN(9);
  @$pb.TagNumber(11)
  set notify($4.BoolValue v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasNotify() => $_has(9);
  @$pb.TagNumber(11)
  void clearNotify() => clearField(11);
  @$pb.TagNumber(11)
  $4.BoolValue ensureNotify() => $_ensure(9);
}

class CreateCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..hasRequiredFields = false
  ;

  CreateCallResponse._() : super();
  factory CreateCallResponse({
    $3.Call? call,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    return _result;
  }
  factory CreateCallResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateCallResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateCallResponse clone() => CreateCallResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateCallResponse copyWith(void Function(CreateCallResponse) updates) => super.copyWith((message) => updates(message as CreateCallResponse)) as CreateCallResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateCallResponse create() => CreateCallResponse._();
  CreateCallResponse createEmptyInstance() => create();
  static $pb.PbList<CreateCallResponse> createRepeated() => $pb.PbList<CreateCallResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateCallResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateCallResponse>(create);
  static CreateCallResponse? _defaultInstance;

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

class UpdateCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'jsonEncodedCustomData', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  UpdateCallRequest._() : super();
  factory UpdateCallRequest({
    $core.String? id,
    $core.String? type,
    $core.List<$core.int>? jsonEncodedCustomData,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (type != null) {
      _result.type = type;
    }
    if (jsonEncodedCustomData != null) {
      _result.jsonEncodedCustomData = jsonEncodedCustomData;
    }
    return _result;
  }
  factory UpdateCallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateCallRequest clone() => UpdateCallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateCallRequest copyWith(void Function(UpdateCallRequest) updates) => super.copyWith((message) => updates(message as UpdateCallRequest)) as UpdateCallRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCallRequest create() => UpdateCallRequest._();
  UpdateCallRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateCallRequest> createRepeated() => $pb.PbList<UpdateCallRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateCallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCallRequest>(create);
  static UpdateCallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get jsonEncodedCustomData => $_getN(2);
  @$pb.TagNumber(3)
  set jsonEncodedCustomData($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasJsonEncodedCustomData() => $_has(2);
  @$pb.TagNumber(3)
  void clearJsonEncodedCustomData() => clearField(3);
}

class UpdateCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..hasRequiredFields = false
  ;

  UpdateCallResponse._() : super();
  factory UpdateCallResponse({
    $3.Call? call,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    return _result;
  }
  factory UpdateCallResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCallResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateCallResponse clone() => UpdateCallResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateCallResponse copyWith(void Function(UpdateCallResponse) updates) => super.copyWith((message) => updates(message as UpdateCallResponse)) as UpdateCallResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCallResponse create() => UpdateCallResponse._();
  UpdateCallResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateCallResponse> createRepeated() => $pb.PbList<UpdateCallResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateCallResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCallResponse>(create);
  static UpdateCallResponse? _defaultInstance;

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

class DeleteCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  DeleteCallRequest._() : super();
  factory DeleteCallRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory DeleteCallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteCallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteCallRequest clone() => DeleteCallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteCallRequest copyWith(void Function(DeleteCallRequest) updates) => super.copyWith((message) => updates(message as DeleteCallRequest)) as DeleteCallRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteCallRequest create() => DeleteCallRequest._();
  DeleteCallRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteCallRequest> createRepeated() => $pb.PbList<DeleteCallRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteCallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteCallRequest>(create);
  static DeleteCallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class DeleteCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  DeleteCallResponse._() : super();
  factory DeleteCallResponse() => create();
  factory DeleteCallResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteCallResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteCallResponse clone() => DeleteCallResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteCallResponse copyWith(void Function(DeleteCallResponse) updates) => super.copyWith((message) => updates(message as DeleteCallResponse)) as DeleteCallResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteCallResponse create() => DeleteCallResponse._();
  DeleteCallResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteCallResponse> createRepeated() => $pb.PbList<DeleteCallResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteCallResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteCallResponse>(create);
  static DeleteCallResponse? _defaultInstance;
}

class SelectEdgeServerRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SelectEdgeServerRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..m<$core.String, $3.Latency>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latencyByEdge', entryClassName: 'SelectEdgeServerRequest.LatencyByEdgeEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $3.Latency.create, packageName: const $pb.PackageName('stream.video'))
    ..hasRequiredFields = false
  ;

  SelectEdgeServerRequest._() : super();
  factory SelectEdgeServerRequest({
    $core.String? callType,
    $core.String? callId,
    $core.Map<$core.String, $3.Latency>? latencyByEdge,
  }) {
    final _result = create();
    if (callType != null) {
      _result.callType = callType;
    }
    if (callId != null) {
      _result.callId = callId;
    }
    if (latencyByEdge != null) {
      _result.latencyByEdge.addAll(latencyByEdge);
    }
    return _result;
  }
  factory SelectEdgeServerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SelectEdgeServerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SelectEdgeServerRequest clone() => SelectEdgeServerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SelectEdgeServerRequest copyWith(void Function(SelectEdgeServerRequest) updates) => super.copyWith((message) => updates(message as SelectEdgeServerRequest)) as SelectEdgeServerRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SelectEdgeServerRequest create() => SelectEdgeServerRequest._();
  SelectEdgeServerRequest createEmptyInstance() => create();
  static $pb.PbList<SelectEdgeServerRequest> createRepeated() => $pb.PbList<SelectEdgeServerRequest>();
  @$core.pragma('dart2js:noInline')
  static SelectEdgeServerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SelectEdgeServerRequest>(create);
  static SelectEdgeServerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callType => $_getSZ(0);
  @$pb.TagNumber(1)
  set callType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get callId => $_getSZ(1);
  @$pb.TagNumber(2)
  set callId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallId() => clearField(2);

  @$pb.TagNumber(3)
  $core.Map<$core.String, $3.Latency> get latencyByEdge => $_getMap(2);
}

class SelectEdgeServerResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SelectEdgeServerResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.EdgeServer>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'edgeServer', subBuilder: $3.EdgeServer.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..hasRequiredFields = false
  ;

  SelectEdgeServerResponse._() : super();
  factory SelectEdgeServerResponse({
    $3.EdgeServer? edgeServer,
    $core.String? token,
  }) {
    final _result = create();
    if (edgeServer != null) {
      _result.edgeServer = edgeServer;
    }
    if (token != null) {
      _result.token = token;
    }
    return _result;
  }
  factory SelectEdgeServerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SelectEdgeServerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SelectEdgeServerResponse clone() => SelectEdgeServerResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SelectEdgeServerResponse copyWith(void Function(SelectEdgeServerResponse) updates) => super.copyWith((message) => updates(message as SelectEdgeServerResponse)) as SelectEdgeServerResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SelectEdgeServerResponse create() => SelectEdgeServerResponse._();
  SelectEdgeServerResponse createEmptyInstance() => create();
  static $pb.PbList<SelectEdgeServerResponse> createRepeated() => $pb.PbList<SelectEdgeServerResponse>();
  @$core.pragma('dart2js:noInline')
  static SelectEdgeServerResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SelectEdgeServerResponse>(create);
  static SelectEdgeServerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $3.EdgeServer get edgeServer => $_getN(0);
  @$pb.TagNumber(1)
  set edgeServer($3.EdgeServer v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasEdgeServer() => $_has(0);
  @$pb.TagNumber(1)
  void clearEdgeServer() => clearField(1);
  @$pb.TagNumber(1)
  $3.EdgeServer ensureEdgeServer() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);
}

class AddDeviceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddDeviceRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pushProviderName')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  AddDeviceRequest._() : super();
  factory AddDeviceRequest({
    $core.String? id,
    $core.String? pushProviderName,
    $core.String? userId,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (pushProviderName != null) {
      _result.pushProviderName = pushProviderName;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory AddDeviceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddDeviceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddDeviceRequest clone() => AddDeviceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddDeviceRequest copyWith(void Function(AddDeviceRequest) updates) => super.copyWith((message) => updates(message as AddDeviceRequest)) as AddDeviceRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddDeviceRequest create() => AddDeviceRequest._();
  AddDeviceRequest createEmptyInstance() => create();
  static $pb.PbList<AddDeviceRequest> createRepeated() => $pb.PbList<AddDeviceRequest>();
  @$core.pragma('dart2js:noInline')
  static AddDeviceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddDeviceRequest>(create);
  static AddDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get pushProviderName => $_getSZ(1);
  @$pb.TagNumber(2)
  set pushProviderName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPushProviderName() => $_has(1);
  @$pb.TagNumber(2)
  void clearPushProviderName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => clearField(3);
}

class AddDeviceResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddDeviceResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Device>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device', subBuilder: $3.Device.create)
    ..hasRequiredFields = false
  ;

  AddDeviceResponse._() : super();
  factory AddDeviceResponse({
    $3.Device? device,
  }) {
    final _result = create();
    if (device != null) {
      _result.device = device;
    }
    return _result;
  }
  factory AddDeviceResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddDeviceResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddDeviceResponse clone() => AddDeviceResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddDeviceResponse copyWith(void Function(AddDeviceResponse) updates) => super.copyWith((message) => updates(message as AddDeviceResponse)) as AddDeviceResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddDeviceResponse create() => AddDeviceResponse._();
  AddDeviceResponse createEmptyInstance() => create();
  static $pb.PbList<AddDeviceResponse> createRepeated() => $pb.PbList<AddDeviceResponse>();
  @$core.pragma('dart2js:noInline')
  static AddDeviceResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddDeviceResponse>(create);
  static AddDeviceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Device get device => $_getN(0);
  @$pb.TagNumber(1)
  set device($3.Device v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => clearField(1);
  @$pb.TagNumber(1)
  $3.Device ensureDevice() => $_ensure(0);
}

class RemoveDeviceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemoveDeviceRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  RemoveDeviceRequest._() : super();
  factory RemoveDeviceRequest({
    $core.String? id,
    $core.String? userId,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory RemoveDeviceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveDeviceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveDeviceRequest clone() => RemoveDeviceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveDeviceRequest copyWith(void Function(RemoveDeviceRequest) updates) => super.copyWith((message) => updates(message as RemoveDeviceRequest)) as RemoveDeviceRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemoveDeviceRequest create() => RemoveDeviceRequest._();
  RemoveDeviceRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveDeviceRequest> createRepeated() => $pb.PbList<RemoveDeviceRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveDeviceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveDeviceRequest>(create);
  static RemoveDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);
}

class RemoveDeviceResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemoveDeviceResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  RemoveDeviceResponse._() : super();
  factory RemoveDeviceResponse() => create();
  factory RemoveDeviceResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveDeviceResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveDeviceResponse clone() => RemoveDeviceResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveDeviceResponse copyWith(void Function(RemoveDeviceResponse) updates) => super.copyWith((message) => updates(message as RemoveDeviceResponse)) as RemoveDeviceResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemoveDeviceResponse create() => RemoveDeviceResponse._();
  RemoveDeviceResponse createEmptyInstance() => create();
  static $pb.PbList<RemoveDeviceResponse> createRepeated() => $pb.PbList<RemoveDeviceResponse>();
  @$core.pragma('dart2js:noInline')
  static RemoveDeviceResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveDeviceResponse>(create);
  static RemoveDeviceResponse? _defaultInstance;
}

class ListDevicesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListDevicesRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  ListDevicesRequest._() : super();
  factory ListDevicesRequest({
    $core.String? userId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory ListDevicesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListDevicesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListDevicesRequest clone() => ListDevicesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListDevicesRequest copyWith(void Function(ListDevicesRequest) updates) => super.copyWith((message) => updates(message as ListDevicesRequest)) as ListDevicesRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListDevicesRequest create() => ListDevicesRequest._();
  ListDevicesRequest createEmptyInstance() => create();
  static $pb.PbList<ListDevicesRequest> createRepeated() => $pb.PbList<ListDevicesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListDevicesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDevicesRequest>(create);
  static ListDevicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);
}

class ListDevicesResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListDevicesResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..pc<$3.Device>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'devices', $pb.PbFieldType.PM, subBuilder: $3.Device.create)
    ..hasRequiredFields = false
  ;

  ListDevicesResponse._() : super();
  factory ListDevicesResponse({
    $core.Iterable<$3.Device>? devices,
  }) {
    final _result = create();
    if (devices != null) {
      _result.devices.addAll(devices);
    }
    return _result;
  }
  factory ListDevicesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListDevicesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListDevicesResponse clone() => ListDevicesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListDevicesResponse copyWith(void Function(ListDevicesResponse) updates) => super.copyWith((message) => updates(message as ListDevicesResponse)) as ListDevicesResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListDevicesResponse create() => ListDevicesResponse._();
  ListDevicesResponse createEmptyInstance() => create();
  static $pb.PbList<ListDevicesResponse> createRepeated() => $pb.PbList<ListDevicesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListDevicesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDevicesResponse>(create);
  static ListDevicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.Device> get devices => $_getList(0);
}

class CreateUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateUserRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  CreateUserRequest._() : super();
  factory CreateUserRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory CreateUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateUserRequest clone() => CreateUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateUserRequest copyWith(void Function(CreateUserRequest) updates) => super.copyWith((message) => updates(message as CreateUserRequest)) as CreateUserRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateUserRequest create() => CreateUserRequest._();
  CreateUserRequest createEmptyInstance() => create();
  static $pb.PbList<CreateUserRequest> createRepeated() => $pb.PbList<CreateUserRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateUserRequest>(create);
  static CreateUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class CreateOrUpdateUsersRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateOrUpdateUsersRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..pc<CreateUserRequest>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'users', $pb.PbFieldType.PM, subBuilder: CreateUserRequest.create)
    ..hasRequiredFields = false
  ;

  CreateOrUpdateUsersRequest._() : super();
  factory CreateOrUpdateUsersRequest({
    $core.Iterable<CreateUserRequest>? users,
  }) {
    final _result = create();
    if (users != null) {
      _result.users.addAll(users);
    }
    return _result;
  }
  factory CreateOrUpdateUsersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateOrUpdateUsersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateOrUpdateUsersRequest clone() => CreateOrUpdateUsersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateOrUpdateUsersRequest copyWith(void Function(CreateOrUpdateUsersRequest) updates) => super.copyWith((message) => updates(message as CreateOrUpdateUsersRequest)) as CreateOrUpdateUsersRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateOrUpdateUsersRequest create() => CreateOrUpdateUsersRequest._();
  CreateOrUpdateUsersRequest createEmptyInstance() => create();
  static $pb.PbList<CreateOrUpdateUsersRequest> createRepeated() => $pb.PbList<CreateOrUpdateUsersRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateOrUpdateUsersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateOrUpdateUsersRequest>(create);
  static CreateOrUpdateUsersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<CreateUserRequest> get users => $_getList(0);
}

class CreateOrUpdateUsersResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateOrUpdateUsersResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..pc<$3.User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'users', $pb.PbFieldType.PM, subBuilder: $3.User.create)
    ..hasRequiredFields = false
  ;

  CreateOrUpdateUsersResponse._() : super();
  factory CreateOrUpdateUsersResponse({
    $core.Iterable<$3.User>? users,
  }) {
    final _result = create();
    if (users != null) {
      _result.users.addAll(users);
    }
    return _result;
  }
  factory CreateOrUpdateUsersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateOrUpdateUsersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateOrUpdateUsersResponse clone() => CreateOrUpdateUsersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateOrUpdateUsersResponse copyWith(void Function(CreateOrUpdateUsersResponse) updates) => super.copyWith((message) => updates(message as CreateOrUpdateUsersResponse)) as CreateOrUpdateUsersResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateOrUpdateUsersResponse create() => CreateOrUpdateUsersResponse._();
  CreateOrUpdateUsersResponse createEmptyInstance() => create();
  static $pb.PbList<CreateOrUpdateUsersResponse> createRepeated() => $pb.PbList<CreateOrUpdateUsersResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateOrUpdateUsersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateOrUpdateUsersResponse>(create);
  static CreateOrUpdateUsersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.User> get users => $_getList(0);
}

class DeleteUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteUserRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  DeleteUserRequest._() : super();
  factory DeleteUserRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory DeleteUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteUserRequest clone() => DeleteUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteUserRequest copyWith(void Function(DeleteUserRequest) updates) => super.copyWith((message) => updates(message as DeleteUserRequest)) as DeleteUserRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteUserRequest create() => DeleteUserRequest._();
  DeleteUserRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteUserRequest> createRepeated() => $pb.PbList<DeleteUserRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteUserRequest>(create);
  static DeleteUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class ExportUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ExportUserRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  ExportUserRequest._() : super();
  factory ExportUserRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory ExportUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportUserRequest clone() => ExportUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportUserRequest copyWith(void Function(ExportUserRequest) updates) => super.copyWith((message) => updates(message as ExportUserRequest)) as ExportUserRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ExportUserRequest create() => ExportUserRequest._();
  ExportUserRequest createEmptyInstance() => create();
  static $pb.PbList<ExportUserRequest> createRepeated() => $pb.PbList<ExportUserRequest>();
  @$core.pragma('dart2js:noInline')
  static ExportUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportUserRequest>(create);
  static ExportUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class ExportUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ExportUserResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  ExportUserResponse._() : super();
  factory ExportUserResponse({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory ExportUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportUserResponse clone() => ExportUserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportUserResponse copyWith(void Function(ExportUserResponse) updates) => super.copyWith((message) => updates(message as ExportUserResponse)) as ExportUserResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ExportUserResponse create() => ExportUserResponse._();
  ExportUserResponse createEmptyInstance() => create();
  static $pb.PbList<ExportUserResponse> createRepeated() => $pb.PbList<ExportUserResponse>();
  @$core.pragma('dart2js:noInline')
  static ExportUserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportUserResponse>(create);
  static ExportUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class DeleteUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteUserResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  DeleteUserResponse._() : super();
  factory DeleteUserResponse({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory DeleteUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteUserResponse clone() => DeleteUserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteUserResponse copyWith(void Function(DeleteUserResponse) updates) => super.copyWith((message) => updates(message as DeleteUserResponse)) as DeleteUserResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteUserResponse create() => DeleteUserResponse._();
  DeleteUserResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteUserResponse> createRepeated() => $pb.PbList<DeleteUserResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteUserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteUserResponse>(create);
  static DeleteUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class CreateUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateUserResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', subBuilder: $3.User.create)
    ..hasRequiredFields = false
  ;

  CreateUserResponse._() : super();
  factory CreateUserResponse({
    $3.User? user,
  }) {
    final _result = create();
    if (user != null) {
      _result.user = user;
    }
    return _result;
  }
  factory CreateUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateUserResponse clone() => CreateUserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateUserResponse copyWith(void Function(CreateUserResponse) updates) => super.copyWith((message) => updates(message as CreateUserResponse)) as CreateUserResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateUserResponse create() => CreateUserResponse._();
  CreateUserResponse createEmptyInstance() => create();
  static $pb.PbList<CreateUserResponse> createRepeated() => $pb.PbList<CreateUserResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateUserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateUserResponse>(create);
  static CreateUserResponse? _defaultInstance;

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

class SendCustomEventRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendCustomEventRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  SendCustomEventRequest._() : super();
  factory SendCustomEventRequest({
    $core.String? type,
    $core.List<$core.int>? data,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (data != null) {
      _result.data = data;
    }
    return _result;
  }
  factory SendCustomEventRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SendCustomEventRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SendCustomEventRequest clone() => SendCustomEventRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SendCustomEventRequest copyWith(void Function(SendCustomEventRequest) updates) => super.copyWith((message) => updates(message as SendCustomEventRequest)) as SendCustomEventRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SendCustomEventRequest create() => SendCustomEventRequest._();
  SendCustomEventRequest createEmptyInstance() => create();
  static $pb.PbList<SendCustomEventRequest> createRepeated() => $pb.PbList<SendCustomEventRequest>();
  @$core.pragma('dart2js:noInline')
  static SendCustomEventRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendCustomEventRequest>(create);
  static SendCustomEventRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
}

class SendCustomEventResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendCustomEventResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  SendCustomEventResponse._() : super();
  factory SendCustomEventResponse() => create();
  factory SendCustomEventResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SendCustomEventResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SendCustomEventResponse clone() => SendCustomEventResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SendCustomEventResponse copyWith(void Function(SendCustomEventResponse) updates) => super.copyWith((message) => updates(message as SendCustomEventResponse)) as SendCustomEventResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SendCustomEventResponse create() => SendCustomEventResponse._();
  SendCustomEventResponse createEmptyInstance() => create();
  static $pb.PbList<SendCustomEventResponse> createRepeated() => $pb.PbList<SendCustomEventResponse>();
  @$core.pragma('dart2js:noInline')
  static SendCustomEventResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendCustomEventResponse>(create);
  static SendCustomEventResponse? _defaultInstance;
}

class JoinCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..hasRequiredFields = false
  ;

  JoinCallRequest._() : super();
  factory JoinCallRequest({
    $core.String? id,
    $core.String? type,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (type != null) {
      _result.type = type;
    }
    return _result;
  }
  factory JoinCallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinCallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinCallRequest clone() => JoinCallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinCallRequest copyWith(void Function(JoinCallRequest) updates) => super.copyWith((message) => updates(message as JoinCallRequest)) as JoinCallRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static JoinCallRequest create() => JoinCallRequest._();
  JoinCallRequest createEmptyInstance() => create();
  static $pb.PbList<JoinCallRequest> createRepeated() => $pb.PbList<JoinCallRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinCallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinCallRequest>(create);
  static JoinCallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);
}

class UserCapability extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UserCapability', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'action')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..hasRequiredFields = false
  ;

  UserCapability._() : super();
  factory UserCapability({
    $core.String? action,
    $core.String? description,
  }) {
    final _result = create();
    if (action != null) {
      _result.action = action;
    }
    if (description != null) {
      _result.description = description;
    }
    return _result;
  }
  factory UserCapability.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserCapability.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserCapability clone() => UserCapability()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserCapability copyWith(void Function(UserCapability) updates) => super.copyWith((message) => updates(message as UserCapability)) as UserCapability; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UserCapability create() => UserCapability._();
  UserCapability createEmptyInstance() => create();
  static $pb.PbList<UserCapability> createRepeated() => $pb.PbList<UserCapability>();
  @$core.pragma('dart2js:noInline')
  static UserCapability getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserCapability>(create);
  static UserCapability? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get action => $_getSZ(0);
  @$pb.TagNumber(1)
  set action($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => clearField(2);
}

class JoinCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', subBuilder: $3.User.create)
    ..aOM<$3.Call>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.Call.create)
    ..aOM<$3.CallState>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callState', subBuilder: $3.CallState.create)
    ..pc<$3.Edge>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'edges', $pb.PbFieldType.PM, subBuilder: $3.Edge.create)
    ..pc<UserCapability>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ownCapabilities', $pb.PbFieldType.PM, subBuilder: UserCapability.create)
    ..hasRequiredFields = false
  ;

  JoinCallResponse._() : super();
  factory JoinCallResponse({
    $3.User? user,
    $3.Call? call,
    $3.CallState? callState,
    $core.Iterable<$3.Edge>? edges,
    $core.Iterable<UserCapability>? ownCapabilities,
  }) {
    final _result = create();
    if (user != null) {
      _result.user = user;
    }
    if (call != null) {
      _result.call = call;
    }
    if (callState != null) {
      _result.callState = callState;
    }
    if (edges != null) {
      _result.edges.addAll(edges);
    }
    if (ownCapabilities != null) {
      _result.ownCapabilities.addAll(ownCapabilities);
    }
    return _result;
  }
  factory JoinCallResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinCallResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinCallResponse clone() => JoinCallResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinCallResponse copyWith(void Function(JoinCallResponse) updates) => super.copyWith((message) => updates(message as JoinCallResponse)) as JoinCallResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static JoinCallResponse create() => JoinCallResponse._();
  JoinCallResponse createEmptyInstance() => create();
  static $pb.PbList<JoinCallResponse> createRepeated() => $pb.PbList<JoinCallResponse>();
  @$core.pragma('dart2js:noInline')
  static JoinCallResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinCallResponse>(create);
  static JoinCallResponse? _defaultInstance;

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

  @$pb.TagNumber(2)
  $3.Call get call => $_getN(1);
  @$pb.TagNumber(2)
  set call($3.Call v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCall() => $_has(1);
  @$pb.TagNumber(2)
  void clearCall() => clearField(2);
  @$pb.TagNumber(2)
  $3.Call ensureCall() => $_ensure(1);

  @$pb.TagNumber(3)
  $3.CallState get callState => $_getN(2);
  @$pb.TagNumber(3)
  set callState($3.CallState v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCallState() => $_has(2);
  @$pb.TagNumber(3)
  void clearCallState() => clearField(3);
  @$pb.TagNumber(3)
  $3.CallState ensureCallState() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<$3.Edge> get edges => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<UserCapability> get ownCapabilities => $_getList(4);
}

class LeaveCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LeaveCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  LeaveCallRequest._() : super();
  factory LeaveCallRequest() => create();
  factory LeaveCallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LeaveCallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LeaveCallRequest clone() => LeaveCallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LeaveCallRequest copyWith(void Function(LeaveCallRequest) updates) => super.copyWith((message) => updates(message as LeaveCallRequest)) as LeaveCallRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LeaveCallRequest create() => LeaveCallRequest._();
  LeaveCallRequest createEmptyInstance() => create();
  static $pb.PbList<LeaveCallRequest> createRepeated() => $pb.PbList<LeaveCallRequest>();
  @$core.pragma('dart2js:noInline')
  static LeaveCallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaveCallRequest>(create);
  static LeaveCallRequest? _defaultInstance;
}

class LeaveCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LeaveCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  LeaveCallResponse._() : super();
  factory LeaveCallResponse() => create();
  factory LeaveCallResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LeaveCallResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LeaveCallResponse clone() => LeaveCallResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LeaveCallResponse copyWith(void Function(LeaveCallResponse) updates) => super.copyWith((message) => updates(message as LeaveCallResponse)) as LeaveCallResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LeaveCallResponse create() => LeaveCallResponse._();
  LeaveCallResponse createEmptyInstance() => create();
  static $pb.PbList<LeaveCallResponse> createRepeated() => $pb.PbList<LeaveCallResponse>();
  @$core.pragma('dart2js:noInline')
  static LeaveCallResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaveCallResponse>(create);
  static LeaveCallResponse? _defaultInstance;
}

class EndCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EndCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  EndCallRequest._() : super();
  factory EndCallRequest() => create();
  factory EndCallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EndCallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EndCallRequest clone() => EndCallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EndCallRequest copyWith(void Function(EndCallRequest) updates) => super.copyWith((message) => updates(message as EndCallRequest)) as EndCallRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EndCallRequest create() => EndCallRequest._();
  EndCallRequest createEmptyInstance() => create();
  static $pb.PbList<EndCallRequest> createRepeated() => $pb.PbList<EndCallRequest>();
  @$core.pragma('dart2js:noInline')
  static EndCallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EndCallRequest>(create);
  static EndCallRequest? _defaultInstance;
}

class EndCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EndCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  EndCallResponse._() : super();
  factory EndCallResponse() => create();
  factory EndCallResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EndCallResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EndCallResponse clone() => EndCallResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EndCallResponse copyWith(void Function(EndCallResponse) updates) => super.copyWith((message) => updates(message as EndCallResponse)) as EndCallResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EndCallResponse create() => EndCallResponse._();
  EndCallResponse createEmptyInstance() => create();
  static $pb.PbList<EndCallResponse> createRepeated() => $pb.PbList<EndCallResponse>();
  @$core.pragma('dart2js:noInline')
  static EndCallResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EndCallResponse>(create);
  static EndCallResponse? _defaultInstance;
}

class StartBroadcastRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StartBroadcastRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hlsBroadcast')
    ..aOM<$3.RTMPOptions>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rtmp', subBuilder: $3.RTMPOptions.create)
    ..hasRequiredFields = false
  ;

  StartBroadcastRequest._() : super();
  factory StartBroadcastRequest({
    $core.String? callId,
    $core.String? callType,
    $core.bool? hlsBroadcast,
    $3.RTMPOptions? rtmp,
  }) {
    final _result = create();
    if (callId != null) {
      _result.callId = callId;
    }
    if (callType != null) {
      _result.callType = callType;
    }
    if (hlsBroadcast != null) {
      _result.hlsBroadcast = hlsBroadcast;
    }
    if (rtmp != null) {
      _result.rtmp = rtmp;
    }
    return _result;
  }
  factory StartBroadcastRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StartBroadcastRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StartBroadcastRequest clone() => StartBroadcastRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StartBroadcastRequest copyWith(void Function(StartBroadcastRequest) updates) => super.copyWith((message) => updates(message as StartBroadcastRequest)) as StartBroadcastRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StartBroadcastRequest create() => StartBroadcastRequest._();
  StartBroadcastRequest createEmptyInstance() => create();
  static $pb.PbList<StartBroadcastRequest> createRepeated() => $pb.PbList<StartBroadcastRequest>();
  @$core.pragma('dart2js:noInline')
  static StartBroadcastRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StartBroadcastRequest>(create);
  static StartBroadcastRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callId => $_getSZ(0);
  @$pb.TagNumber(1)
  set callId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get callType => $_getSZ(1);
  @$pb.TagNumber(2)
  set callType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCallType() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallType() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hlsBroadcast => $_getBF(2);
  @$pb.TagNumber(3)
  set hlsBroadcast($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHlsBroadcast() => $_has(2);
  @$pb.TagNumber(3)
  void clearHlsBroadcast() => clearField(3);

  @$pb.TagNumber(5)
  $3.RTMPOptions get rtmp => $_getN(3);
  @$pb.TagNumber(5)
  set rtmp($3.RTMPOptions v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasRtmp() => $_has(3);
  @$pb.TagNumber(5)
  void clearRtmp() => clearField(5);
  @$pb.TagNumber(5)
  $3.RTMPOptions ensureRtmp() => $_ensure(3);
}

class StartBroadcastResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StartBroadcastResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$3.Broadcast>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcast', subBuilder: $3.Broadcast.create)
    ..hasRequiredFields = false
  ;

  StartBroadcastResponse._() : super();
  factory StartBroadcastResponse({
    $3.Broadcast? broadcast,
  }) {
    final _result = create();
    if (broadcast != null) {
      _result.broadcast = broadcast;
    }
    return _result;
  }
  factory StartBroadcastResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StartBroadcastResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StartBroadcastResponse clone() => StartBroadcastResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StartBroadcastResponse copyWith(void Function(StartBroadcastResponse) updates) => super.copyWith((message) => updates(message as StartBroadcastResponse)) as StartBroadcastResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StartBroadcastResponse create() => StartBroadcastResponse._();
  StartBroadcastResponse createEmptyInstance() => create();
  static $pb.PbList<StartBroadcastResponse> createRepeated() => $pb.PbList<StartBroadcastResponse>();
  @$core.pragma('dart2js:noInline')
  static StartBroadcastResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StartBroadcastResponse>(create);
  static StartBroadcastResponse? _defaultInstance;

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

class StopBroadcastRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StopBroadcastRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  StopBroadcastRequest._() : super();
  factory StopBroadcastRequest() => create();
  factory StopBroadcastRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StopBroadcastRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StopBroadcastRequest clone() => StopBroadcastRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StopBroadcastRequest copyWith(void Function(StopBroadcastRequest) updates) => super.copyWith((message) => updates(message as StopBroadcastRequest)) as StopBroadcastRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StopBroadcastRequest create() => StopBroadcastRequest._();
  StopBroadcastRequest createEmptyInstance() => create();
  static $pb.PbList<StopBroadcastRequest> createRepeated() => $pb.PbList<StopBroadcastRequest>();
  @$core.pragma('dart2js:noInline')
  static StopBroadcastRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StopBroadcastRequest>(create);
  static StopBroadcastRequest? _defaultInstance;
}

class StopBroadcastResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StopBroadcastResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  StopBroadcastResponse._() : super();
  factory StopBroadcastResponse() => create();
  factory StopBroadcastResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StopBroadcastResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StopBroadcastResponse clone() => StopBroadcastResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StopBroadcastResponse copyWith(void Function(StopBroadcastResponse) updates) => super.copyWith((message) => updates(message as StopBroadcastResponse)) as StopBroadcastResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StopBroadcastResponse create() => StopBroadcastResponse._();
  StopBroadcastResponse createEmptyInstance() => create();
  static $pb.PbList<StopBroadcastResponse> createRepeated() => $pb.PbList<StopBroadcastResponse>();
  @$core.pragma('dart2js:noInline')
  static StopBroadcastResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StopBroadcastResponse>(create);
  static StopBroadcastResponse? _defaultInstance;
}

class TranscribeCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TranscribeCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  TranscribeCallRequest._() : super();
  factory TranscribeCallRequest() => create();
  factory TranscribeCallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TranscribeCallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TranscribeCallRequest clone() => TranscribeCallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TranscribeCallRequest copyWith(void Function(TranscribeCallRequest) updates) => super.copyWith((message) => updates(message as TranscribeCallRequest)) as TranscribeCallRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TranscribeCallRequest create() => TranscribeCallRequest._();
  TranscribeCallRequest createEmptyInstance() => create();
  static $pb.PbList<TranscribeCallRequest> createRepeated() => $pb.PbList<TranscribeCallRequest>();
  @$core.pragma('dart2js:noInline')
  static TranscribeCallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TranscribeCallRequest>(create);
  static TranscribeCallRequest? _defaultInstance;
}

class TranscribeCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TranscribeCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  TranscribeCallResponse._() : super();
  factory TranscribeCallResponse() => create();
  factory TranscribeCallResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TranscribeCallResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TranscribeCallResponse clone() => TranscribeCallResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TranscribeCallResponse copyWith(void Function(TranscribeCallResponse) updates) => super.copyWith((message) => updates(message as TranscribeCallResponse)) as TranscribeCallResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TranscribeCallResponse create() => TranscribeCallResponse._();
  TranscribeCallResponse createEmptyInstance() => create();
  static $pb.PbList<TranscribeCallResponse> createRepeated() => $pb.PbList<TranscribeCallResponse>();
  @$core.pragma('dart2js:noInline')
  static TranscribeCallResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TranscribeCallResponse>(create);
  static TranscribeCallResponse? _defaultInstance;
}

class StopTranscribeCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StopTranscribeCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  StopTranscribeCallRequest._() : super();
  factory StopTranscribeCallRequest() => create();
  factory StopTranscribeCallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StopTranscribeCallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StopTranscribeCallRequest clone() => StopTranscribeCallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StopTranscribeCallRequest copyWith(void Function(StopTranscribeCallRequest) updates) => super.copyWith((message) => updates(message as StopTranscribeCallRequest)) as StopTranscribeCallRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StopTranscribeCallRequest create() => StopTranscribeCallRequest._();
  StopTranscribeCallRequest createEmptyInstance() => create();
  static $pb.PbList<StopTranscribeCallRequest> createRepeated() => $pb.PbList<StopTranscribeCallRequest>();
  @$core.pragma('dart2js:noInline')
  static StopTranscribeCallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StopTranscribeCallRequest>(create);
  static StopTranscribeCallRequest? _defaultInstance;
}

class StopTranscribeCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StopTranscribeCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  StopTranscribeCallResponse._() : super();
  factory StopTranscribeCallResponse() => create();
  factory StopTranscribeCallResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StopTranscribeCallResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StopTranscribeCallResponse clone() => StopTranscribeCallResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StopTranscribeCallResponse copyWith(void Function(StopTranscribeCallResponse) updates) => super.copyWith((message) => updates(message as StopTranscribeCallResponse)) as StopTranscribeCallResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StopTranscribeCallResponse create() => StopTranscribeCallResponse._();
  StopTranscribeCallResponse createEmptyInstance() => create();
  static $pb.PbList<StopTranscribeCallResponse> createRepeated() => $pb.PbList<StopTranscribeCallResponse>();
  @$core.pragma('dart2js:noInline')
  static StopTranscribeCallResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StopTranscribeCallResponse>(create);
  static StopTranscribeCallResponse? _defaultInstance;
}

class StoreLatencyRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StoreLatencyRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  StoreLatencyRequest._() : super();
  factory StoreLatencyRequest() => create();
  factory StoreLatencyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StoreLatencyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StoreLatencyRequest clone() => StoreLatencyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StoreLatencyRequest copyWith(void Function(StoreLatencyRequest) updates) => super.copyWith((message) => updates(message as StoreLatencyRequest)) as StoreLatencyRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StoreLatencyRequest create() => StoreLatencyRequest._();
  StoreLatencyRequest createEmptyInstance() => create();
  static $pb.PbList<StoreLatencyRequest> createRepeated() => $pb.PbList<StoreLatencyRequest>();
  @$core.pragma('dart2js:noInline')
  static StoreLatencyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StoreLatencyRequest>(create);
  static StoreLatencyRequest? _defaultInstance;
}

class StoreLatencyResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StoreLatencyResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  StoreLatencyResponse._() : super();
  factory StoreLatencyResponse() => create();
  factory StoreLatencyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StoreLatencyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StoreLatencyResponse clone() => StoreLatencyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StoreLatencyResponse copyWith(void Function(StoreLatencyResponse) updates) => super.copyWith((message) => updates(message as StoreLatencyResponse)) as StoreLatencyResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StoreLatencyResponse create() => StoreLatencyResponse._();
  StoreLatencyResponse createEmptyInstance() => create();
  static $pb.PbList<StoreLatencyResponse> createRepeated() => $pb.PbList<StoreLatencyResponse>();
  @$core.pragma('dart2js:noInline')
  static StoreLatencyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StoreLatencyResponse>(create);
  static StoreLatencyResponse? _defaultInstance;
}

class StartRecordingRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StartRecordingRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..hasRequiredFields = false
  ;

  StartRecordingRequest._() : super();
  factory StartRecordingRequest({
    $core.String? callType,
    $core.String? callId,
  }) {
    final _result = create();
    if (callType != null) {
      _result.callType = callType;
    }
    if (callId != null) {
      _result.callId = callId;
    }
    return _result;
  }
  factory StartRecordingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StartRecordingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StartRecordingRequest clone() => StartRecordingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StartRecordingRequest copyWith(void Function(StartRecordingRequest) updates) => super.copyWith((message) => updates(message as StartRecordingRequest)) as StartRecordingRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StartRecordingRequest create() => StartRecordingRequest._();
  StartRecordingRequest createEmptyInstance() => create();
  static $pb.PbList<StartRecordingRequest> createRepeated() => $pb.PbList<StartRecordingRequest>();
  @$core.pragma('dart2js:noInline')
  static StartRecordingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StartRecordingRequest>(create);
  static StartRecordingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callType => $_getSZ(0);
  @$pb.TagNumber(1)
  set callType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get callId => $_getSZ(1);
  @$pb.TagNumber(2)
  set callId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallId() => clearField(2);
}

class StartRecordingResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StartRecordingResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  StartRecordingResponse._() : super();
  factory StartRecordingResponse() => create();
  factory StartRecordingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StartRecordingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StartRecordingResponse clone() => StartRecordingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StartRecordingResponse copyWith(void Function(StartRecordingResponse) updates) => super.copyWith((message) => updates(message as StartRecordingResponse)) as StartRecordingResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StartRecordingResponse create() => StartRecordingResponse._();
  StartRecordingResponse createEmptyInstance() => create();
  static $pb.PbList<StartRecordingResponse> createRepeated() => $pb.PbList<StartRecordingResponse>();
  @$core.pragma('dart2js:noInline')
  static StartRecordingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StartRecordingResponse>(create);
  static StartRecordingResponse? _defaultInstance;
}

class StopRecordingRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StopRecordingRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..hasRequiredFields = false
  ;

  StopRecordingRequest._() : super();
  factory StopRecordingRequest({
    $core.String? callType,
    $core.String? callId,
  }) {
    final _result = create();
    if (callType != null) {
      _result.callType = callType;
    }
    if (callId != null) {
      _result.callId = callId;
    }
    return _result;
  }
  factory StopRecordingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StopRecordingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StopRecordingRequest clone() => StopRecordingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StopRecordingRequest copyWith(void Function(StopRecordingRequest) updates) => super.copyWith((message) => updates(message as StopRecordingRequest)) as StopRecordingRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StopRecordingRequest create() => StopRecordingRequest._();
  StopRecordingRequest createEmptyInstance() => create();
  static $pb.PbList<StopRecordingRequest> createRepeated() => $pb.PbList<StopRecordingRequest>();
  @$core.pragma('dart2js:noInline')
  static StopRecordingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StopRecordingRequest>(create);
  static StopRecordingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callType => $_getSZ(0);
  @$pb.TagNumber(1)
  set callType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get callId => $_getSZ(1);
  @$pb.TagNumber(2)
  set callId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallId() => clearField(2);
}

class StopRecordingResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StopRecordingResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 's3FileUrl')
    ..hasRequiredFields = false
  ;

  StopRecordingResponse._() : super();
  factory StopRecordingResponse({
    $core.String? s3FileUrl,
  }) {
    final _result = create();
    if (s3FileUrl != null) {
      _result.s3FileUrl = s3FileUrl;
    }
    return _result;
  }
  factory StopRecordingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StopRecordingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StopRecordingResponse clone() => StopRecordingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StopRecordingResponse copyWith(void Function(StopRecordingResponse) updates) => super.copyWith((message) => updates(message as StopRecordingResponse)) as StopRecordingResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StopRecordingResponse create() => StopRecordingResponse._();
  StopRecordingResponse createEmptyInstance() => create();
  static $pb.PbList<StopRecordingResponse> createRepeated() => $pb.PbList<StopRecordingResponse>();
  @$core.pragma('dart2js:noInline')
  static StopRecordingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StopRecordingResponse>(create);
  static StopRecordingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get s3FileUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set s3FileUrl($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasS3FileUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearS3FileUrl() => clearField(1);
}

class GetRecordingsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetRecordingsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  GetRecordingsRequest._() : super();
  factory GetRecordingsRequest() => create();
  factory GetRecordingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetRecordingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetRecordingsRequest clone() => GetRecordingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetRecordingsRequest copyWith(void Function(GetRecordingsRequest) updates) => super.copyWith((message) => updates(message as GetRecordingsRequest)) as GetRecordingsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetRecordingsRequest create() => GetRecordingsRequest._();
  GetRecordingsRequest createEmptyInstance() => create();
  static $pb.PbList<GetRecordingsRequest> createRepeated() => $pb.PbList<GetRecordingsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetRecordingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetRecordingsRequest>(create);
  static GetRecordingsRequest? _defaultInstance;
}

class GetRecordingsResponse_Recording extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetRecordingsResponse.Recording', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 's3FileUrl')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startTime')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stopTime')
    ..hasRequiredFields = false
  ;

  GetRecordingsResponse_Recording._() : super();
  factory GetRecordingsResponse_Recording({
    $core.String? callType,
    $core.String? callId,
    $core.String? s3FileUrl,
    $core.String? startTime,
    $core.String? stopTime,
  }) {
    final _result = create();
    if (callType != null) {
      _result.callType = callType;
    }
    if (callId != null) {
      _result.callId = callId;
    }
    if (s3FileUrl != null) {
      _result.s3FileUrl = s3FileUrl;
    }
    if (startTime != null) {
      _result.startTime = startTime;
    }
    if (stopTime != null) {
      _result.stopTime = stopTime;
    }
    return _result;
  }
  factory GetRecordingsResponse_Recording.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetRecordingsResponse_Recording.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetRecordingsResponse_Recording clone() => GetRecordingsResponse_Recording()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetRecordingsResponse_Recording copyWith(void Function(GetRecordingsResponse_Recording) updates) => super.copyWith((message) => updates(message as GetRecordingsResponse_Recording)) as GetRecordingsResponse_Recording; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetRecordingsResponse_Recording create() => GetRecordingsResponse_Recording._();
  GetRecordingsResponse_Recording createEmptyInstance() => create();
  static $pb.PbList<GetRecordingsResponse_Recording> createRepeated() => $pb.PbList<GetRecordingsResponse_Recording>();
  @$core.pragma('dart2js:noInline')
  static GetRecordingsResponse_Recording getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetRecordingsResponse_Recording>(create);
  static GetRecordingsResponse_Recording? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callType => $_getSZ(0);
  @$pb.TagNumber(1)
  set callType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get callId => $_getSZ(1);
  @$pb.TagNumber(2)
  set callId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get s3FileUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set s3FileUrl($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasS3FileUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearS3FileUrl() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get startTime => $_getSZ(3);
  @$pb.TagNumber(4)
  set startTime($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStartTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartTime() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get stopTime => $_getSZ(4);
  @$pb.TagNumber(5)
  set stopTime($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasStopTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearStopTime() => clearField(5);
}

class GetRecordingsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetRecordingsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..pc<GetRecordingsResponse_Recording>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recordings', $pb.PbFieldType.PM, subBuilder: GetRecordingsResponse_Recording.create)
    ..hasRequiredFields = false
  ;

  GetRecordingsResponse._() : super();
  factory GetRecordingsResponse({
    $core.Iterable<GetRecordingsResponse_Recording>? recordings,
  }) {
    final _result = create();
    if (recordings != null) {
      _result.recordings.addAll(recordings);
    }
    return _result;
  }
  factory GetRecordingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetRecordingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetRecordingsResponse clone() => GetRecordingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetRecordingsResponse copyWith(void Function(GetRecordingsResponse) updates) => super.copyWith((message) => updates(message as GetRecordingsResponse)) as GetRecordingsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetRecordingsResponse create() => GetRecordingsResponse._();
  GetRecordingsResponse createEmptyInstance() => create();
  static $pb.PbList<GetRecordingsResponse> createRepeated() => $pb.PbList<GetRecordingsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetRecordingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetRecordingsResponse>(create);
  static GetRecordingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<GetRecordingsResponse_Recording> get recordings => $_getList(0);
}

class SendEventRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendEventRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..e<UserEventType>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'eventType', $pb.PbFieldType.OE, defaultOrMaker: UserEventType.USER_EVENT_TYPE_AUDIO_MUTED_UNSPECIFIED, valueOf: UserEventType.valueOf, enumValues: UserEventType.values)
    ..hasRequiredFields = false
  ;

  SendEventRequest._() : super();
  factory SendEventRequest({
    $core.String? userId,
    $core.String? callType,
    $core.String? callId,
    UserEventType? eventType,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (callType != null) {
      _result.callType = callType;
    }
    if (callId != null) {
      _result.callId = callId;
    }
    if (eventType != null) {
      _result.eventType = eventType;
    }
    return _result;
  }
  factory SendEventRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SendEventRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SendEventRequest clone() => SendEventRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SendEventRequest copyWith(void Function(SendEventRequest) updates) => super.copyWith((message) => updates(message as SendEventRequest)) as SendEventRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SendEventRequest create() => SendEventRequest._();
  SendEventRequest createEmptyInstance() => create();
  static $pb.PbList<SendEventRequest> createRepeated() => $pb.PbList<SendEventRequest>();
  @$core.pragma('dart2js:noInline')
  static SendEventRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendEventRequest>(create);
  static SendEventRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get callType => $_getSZ(1);
  @$pb.TagNumber(2)
  set callType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCallType() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallType() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get callId => $_getSZ(2);
  @$pb.TagNumber(3)
  set callId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCallId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCallId() => clearField(3);

  @$pb.TagNumber(4)
  UserEventType get eventType => $_getN(3);
  @$pb.TagNumber(4)
  set eventType(UserEventType v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasEventType() => $_has(3);
  @$pb.TagNumber(4)
  void clearEventType() => clearField(4);
}

class SendEventResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendEventResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  SendEventResponse._() : super();
  factory SendEventResponse() => create();
  factory SendEventResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SendEventResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SendEventResponse clone() => SendEventResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SendEventResponse copyWith(void Function(SendEventResponse) updates) => super.copyWith((message) => updates(message as SendEventResponse)) as SendEventResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SendEventResponse create() => SendEventResponse._();
  SendEventResponse createEmptyInstance() => create();
  static $pb.PbList<SendEventResponse> createRepeated() => $pb.PbList<SendEventResponse>();
  @$core.pragma('dart2js:noInline')
  static SendEventResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendEventResponse>(create);
  static SendEventResponse? _defaultInstance;
}

class CallCoordinatorServiceApi {
  $pb.RpcClient _client;
  CallCoordinatorServiceApi(this._client);

  $async.Future<CreateCallResponse> createCall($pb.ClientContext? ctx, CreateCallRequest request) {
    var emptyResponse = CreateCallResponse();
    return _client.invoke<CreateCallResponse>(ctx, 'CallCoordinatorService', 'CreateCall', request, emptyResponse);
  }
  $async.Future<GetCallResponse> getCall($pb.ClientContext? ctx, GetCallRequest request) {
    var emptyResponse = GetCallResponse();
    return _client.invoke<GetCallResponse>(ctx, 'CallCoordinatorService', 'GetCall', request, emptyResponse);
  }
  $async.Future<UpdateCallResponse> updateCall($pb.ClientContext? ctx, UpdateCallRequest request) {
    var emptyResponse = UpdateCallResponse();
    return _client.invoke<UpdateCallResponse>(ctx, 'CallCoordinatorService', 'UpdateCall', request, emptyResponse);
  }
  $async.Future<DeleteCallResponse> deleteCall($pb.ClientContext? ctx, DeleteCallRequest request) {
    var emptyResponse = DeleteCallResponse();
    return _client.invoke<DeleteCallResponse>(ctx, 'CallCoordinatorService', 'DeleteCall', request, emptyResponse);
  }
  $async.Future<JoinCallResponse> joinCall($pb.ClientContext? ctx, JoinCallRequest request) {
    var emptyResponse = JoinCallResponse();
    return _client.invoke<JoinCallResponse>(ctx, 'CallCoordinatorService', 'JoinCall', request, emptyResponse);
  }
  $async.Future<SelectEdgeServerResponse> selectEdgeServer($pb.ClientContext? ctx, SelectEdgeServerRequest request) {
    var emptyResponse = SelectEdgeServerResponse();
    return _client.invoke<SelectEdgeServerResponse>(ctx, 'CallCoordinatorService', 'SelectEdgeServer', request, emptyResponse);
  }
  $async.Future<LeaveCallResponse> leaveCall($pb.ClientContext? ctx, LeaveCallRequest request) {
    var emptyResponse = LeaveCallResponse();
    return _client.invoke<LeaveCallResponse>(ctx, 'CallCoordinatorService', 'LeaveCall', request, emptyResponse);
  }
  $async.Future<EndCallResponse> endCall($pb.ClientContext? ctx, EndCallRequest request) {
    var emptyResponse = EndCallResponse();
    return _client.invoke<EndCallResponse>(ctx, 'CallCoordinatorService', 'EndCall', request, emptyResponse);
  }
  $async.Future<AddDeviceResponse> addDevice($pb.ClientContext? ctx, AddDeviceRequest request) {
    var emptyResponse = AddDeviceResponse();
    return _client.invoke<AddDeviceResponse>(ctx, 'CallCoordinatorService', 'AddDevice', request, emptyResponse);
  }
  $async.Future<RemoveDeviceResponse> removeDevice($pb.ClientContext? ctx, RemoveDeviceRequest request) {
    var emptyResponse = RemoveDeviceResponse();
    return _client.invoke<RemoveDeviceResponse>(ctx, 'CallCoordinatorService', 'RemoveDevice', request, emptyResponse);
  }
  $async.Future<ListDevicesResponse> listDevices($pb.ClientContext? ctx, ListDevicesRequest request) {
    var emptyResponse = ListDevicesResponse();
    return _client.invoke<ListDevicesResponse>(ctx, 'CallCoordinatorService', 'ListDevices', request, emptyResponse);
  }
  $async.Future<SendEventResponse> sendEvent($pb.ClientContext? ctx, SendEventRequest request) {
    var emptyResponse = SendEventResponse();
    return _client.invoke<SendEventResponse>(ctx, 'CallCoordinatorService', 'SendEvent', request, emptyResponse);
  }
  $async.Future<SendCustomEventResponse> sendCustomEvent($pb.ClientContext? ctx, SendCustomEventRequest request) {
    var emptyResponse = SendCustomEventResponse();
    return _client.invoke<SendCustomEventResponse>(ctx, 'CallCoordinatorService', 'SendCustomEvent', request, emptyResponse);
  }
  $async.Future<CreateOrUpdateCallsResponse> createOrUpdateCalls($pb.ClientContext? ctx, CreateOrUpdateCallsRequest request) {
    var emptyResponse = CreateOrUpdateCallsResponse();
    return _client.invoke<CreateOrUpdateCallsResponse>(ctx, 'CallCoordinatorService', 'CreateOrUpdateCalls', request, emptyResponse);
  }
  $async.Future<CreateOrUpdateUsersResponse> createOrUpdateUsers($pb.ClientContext? ctx, CreateOrUpdateUsersRequest request) {
    var emptyResponse = CreateOrUpdateUsersResponse();
    return _client.invoke<CreateOrUpdateUsersResponse>(ctx, 'CallCoordinatorService', 'CreateOrUpdateUsers', request, emptyResponse);
  }
  $async.Future<TranscribeCallResponse> transcribeCall($pb.ClientContext? ctx, TranscribeCallRequest request) {
    var emptyResponse = TranscribeCallResponse();
    return _client.invoke<TranscribeCallResponse>(ctx, 'CallCoordinatorService', 'TranscribeCall', request, emptyResponse);
  }
  $async.Future<StopTranscribeCallResponse> stopTranscribeCall($pb.ClientContext? ctx, StopTranscribeCallRequest request) {
    var emptyResponse = StopTranscribeCallResponse();
    return _client.invoke<StopTranscribeCallResponse>(ctx, 'CallCoordinatorService', 'StopTranscribeCall', request, emptyResponse);
  }
  $async.Future<StartBroadcastResponse> startBroadcast($pb.ClientContext? ctx, StartBroadcastRequest request) {
    var emptyResponse = StartBroadcastResponse();
    return _client.invoke<StartBroadcastResponse>(ctx, 'CallCoordinatorService', 'StartBroadcast', request, emptyResponse);
  }
  $async.Future<StopBroadcastResponse> stopBroadcast($pb.ClientContext? ctx, StopBroadcastRequest request) {
    var emptyResponse = StopBroadcastResponse();
    return _client.invoke<StopBroadcastResponse>(ctx, 'CallCoordinatorService', 'StopBroadcast', request, emptyResponse);
  }
  $async.Future<StartRecordingResponse> startRecording($pb.ClientContext? ctx, StartRecordingRequest request) {
    var emptyResponse = StartRecordingResponse();
    return _client.invoke<StartRecordingResponse>(ctx, 'CallCoordinatorService', 'StartRecording', request, emptyResponse);
  }
  $async.Future<StopRecordingResponse> stopRecording($pb.ClientContext? ctx, StopRecordingRequest request) {
    var emptyResponse = StopRecordingResponse();
    return _client.invoke<StopRecordingResponse>(ctx, 'CallCoordinatorService', 'StopRecording', request, emptyResponse);
  }
  $async.Future<GetRecordingsResponse> getRecordings($pb.ClientContext? ctx, GetRecordingsRequest request) {
    var emptyResponse = GetRecordingsResponse();
    return _client.invoke<GetRecordingsResponse>(ctx, 'CallCoordinatorService', 'GetRecordings', request, emptyResponse);
  }
  $async.Future<CreateUserResponse> createUser($pb.ClientContext? ctx, CreateUserRequest request) {
    var emptyResponse = CreateUserResponse();
    return _client.invoke<CreateUserResponse>(ctx, 'CallCoordinatorService', 'CreateUser', request, emptyResponse);
  }
  $async.Future<DeleteUserResponse> deleteUser($pb.ClientContext? ctx, DeleteUserRequest request) {
    var emptyResponse = DeleteUserResponse();
    return _client.invoke<DeleteUserResponse>(ctx, 'CallCoordinatorService', 'DeleteUser', request, emptyResponse);
  }
  $async.Future<ExportUserResponse> exportUser($pb.ClientContext? ctx, ExportUserRequest request) {
    var emptyResponse = ExportUserResponse();
    return _client.invoke<ExportUserResponse>(ctx, 'CallCoordinatorService', 'ExportUser', request, emptyResponse);
  }
}

