///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/client_rpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'envelopes.pb.dart' as $3;
import '../user_v1/user.pb.dart' as $1;
import '../edge_v1/edge.pb.dart' as $4;
import '../call_v1/call.pb.dart' as $0;
import '../utils_v1/utils.pb.dart' as $5;
import '../push_v1/push.pb.dart' as $6;
import '../../../google/protobuf/timestamp.pb.dart' as $7;
import '../stat_v1/stat.pb.dart' as $8;
import '../broadcast_v1/broadcast.pb.dart' as $9;

import 'client_rpc.pbenum.dart';

export 'client_rpc.pbenum.dart';

class GetCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..hasRequiredFields = false
  ;

  GetCallRequest._() : super();
  factory GetCallRequest({
    $core.String? callCid,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
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
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);
}

class GetCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOM<$3.CallEnvelope>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.CallEnvelope.create)
    ..hasRequiredFields = false
  ;

  GetCallResponse._() : super();
  factory GetCallResponse({
    $3.CallEnvelope? call,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
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
  $3.CallEnvelope get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.CallEnvelope v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.CallEnvelope ensureCall() => $_ensure(0);
}

class MemberInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MemberInput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'role')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'customJson', $pb.PbFieldType.OY)
    ..aOM<$1.UserInput>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userInput', subBuilder: $1.UserInput.create)
    ..hasRequiredFields = false
  ;

  MemberInput._() : super();
  factory MemberInput({
    $core.String? userId,
    $core.String? role,
    $core.List<$core.int>? customJson,
    $1.UserInput? userInput,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (role != null) {
      _result.role = role;
    }
    if (customJson != null) {
      _result.customJson = customJson;
    }
    if (userInput != null) {
      _result.userInput = userInput;
    }
    return _result;
  }
  factory MemberInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MemberInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MemberInput clone() => MemberInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MemberInput copyWith(void Function(MemberInput) updates) => super.copyWith((message) => updates(message as MemberInput)) as MemberInput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MemberInput create() => MemberInput._();
  MemberInput createEmptyInstance() => create();
  static $pb.PbList<MemberInput> createRepeated() => $pb.PbList<MemberInput>();
  @$core.pragma('dart2js:noInline')
  static MemberInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MemberInput>(create);
  static MemberInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get customJson => $_getN(2);
  @$pb.TagNumber(3)
  set customJson($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCustomJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustomJson() => clearField(3);

  @$pb.TagNumber(4)
  $1.UserInput get userInput => $_getN(3);
  @$pb.TagNumber(4)
  set userInput($1.UserInput v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasUserInput() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserInput() => clearField(4);
  @$pb.TagNumber(4)
  $1.UserInput ensureUserInput() => $_ensure(3);
}

class UpsertCallMembersRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpsertCallMembersRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..pc<MemberInput>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'members', $pb.PbFieldType.PM, subBuilder: MemberInput.create)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ring')
    ..hasRequiredFields = false
  ;

  UpsertCallMembersRequest._() : super();
  factory UpsertCallMembersRequest({
    $core.String? callCid,
    $core.Iterable<MemberInput>? members,
    $core.bool? ring,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (members != null) {
      _result.members.addAll(members);
    }
    if (ring != null) {
      _result.ring = ring;
    }
    return _result;
  }
  factory UpsertCallMembersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertCallMembersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertCallMembersRequest clone() => UpsertCallMembersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertCallMembersRequest copyWith(void Function(UpsertCallMembersRequest) updates) => super.copyWith((message) => updates(message as UpsertCallMembersRequest)) as UpsertCallMembersRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpsertCallMembersRequest create() => UpsertCallMembersRequest._();
  UpsertCallMembersRequest createEmptyInstance() => create();
  static $pb.PbList<UpsertCallMembersRequest> createRepeated() => $pb.PbList<UpsertCallMembersRequest>();
  @$core.pragma('dart2js:noInline')
  static UpsertCallMembersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertCallMembersRequest>(create);
  static UpsertCallMembersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<MemberInput> get members => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get ring => $_getBF(2);
  @$pb.TagNumber(3)
  set ring($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRing() => $_has(2);
  @$pb.TagNumber(3)
  void clearRing() => clearField(3);
}

class UpsertCallMembersResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpsertCallMembersResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  UpsertCallMembersResponse._() : super();
  factory UpsertCallMembersResponse() => create();
  factory UpsertCallMembersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertCallMembersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertCallMembersResponse clone() => UpsertCallMembersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertCallMembersResponse copyWith(void Function(UpsertCallMembersResponse) updates) => super.copyWith((message) => updates(message as UpsertCallMembersResponse)) as UpsertCallMembersResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpsertCallMembersResponse create() => UpsertCallMembersResponse._();
  UpsertCallMembersResponse createEmptyInstance() => create();
  static $pb.PbList<UpsertCallMembersResponse> createRepeated() => $pb.PbList<UpsertCallMembersResponse>();
  @$core.pragma('dart2js:noInline')
  static UpsertCallMembersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertCallMembersResponse>(create);
  static UpsertCallMembersResponse? _defaultInstance;
}

class DeleteCallMembersRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteCallMembersRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userIds')
    ..hasRequiredFields = false
  ;

  DeleteCallMembersRequest._() : super();
  factory DeleteCallMembersRequest({
    $core.String? callCid,
    $core.Iterable<$core.String>? userIds,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (userIds != null) {
      _result.userIds.addAll(userIds);
    }
    return _result;
  }
  factory DeleteCallMembersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteCallMembersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteCallMembersRequest clone() => DeleteCallMembersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteCallMembersRequest copyWith(void Function(DeleteCallMembersRequest) updates) => super.copyWith((message) => updates(message as DeleteCallMembersRequest)) as DeleteCallMembersRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteCallMembersRequest create() => DeleteCallMembersRequest._();
  DeleteCallMembersRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteCallMembersRequest> createRepeated() => $pb.PbList<DeleteCallMembersRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteCallMembersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteCallMembersRequest>(create);
  static DeleteCallMembersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get userIds => $_getList(1);
}

class DeleteCallMembersResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteCallMembersResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  DeleteCallMembersResponse._() : super();
  factory DeleteCallMembersResponse() => create();
  factory DeleteCallMembersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteCallMembersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteCallMembersResponse clone() => DeleteCallMembersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteCallMembersResponse copyWith(void Function(DeleteCallMembersResponse) updates) => super.copyWith((message) => updates(message as DeleteCallMembersResponse)) as DeleteCallMembersResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteCallMembersResponse create() => DeleteCallMembersResponse._();
  DeleteCallMembersResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteCallMembersResponse> createRepeated() => $pb.PbList<DeleteCallMembersResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteCallMembersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteCallMembersResponse>(create);
  static DeleteCallMembersResponse? _defaultInstance;
}

class CreateCallInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateCallInput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOM<CallInput>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: CallInput.create)
    ..pc<MemberInput>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'members', $pb.PbFieldType.PM, subBuilder: MemberInput.create)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ring')
    ..hasRequiredFields = false
  ;

  CreateCallInput._() : super();
  factory CreateCallInput({
    CallInput? call,
    $core.Iterable<MemberInput>? members,
    $core.bool? ring,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (members != null) {
      _result.members.addAll(members);
    }
    if (ring != null) {
      _result.ring = ring;
    }
    return _result;
  }
  factory CreateCallInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateCallInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateCallInput clone() => CreateCallInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateCallInput copyWith(void Function(CreateCallInput) updates) => super.copyWith((message) => updates(message as CreateCallInput)) as CreateCallInput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateCallInput create() => CreateCallInput._();
  CreateCallInput createEmptyInstance() => create();
  static $pb.PbList<CreateCallInput> createRepeated() => $pb.PbList<CreateCallInput>();
  @$core.pragma('dart2js:noInline')
  static CreateCallInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateCallInput>(create);
  static CreateCallInput? _defaultInstance;

  @$pb.TagNumber(1)
  CallInput get call => $_getN(0);
  @$pb.TagNumber(1)
  set call(CallInput v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  CallInput ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<MemberInput> get members => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get ring => $_getBF(2);
  @$pb.TagNumber(3)
  set ring($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRing() => $_has(2);
  @$pb.TagNumber(3)
  void clearRing() => clearField(3);
}

class CreateCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOM<CreateCallInput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'input', subBuilder: CreateCallInput.create)
    ..hasRequiredFields = false
  ;

  CreateCallRequest._() : super();
  factory CreateCallRequest({
    $core.String? type,
    $core.String? id,
    CreateCallInput? input,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (id != null) {
      _result.id = id;
    }
    if (input != null) {
      _result.input = input;
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
  CreateCallInput get input => $_getN(2);
  @$pb.TagNumber(3)
  set input(CreateCallInput v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasInput() => $_has(2);
  @$pb.TagNumber(3)
  void clearInput() => clearField(3);
  @$pb.TagNumber(3)
  CreateCallInput ensureInput() => $_ensure(2);
}

class GetOrCreateCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetOrCreateCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOM<CreateCallInput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'input', subBuilder: CreateCallInput.create)
    ..hasRequiredFields = false
  ;

  GetOrCreateCallRequest._() : super();
  factory GetOrCreateCallRequest({
    $core.String? type,
    $core.String? id,
    CreateCallInput? input,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (id != null) {
      _result.id = id;
    }
    if (input != null) {
      _result.input = input;
    }
    return _result;
  }
  factory GetOrCreateCallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetOrCreateCallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetOrCreateCallRequest clone() => GetOrCreateCallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetOrCreateCallRequest copyWith(void Function(GetOrCreateCallRequest) updates) => super.copyWith((message) => updates(message as GetOrCreateCallRequest)) as GetOrCreateCallRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetOrCreateCallRequest create() => GetOrCreateCallRequest._();
  GetOrCreateCallRequest createEmptyInstance() => create();
  static $pb.PbList<GetOrCreateCallRequest> createRepeated() => $pb.PbList<GetOrCreateCallRequest>();
  @$core.pragma('dart2js:noInline')
  static GetOrCreateCallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetOrCreateCallRequest>(create);
  static GetOrCreateCallRequest? _defaultInstance;

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
  CreateCallInput get input => $_getN(2);
  @$pb.TagNumber(3)
  set input(CreateCallInput v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasInput() => $_has(2);
  @$pb.TagNumber(3)
  void clearInput() => clearField(3);
  @$pb.TagNumber(3)
  CreateCallInput ensureInput() => $_ensure(2);
}

class JoinCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOM<CreateCallInput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'input', subBuilder: CreateCallInput.create)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'datacenterId')
    ..hasRequiredFields = false
  ;

  JoinCallRequest._() : super();
  factory JoinCallRequest({
    $core.String? type,
    $core.String? id,
    CreateCallInput? input,
    $core.String? datacenterId,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (id != null) {
      _result.id = id;
    }
    if (input != null) {
      _result.input = input;
    }
    if (datacenterId != null) {
      _result.datacenterId = datacenterId;
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
  CreateCallInput get input => $_getN(2);
  @$pb.TagNumber(3)
  set input(CreateCallInput v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasInput() => $_has(2);
  @$pb.TagNumber(3)
  void clearInput() => clearField(3);
  @$pb.TagNumber(3)
  CreateCallInput ensureInput() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get datacenterId => $_getSZ(3);
  @$pb.TagNumber(4)
  set datacenterId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDatacenterId() => $_has(3);
  @$pb.TagNumber(4)
  void clearDatacenterId() => clearField(4);
}

class JoinCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOM<$3.CallEnvelope>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.CallEnvelope.create)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'created')
    ..pc<$4.Edge>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'edges', $pb.PbFieldType.PM, subBuilder: $4.Edge.create)
    ..hasRequiredFields = false
  ;

  JoinCallResponse._() : super();
  factory JoinCallResponse({
    $3.CallEnvelope? call,
    $core.bool? created,
    $core.Iterable<$4.Edge>? edges,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (created != null) {
      _result.created = created;
    }
    if (edges != null) {
      _result.edges.addAll(edges);
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
  $3.CallEnvelope get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.CallEnvelope v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.CallEnvelope ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get created => $_getBF(1);
  @$pb.TagNumber(2)
  set created($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreated() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreated() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$4.Edge> get edges => $_getList(2);
}

class CallInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallInput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'customJson', $pb.PbFieldType.OY)
    ..aOM<$0.CallSettings>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'settingsOverrides', subBuilder: $0.CallSettings.create)
    ..hasRequiredFields = false
  ;

  CallInput._() : super();
  factory CallInput({
    $core.List<$core.int>? customJson,
    $0.CallSettings? settingsOverrides,
  }) {
    final _result = create();
    if (customJson != null) {
      _result.customJson = customJson;
    }
    if (settingsOverrides != null) {
      _result.settingsOverrides = settingsOverrides;
    }
    return _result;
  }
  factory CallInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallInput clone() => CallInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallInput copyWith(void Function(CallInput) updates) => super.copyWith((message) => updates(message as CallInput)) as CallInput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallInput create() => CallInput._();
  CallInput createEmptyInstance() => create();
  static $pb.PbList<CallInput> createRepeated() => $pb.PbList<CallInput>();
  @$core.pragma('dart2js:noInline')
  static CallInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallInput>(create);
  static CallInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get customJson => $_getN(0);
  @$pb.TagNumber(1)
  set customJson($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCustomJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomJson() => clearField(1);

  @$pb.TagNumber(2)
  $0.CallSettings get settingsOverrides => $_getN(1);
  @$pb.TagNumber(2)
  set settingsOverrides($0.CallSettings v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSettingsOverrides() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettingsOverrides() => clearField(2);
  @$pb.TagNumber(2)
  $0.CallSettings ensureSettingsOverrides() => $_ensure(1);
}

class GetOrCreateCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetOrCreateCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOM<$3.CallEnvelope>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.CallEnvelope.create)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'created')
    ..hasRequiredFields = false
  ;

  GetOrCreateCallResponse._() : super();
  factory GetOrCreateCallResponse({
    $3.CallEnvelope? call,
    $core.bool? created,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (created != null) {
      _result.created = created;
    }
    return _result;
  }
  factory GetOrCreateCallResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetOrCreateCallResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetOrCreateCallResponse clone() => GetOrCreateCallResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetOrCreateCallResponse copyWith(void Function(GetOrCreateCallResponse) updates) => super.copyWith((message) => updates(message as GetOrCreateCallResponse)) as GetOrCreateCallResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetOrCreateCallResponse create() => GetOrCreateCallResponse._();
  GetOrCreateCallResponse createEmptyInstance() => create();
  static $pb.PbList<GetOrCreateCallResponse> createRepeated() => $pb.PbList<GetOrCreateCallResponse>();
  @$core.pragma('dart2js:noInline')
  static GetOrCreateCallResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetOrCreateCallResponse>(create);
  static GetOrCreateCallResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $3.CallEnvelope get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.CallEnvelope v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.CallEnvelope ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get created => $_getBF(1);
  @$pb.TagNumber(2)
  set created($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreated() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreated() => clearField(2);
}

class UpdateCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..aOM<CallInput>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'input', subBuilder: CallInput.create)
    ..hasRequiredFields = false
  ;

  UpdateCallRequest._() : super();
  factory UpdateCallRequest({
    $core.String? callCid,
    CallInput? input,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (input != null) {
      _result.input = input;
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
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  CallInput get input => $_getN(1);
  @$pb.TagNumber(2)
  set input(CallInput v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasInput() => $_has(1);
  @$pb.TagNumber(2)
  void clearInput() => clearField(2);
  @$pb.TagNumber(2)
  CallInput ensureInput() => $_ensure(1);
}

class UpdateCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOM<$3.CallEnvelope>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.CallEnvelope.create)
    ..hasRequiredFields = false
  ;

  UpdateCallResponse._() : super();
  factory UpdateCallResponse({
    $3.CallEnvelope? call,
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
  $3.CallEnvelope get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.CallEnvelope v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.CallEnvelope ensureCall() => $_ensure(0);
}

class RoleOverride extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RoleOverride', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userIds')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'roleName')
    ..hasRequiredFields = false
  ;

  RoleOverride._() : super();
  factory RoleOverride({
    $core.Iterable<$core.String>? userIds,
    $core.String? roleName,
  }) {
    final _result = create();
    if (userIds != null) {
      _result.userIds.addAll(userIds);
    }
    if (roleName != null) {
      _result.roleName = roleName;
    }
    return _result;
  }
  factory RoleOverride.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoleOverride.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoleOverride clone() => RoleOverride()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoleOverride copyWith(void Function(RoleOverride) updates) => super.copyWith((message) => updates(message as RoleOverride)) as RoleOverride; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RoleOverride create() => RoleOverride._();
  RoleOverride createEmptyInstance() => create();
  static $pb.PbList<RoleOverride> createRepeated() => $pb.PbList<RoleOverride>();
  @$core.pragma('dart2js:noInline')
  static RoleOverride getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoleOverride>(create);
  static RoleOverride? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get userIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get roleName => $_getSZ(1);
  @$pb.TagNumber(2)
  set roleName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoleName() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoleName() => clearField(2);
}

class PermissionGrantOverride extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PermissionGrantOverride', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userIds')
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissions')
    ..hasRequiredFields = false
  ;

  PermissionGrantOverride._() : super();
  factory PermissionGrantOverride({
    $core.Iterable<$core.String>? userIds,
    $core.Iterable<$core.String>? permissions,
  }) {
    final _result = create();
    if (userIds != null) {
      _result.userIds.addAll(userIds);
    }
    if (permissions != null) {
      _result.permissions.addAll(permissions);
    }
    return _result;
  }
  factory PermissionGrantOverride.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PermissionGrantOverride.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PermissionGrantOverride clone() => PermissionGrantOverride()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PermissionGrantOverride copyWith(void Function(PermissionGrantOverride) updates) => super.copyWith((message) => updates(message as PermissionGrantOverride)) as PermissionGrantOverride; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PermissionGrantOverride create() => PermissionGrantOverride._();
  PermissionGrantOverride createEmptyInstance() => create();
  static $pb.PbList<PermissionGrantOverride> createRepeated() => $pb.PbList<PermissionGrantOverride>();
  @$core.pragma('dart2js:noInline')
  static PermissionGrantOverride getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PermissionGrantOverride>(create);
  static PermissionGrantOverride? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get userIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get permissions => $_getList(1);
}

