///
//  Generated code. Do not modify.
//  source: video/coordinator/closed_caption_v1/closed_caption.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Terms extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Terms', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.closed_caption_v1'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'start', $pb.PbFieldType.OD)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'end', $pb.PbFieldType.OD)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'text')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'conf', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  Terms._() : super();
  factory Terms({
    $core.double? start,
    $core.double? end,
    $core.String? text,
    $core.String? type,
    $core.double? conf,
  }) {
    final _result = create();
    if (start != null) {
      _result.start = start;
    }
    if (end != null) {
      _result.end = end;
    }
    if (text != null) {
      _result.text = text;
    }
    if (type != null) {
      _result.type = type;
    }
    if (conf != null) {
      _result.conf = conf;
    }
    return _result;
  }
  factory Terms.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Terms.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Terms clone() => Terms()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Terms copyWith(void Function(Terms) updates) => super.copyWith((message) => updates(message as Terms)) as Terms; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Terms create() => Terms._();
  Terms createEmptyInstance() => create();
  static $pb.PbList<Terms> createRepeated() => $pb.PbList<Terms>();
  @$core.pragma('dart2js:noInline')
  static Terms getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Terms>(create);
  static Terms? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get start => $_getN(0);
  @$pb.TagNumber(1)
  set start($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get end => $_getN(1);
  @$pb.TagNumber(2)
  set end($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get type => $_getSZ(3);
  @$pb.TagNumber(4)
  set type($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get conf => $_getN(4);
  @$pb.TagNumber(5)
  set conf($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasConf() => $_has(4);
  @$pb.TagNumber(5)
  void clearConf() => clearField(5);
}

class Monologuewords extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Monologuewords', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.closed_caption_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..pc<Terms>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'terms', $pb.PbFieldType.PM, subBuilder: Terms.create)
    ..hasRequiredFields = false
  ;

  Monologuewords._() : super();
  factory Monologuewords({
    $core.String? userId,
    $core.Iterable<Terms>? terms,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (terms != null) {
      _result.terms.addAll(terms);
    }
    return _result;
  }
  factory Monologuewords.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Monologuewords.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Monologuewords clone() => Monologuewords()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Monologuewords copyWith(void Function(Monologuewords) updates) => super.copyWith((message) => updates(message as Monologuewords)) as Monologuewords; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Monologuewords create() => Monologuewords._();
  Monologuewords createEmptyInstance() => create();
  static $pb.PbList<Monologuewords> createRepeated() => $pb.PbList<Monologuewords>();
  @$core.pragma('dart2js:noInline')
  static Monologuewords getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Monologuewords>(create);
  static Monologuewords? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<Terms> get terms => $_getList(1);
}

class ClosedCaption extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ClosedCaption', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.closed_caption_v1'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp', $pb.PbFieldType.OD)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'speakerName')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'speakerId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'text')
    ..aOM<Monologuewords>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monologueWords', subBuilder: Monologuewords.create)
    ..hasRequiredFields = false
  ;

  ClosedCaption._() : super();
  factory ClosedCaption({
    $core.double? timestamp,
    $core.String? speakerName,
    $core.String? speakerId,
    $core.String? text,
    Monologuewords? monologueWords,
  }) {
    final _result = create();
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (speakerName != null) {
      _result.speakerName = speakerName;
    }
    if (speakerId != null) {
      _result.speakerId = speakerId;
    }
    if (text != null) {
      _result.text = text;
    }
    if (monologueWords != null) {
      _result.monologueWords = monologueWords;
    }
    return _result;
  }
  factory ClosedCaption.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClosedCaption.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClosedCaption clone() => ClosedCaption()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClosedCaption copyWith(void Function(ClosedCaption) updates) => super.copyWith((message) => updates(message as ClosedCaption)) as ClosedCaption; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClosedCaption create() => ClosedCaption._();
  ClosedCaption createEmptyInstance() => create();
  static $pb.PbList<ClosedCaption> createRepeated() => $pb.PbList<ClosedCaption>();
  @$core.pragma('dart2js:noInline')
  static ClosedCaption getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClosedCaption>(create);
  static ClosedCaption? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get timestamp => $_getN(0);
  @$pb.TagNumber(1)
  set timestamp($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get speakerName => $_getSZ(1);
  @$pb.TagNumber(2)
  set speakerName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSpeakerName() => $_has(1);
  @$pb.TagNumber(2)
  void clearSpeakerName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get speakerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set speakerId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSpeakerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpeakerId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get text => $_getSZ(3);
  @$pb.TagNumber(4)
  set text($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasText() => $_has(3);
  @$pb.TagNumber(4)
  void clearText() => clearField(4);

  @$pb.TagNumber(5)
  Monologuewords get monologueWords => $_getN(4);
  @$pb.TagNumber(5)
  set monologueWords(Monologuewords v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasMonologueWords() => $_has(4);
  @$pb.TagNumber(5)
  void clearMonologueWords() => clearField(5);
  @$pb.TagNumber(5)
  Monologuewords ensureMonologueWords() => $_ensure(4);
}

class ClosedCaptionSettings extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ClosedCaptionSettings', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.closed_caption_v1'), createEmptyInstance: create)
    ..aOM<AvailableLanguages>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'availableLanguages', subBuilder: AvailableLanguages.create)
    ..aOM<Language>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'preferred', subBuilder: Language.create)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..hasRequiredFields = false
  ;

  ClosedCaptionSettings._() : super();
  factory ClosedCaptionSettings({
    AvailableLanguages? availableLanguages,
    Language? preferred,
    $core.bool? enabled,
  }) {
    final _result = create();
    if (availableLanguages != null) {
      _result.availableLanguages = availableLanguages;
    }
    if (preferred != null) {
      _result.preferred = preferred;
    }
    if (enabled != null) {
      _result.enabled = enabled;
    }
    return _result;
  }
  factory ClosedCaptionSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClosedCaptionSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClosedCaptionSettings clone() => ClosedCaptionSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClosedCaptionSettings copyWith(void Function(ClosedCaptionSettings) updates) => super.copyWith((message) => updates(message as ClosedCaptionSettings)) as ClosedCaptionSettings; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClosedCaptionSettings create() => ClosedCaptionSettings._();
  ClosedCaptionSettings createEmptyInstance() => create();
  static $pb.PbList<ClosedCaptionSettings> createRepeated() => $pb.PbList<ClosedCaptionSettings>();
  @$core.pragma('dart2js:noInline')
  static ClosedCaptionSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClosedCaptionSettings>(create);
  static ClosedCaptionSettings? _defaultInstance;

  @$pb.TagNumber(1)
  AvailableLanguages get availableLanguages => $_getN(0);
  @$pb.TagNumber(1)
  set availableLanguages(AvailableLanguages v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAvailableLanguages() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvailableLanguages() => clearField(1);
  @$pb.TagNumber(1)
  AvailableLanguages ensureAvailableLanguages() => $_ensure(0);

  @$pb.TagNumber(2)
  Language get preferred => $_getN(1);
  @$pb.TagNumber(2)
  set preferred(Language v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPreferred() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreferred() => clearField(2);
  @$pb.TagNumber(2)
  Language ensurePreferred() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get enabled => $_getBF(2);
  @$pb.TagNumber(3)
  set enabled($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnabled() => clearField(3);
}

class Language extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Language', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.closed_caption_v1'), createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AvailableLanguages', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.closed_caption_v1'), createEmptyInstance: create)
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

