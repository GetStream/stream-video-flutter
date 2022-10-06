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
import '../edge_v1/edge.pb.dart' as $4;
import '../call_v1/call.pb.dart' as $0;
import '../utils_v1/utils.pb.dart' as $5;
import '../push_v1/push.pb.dart' as $6;

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
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'role')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'customJson', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  MemberInput._() : super();
  factory MemberInput({
    $core.String? role,
    $core.List<$core.int>? customJson,
  }) {
    final _result = create();
    if (role != null) {
      _result.role = role;
    }
    if (customJson != null) {
      _result.customJson = customJson;
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
  $core.String get role => $_getSZ(0);
  @$pb.TagNumber(1)
  set role($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get customJson => $_getN(1);
  @$pb.TagNumber(2)
  set customJson($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCustomJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustomJson() => clearField(2);
}

class UpdateCallMembersRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateCallMembersRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..m<$core.String, MemberInput>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'members', entryClassName: 'UpdateCallMembersRequest.MembersEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: MemberInput.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..pc<MemberField>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fields', $pb.PbFieldType.KE, valueOf: MemberField.valueOf, enumValues: MemberField.values, defaultEnumValue: MemberField.MEMBER_FIELD_UNSPECIFIED)
    ..hasRequiredFields = false
  ;

  UpdateCallMembersRequest._() : super();
  factory UpdateCallMembersRequest({
    $core.String? callCid,
    $core.Map<$core.String, MemberInput>? members,
    $core.Iterable<MemberField>? fields,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (members != null) {
      _result.members.addAll(members);
    }
    if (fields != null) {
      _result.fields.addAll(fields);
    }
    return _result;
  }
  factory UpdateCallMembersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCallMembersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateCallMembersRequest clone() => UpdateCallMembersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateCallMembersRequest copyWith(void Function(UpdateCallMembersRequest) updates) => super.copyWith((message) => updates(message as UpdateCallMembersRequest)) as UpdateCallMembersRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCallMembersRequest create() => UpdateCallMembersRequest._();
  UpdateCallMembersRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateCallMembersRequest> createRepeated() => $pb.PbList<UpdateCallMembersRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateCallMembersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCallMembersRequest>(create);
  static UpdateCallMembersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  $core.Map<$core.String, MemberInput> get members => $_getMap(1);

  @$pb.TagNumber(3)
  $core.List<MemberField> get fields => $_getList(2);
}

class UpdateCallMembersResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateCallMembersResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  UpdateCallMembersResponse._() : super();
  factory UpdateCallMembersResponse() => create();
  factory UpdateCallMembersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCallMembersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateCallMembersResponse clone() => UpdateCallMembersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateCallMembersResponse copyWith(void Function(UpdateCallMembersResponse) updates) => super.copyWith((message) => updates(message as UpdateCallMembersResponse)) as UpdateCallMembersResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCallMembersResponse create() => UpdateCallMembersResponse._();
  UpdateCallMembersResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateCallMembersResponse> createRepeated() => $pb.PbList<UpdateCallMembersResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateCallMembersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCallMembersResponse>(create);
  static UpdateCallMembersResponse? _defaultInstance;
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
    ..m<$core.String, MemberInput>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'members', entryClassName: 'CreateCallInput.MembersEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: MemberInput.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..hasRequiredFields = false
  ;

  CreateCallInput._() : super();
  factory CreateCallInput({
    CallInput? call,
    $core.Map<$core.String, MemberInput>? members,
  }) {
    final _result = create();
    if (call != null) {
      _result.call = call;
    }
    if (members != null) {
      _result.members.addAll(members);
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
  $core.Map<$core.String, MemberInput> get members => $_getMap(1);
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
    ..aOM<$0.CallOptions>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'options', subBuilder: $0.CallOptions.create)
    ..hasRequiredFields = false
  ;

  CallInput._() : super();
  factory CallInput({
    $core.List<$core.int>? customJson,
    $0.CallOptions? options,
  }) {
    final _result = create();
    if (customJson != null) {
      _result.customJson = customJson;
    }
    if (options != null) {
      _result.options = options;
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
  $0.CallOptions get options => $_getN(1);
  @$pb.TagNumber(2)
  set options($0.CallOptions v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasOptions() => $_has(1);
  @$pb.TagNumber(2)
  void clearOptions() => clearField(2);
  @$pb.TagNumber(2)
  $0.CallOptions ensureOptions() => $_ensure(1);
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

class SendCustomEventRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendCustomEventRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
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
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'statsJson', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ReportCallStatsRequest._() : super();
  factory ReportCallStatsRequest({
    $core.String? callType,
    $core.String? callId,
    $core.List<$core.int>? statsJson,
  }) {
    final _result = create();
    if (callType != null) {
      _result.callType = callType;
    }
    if (callId != null) {
      _result.callId = callId;
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
  $core.List<$core.int> get statsJson => $_getN(2);
  @$pb.TagNumber(3)
  set statsJson($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatsJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatsJson() => clearField(3);
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

class GetCallStatsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetCallStatsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..hasRequiredFields = false
  ;

  GetCallStatsRequest._() : super();
  factory GetCallStatsRequest({
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

class ReportIssueRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReportIssueRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'customJson', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ReportIssueRequest._() : super();
  factory ReportIssueRequest({
    $core.String? callType,
    $core.String? callId,
    $core.String? description,
    $core.List<$core.int>? customJson,
  }) {
    final _result = create();
    if (callType != null) {
      _result.callType = callType;
    }
    if (callId != null) {
      _result.callId = callId;
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
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stars', $pb.PbFieldType.OF)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'customJson', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ReviewCallRequest._() : super();
  factory ReviewCallRequest({
    $core.String? callType,
    $core.String? callId,
    $core.double? stars,
    $core.String? description,
    $core.List<$core.int>? customJson,
  }) {
    final _result = create();
    if (callType != null) {
      _result.callType = callType;
    }
    if (callId != null) {
      _result.callId = callId;
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
  $core.double get stars => $_getN(2);
  @$pb.TagNumber(3)
  set stars($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStars() => $_has(2);
  @$pb.TagNumber(3)
  void clearStars() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get customJson => $_getN(4);
  @$pb.TagNumber(5)
  set customJson($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCustomJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearCustomJson() => clearField(5);
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
  $async.Future<UpdateCallMembersResponse> updateCallMembers($pb.ClientContext? ctx, UpdateCallMembersRequest request) {
    var emptyResponse = UpdateCallMembersResponse();
    return _client.invoke<UpdateCallMembersResponse>(ctx, 'ClientRPC', 'UpdateCallMembers', request, emptyResponse);
  }
  $async.Future<DeleteCallMembersResponse> deleteCallMembers($pb.ClientContext? ctx, DeleteCallMembersRequest request) {
    var emptyResponse = DeleteCallMembersResponse();
    return _client.invoke<DeleteCallMembersResponse>(ctx, 'ClientRPC', 'DeleteCallMembers', request, emptyResponse);
  }
  $async.Future<SendCustomEventResponse> sendCustomEvent($pb.ClientContext? ctx, SendCustomEventRequest request) {
    var emptyResponse = SendCustomEventResponse();
    return _client.invoke<SendCustomEventResponse>(ctx, 'ClientRPC', 'SendCustomEvent', request, emptyResponse);
  }
  $async.Future<ReportCallStatsResponse> reportCallStats($pb.ClientContext? ctx, ReportCallStatsRequest request) {
    var emptyResponse = ReportCallStatsResponse();
    return _client.invoke<ReportCallStatsResponse>(ctx, 'ClientRPC', 'ReportCallStats', request, emptyResponse);
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