enum UpdateCallPermissionsRequest_GrantInput {
  roleOverride, 
  permissionOverride, 
  notSet
}

class UpdateCallPermissionsRequest extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, UpdateCallPermissionsRequest_GrantInput> _UpdateCallPermissionsRequest_GrantInputByTag = {
    2 : UpdateCallPermissionsRequest_GrantInput.roleOverride,
    3 : UpdateCallPermissionsRequest_GrantInput.permissionOverride,
    0 : UpdateCallPermissionsRequest_GrantInput.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateCallPermissionsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..aOM<RoleOverride>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'roleOverride', subBuilder: RoleOverride.create)
    ..aOM<PermissionGrantOverride>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionOverride', subBuilder: PermissionGrantOverride.create)
    ..hasRequiredFields = false
  ;

  UpdateCallPermissionsRequest._() : super();
  factory UpdateCallPermissionsRequest({
    $core.String? callCid,
    RoleOverride? roleOverride,
    PermissionGrantOverride? permissionOverride,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (roleOverride != null) {
      _result.roleOverride = roleOverride;
    }
    if (permissionOverride != null) {
      _result.permissionOverride = permissionOverride;
    }
    return _result;
  }
  factory UpdateCallPermissionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCallPermissionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateCallPermissionsRequest clone() => UpdateCallPermissionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateCallPermissionsRequest copyWith(void Function(UpdateCallPermissionsRequest) updates) => super.copyWith((message) => updates(message as UpdateCallPermissionsRequest)) as UpdateCallPermissionsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCallPermissionsRequest create() => UpdateCallPermissionsRequest._();
  UpdateCallPermissionsRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateCallPermissionsRequest> createRepeated() => $pb.PbList<UpdateCallPermissionsRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateCallPermissionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCallPermissionsRequest>(create);
  static UpdateCallPermissionsRequest? _defaultInstance;

  UpdateCallPermissionsRequest_GrantInput whichGrantInput() => _UpdateCallPermissionsRequest_GrantInputByTag[$_whichOneof(0)]!;
  void clearGrantInput() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  RoleOverride get roleOverride => $_getN(1);
  @$pb.TagNumber(2)
  set roleOverride(RoleOverride v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoleOverride() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoleOverride() => clearField(2);
  @$pb.TagNumber(2)
  RoleOverride ensureRoleOverride() => $_ensure(1);

  @$pb.TagNumber(3)
  PermissionGrantOverride get permissionOverride => $_getN(2);
  @$pb.TagNumber(3)
  set permissionOverride(PermissionGrantOverride v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPermissionOverride() => $_has(2);
  @$pb.TagNumber(3)
  void clearPermissionOverride() => clearField(3);
  @$pb.TagNumber(3)
  PermissionGrantOverride ensurePermissionOverride() => $_ensure(2);
}

class UpdateCallPermissionsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateCallPermissionsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  UpdateCallPermissionsResponse._() : super();
  factory UpdateCallPermissionsResponse() => create();
  factory UpdateCallPermissionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCallPermissionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateCallPermissionsResponse clone() => UpdateCallPermissionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateCallPermissionsResponse copyWith(void Function(UpdateCallPermissionsResponse) updates) => super.copyWith((message) => updates(message as UpdateCallPermissionsResponse)) as UpdateCallPermissionsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCallPermissionsResponse create() => UpdateCallPermissionsResponse._();
  UpdateCallPermissionsResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateCallPermissionsResponse> createRepeated() => $pb.PbList<UpdateCallPermissionsResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateCallPermissionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCallPermissionsResponse>(create);
  static UpdateCallPermissionsResponse? _defaultInstance;
}

class EndCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EndCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..hasRequiredFields = false
  ;

  EndCallRequest._() : super();
  factory EndCallRequest({
    $core.String? callCid,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    return _result;
  }
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

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);
}

class EndCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EndCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
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

class CreateCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOM<$3.CallEnvelope>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.CallEnvelope.create)
    ..hasRequiredFields = false
  ;

  CreateCallResponse._() : super();
  factory CreateCallResponse({
    $3.CallEnvelope? call,
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
  $3.CallEnvelope get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.CallEnvelope v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.CallEnvelope ensureCall() => $_ensure(0);
}

class QueryCallsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryCallsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mqJson', $pb.PbFieldType.OY)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'limit', $pb.PbFieldType.O3)
    ..pc<$5.Sort>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sorts', $pb.PbFieldType.PM, subBuilder: $5.Sort.create)
    ..hasRequiredFields = false
  ;

  QueryCallsRequest._() : super();
  factory QueryCallsRequest({
    $core.List<$core.int>? mqJson,
    $core.int? limit,
    $core.Iterable<$5.Sort>? sorts,
  }) {
    final _result = create();
    if (mqJson != null) {
      _result.mqJson = mqJson;
    }
    if (limit != null) {
      _result.limit = limit;
    }
    if (sorts != null) {
      _result.sorts.addAll(sorts);
    }
    return _result;
  }
  factory QueryCallsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryCallsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryCallsRequest clone() => QueryCallsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryCallsRequest copyWith(void Function(QueryCallsRequest) updates) => super.copyWith((message) => updates(message as QueryCallsRequest)) as QueryCallsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryCallsRequest create() => QueryCallsRequest._();
  QueryCallsRequest createEmptyInstance() => create();
  static $pb.PbList<QueryCallsRequest> createRepeated() => $pb.PbList<QueryCallsRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryCallsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryCallsRequest>(create);
  static QueryCallsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get mqJson => $_getN(0);
  @$pb.TagNumber(1)
  set mqJson($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMqJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearMqJson() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$5.Sort> get sorts => $_getList(2);
}

class QueryCallsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryCallsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOM<$3.CallsEnvelope>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calls', subBuilder: $3.CallsEnvelope.create)
    ..hasRequiredFields = false
  ;

  QueryCallsResponse._() : super();
  factory QueryCallsResponse({
    $3.CallsEnvelope? calls,
  }) {
    final _result = create();
    if (calls != null) {
      _result.calls = calls;
    }
    return _result;
  }
  factory QueryCallsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryCallsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryCallsResponse clone() => QueryCallsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryCallsResponse copyWith(void Function(QueryCallsResponse) updates) => super.copyWith((message) => updates(message as QueryCallsResponse)) as QueryCallsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryCallsResponse create() => QueryCallsResponse._();
  QueryCallsResponse createEmptyInstance() => create();
  static $pb.PbList<QueryCallsResponse> createRepeated() => $pb.PbList<QueryCallsResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryCallsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryCallsResponse>(create);
  static QueryCallsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $3.CallsEnvelope get calls => $_getN(0);
  @$pb.TagNumber(1)
  set calls($3.CallsEnvelope v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCalls() => $_has(0);
  @$pb.TagNumber(1)
  void clearCalls() => clearField(1);
  @$pb.TagNumber(1)
  $3.CallsEnvelope ensureCalls() => $_ensure(0);
}

class QueryMembersRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryMembersRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mqJson', $pb.PbFieldType.OY)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'limit', $pb.PbFieldType.O3)
    ..pc<$5.Sort>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sorts', $pb.PbFieldType.PM, subBuilder: $5.Sort.create)
    ..hasRequiredFields = false
  ;

  QueryMembersRequest._() : super();
  factory QueryMembersRequest({
    $core.List<$core.int>? mqJson,
    $core.int? limit,
    $core.Iterable<$5.Sort>? sorts,
  }) {
    final _result = create();
    if (mqJson != null) {
      _result.mqJson = mqJson;
    }
    if (limit != null) {
      _result.limit = limit;
    }
    if (sorts != null) {
      _result.sorts.addAll(sorts);
    }
    return _result;
  }
  factory QueryMembersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryMembersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryMembersRequest clone() => QueryMembersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryMembersRequest copyWith(void Function(QueryMembersRequest) updates) => super.copyWith((message) => updates(message as QueryMembersRequest)) as QueryMembersRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryMembersRequest create() => QueryMembersRequest._();
  QueryMembersRequest createEmptyInstance() => create();
  static $pb.PbList<QueryMembersRequest> createRepeated() => $pb.PbList<QueryMembersRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryMembersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryMembersRequest>(create);
  static QueryMembersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get mqJson => $_getN(0);
  @$pb.TagNumber(1)
  set mqJson($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMqJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearMqJson() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$5.Sort> get sorts => $_getList(2);
}

class QueryMembersResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryMembersResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOM<$3.MembersEnvelope>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'members', subBuilder: $3.MembersEnvelope.create)
    ..hasRequiredFields = false
  ;

  QueryMembersResponse._() : super();
  factory QueryMembersResponse({
    $3.MembersEnvelope? members,
  }) {
    final _result = create();
    if (members != null) {
      _result.members = members;
    }
    return _result;
  }
  factory QueryMembersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryMembersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryMembersResponse clone() => QueryMembersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryMembersResponse copyWith(void Function(QueryMembersResponse) updates) => super.copyWith((message) => updates(message as QueryMembersResponse)) as QueryMembersResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryMembersResponse create() => QueryMembersResponse._();
  QueryMembersResponse createEmptyInstance() => create();
  static $pb.PbList<QueryMembersResponse> createRepeated() => $pb.PbList<QueryMembersResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryMembersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryMembersResponse>(create);
  static QueryMembersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $3.MembersEnvelope get members => $_getN(0);
  @$pb.TagNumber(1)
  set members($3.MembersEnvelope v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMembers() => $_has(0);
  @$pb.TagNumber(1)
  void clearMembers() => clearField(1);
  @$pb.TagNumber(1)
  $3.MembersEnvelope ensureMembers() => $_ensure(0);
}

class QueryUsersRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryUsersRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mqJson', $pb.PbFieldType.OY)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'limit', $pb.PbFieldType.O3)
    ..pc<$5.Sort>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sorts', $pb.PbFieldType.PM, subBuilder: $5.Sort.create)
    ..hasRequiredFields = false
  ;

  QueryUsersRequest._() : super();
  factory QueryUsersRequest({
    $core.List<$core.int>? mqJson,
    $core.int? limit,
    $core.Iterable<$5.Sort>? sorts,
  }) {
    final _result = create();
    if (mqJson != null) {
      _result.mqJson = mqJson;
    }
    if (limit != null) {
      _result.limit = limit;
    }
    if (sorts != null) {
      _result.sorts.addAll(sorts);
    }
    return _result;
  }
  factory QueryUsersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryUsersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryUsersRequest clone() => QueryUsersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryUsersRequest copyWith(void Function(QueryUsersRequest) updates) => super.copyWith((message) => updates(message as QueryUsersRequest)) as QueryUsersRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryUsersRequest create() => QueryUsersRequest._();
  QueryUsersRequest createEmptyInstance() => create();
  static $pb.PbList<QueryUsersRequest> createRepeated() => $pb.PbList<QueryUsersRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryUsersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryUsersRequest>(create);
  static QueryUsersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get mqJson => $_getN(0);
  @$pb.TagNumber(1)
  set mqJson($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMqJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearMqJson() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$5.Sort> get sorts => $_getList(2);
}

class QueryUsersResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryUsersResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..pc<$1.User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'users', $pb.PbFieldType.PM, subBuilder: $1.User.create)
    ..hasRequiredFields = false
  ;

  QueryUsersResponse._() : super();
  factory QueryUsersResponse({
    $core.Iterable<$1.User>? users,
  }) {
    final _result = create();
    if (users != null) {
      _result.users.addAll(users);
    }
    return _result;
  }
  factory QueryUsersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryUsersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryUsersResponse clone() => QueryUsersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryUsersResponse copyWith(void Function(QueryUsersResponse) updates) => super.copyWith((message) => updates(message as QueryUsersResponse)) as QueryUsersResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryUsersResponse create() => QueryUsersResponse._();
  QueryUsersResponse createEmptyInstance() => create();
  static $pb.PbList<QueryUsersResponse> createRepeated() => $pb.PbList<QueryUsersResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryUsersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryUsersResponse>(create);
  static QueryUsersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$1.User> get users => $_getList(0);
}

class UpsertUsersRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpsertUsersRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..pc<$1.UserInput>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'users', $pb.PbFieldType.PM, subBuilder: $1.UserInput.create)
    ..hasRequiredFields = false
  ;

  UpsertUsersRequest._() : super();
  factory UpsertUsersRequest({
    $core.Iterable<$1.UserInput>? users,
  }) {
    final _result = create();
    if (users != null) {
      _result.users.addAll(users);
    }
    return _result;
  }
  factory UpsertUsersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertUsersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertUsersRequest clone() => UpsertUsersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertUsersRequest copyWith(void Function(UpsertUsersRequest) updates) => super.copyWith((message) => updates(message as UpsertUsersRequest)) as UpsertUsersRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpsertUsersRequest create() => UpsertUsersRequest._();
  UpsertUsersRequest createEmptyInstance() => create();
  static $pb.PbList<UpsertUsersRequest> createRepeated() => $pb.PbList<UpsertUsersRequest>();
  @$core.pragma('dart2js:noInline')
  static UpsertUsersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertUsersRequest>(create);
  static UpsertUsersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$1.UserInput> get users => $_getList(0);
}

class UpsertUsersResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpsertUsersResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..pc<$1.User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'users', $pb.PbFieldType.PM, subBuilder: $1.User.create)
    ..hasRequiredFields = false
  ;

  UpsertUsersResponse._() : super();
  factory UpsertUsersResponse({
    $core.Iterable<$1.User>? users,
  }) {
    final _result = create();
    if (users != null) {
      _result.users.addAll(users);
    }
    return _result;
  }
  factory UpsertUsersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertUsersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertUsersResponse clone() => UpsertUsersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertUsersResponse copyWith(void Function(UpsertUsersResponse) updates) => super.copyWith((message) => updates(message as UpsertUsersResponse)) as UpsertUsersResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpsertUsersResponse create() => UpsertUsersResponse._();
  UpsertUsersResponse createEmptyInstance() => create();
  static $pb.PbList<UpsertUsersResponse> createRepeated() => $pb.PbList<UpsertUsersResponse>();
  @$core.pragma('dart2js:noInline')
  static UpsertUsersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertUsersResponse>(create);
  static UpsertUsersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$1.User> get users => $_getList(0);
}

class GetCallEdgeServerRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetCallEdgeServerRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..aOM<$4.LatencyMeasurements>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'measurements', subBuilder: $4.LatencyMeasurements.create)
    ..hasRequiredFields = false
  ;

  GetCallEdgeServerRequest._() : super();
  factory GetCallEdgeServerRequest({
    $core.String? callCid,
    $4.LatencyMeasurements? measurements,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (measurements != null) {
      _result.measurements = measurements;
    }
    return _result;
  }
  factory GetCallEdgeServerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCallEdgeServerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCallEdgeServerRequest clone() => GetCallEdgeServerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCallEdgeServerRequest copyWith(void Function(GetCallEdgeServerRequest) updates) => super.copyWith((message) => updates(message as GetCallEdgeServerRequest)) as GetCallEdgeServerRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCallEdgeServerRequest create() => GetCallEdgeServerRequest._();
  GetCallEdgeServerRequest createEmptyInstance() => create();
  static $pb.PbList<GetCallEdgeServerRequest> createRepeated() => $pb.PbList<GetCallEdgeServerRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCallEdgeServerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCallEdgeServerRequest>(create);
  static GetCallEdgeServerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  $4.LatencyMeasurements get measurements => $_getN(1);
  @$pb.TagNumber(2)
  set measurements($4.LatencyMeasurements v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasMeasurements() => $_has(1);
  @$pb.TagNumber(2)
  void clearMeasurements() => clearField(2);
  @$pb.TagNumber(2)
  $4.LatencyMeasurements ensureMeasurements() => $_ensure(1);
}

class GetCallEdgeServerResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetCallEdgeServerResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOM<$3.CallEnvelope>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $3.CallEnvelope.create)
    ..aOM<$4.Credentials>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'credentials', subBuilder: $4.Credentials.create)
    ..hasRequiredFields = false
  ;

  GetCallEdgeServerResponse._() : super();
  factory GetCallEdgeServerResponse({
    $3.CallEnvelope? call,
    $4.Credentials? credentials,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (credentials != null) {
      _result.credentials = credentials;
    }
    return _result;
  }
  factory GetCallEdgeServerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCallEdgeServerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCallEdgeServerResponse clone() => GetCallEdgeServerResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCallEdgeServerResponse copyWith(void Function(GetCallEdgeServerResponse) updates) => super.copyWith((message) => updates(message as GetCallEdgeServerResponse)) as GetCallEdgeServerResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCallEdgeServerResponse create() => GetCallEdgeServerResponse._();
  GetCallEdgeServerResponse createEmptyInstance() => create();
  static $pb.PbList<GetCallEdgeServerResponse> createRepeated() => $pb.PbList<GetCallEdgeServerResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCallEdgeServerResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCallEdgeServerResponse>(create);
  static GetCallEdgeServerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $3.CallEnvelope get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($3.CallEnvelope v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $3.CallEnvelope ensureCall() => $_ensure(0);

  @$pb.TagNumber(2)
  $4.Credentials get credentials => $_getN(1);
  @$pb.TagNumber(2)
  set credentials($4.Credentials v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCredentials() => $_has(1);
  @$pb.TagNumber(2)
  void clearCredentials() => clearField(2);
  @$pb.TagNumber(2)
  $4.Credentials ensureCredentials() => $_ensure(1);
}

class CreateDeviceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateDeviceRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOM<$6.DeviceInput>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'input', subBuilder: $6.DeviceInput.create)
    ..hasRequiredFields = false
  ;

  CreateDeviceRequest._() : super();
  factory CreateDeviceRequest({
    $6.DeviceInput? input,
  }) {
    final _result = create();
    if (input != null) {
      _result.input = input;
    }
    return _result;
  }
  factory CreateDeviceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateDeviceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateDeviceRequest clone() => CreateDeviceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateDeviceRequest copyWith(void Function(CreateDeviceRequest) updates) => super.copyWith((message) => updates(message as CreateDeviceRequest)) as CreateDeviceRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateDeviceRequest create() => CreateDeviceRequest._();
  CreateDeviceRequest createEmptyInstance() => create();
  static $pb.PbList<CreateDeviceRequest> createRepeated() => $pb.PbList<CreateDeviceRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateDeviceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateDeviceRequest>(create);
  static CreateDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $6.DeviceInput get input => $_getN(0);
  @$pb.TagNumber(1)
  set input($6.DeviceInput v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasInput() => $_has(0);
  @$pb.TagNumber(1)
  void clearInput() => clearField(1);
  @$pb.TagNumber(1)
  $6.DeviceInput ensureInput() => $_ensure(0);
}

class CreateDeviceResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateDeviceResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOM<$6.Device>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device', subBuilder: $6.Device.create)
    ..hasRequiredFields = false
  ;

  CreateDeviceResponse._() : super();
  factory CreateDeviceResponse({
    $6.Device? device,
  }) {
    final _result = create();
    if (device != null) {
      _result.device = device;
    }
    return _result;
  }
  factory CreateDeviceResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateDeviceResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateDeviceResponse clone() => CreateDeviceResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateDeviceResponse copyWith(void Function(CreateDeviceResponse) updates) => super.copyWith((message) => updates(message as CreateDeviceResponse)) as CreateDeviceResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateDeviceResponse create() => CreateDeviceResponse._();
  CreateDeviceResponse createEmptyInstance() => create();
  static $pb.PbList<CreateDeviceResponse> createRepeated() => $pb.PbList<CreateDeviceResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateDeviceResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateDeviceResponse>(create);
  static CreateDeviceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $6.Device get device => $_getN(0);
  @$pb.TagNumber(1)
  set device($6.Device v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => clearField(1);
  @$pb.TagNumber(1)
  $6.Device ensureDevice() => $_ensure(0);
}

class DeleteDeviceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteDeviceRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  DeleteDeviceRequest._() : super();
  factory DeleteDeviceRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory DeleteDeviceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteDeviceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteDeviceRequest clone() => DeleteDeviceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteDeviceRequest copyWith(void Function(DeleteDeviceRequest) updates) => super.copyWith((message) => updates(message as DeleteDeviceRequest)) as DeleteDeviceRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteDeviceRequest create() => DeleteDeviceRequest._();
  DeleteDeviceRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteDeviceRequest> createRepeated() => $pb.PbList<DeleteDeviceRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteDeviceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteDeviceRequest>(create);
  static DeleteDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class DeleteDeviceResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteDeviceResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  DeleteDeviceResponse._() : super();
  factory DeleteDeviceResponse() => create();
  factory DeleteDeviceResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteDeviceResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteDeviceResponse clone() => DeleteDeviceResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteDeviceResponse copyWith(void Function(DeleteDeviceResponse) updates) => super.copyWith((message) => updates(message as DeleteDeviceResponse)) as DeleteDeviceResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteDeviceResponse create() => DeleteDeviceResponse._();
  DeleteDeviceResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteDeviceResponse> createRepeated() => $pb.PbList<DeleteDeviceResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteDeviceResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteDeviceResponse>(create);
  static DeleteDeviceResponse? _defaultInstance;
}

class QueryDevicesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryDevicesRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  QueryDevicesRequest._() : super();
  factory QueryDevicesRequest() => create();
  factory QueryDevicesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryDevicesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryDevicesRequest clone() => QueryDevicesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryDevicesRequest copyWith(void Function(QueryDevicesRequest) updates) => super.copyWith((message) => updates(message as QueryDevicesRequest)) as QueryDevicesRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryDevicesRequest create() => QueryDevicesRequest._();
  QueryDevicesRequest createEmptyInstance() => create();
  static $pb.PbList<QueryDevicesRequest> createRepeated() => $pb.PbList<QueryDevicesRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryDevicesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryDevicesRequest>(create);
  static QueryDevicesRequest? _defaultInstance;
}

class QueryDevicesResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryDevicesResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..pc<$6.Device>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'devices', $pb.PbFieldType.PM, subBuilder: $6.Device.create)
    ..hasRequiredFields = false
  ;

  QueryDevicesResponse._() : super();
  factory QueryDevicesResponse({
    $core.Iterable<$6.Device>? devices,
  }) {
    final _result = create();
    if (devices != null) {
      _result.devices.addAll(devices);
    }
    return _result;
  }
  factory QueryDevicesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryDevicesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryDevicesResponse clone() => QueryDevicesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryDevicesResponse copyWith(void Function(QueryDevicesResponse) updates) => super.copyWith((message) => updates(message as QueryDevicesResponse)) as QueryDevicesResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryDevicesResponse create() => QueryDevicesResponse._();
  QueryDevicesResponse createEmptyInstance() => create();
  static $pb.PbList<QueryDevicesResponse> createRepeated() => $pb.PbList<QueryDevicesResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryDevicesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryDevicesResponse>(create);
  static QueryDevicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$6.Device> get devices => $_getList(0);
}

class SendEventRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendEventRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..e<UserEventType>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'eventType', $pb.PbFieldType.OE, defaultOrMaker: UserEventType.USER_EVENT_TYPE_UNSPECIFIED, valueOf: UserEventType.valueOf, enumValues: UserEventType.values)
    ..hasRequiredFields = false
  ;

  SendEventRequest._() : super();
  factory SendEventRequest({
    $core.String? callCid,
    UserEventType? eventType,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
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
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  UserEventType get eventType => $_getN(1);
  @$pb.TagNumber(2)
  set eventType(UserEventType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasEventType() => $_has(1);
  @$pb.TagNumber(2)
  void clearEventType() => clearField(2);
}

class SendEventResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendEventResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
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

class SendCustomEventRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendCustomEventRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dataJson', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  SendCustomEventRequest._() : super();
  factory SendCustomEventRequest({
    $core.String? callCid,
    $core.String? type,
    $core.List<$core.int>? dataJson,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (type != null) {
      _result.type = type;
    }
    if (dataJson != null) {
      _result.dataJson = dataJson;
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
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get dataJson => $_getN(2);
  @$pb.TagNumber(3)
  set dataJson($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDataJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearDataJson() => clearField(3);
}

class SendCustomEventResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendCustomEventResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
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

class ReportCallStatsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReportCallStatsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'statsJson', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ReportCallStatsRequest._() : super();
  factory ReportCallStatsRequest({
    $core.String? callCid,
    $core.List<$core.int>? statsJson,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (statsJson != null) {
      _result.statsJson = statsJson;
    }
    return _result;
  }
  factory ReportCallStatsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReportCallStatsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReportCallStatsRequest clone() => ReportCallStatsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReportCallStatsRequest copyWith(void Function(ReportCallStatsRequest) updates) => super.copyWith((message) => updates(message as ReportCallStatsRequest)) as ReportCallStatsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReportCallStatsRequest create() => ReportCallStatsRequest._();
  ReportCallStatsRequest createEmptyInstance() => create();
  static $pb.PbList<ReportCallStatsRequest> createRepeated() => $pb.PbList<ReportCallStatsRequest>();
  @$core.pragma('dart2js:noInline')
  static ReportCallStatsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportCallStatsRequest>(create);
  static ReportCallStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get statsJson => $_getN(1);
  @$pb.TagNumber(2)
  set statsJson($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatsJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatsJson() => clearField(2);
}

class ReportCallStatsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReportCallStatsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  ReportCallStatsResponse._() : super();
  factory ReportCallStatsResponse() => create();
  factory ReportCallStatsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReportCallStatsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReportCallStatsResponse clone() => ReportCallStatsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReportCallStatsResponse copyWith(void Function(ReportCallStatsResponse) updates) => super.copyWith((message) => updates(message as ReportCallStatsResponse)) as ReportCallStatsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReportCallStatsResponse create() => ReportCallStatsResponse._();
  ReportCallStatsResponse createEmptyInstance() => create();
  static $pb.PbList<ReportCallStatsResponse> createRepeated() => $pb.PbList<ReportCallStatsResponse>();
  @$core.pragma('dart2js:noInline')
  static ReportCallStatsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportCallStatsResponse>(create);
  static ReportCallStatsResponse? _defaultInstance;
}

enum ReportCallStatEventRequest_Event {
  participantConnected, 
  participantDisconnected, 
  mediaStateChanged, 
  notSet
}

class ReportCallStatEventRequest extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, ReportCallStatEventRequest_Event> _ReportCallStatEventRequest_EventByTag = {
    3 : ReportCallStatEventRequest_Event.participantConnected,
    4 : ReportCallStatEventRequest_Event.participantDisconnected,
    5 : ReportCallStatEventRequest_Event.mediaStateChanged,
    0 : ReportCallStatEventRequest_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReportCallStatEventRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..aOM<$7.Timestamp>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp', subBuilder: $7.Timestamp.create)
    ..aOM<$8.ParticipantConnected>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantConnected', subBuilder: $8.ParticipantConnected.create)
    ..aOM<$8.ParticipantDisconnected>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participantDisconnected', subBuilder: $8.ParticipantDisconnected.create)
    ..aOM<$8.MediaStateChanged>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mediaStateChanged', subBuilder: $8.MediaStateChanged.create)
    ..hasRequiredFields = false
  ;

  ReportCallStatEventRequest._() : super();
  factory ReportCallStatEventRequest({
    $core.String? callCid,
    $7.Timestamp? timestamp,
    $8.ParticipantConnected? participantConnected,
    $8.ParticipantDisconnected? participantDisconnected,
    $8.MediaStateChanged? mediaStateChanged,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (participantConnected != null) {
      _result.participantConnected = participantConnected;
    }
    if (participantDisconnected != null) {
      _result.participantDisconnected = participantDisconnected;
    }
    if (mediaStateChanged != null) {
      _result.mediaStateChanged = mediaStateChanged;
    }
    return _result;
  }
  factory ReportCallStatEventRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReportCallStatEventRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReportCallStatEventRequest clone() => ReportCallStatEventRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReportCallStatEventRequest copyWith(void Function(ReportCallStatEventRequest) updates) => super.copyWith((message) => updates(message as ReportCallStatEventRequest)) as ReportCallStatEventRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReportCallStatEventRequest create() => ReportCallStatEventRequest._();
  ReportCallStatEventRequest createEmptyInstance() => create();
  static $pb.PbList<ReportCallStatEventRequest> createRepeated() => $pb.PbList<ReportCallStatEventRequest>();
  @$core.pragma('dart2js:noInline')
  static ReportCallStatEventRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportCallStatEventRequest>(create);
  static ReportCallStatEventRequest? _defaultInstance;

  ReportCallStatEventRequest_Event whichEvent() => _ReportCallStatEventRequest_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  $7.Timestamp get timestamp => $_getN(1);
  @$pb.TagNumber(2)
  set timestamp($7.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => clearField(2);
  @$pb.TagNumber(2)
  $7.Timestamp ensureTimestamp() => $_ensure(1);

  @$pb.TagNumber(3)
  $8.ParticipantConnected get participantConnected => $_getN(2);
  @$pb.TagNumber(3)
  set participantConnected($8.ParticipantConnected v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasParticipantConnected() => $_has(2);
  @$pb.TagNumber(3)
  void clearParticipantConnected() => clearField(3);
  @$pb.TagNumber(3)
  $8.ParticipantConnected ensureParticipantConnected() => $_ensure(2);

  @$pb.TagNumber(4)
  $8.ParticipantDisconnected get participantDisconnected => $_getN(3);
  @$pb.TagNumber(4)
  set participantDisconnected($8.ParticipantDisconnected v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasParticipantDisconnected() => $_has(3);
  @$pb.TagNumber(4)
  void clearParticipantDisconnected() => clearField(4);
  @$pb.TagNumber(4)
  $8.ParticipantDisconnected ensureParticipantDisconnected() => $_ensure(3);

  @$pb.TagNumber(5)
  $8.MediaStateChanged get mediaStateChanged => $_getN(4);
  @$pb.TagNumber(5)
  set mediaStateChanged($8.MediaStateChanged v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasMediaStateChanged() => $_has(4);
  @$pb.TagNumber(5)
  void clearMediaStateChanged() => clearField(5);
  @$pb.TagNumber(5)
  $8.MediaStateChanged ensureMediaStateChanged() => $_ensure(4);
}

class ReportCallStatEventResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReportCallStatEventResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  ReportCallStatEventResponse._() : super();
  factory ReportCallStatEventResponse() => create();
  factory ReportCallStatEventResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReportCallStatEventResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReportCallStatEventResponse clone() => ReportCallStatEventResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReportCallStatEventResponse copyWith(void Function(ReportCallStatEventResponse) updates) => super.copyWith((message) => updates(message as ReportCallStatEventResponse)) as ReportCallStatEventResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReportCallStatEventResponse create() => ReportCallStatEventResponse._();
  ReportCallStatEventResponse createEmptyInstance() => create();
  static $pb.PbList<ReportCallStatEventResponse> createRepeated() => $pb.PbList<ReportCallStatEventResponse>();
  @$core.pragma('dart2js:noInline')
  static ReportCallStatEventResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportCallStatEventResponse>(create);
  static ReportCallStatEventResponse? _defaultInstance;
}

class GetCallStatsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetCallStatsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..hasRequiredFields = false
  ;

  GetCallStatsRequest._() : super();
  factory GetCallStatsRequest({
    $core.String? callCid,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    return _result;
  }
  factory GetCallStatsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCallStatsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCallStatsRequest clone() => GetCallStatsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCallStatsRequest copyWith(void Function(GetCallStatsRequest) updates) => super.copyWith((message) => updates(message as GetCallStatsRequest)) as GetCallStatsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCallStatsRequest create() => GetCallStatsRequest._();
  GetCallStatsRequest createEmptyInstance() => create();
  static $pb.PbList<GetCallStatsRequest> createRepeated() => $pb.PbList<GetCallStatsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCallStatsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCallStatsRequest>(create);
  static GetCallStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);
}

class ReportIssueRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReportIssueRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'customJson', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ReportIssueRequest._() : super();
  factory ReportIssueRequest({
    $core.String? callCid,
    $core.String? description,
    $core.List<$core.int>? customJson,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (description != null) {
      _result.description = description;
    }
    if (customJson != null) {
      _result.customJson = customJson;
    }
    return _result;
  }
  factory ReportIssueRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReportIssueRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReportIssueRequest clone() => ReportIssueRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReportIssueRequest copyWith(void Function(ReportIssueRequest) updates) => super.copyWith((message) => updates(message as ReportIssueRequest)) as ReportIssueRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReportIssueRequest create() => ReportIssueRequest._();
  ReportIssueRequest createEmptyInstance() => create();
  static $pb.PbList<ReportIssueRequest> createRepeated() => $pb.PbList<ReportIssueRequest>();
  @$core.pragma('dart2js:noInline')
  static ReportIssueRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportIssueRequest>(create);
  static ReportIssueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get customJson => $_getN(2);
  @$pb.TagNumber(3)
  set customJson($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCustomJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustomJson() => clearField(3);
}

class ReportIssueResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReportIssueResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  ReportIssueResponse._() : super();
  factory ReportIssueResponse() => create();
  factory ReportIssueResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReportIssueResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReportIssueResponse clone() => ReportIssueResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReportIssueResponse copyWith(void Function(ReportIssueResponse) updates) => super.copyWith((message) => updates(message as ReportIssueResponse)) as ReportIssueResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReportIssueResponse create() => ReportIssueResponse._();
  ReportIssueResponse createEmptyInstance() => create();
  static $pb.PbList<ReportIssueResponse> createRepeated() => $pb.PbList<ReportIssueResponse>();
  @$core.pragma('dart2js:noInline')
  static ReportIssueResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportIssueResponse>(create);
  static ReportIssueResponse? _defaultInstance;
}

class ReviewCallRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReviewCallRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stars', $pb.PbFieldType.OF)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'customJson', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ReviewCallRequest._() : super();
  factory ReviewCallRequest({
    $core.String? callCid,
    $core.double? stars,
    $core.String? description,
    $core.List<$core.int>? customJson,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (stars != null) {
      _result.stars = stars;
    }
    if (description != null) {
      _result.description = description;
    }
    if (customJson != null) {
      _result.customJson = customJson;
    }
    return _result;
  }
  factory ReviewCallRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReviewCallRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReviewCallRequest clone() => ReviewCallRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReviewCallRequest copyWith(void Function(ReviewCallRequest) updates) => super.copyWith((message) => updates(message as ReviewCallRequest)) as ReviewCallRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReviewCallRequest create() => ReviewCallRequest._();
  ReviewCallRequest createEmptyInstance() => create();
  static $pb.PbList<ReviewCallRequest> createRepeated() => $pb.PbList<ReviewCallRequest>();
  @$core.pragma('dart2js:noInline')
  static ReviewCallRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReviewCallRequest>(create);
  static ReviewCallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get stars => $_getN(1);
  @$pb.TagNumber(2)
  set stars($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStars() => $_has(1);
  @$pb.TagNumber(2)
  void clearStars() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get customJson => $_getN(3);
  @$pb.TagNumber(4)
  set customJson($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCustomJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomJson() => clearField(4);
}

class ReviewCallResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReviewCallResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  ReviewCallResponse._() : super();
  factory ReviewCallResponse() => create();
  factory ReviewCallResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReviewCallResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReviewCallResponse clone() => ReviewCallResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReviewCallResponse copyWith(void Function(ReviewCallResponse) updates) => super.copyWith((message) => updates(message as ReviewCallResponse)) as ReviewCallResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReviewCallResponse create() => ReviewCallResponse._();
  ReviewCallResponse createEmptyInstance() => create();
  static $pb.PbList<ReviewCallResponse> createRepeated() => $pb.PbList<ReviewCallResponse>();
  @$core.pragma('dart2js:noInline')
  static ReviewCallResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReviewCallResponse>(create);
  static ReviewCallResponse? _defaultInstance;
}

class StartBroadcastRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StartBroadcastRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hlsBroadcast')
    ..aOM<$9.RTMPOptions>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rtmp', subBuilder: $9.RTMPOptions.create)
    ..hasRequiredFields = false
  ;

  StartBroadcastRequest._() : super();
  factory StartBroadcastRequest({
    $core.String? callType,
    $core.String? callId,
    $core.bool? hlsBroadcast,
    $9.RTMPOptions? rtmp,
  }) {
    final _result = create();
    if (callType != null) {
      _result.callType = callType;
    }
    if (callId != null) {
      _result.callId = callId;
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
  $core.bool get hlsBroadcast => $_getBF(2);
  @$pb.TagNumber(3)
  set hlsBroadcast($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHlsBroadcast() => $_has(2);
  @$pb.TagNumber(3)
  void clearHlsBroadcast() => clearField(3);

  @$pb.TagNumber(5)
  $9.RTMPOptions get rtmp => $_getN(3);
  @$pb.TagNumber(5)
  set rtmp($9.RTMPOptions v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasRtmp() => $_has(3);
  @$pb.TagNumber(5)
  void clearRtmp() => clearField(5);
  @$pb.TagNumber(5)
  $9.RTMPOptions ensureRtmp() => $_ensure(3);
}

class StartBroadcastResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StartBroadcastResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOM<$9.Broadcast>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcast', subBuilder: $9.Broadcast.create)
    ..hasRequiredFields = false
  ;

  StartBroadcastResponse._() : super();
  factory StartBroadcastResponse({
    $9.Broadcast? broadcast,
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
  $9.Broadcast get broadcast => $_getN(0);
  @$pb.TagNumber(1)
  set broadcast($9.Broadcast v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBroadcast() => $_has(0);
  @$pb.TagNumber(1)
  void clearBroadcast() => clearField(1);
  @$pb.TagNumber(1)
  $9.Broadcast ensureBroadcast() => $_ensure(0);
}

class StopBroadcastRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StopBroadcastRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..hasRequiredFields = false
  ;

  StopBroadcastRequest._() : super();
  factory StopBroadcastRequest({
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

class StopBroadcastResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StopBroadcastResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
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

class StartRecordingRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StartRecordingRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StartRecordingResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StopRecordingRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StopRecordingResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  StopRecordingResponse._() : super();
  factory StopRecordingResponse() => create();
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
}

class ClientRPCApi {
  $pb.RpcClient _client;
  ClientRPCApi(this._client);

  $async.Future<CreateCallResponse> createCall($pb.ClientContext? ctx, CreateCallRequest request) {
    var emptyResponse = CreateCallResponse();
    return _client.invoke<CreateCallResponse>(ctx, 'ClientRPC', 'CreateCall', request, emptyResponse);
  }
  $async.Future<GetOrCreateCallResponse> getOrCreateCall($pb.ClientContext? ctx, GetOrCreateCallRequest request) {
    var emptyResponse = GetOrCreateCallResponse();
    return _client.invoke<GetOrCreateCallResponse>(ctx, 'ClientRPC', 'GetOrCreateCall', request, emptyResponse);
  }
  $async.Future<JoinCallResponse> joinCall($pb.ClientContext? ctx, JoinCallRequest request) {
    var emptyResponse = JoinCallResponse();
    return _client.invoke<JoinCallResponse>(ctx, 'ClientRPC', 'JoinCall', request, emptyResponse);
  }
  $async.Future<GetCallEdgeServerResponse> getCallEdgeServer($pb.ClientContext? ctx, GetCallEdgeServerRequest request) {
    var emptyResponse = GetCallEdgeServerResponse();
    return _client.invoke<GetCallEdgeServerResponse>(ctx, 'ClientRPC', 'GetCallEdgeServer', request, emptyResponse);
  }
  $async.Future<UpdateCallResponse> updateCall($pb.ClientContext? ctx, UpdateCallRequest request) {
    var emptyResponse = UpdateCallResponse();
    return _client.invoke<UpdateCallResponse>(ctx, 'ClientRPC', 'UpdateCall', request, emptyResponse);
  }
  $async.Future<UpdateCallPermissionsResponse> updateCallPermissions($pb.ClientContext? ctx, UpdateCallPermissionsRequest request) {
    var emptyResponse = UpdateCallPermissionsResponse();
    return _client.invoke<UpdateCallPermissionsResponse>(ctx, 'ClientRPC', 'UpdateCallPermissions', request, emptyResponse);
  }
  $async.Future<EndCallResponse> endCall($pb.ClientContext? ctx, EndCallRequest request) {
    var emptyResponse = EndCallResponse();
    return _client.invoke<EndCallResponse>(ctx, 'ClientRPC', 'EndCall', request, emptyResponse);
  }
  $async.Future<QueryCallsResponse> queryCalls($pb.ClientContext? ctx, QueryCallsRequest request) {
    var emptyResponse = QueryCallsResponse();
    return _client.invoke<QueryCallsResponse>(ctx, 'ClientRPC', 'QueryCalls', request, emptyResponse);
  }
  $async.Future<QueryMembersResponse> queryMembers($pb.ClientContext? ctx, QueryMembersRequest request) {
    var emptyResponse = QueryMembersResponse();
    return _client.invoke<QueryMembersResponse>(ctx, 'ClientRPC', 'QueryMembers', request, emptyResponse);
  }
  $async.Future<CreateDeviceResponse> createDevice($pb.ClientContext? ctx, CreateDeviceRequest request) {
    var emptyResponse = CreateDeviceResponse();
    return _client.invoke<CreateDeviceResponse>(ctx, 'ClientRPC', 'CreateDevice', request, emptyResponse);
  }
  $async.Future<DeleteDeviceResponse> deleteDevice($pb.ClientContext? ctx, DeleteDeviceRequest request) {
    var emptyResponse = DeleteDeviceResponse();
    return _client.invoke<DeleteDeviceResponse>(ctx, 'ClientRPC', 'DeleteDevice', request, emptyResponse);
  }
  $async.Future<QueryDevicesResponse> queryDevices($pb.ClientContext? ctx, QueryDevicesRequest request) {
    var emptyResponse = QueryDevicesResponse();
    return _client.invoke<QueryDevicesResponse>(ctx, 'ClientRPC', 'QueryDevices', request, emptyResponse);
  }
  $async.Future<StartBroadcastResponse> startBroadcast($pb.ClientContext? ctx, StartBroadcastRequest request) {
    var emptyResponse = StartBroadcastResponse();
    return _client.invoke<StartBroadcastResponse>(ctx, 'ClientRPC', 'StartBroadcast', request, emptyResponse);
  }
  $async.Future<StopBroadcastResponse> stopBroadcast($pb.ClientContext? ctx, StopBroadcastRequest request) {
    var emptyResponse = StopBroadcastResponse();
    return _client.invoke<StopBroadcastResponse>(ctx, 'ClientRPC', 'StopBroadcast', request, emptyResponse);
  }
  $async.Future<StartRecordingResponse> startRecording($pb.ClientContext? ctx, StartRecordingRequest request) {
    var emptyResponse = StartRecordingResponse();
    return _client.invoke<StartRecordingResponse>(ctx, 'ClientRPC', 'StartRecording', request, emptyResponse);
  }
  $async.Future<StopRecordingResponse> stopRecording($pb.ClientContext? ctx, StopRecordingRequest request) {
    var emptyResponse = StopRecordingResponse();
    return _client.invoke<StopRecordingResponse>(ctx, 'ClientRPC', 'StopRecording', request, emptyResponse);
  }
  $async.Future<UpsertCallMembersResponse> upsertCallMembers($pb.ClientContext? ctx, UpsertCallMembersRequest request) {
    var emptyResponse = UpsertCallMembersResponse();
    return _client.invoke<UpsertCallMembersResponse>(ctx, 'ClientRPC', 'UpsertCallMembers', request, emptyResponse);
  }
  $async.Future<DeleteCallMembersResponse> deleteCallMembers($pb.ClientContext? ctx, DeleteCallMembersRequest request) {
    var emptyResponse = DeleteCallMembersResponse();
    return _client.invoke<DeleteCallMembersResponse>(ctx, 'ClientRPC', 'DeleteCallMembers', request, emptyResponse);
  }
  $async.Future<SendEventResponse> sendEvent($pb.ClientContext? ctx, SendEventRequest request) {
    var emptyResponse = SendEventResponse();
    return _client.invoke<SendEventResponse>(ctx, 'ClientRPC', 'SendEvent', request, emptyResponse);
  }
  $async.Future<SendCustomEventResponse> sendCustomEvent($pb.ClientContext? ctx, SendCustomEventRequest request) {
    var emptyResponse = SendCustomEventResponse();
    return _client.invoke<SendCustomEventResponse>(ctx, 'ClientRPC', 'SendCustomEvent', request, emptyResponse);
  }
  $async.Future<QueryUsersResponse> queryUsers($pb.ClientContext? ctx, QueryUsersRequest request) {
    var emptyResponse = QueryUsersResponse();
    return _client.invoke<QueryUsersResponse>(ctx, 'ClientRPC', 'QueryUsers', request, emptyResponse);
  }
  $async.Future<UpsertUsersResponse> upsertUsers($pb.ClientContext? ctx, UpsertUsersRequest request) {
    var emptyResponse = UpsertUsersResponse();
    return _client.invoke<UpsertUsersResponse>(ctx, 'ClientRPC', 'UpsertUsers', request, emptyResponse);
  }
  $async.Future<ReportCallStatsResponse> reportCallStats($pb.ClientContext? ctx, ReportCallStatsRequest request) {
    var emptyResponse = ReportCallStatsResponse();
    return _client.invoke<ReportCallStatsResponse>(ctx, 'ClientRPC', 'ReportCallStats', request, emptyResponse);
  }
  $async.Future<ReportCallStatEventResponse> reportCallStatEvent($pb.ClientContext? ctx, ReportCallStatEventRequest request) {
    var emptyResponse = ReportCallStatEventResponse();
    return _client.invoke<ReportCallStatEventResponse>(ctx, 'ClientRPC', 'ReportCallStatEvent', request, emptyResponse);
  }
  $async.Future<ReviewCallResponse> reviewCall($pb.ClientContext? ctx, ReviewCallRequest request) {
    var emptyResponse = ReviewCallResponse();
    return _client.invoke<ReviewCallResponse>(ctx, 'ClientRPC', 'ReviewCall', request, emptyResponse);
  }
  $async.Future<ReportIssueResponse> reportIssue($pb.ClientContext? ctx, ReportIssueRequest request) {
    var emptyResponse = ReportIssueResponse();
    return _client.invoke<ReportIssueResponse>(ctx, 'ClientRPC', 'ReportIssue', request, emptyResponse);
  }
}

