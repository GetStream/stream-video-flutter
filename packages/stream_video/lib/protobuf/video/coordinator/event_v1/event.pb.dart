///
//  Generated code. Do not modify.
//  source: video/coordinator/event_v1/event.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RecordingStarted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecordingStarted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..hasRequiredFields = false
  ;

  RecordingStarted._() : super();
  factory RecordingStarted({
    $core.String? callCid,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
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
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);
}

class RecordingStopped extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecordingStopped', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..hasRequiredFields = false
  ;

  RecordingStopped._() : super();
  factory RecordingStopped({
    $core.String? callCid,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
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
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);
}

class UserUpdated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UserUpdated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  UserUpdated._() : super();
  factory UserUpdated({
    $core.String? userId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
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
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);
}

class BroadcastStarted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastStarted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..hasRequiredFields = false
  ;

  BroadcastStarted._() : super();
  factory BroadcastStarted({
    $core.String? callCid,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
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
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);
}

class BroadcastEnded extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastEnded', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..hasRequiredFields = false
  ;

  BroadcastEnded._() : super();
  factory BroadcastEnded({
    $core.String? callCid,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
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
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);
}

class CallMembersUpdated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallMembersUpdated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..hasRequiredFields = false
  ;

  CallMembersUpdated._() : super();
  factory CallMembersUpdated({
    $core.String? callCid,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    return _result;
  }
  factory CallMembersUpdated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallMembersUpdated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallMembersUpdated clone() => CallMembersUpdated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallMembersUpdated copyWith(void Function(CallMembersUpdated) updates) => super.copyWith((message) => updates(message as CallMembersUpdated)) as CallMembersUpdated; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallMembersUpdated create() => CallMembersUpdated._();
  CallMembersUpdated createEmptyInstance() => create();
  static $pb.PbList<CallMembersUpdated> createRepeated() => $pb.PbList<CallMembersUpdated>();
  @$core.pragma('dart2js:noInline')
  static CallMembersUpdated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallMembersUpdated>(create);
  static CallMembersUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);
}

class CallMembersDeleted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallMembersDeleted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..hasRequiredFields = false
  ;

  CallMembersDeleted._() : super();
  factory CallMembersDeleted({
    $core.String? callCid,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    return _result;
  }
  factory CallMembersDeleted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallMembersDeleted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallMembersDeleted clone() => CallMembersDeleted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallMembersDeleted copyWith(void Function(CallMembersDeleted) updates) => super.copyWith((message) => updates(message as CallMembersDeleted)) as CallMembersDeleted; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallMembersDeleted create() => CallMembersDeleted._();
  CallMembersDeleted createEmptyInstance() => create();
  static $pb.PbList<CallMembersDeleted> createRepeated() => $pb.PbList<CallMembersDeleted>();
  @$core.pragma('dart2js:noInline')
  static CallMembersDeleted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallMembersDeleted>(create);
  static CallMembersDeleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);
}

class CallCreated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallCreated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ringing')
    ..hasRequiredFields = false
  ;

  CallCreated._() : super();
  factory CallCreated({
    $core.String? callCid,
    $core.bool? ringing,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
    }
    if (ringing != null) {
      _result.ringing = ringing;
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
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get ringing => $_getBF(1);
  @$pb.TagNumber(2)
  set ringing($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRinging() => $_has(1);
  @$pb.TagNumber(2)
  void clearRinging() => clearField(2);
}

class CallUpdated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallUpdated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..hasRequiredFields = false
  ;

  CallUpdated._() : super();
  factory CallUpdated({
    $core.String? callCid,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
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
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);
}

class CallEnded extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallEnded', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..hasRequiredFields = false
  ;

  CallEnded._() : super();
  factory CallEnded({
    $core.String? callCid,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
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
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);
}

class CallDeleted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallDeleted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callCid')
    ..hasRequiredFields = false
  ;

  CallDeleted._() : super();
  factory CallDeleted({
    $core.String? callCid,
  }) {
    final _result = create();
    if (callCid != null) {
      _result.callCid = callCid;
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
  $core.String get callCid => $_getSZ(0);
  @$pb.TagNumber(1)
  set callCid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallCid() => clearField(1);
}

class CallAccepted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallAccepted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  CallAccepted._() : super();
  factory CallAccepted() => create();
  factory CallAccepted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallAccepted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallAccepted clone() => CallAccepted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallAccepted copyWith(void Function(CallAccepted) updates) => super.copyWith((message) => updates(message as CallAccepted)) as CallAccepted; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallAccepted create() => CallAccepted._();
  CallAccepted createEmptyInstance() => create();
  static $pb.PbList<CallAccepted> createRepeated() => $pb.PbList<CallAccepted>();
  @$core.pragma('dart2js:noInline')
  static CallAccepted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallAccepted>(create);
  static CallAccepted? _defaultInstance;
}

class CallRejected extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallRejected', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  CallRejected._() : super();
  factory CallRejected() => create();
  factory CallRejected.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallRejected.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallRejected clone() => CallRejected()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallRejected copyWith(void Function(CallRejected) updates) => super.copyWith((message) => updates(message as CallRejected)) as CallRejected; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallRejected create() => CallRejected._();
  CallRejected createEmptyInstance() => create();
  static $pb.PbList<CallRejected> createRepeated() => $pb.PbList<CallRejected>();
  @$core.pragma('dart2js:noInline')
  static CallRejected getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallRejected>(create);
  static CallRejected? _defaultInstance;
}

class CallCancelled extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallCancelled', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.event_v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  CallCancelled._() : super();
  factory CallCancelled() => create();
  factory CallCancelled.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallCancelled.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallCancelled clone() => CallCancelled()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallCancelled copyWith(void Function(CallCancelled) updates) => super.copyWith((message) => updates(message as CallCancelled)) as CallCancelled; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallCancelled create() => CallCancelled._();
  CallCancelled createEmptyInstance() => create();
  static $pb.PbList<CallCancelled> createRepeated() => $pb.PbList<CallCancelled>();
  @$core.pragma('dart2js:noInline')
  static CallCancelled getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallCancelled>(create);
  static CallCancelled? _defaultInstance;
}

