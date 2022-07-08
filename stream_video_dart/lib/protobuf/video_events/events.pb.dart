///
//  Generated code. Do not modify.
//  source: video_events/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../video_models/models.pb.dart' as $2;

class CallRinging extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallRinging', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$2.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $2.Call.create)
    ..hasRequiredFields = false
  ;

  CallRinging._() : super();
  factory CallRinging({
    $2.Call? call,
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
  $2.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($2.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $2.Call ensureCall() => $_ensure(0);
}

class CallCreated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallCreated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$2.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $2.Call.create)
    ..hasRequiredFields = false
  ;

  CallCreated._() : super();
  factory CallCreated({
    $2.Call? call,
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
  $2.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($2.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $2.Call ensureCall() => $_ensure(0);
}

class CallUpdated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallUpdated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$2.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $2.Call.create)
    ..hasRequiredFields = false
  ;

  CallUpdated._() : super();
  factory CallUpdated({
    $2.Call? call,
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
  $2.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($2.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $2.Call ensureCall() => $_ensure(0);
}

class CallEnded extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallEnded', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$2.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $2.Call.create)
    ..hasRequiredFields = false
  ;

  CallEnded._() : super();
  factory CallEnded({
    $2.Call? call,
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
  $2.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($2.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $2.Call ensureCall() => $_ensure(0);
}

class CallDeleted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallDeleted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$2.Call>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'call', subBuilder: $2.Call.create)
    ..hasRequiredFields = false
  ;

  CallDeleted._() : super();
  factory CallDeleted({
    $2.Call? call,
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
  $2.Call get call => $_getN(0);
  @$pb.TagNumber(1)
  set call($2.Call v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCall() => $_has(0);
  @$pb.TagNumber(1)
  void clearCall() => clearField(1);
  @$pb.TagNumber(1)
  $2.Call ensureCall() => $_ensure(0);
}

class UserUpdated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UserUpdated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$2.User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', subBuilder: $2.User.create)
    ..hasRequiredFields = false
  ;

  UserUpdated._() : super();
  factory UserUpdated({
    $2.User? user,
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
  $2.User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user($2.User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  $2.User ensureUser() => $_ensure(0);
}

class ParticipantInvited extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantInvited', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$2.Participant>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $2.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantInvited._() : super();
  factory ParticipantInvited({
    $2.Participant? participant,
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
  $2.Participant get participant => $_getN(0);
  @$pb.TagNumber(1)
  set participant($2.Participant v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasParticipant() => $_has(0);
  @$pb.TagNumber(1)
  void clearParticipant() => clearField(1);
  @$pb.TagNumber(1)
  $2.Participant ensureParticipant() => $_ensure(0);
}

class ParticipantUpdated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantUpdated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$2.Participant>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $2.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantUpdated._() : super();
  factory ParticipantUpdated({
    $2.Participant? participant,
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
  $2.Participant get participant => $_getN(0);
  @$pb.TagNumber(1)
  set participant($2.Participant v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasParticipant() => $_has(0);
  @$pb.TagNumber(1)
  void clearParticipant() => clearField(1);
  @$pb.TagNumber(1)
  $2.Participant ensureParticipant() => $_ensure(0);
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
    ..aOM<$2.Participant>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $2.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantJoined._() : super();
  factory ParticipantJoined({
    $2.Participant? participant,
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
  $2.Participant get participant => $_getN(0);
  @$pb.TagNumber(1)
  set participant($2.Participant v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasParticipant() => $_has(0);
  @$pb.TagNumber(1)
  void clearParticipant() => clearField(1);
  @$pb.TagNumber(1)
  $2.Participant ensureParticipant() => $_ensure(0);
}

class ParticipantLeft extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantLeft', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$2.Participant>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participant', subBuilder: $2.Participant.create)
    ..hasRequiredFields = false
  ;

  ParticipantLeft._() : super();
  factory ParticipantLeft({
    $2.Participant? participant,
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
  $2.Participant get participant => $_getN(0);
  @$pb.TagNumber(1)
  set participant($2.Participant v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasParticipant() => $_has(0);
  @$pb.TagNumber(1)
  void clearParticipant() => clearField(1);
  @$pb.TagNumber(1)
  $2.Participant ensureParticipant() => $_ensure(0);
}

class BroadcastStarted extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastStarted', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$2.Broadcast>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcast', subBuilder: $2.Broadcast.create)
    ..hasRequiredFields = false
  ;

  BroadcastStarted._() : super();
  factory BroadcastStarted({
    $2.Broadcast? broadcast,
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
  $2.Broadcast get broadcast => $_getN(0);
  @$pb.TagNumber(1)
  set broadcast($2.Broadcast v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBroadcast() => $_has(0);
  @$pb.TagNumber(1)
  void clearBroadcast() => clearField(1);
  @$pb.TagNumber(1)
  $2.Broadcast ensureBroadcast() => $_ensure(0);
}

class BroadcastEnded extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastEnded', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOM<$2.Broadcast>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcast', subBuilder: $2.Broadcast.create)
    ..hasRequiredFields = false
  ;

  BroadcastEnded._() : super();
  factory BroadcastEnded({
    $2.Broadcast? broadcast,
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
  $2.Broadcast get broadcast => $_getN(0);
  @$pb.TagNumber(1)
  set broadcast($2.Broadcast v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBroadcast() => $_has(0);
  @$pb.TagNumber(1)
  void clearBroadcast() => clearField(1);
  @$pb.TagNumber(1)
  $2.Broadcast ensureBroadcast() => $_ensure(0);
}

