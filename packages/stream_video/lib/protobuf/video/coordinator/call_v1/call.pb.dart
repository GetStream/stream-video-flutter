///
//  Generated code. Do not modify.
//  source: video/coordinator/call_v1/call.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../../google/protobuf/timestamp.pb.dart' as $0;
import '../member_v1/member.pb.dart' as $1;

class CallType extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallType', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.call_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOM<CallSettings>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'settings', subBuilder: CallSettings.create)
    ..aOM<$0.Timestamp>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  CallType._() : super();
  factory CallType({
    $core.String? name,
    CallSettings? settings,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (settings != null) {
      _result.settings = settings;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    return _result;
  }
  factory CallType.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallType.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallType clone() => CallType()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallType copyWith(void Function(CallType) updates) => super.copyWith((message) => updates(message as CallType)) as CallType; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallType create() => CallType._();
  CallType createEmptyInstance() => create();
  static $pb.PbList<CallType> createRepeated() => $pb.PbList<CallType>();
  @$core.pragma('dart2js:noInline')
  static CallType getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallType>(create);
  static CallType? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  CallSettings get settings => $_getN(1);
  @$pb.TagNumber(2)
  set settings(CallSettings v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSettings() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettings() => clearField(2);
  @$pb.TagNumber(2)
  CallSettings ensureSettings() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get createdAt => $_getN(2);
  @$pb.TagNumber(3)
  set createdAt($0.Timestamp v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureCreatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get updatedAt => $_getN(3);
  @$pb.TagNumber(4)
  set updatedAt($0.Timestamp v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasUpdatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdatedAt() => clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureUpdatedAt() => $_ensure(3);
}

class Call extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Call', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.call_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdByUserId')
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'customJson', $pb.PbFieldType.OY)
    ..aOM<CallSettings>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'settingsOverrides', subBuilder: CallSettings.create)
    ..aOM<$0.Timestamp>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recordingActive')
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcastingActive')
    ..hasRequiredFields = false
  ;

  Call._() : super();
  factory Call({
    $core.String? type,
    $core.String? id,
    $core.String? callCid,
    $core.String? createdByUserId,
    $core.List<$core.int>? customJson,
    CallSettings? settingsOverrides,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $core.bool? recordingActive,
    $core.bool? broadcastingActive,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (id != null) {
      _result.id = id;
    }
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (createdByUserId != null) {
      _result.createdByUserId = createdByUserId;
    }
    if (customJson != null) {
      _result.customJson = customJson;
    }
    if (settingsOverrides != null) {
      _result.settingsOverrides = settingsOverrides;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    if (recordingActive != null) {
      _result.recordingActive = recordingActive;
    }
    if (broadcastingActive != null) {
      _result.broadcastingActive = broadcastingActive;
    }
    return _result;
  }
  factory Call.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Call.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Call clone() => Call()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Call copyWith(void Function(Call) updates) => super.copyWith((message) => updates(message as Call)) as Call; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Call create() => Call._();
  Call createEmptyInstance() => create();
  static $pb.PbList<Call> createRepeated() => $pb.PbList<Call>();
  @$core.pragma('dart2js:noInline')
  static Call getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Call>(create);
  static Call? _defaultInstance;

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
  $core.String get callCid => $_getSZ(2);
  @$pb.TagNumber(3)
  set callCid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCallCid() => $_has(2);
  @$pb.TagNumber(3)
  void clearCallCid() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get createdByUserId => $_getSZ(3);
  @$pb.TagNumber(4)
  set createdByUserId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCreatedByUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedByUserId() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get customJson => $_getN(4);
  @$pb.TagNumber(5)
  set customJson($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCustomJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearCustomJson() => clearField(5);

  @$pb.TagNumber(6)
  CallSettings get settingsOverrides => $_getN(5);
  @$pb.TagNumber(6)
  set settingsOverrides(CallSettings v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSettingsOverrides() => $_has(5);
  @$pb.TagNumber(6)
  void clearSettingsOverrides() => clearField(6);
  @$pb.TagNumber(6)
  CallSettings ensureSettingsOverrides() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get createdAt => $_getN(6);
  @$pb.TagNumber(7)
  set createdAt($0.Timestamp v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCreatedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get updatedAt => $_getN(7);
  @$pb.TagNumber(8)
  set updatedAt($0.Timestamp v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureUpdatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.bool get recordingActive => $_getBF(8);
  @$pb.TagNumber(9)
  set recordingActive($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasRecordingActive() => $_has(8);
  @$pb.TagNumber(9)
  void clearRecordingActive() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get broadcastingActive => $_getBF(9);
  @$pb.TagNumber(10)
  set broadcastingActive($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasBroadcastingActive() => $_has(9);
  @$pb.TagNumber(10)
  void clearBroadcastingActive() => clearField(10);
}

class CallDetails extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallDetails', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.call_v1'), createEmptyInstance: create)
    ..aOM<CallSettings>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'settings', subBuilder: CallSettings.create)
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'memberUserIds')
    ..m<$core.String, $1.Member>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'members', entryClassName: 'CallDetails.MembersEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $1.Member.create, packageName: const $pb.PackageName('stream.video.coordinator.call_v1'))
    ..hasRequiredFields = false
  ;

  CallDetails._() : super();
  factory CallDetails({
    CallSettings? settings,
    $core.Iterable<$core.String>? memberUserIds,
    $core.Map<$core.String, $1.Member>? members,
  }) {
    final _result = create();
    if (settings != null) {
      _result.settings = settings;
    }
    if (memberUserIds != null) {
      _result.memberUserIds.addAll(memberUserIds);
    }
    if (members != null) {
      _result.members.addAll(members);
    }
    return _result;
  }
  factory CallDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallDetails clone() => CallDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallDetails copyWith(void Function(CallDetails) updates) => super.copyWith((message) => updates(message as CallDetails)) as CallDetails; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallDetails create() => CallDetails._();
  CallDetails createEmptyInstance() => create();
  static $pb.PbList<CallDetails> createRepeated() => $pb.PbList<CallDetails>();
  @$core.pragma('dart2js:noInline')
  static CallDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallDetails>(create);
  static CallDetails? _defaultInstance;

  @$pb.TagNumber(1)
  CallSettings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(CallSettings v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => clearField(1);
  @$pb.TagNumber(1)
  CallSettings ensureSettings() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get memberUserIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.Map<$core.String, $1.Member> get members => $_getMap(2);
}

class CallSettings extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallSettings', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.call_v1'), createEmptyInstance: create)
    ..aOM<RecordingOptions>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recording', subBuilder: RecordingOptions.create)
    ..aOM<BroadcastingOptions>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcasting', subBuilder: BroadcastingOptions.create)
    ..hasRequiredFields = false
  ;

  CallSettings._() : super();
  factory CallSettings({
    RecordingOptions? recording,
    BroadcastingOptions? broadcasting,
  }) {
    final _result = create();
    if (recording != null) {
      _result.recording = recording;
    }
    if (broadcasting != null) {
      _result.broadcasting = broadcasting;
    }
    return _result;
  }
  factory CallSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallSettings clone() => CallSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallSettings copyWith(void Function(CallSettings) updates) => super.copyWith((message) => updates(message as CallSettings)) as CallSettings; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallSettings create() => CallSettings._();
  CallSettings createEmptyInstance() => create();
  static $pb.PbList<CallSettings> createRepeated() => $pb.PbList<CallSettings>();
  @$core.pragma('dart2js:noInline')
  static CallSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallSettings>(create);
  static CallSettings? _defaultInstance;

  @$pb.TagNumber(1)
  RecordingOptions get recording => $_getN(0);
  @$pb.TagNumber(1)
  set recording(RecordingOptions v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecording() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecording() => clearField(1);
  @$pb.TagNumber(1)
  RecordingOptions ensureRecording() => $_ensure(0);

  @$pb.TagNumber(2)
  BroadcastingOptions get broadcasting => $_getN(1);
  @$pb.TagNumber(2)
  set broadcasting(BroadcastingOptions v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasBroadcasting() => $_has(1);
  @$pb.TagNumber(2)
  void clearBroadcasting() => clearField(2);
  @$pb.TagNumber(2)
  BroadcastingOptions ensureBroadcasting() => $_ensure(1);
}

class RecordingOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecordingOptions', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.call_v1'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..hasRequiredFields = false
  ;

  RecordingOptions._() : super();
  factory RecordingOptions({
    $core.bool? enabled,
  }) {
    final _result = create();
    if (enabled != null) {
      _result.enabled = enabled;
    }
    return _result;
  }
  factory RecordingOptions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecordingOptions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecordingOptions clone() => RecordingOptions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecordingOptions copyWith(void Function(RecordingOptions) updates) => super.copyWith((message) => updates(message as RecordingOptions)) as RecordingOptions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RecordingOptions create() => RecordingOptions._();
  RecordingOptions createEmptyInstance() => create();
  static $pb.PbList<RecordingOptions> createRepeated() => $pb.PbList<RecordingOptions>();
  @$core.pragma('dart2js:noInline')
  static RecordingOptions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecordingOptions>(create);
  static RecordingOptions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => clearField(1);
}

class BroadcastingOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastingOptions', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.call_v1'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..hasRequiredFields = false
  ;

  BroadcastingOptions._() : super();
  factory BroadcastingOptions({
    $core.bool? enabled,
  }) {
    final _result = create();
    if (enabled != null) {
      _result.enabled = enabled;
    }
    return _result;
  }
  factory BroadcastingOptions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BroadcastingOptions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BroadcastingOptions clone() => BroadcastingOptions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BroadcastingOptions copyWith(void Function(BroadcastingOptions) updates) => super.copyWith((message) => updates(message as BroadcastingOptions)) as BroadcastingOptions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BroadcastingOptions create() => BroadcastingOptions._();
  BroadcastingOptions createEmptyInstance() => create();
  static $pb.PbList<BroadcastingOptions> createRepeated() => $pb.PbList<BroadcastingOptions>();
  @$core.pragma('dart2js:noInline')
  static BroadcastingOptions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BroadcastingOptions>(create);
  static BroadcastingOptions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => clearField(1);
}

