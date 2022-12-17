///
//  Generated code. Do not modify.
//  source: video/coordinator/push_v1/push.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../../google/protobuf/timestamp.pb.dart' as $0;

enum PushProvider_Credentials { apn, firebase, huawei, xiaomi, notSet }

class PushProvider extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, PushProvider_Credentials>
      _PushProvider_CredentialsByTag = {
    6: PushProvider_Credentials.apn,
    7: PushProvider_Credentials.firebase,
    8: PushProvider_Credentials.huawei,
    9: PushProvider_Credentials.xiaomi,
    0: PushProvider_Credentials.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PushProvider',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.push_v1'),
      createEmptyInstance: create)
    ..oo(0, [6, 7, 8, 9])
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'disabled')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'disabledReason')
    ..aOM<$0.Timestamp>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<ApnCredentials>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'apn',
        subBuilder: ApnCredentials.create)
    ..aOM<FirebaseCredentials>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'firebase',
        subBuilder: FirebaseCredentials.create)
    ..aOM<HuaweiCredentials>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'huawei',
        subBuilder: HuaweiCredentials.create)
    ..aOM<XiaomiCredentials>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'xiaomi',
        subBuilder: XiaomiCredentials.create)
    ..hasRequiredFields = false;

  PushProvider._() : super();
  factory PushProvider({
    $core.String? id,
    $core.bool? disabled,
    $core.String? disabledReason,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    ApnCredentials? apn,
    FirebaseCredentials? firebase,
    HuaweiCredentials? huawei,
    XiaomiCredentials? xiaomi,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (disabled != null) {
      _result.disabled = disabled;
    }
    if (disabledReason != null) {
      _result.disabledReason = disabledReason;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    if (apn != null) {
      _result.apn = apn;
    }
    if (firebase != null) {
      _result.firebase = firebase;
    }
    if (huawei != null) {
      _result.huawei = huawei;
    }
    if (xiaomi != null) {
      _result.xiaomi = xiaomi;
    }
    return _result;
  }
  factory PushProvider.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PushProvider.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PushProvider clone() => PushProvider()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PushProvider copyWith(void Function(PushProvider) updates) =>
      super.copyWith((message) => updates(message as PushProvider))
          as PushProvider; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PushProvider create() => PushProvider._();
  PushProvider createEmptyInstance() => create();
  static $pb.PbList<PushProvider> createRepeated() =>
      $pb.PbList<PushProvider>();
  @$core.pragma('dart2js:noInline')
  static PushProvider getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PushProvider>(create);
  static PushProvider? _defaultInstance;

  PushProvider_Credentials whichCredentials() =>
      _PushProvider_CredentialsByTag[$_whichOneof(0)]!;
  void clearCredentials() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get disabled => $_getBF(1);
  @$pb.TagNumber(2)
  set disabled($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDisabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisabled() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get disabledReason => $_getSZ(2);
  @$pb.TagNumber(3)
  set disabledReason($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDisabledReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisabledReason() => clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get createdAt => $_getN(3);
  @$pb.TagNumber(4)
  set createdAt($0.Timestamp v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCreatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedAt() => clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureCreatedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get updatedAt => $_getN(4);
  @$pb.TagNumber(5)
  set updatedAt($0.Timestamp v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasUpdatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdatedAt() => clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureUpdatedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  ApnCredentials get apn => $_getN(5);
  @$pb.TagNumber(6)
  set apn(ApnCredentials v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasApn() => $_has(5);
  @$pb.TagNumber(6)
  void clearApn() => clearField(6);
  @$pb.TagNumber(6)
  ApnCredentials ensureApn() => $_ensure(5);

  @$pb.TagNumber(7)
  FirebaseCredentials get firebase => $_getN(6);
  @$pb.TagNumber(7)
  set firebase(FirebaseCredentials v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasFirebase() => $_has(6);
  @$pb.TagNumber(7)
  void clearFirebase() => clearField(7);
  @$pb.TagNumber(7)
  FirebaseCredentials ensureFirebase() => $_ensure(6);

  @$pb.TagNumber(8)
  HuaweiCredentials get huawei => $_getN(7);
  @$pb.TagNumber(8)
  set huawei(HuaweiCredentials v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasHuawei() => $_has(7);
  @$pb.TagNumber(8)
  void clearHuawei() => clearField(8);
  @$pb.TagNumber(8)
  HuaweiCredentials ensureHuawei() => $_ensure(7);

  @$pb.TagNumber(9)
  XiaomiCredentials get xiaomi => $_getN(8);
  @$pb.TagNumber(9)
  set xiaomi(XiaomiCredentials v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasXiaomi() => $_has(8);
  @$pb.TagNumber(9)
  void clearXiaomi() => clearField(9);
  @$pb.TagNumber(9)
  XiaomiCredentials ensureXiaomi() => $_ensure(8);
}

class ApnCredentials extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ApnCredentials',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.push_v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'certificateP12',
        $pb.PbFieldType.OY)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'topic')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'teamId')
    ..hasRequiredFields = false;

  ApnCredentials._() : super();
  factory ApnCredentials({
    $core.List<$core.int>? certificateP12,
    $core.String? topic,
    $core.String? teamId,
  }) {
    final _result = create();
    if (certificateP12 != null) {
      _result.certificateP12 = certificateP12;
    }
    if (topic != null) {
      _result.topic = topic;
    }
    if (teamId != null) {
      _result.teamId = teamId;
    }
    return _result;
  }
  factory ApnCredentials.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ApnCredentials.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ApnCredentials clone() => ApnCredentials()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ApnCredentials copyWith(void Function(ApnCredentials) updates) =>
      super.copyWith((message) => updates(message as ApnCredentials))
          as ApnCredentials; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ApnCredentials create() => ApnCredentials._();
  ApnCredentials createEmptyInstance() => create();
  static $pb.PbList<ApnCredentials> createRepeated() =>
      $pb.PbList<ApnCredentials>();
  @$core.pragma('dart2js:noInline')
  static ApnCredentials getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApnCredentials>(create);
  static ApnCredentials? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get certificateP12 => $_getN(0);
  @$pb.TagNumber(1)
  set certificateP12($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCertificateP12() => $_has(0);
  @$pb.TagNumber(1)
  void clearCertificateP12() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get topic => $_getSZ(1);
  @$pb.TagNumber(2)
  set topic($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTopic() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopic() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get teamId => $_getSZ(2);
  @$pb.TagNumber(3)
  set teamId($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTeamId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTeamId() => clearField(3);
}

class FirebaseCredentials extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'FirebaseCredentials',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.push_v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'credentials')
    ..hasRequiredFields = false;

  FirebaseCredentials._() : super();
  factory FirebaseCredentials({
    $core.String? credentials,
  }) {
    final _result = create();
    if (credentials != null) {
      _result.credentials = credentials;
    }
    return _result;
  }
  factory FirebaseCredentials.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory FirebaseCredentials.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  FirebaseCredentials clone() => FirebaseCredentials()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  FirebaseCredentials copyWith(void Function(FirebaseCredentials) updates) =>
      super.copyWith((message) => updates(message as FirebaseCredentials))
          as FirebaseCredentials; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FirebaseCredentials create() => FirebaseCredentials._();
  FirebaseCredentials createEmptyInstance() => create();
  static $pb.PbList<FirebaseCredentials> createRepeated() =>
      $pb.PbList<FirebaseCredentials>();
  @$core.pragma('dart2js:noInline')
  static FirebaseCredentials getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FirebaseCredentials>(create);
  static FirebaseCredentials? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get credentials => $_getSZ(0);
  @$pb.TagNumber(1)
  set credentials($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCredentials() => $_has(0);
  @$pb.TagNumber(1)
  void clearCredentials() => clearField(1);
}

class HuaweiCredentials extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HuaweiCredentials',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.push_v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'secret')
    ..hasRequiredFields = false;

  HuaweiCredentials._() : super();
  factory HuaweiCredentials({
    $core.String? id,
    $core.String? secret,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (secret != null) {
      _result.secret = secret;
    }
    return _result;
  }
  factory HuaweiCredentials.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HuaweiCredentials.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HuaweiCredentials clone() => HuaweiCredentials()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HuaweiCredentials copyWith(void Function(HuaweiCredentials) updates) =>
      super.copyWith((message) => updates(message as HuaweiCredentials))
          as HuaweiCredentials; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HuaweiCredentials create() => HuaweiCredentials._();
  HuaweiCredentials createEmptyInstance() => create();
  static $pb.PbList<HuaweiCredentials> createRepeated() =>
      $pb.PbList<HuaweiCredentials>();
  @$core.pragma('dart2js:noInline')
  static HuaweiCredentials getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HuaweiCredentials>(create);
  static HuaweiCredentials? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get secret => $_getSZ(1);
  @$pb.TagNumber(2)
  set secret($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearSecret() => clearField(2);
}

class XiaomiCredentials extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'XiaomiCredentials',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.push_v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'packageName')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'secret')
    ..hasRequiredFields = false;

  XiaomiCredentials._() : super();
  factory XiaomiCredentials({
    $core.String? packageName,
    $core.String? secret,
  }) {
    final _result = create();
    if (packageName != null) {
      _result.packageName = packageName;
    }
    if (secret != null) {
      _result.secret = secret;
    }
    return _result;
  }
  factory XiaomiCredentials.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory XiaomiCredentials.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  XiaomiCredentials clone() => XiaomiCredentials()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  XiaomiCredentials copyWith(void Function(XiaomiCredentials) updates) =>
      super.copyWith((message) => updates(message as XiaomiCredentials))
          as XiaomiCredentials; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static XiaomiCredentials create() => XiaomiCredentials._();
  XiaomiCredentials createEmptyInstance() => create();
  static $pb.PbList<XiaomiCredentials> createRepeated() =>
      $pb.PbList<XiaomiCredentials>();
  @$core.pragma('dart2js:noInline')
  static XiaomiCredentials getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<XiaomiCredentials>(create);
  static XiaomiCredentials? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get packageName => $_getSZ(0);
  @$pb.TagNumber(1)
  set packageName($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPackageName() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackageName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get secret => $_getSZ(1);
  @$pb.TagNumber(2)
  set secret($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearSecret() => clearField(2);
}

class Device extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Device',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.push_v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'userId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'disabled')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'disabledReason')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pushProviderName')
    ..aOM<$0.Timestamp>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  Device._() : super();
  factory Device({
    $core.String? userId,
    $core.String? id,
    $core.bool? disabled,
    $core.String? disabledReason,
    $core.String? pushProviderName,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (id != null) {
      _result.id = id;
    }
    if (disabled != null) {
      _result.disabled = disabled;
    }
    if (disabledReason != null) {
      _result.disabledReason = disabledReason;
    }
    if (pushProviderName != null) {
      _result.pushProviderName = pushProviderName;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    return _result;
  }
  factory Device.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Device.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Device clone() => Device()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Device copyWith(void Function(Device) updates) =>
      super.copyWith((message) => updates(message as Device))
          as Device; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Device create() => Device._();
  Device createEmptyInstance() => create();
  static $pb.PbList<Device> createRepeated() => $pb.PbList<Device>();
  @$core.pragma('dart2js:noInline')
  static Device getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Device>(create);
  static Device? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get disabled => $_getBF(2);
  @$pb.TagNumber(3)
  set disabled($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDisabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisabled() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get disabledReason => $_getSZ(3);
  @$pb.TagNumber(4)
  set disabledReason($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasDisabledReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisabledReason() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get pushProviderName => $_getSZ(4);
  @$pb.TagNumber(5)
  set pushProviderName($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPushProviderName() => $_has(4);
  @$pb.TagNumber(5)
  void clearPushProviderName() => clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($0.Timestamp v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get updatedAt => $_getN(6);
  @$pb.TagNumber(7)
  set updatedAt($0.Timestamp v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureUpdatedAt() => $_ensure(6);
}

class DeviceInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DeviceInput',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.push_v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pushProviderId')
    ..hasRequiredFields = false;

  DeviceInput._() : super();
  factory DeviceInput({
    $core.String? id,
    $core.String? pushProviderId,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (pushProviderId != null) {
      _result.pushProviderId = pushProviderId;
    }
    return _result;
  }
  factory DeviceInput.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeviceInput.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DeviceInput clone() => DeviceInput()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DeviceInput copyWith(void Function(DeviceInput) updates) =>
      super.copyWith((message) => updates(message as DeviceInput))
          as DeviceInput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceInput create() => DeviceInput._();
  DeviceInput createEmptyInstance() => create();
  static $pb.PbList<DeviceInput> createRepeated() => $pb.PbList<DeviceInput>();
  @$core.pragma('dart2js:noInline')
  static DeviceInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceInput>(create);
  static DeviceInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get pushProviderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set pushProviderId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPushProviderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPushProviderId() => clearField(2);
}
