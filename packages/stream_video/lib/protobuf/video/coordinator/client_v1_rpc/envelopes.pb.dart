///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/envelopes.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../call_v1/call.pb.dart' as $0;
import '../user_v1/user.pb.dart' as $1;
import '../member_v1/member.pb.dart' as $2;

class CallEnvelope extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallEnvelope', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..m<$core.String, $1.User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'users', entryClassName: 'CallEnvelope.UsersEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $1.User.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..aOM<$0.Call>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $0.Call.create)
    ..aOM<$0.CallDetails>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'details', subBuilder: $0.CallDetails.create)
    ..hasRequiredFields = false
  ;

  CallEnvelope._() : super();
  factory CallEnvelope({
    $core.Map<$core.String, $1.User>? users,
    $0.Call? call,
    $0.CallDetails? details,
  }) {
    final _result = create();
    if (users != null) {
      _result.users.addAll(users);
    }
    if (call != null) {
      _result.call = call;
    }
    if (details != null) {
      _result.details = details;
    }
    return _result;
  }
  factory CallEnvelope.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallEnvelope.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallEnvelope clone() => CallEnvelope()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallEnvelope copyWith(void Function(CallEnvelope) updates) => super.copyWith((message) => updates(message as CallEnvelope)) as CallEnvelope; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallEnvelope create() => CallEnvelope._();
  CallEnvelope createEmptyInstance() => create();
  static $pb.PbList<CallEnvelope> createRepeated() => $pb.PbList<CallEnvelope>();
  @$core.pragma('dart2js:noInline')
  static CallEnvelope getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallEnvelope>(create);
  static CallEnvelope? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, $1.User> get users => $_getMap(0);

  @$pb.TagNumber(2)
  $0.Call get call => $_getN(1);
  @$pb.TagNumber(2)
  set call($0.Call v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCall() => $_has(1);
  @$pb.TagNumber(2)
  void clearCall() => clearField(2);
  @$pb.TagNumber(2)
  $0.Call ensureCall() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.CallDetails get details => $_getN(2);
  @$pb.TagNumber(3)
  set details($0.CallDetails v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDetails() => $_has(2);
  @$pb.TagNumber(3)
  void clearDetails() => clearField(3);
  @$pb.TagNumber(3)
  $0.CallDetails ensureDetails() => $_ensure(2);
}

class CallsEnvelope extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallsEnvelope', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..m<$core.String, $1.User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'users', entryClassName: 'CallsEnvelope.UsersEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $1.User.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCids')
    ..m<$core.String, $0.Call>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calls', entryClassName: 'CallsEnvelope.CallsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $0.Call.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..m<$core.String, $0.CallDetails>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'details', entryClassName: 'CallsEnvelope.DetailsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $0.CallDetails.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..hasRequiredFields = false
  ;

  CallsEnvelope._() : super();
  factory CallsEnvelope({
    $core.Map<$core.String, $1.User>? users,
    $core.Iterable<$core.String>? callCids,
    $core.Map<$core.String, $0.Call>? calls,
    $core.Map<$core.String, $0.CallDetails>? details,
  }) {
    final _result = create();
    if (users != null) {
      _result.users.addAll(users);
    }
    if (callCids != null) {
      _result.callCids.addAll(callCids);
    }
    if (calls != null) {
      _result.calls.addAll(calls);
    }
    if (details != null) {
      _result.details.addAll(details);
    }
    return _result;
  }
  factory CallsEnvelope.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallsEnvelope.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallsEnvelope clone() => CallsEnvelope()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallsEnvelope copyWith(void Function(CallsEnvelope) updates) => super.copyWith((message) => updates(message as CallsEnvelope)) as CallsEnvelope; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallsEnvelope create() => CallsEnvelope._();
  CallsEnvelope createEmptyInstance() => create();
  static $pb.PbList<CallsEnvelope> createRepeated() => $pb.PbList<CallsEnvelope>();
  @$core.pragma('dart2js:noInline')
  static CallsEnvelope getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallsEnvelope>(create);
  static CallsEnvelope? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, $1.User> get users => $_getMap(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get callCids => $_getList(1);

  @$pb.TagNumber(3)
  $core.Map<$core.String, $0.Call> get calls => $_getMap(2);

  @$pb.TagNumber(4)
  $core.Map<$core.String, $0.CallDetails> get details => $_getMap(3);
}

class MembersEnvelope extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MembersEnvelope', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.client_v1_rpc'), createEmptyInstance: create)
    ..m<$core.String, $1.User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'users', entryClassName: 'MembersEnvelope.UsersEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $1.User.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'memberUserIds')
    ..m<$core.String, $2.Member>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'members', entryClassName: 'MembersEnvelope.MembersEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $2.Member.create, packageName: const $pb.PackageName('stream.video.coordinator.client_v1_rpc'))
    ..hasRequiredFields = false
  ;

  MembersEnvelope._() : super();
  factory MembersEnvelope({
    $core.Map<$core.String, $1.User>? users,
    $core.Iterable<$core.String>? memberUserIds,
    $core.Map<$core.String, $2.Member>? members,
  }) {
    final _result = create();
    if (users != null) {
      _result.users.addAll(users);
    }
    if (memberUserIds != null) {
      _result.memberUserIds.addAll(memberUserIds);
    }
    if (members != null) {
      _result.members.addAll(members);
    }
    return _result;
  }
  factory MembersEnvelope.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MembersEnvelope.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MembersEnvelope clone() => MembersEnvelope()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MembersEnvelope copyWith(void Function(MembersEnvelope) updates) => super.copyWith((message) => updates(message as MembersEnvelope)) as MembersEnvelope; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MembersEnvelope create() => MembersEnvelope._();
  MembersEnvelope createEmptyInstance() => create();
  static $pb.PbList<MembersEnvelope> createRepeated() => $pb.PbList<MembersEnvelope>();
  @$core.pragma('dart2js:noInline')
  static MembersEnvelope getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MembersEnvelope>(create);
  static MembersEnvelope? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, $1.User> get users => $_getMap(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get memberUserIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.Map<$core.String, $2.Member> get members => $_getMap(2);
}

