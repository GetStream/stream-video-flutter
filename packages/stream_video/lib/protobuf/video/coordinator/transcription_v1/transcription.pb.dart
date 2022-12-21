///
//  Generated code. Do not modify.
//  source: video/coordinator/transcription_v1/transcription.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'transcription.pbenum.dart';

export 'transcription.pbenum.dart';

class Transcription extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Transcription', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.transcription_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callType')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 's3FileUrl')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startTime')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stopTime')
    ..hasRequiredFields = false
  ;

  Transcription._() : super();
  factory Transcription({
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
  factory Transcription.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Transcription.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Transcription clone() => Transcription()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Transcription copyWith(void Function(Transcription) updates) => super.copyWith((message) => updates(message as Transcription)) as Transcription; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Transcription create() => Transcription._();
  Transcription createEmptyInstance() => create();
  static $pb.PbList<Transcription> createRepeated() => $pb.PbList<Transcription>();
  @$core.pragma('dart2js:noInline')
  static Transcription getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Transcription>(create);
  static Transcription? _defaultInstance;

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

class TranscriptionStorageOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TranscriptionStorageOptions', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.transcription_v1'), createEmptyInstance: create)
    ..e<TranscriptionStorage>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'storage', $pb.PbFieldType.OE, defaultOrMaker: TranscriptionStorage.TRANSCRIPTION_STORAGE_S3_UNSPECIFIED, valueOf: TranscriptionStorage.valueOf, enumValues: TranscriptionStorage.values)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accessKey')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'secretKey')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bucketName')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'region')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path')
    ..hasRequiredFields = false
  ;

  TranscriptionStorageOptions._() : super();
  factory TranscriptionStorageOptions({
    TranscriptionStorage? storage,
    $core.String? accessKey,
    $core.String? secretKey,
    $core.String? bucketName,
    $core.String? region,
    $core.String? path,
  }) {
    final _result = create();
    if (storage != null) {
      _result.storage = storage;
    }
    if (accessKey != null) {
      _result.accessKey = accessKey;
    }
    if (secretKey != null) {
      _result.secretKey = secretKey;
    }
    if (bucketName != null) {
      _result.bucketName = bucketName;
    }
    if (region != null) {
      _result.region = region;
    }
    if (path != null) {
      _result.path = path;
    }
    return _result;
  }
  factory TranscriptionStorageOptions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TranscriptionStorageOptions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TranscriptionStorageOptions clone() => TranscriptionStorageOptions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TranscriptionStorageOptions copyWith(void Function(TranscriptionStorageOptions) updates) => super.copyWith((message) => updates(message as TranscriptionStorageOptions)) as TranscriptionStorageOptions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TranscriptionStorageOptions create() => TranscriptionStorageOptions._();
  TranscriptionStorageOptions createEmptyInstance() => create();
  static $pb.PbList<TranscriptionStorageOptions> createRepeated() => $pb.PbList<TranscriptionStorageOptions>();
  @$core.pragma('dart2js:noInline')
  static TranscriptionStorageOptions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TranscriptionStorageOptions>(create);
  static TranscriptionStorageOptions? _defaultInstance;

  @$pb.TagNumber(1)
  TranscriptionStorage get storage => $_getN(0);
  @$pb.TagNumber(1)
  set storage(TranscriptionStorage v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStorage() => $_has(0);
  @$pb.TagNumber(1)
  void clearStorage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get accessKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set accessKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAccessKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccessKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get secretKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set secretKey($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSecretKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearSecretKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get bucketName => $_getSZ(3);
  @$pb.TagNumber(4)
  set bucketName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBucketName() => $_has(3);
  @$pb.TagNumber(4)
  void clearBucketName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get region => $_getSZ(4);
  @$pb.TagNumber(5)
  set region($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRegion() => $_has(4);
  @$pb.TagNumber(5)
  void clearRegion() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get path => $_getSZ(5);
  @$pb.TagNumber(6)
  set path($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPath() => $_has(5);
  @$pb.TagNumber(6)
  void clearPath() => clearField(6);
}

class TranscriptionSettings extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TranscriptionSettings', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.transcription_v1'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..aOM<TranscriptionStorageOptions>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'storage', subBuilder: TranscriptionStorageOptions.create)
    ..aOM<AvailableLanguages>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'availableLanguages', subBuilder: AvailableLanguages.create)
    ..aOM<Language>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'preferred', subBuilder: Language.create)
    ..hasRequiredFields = false
  ;

  TranscriptionSettings._() : super();
  factory TranscriptionSettings({
    $core.bool? enabled,
    TranscriptionStorageOptions? storage,
    AvailableLanguages? availableLanguages,
    Language? preferred,
  }) {
    final _result = create();
    if (enabled != null) {
      _result.enabled = enabled;
    }
    if (storage != null) {
      _result.storage = storage;
    }
    if (availableLanguages != null) {
      _result.availableLanguages = availableLanguages;
    }
    if (preferred != null) {
      _result.preferred = preferred;
    }
    return _result;
  }
  factory TranscriptionSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TranscriptionSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TranscriptionSettings clone() => TranscriptionSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TranscriptionSettings copyWith(void Function(TranscriptionSettings) updates) => super.copyWith((message) => updates(message as TranscriptionSettings)) as TranscriptionSettings; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TranscriptionSettings create() => TranscriptionSettings._();
  TranscriptionSettings createEmptyInstance() => create();
  static $pb.PbList<TranscriptionSettings> createRepeated() => $pb.PbList<TranscriptionSettings>();
  @$core.pragma('dart2js:noInline')
  static TranscriptionSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TranscriptionSettings>(create);
  static TranscriptionSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => clearField(1);

  @$pb.TagNumber(2)
  TranscriptionStorageOptions get storage => $_getN(1);
  @$pb.TagNumber(2)
  set storage(TranscriptionStorageOptions v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStorage() => $_has(1);
  @$pb.TagNumber(2)
  void clearStorage() => clearField(2);
  @$pb.TagNumber(2)
  TranscriptionStorageOptions ensureStorage() => $_ensure(1);

  @$pb.TagNumber(3)
  AvailableLanguages get availableLanguages => $_getN(2);
  @$pb.TagNumber(3)
  set availableLanguages(AvailableLanguages v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAvailableLanguages() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvailableLanguages() => clearField(3);
  @$pb.TagNumber(3)
  AvailableLanguages ensureAvailableLanguages() => $_ensure(2);

  @$pb.TagNumber(4)
  Language get preferred => $_getN(3);
  @$pb.TagNumber(4)
  set preferred(Language v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPreferred() => $_has(3);
  @$pb.TagNumber(4)
  void clearPreferred() => clearField(4);
  @$pb.TagNumber(4)
  Language ensurePreferred() => $_ensure(3);
}

class Language extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Language', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.transcription_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code')
    ..hasRequiredFields = false
  ;

  Language._() : super();
  factory Language({
    $core.String? code,
  }) {
    final _result = create();
    if (code != null) {
      _result.code = code;
    }
    return _result;
  }
  factory Language.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Language.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Language clone() => Language()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Language copyWith(void Function(Language) updates) => super.copyWith((message) => updates(message as Language)) as Language; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Language create() => Language._();
  Language createEmptyInstance() => create();
  static $pb.PbList<Language> createRepeated() => $pb.PbList<Language>();
  @$core.pragma('dart2js:noInline')
  static Language getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Language>(create);
  static Language? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);
}

class AvailableLanguages extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AvailableLanguages', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.transcription_v1'), createEmptyInstance: create)
    ..pc<Language>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'languages', $pb.PbFieldType.PM, subBuilder: Language.create)
    ..hasRequiredFields = false
  ;

  AvailableLanguages._() : super();
  factory AvailableLanguages({
    $core.Iterable<Language>? languages,
  }) {
    final _result = create();
    if (languages != null) {
      _result.languages.addAll(languages);
    }
    return _result;
  }
  factory AvailableLanguages.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AvailableLanguages.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AvailableLanguages clone() => AvailableLanguages()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AvailableLanguages copyWith(void Function(AvailableLanguages) updates) => super.copyWith((message) => updates(message as AvailableLanguages)) as AvailableLanguages; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AvailableLanguages create() => AvailableLanguages._();
  AvailableLanguages createEmptyInstance() => create();
  static $pb.PbList<AvailableLanguages> createRepeated() => $pb.PbList<AvailableLanguages>();
  @$core.pragma('dart2js:noInline')
  static AvailableLanguages getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AvailableLanguages>(create);
  static AvailableLanguages? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Language> get languages => $_getList(0);
}

