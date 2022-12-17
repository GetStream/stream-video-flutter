///
//  Generated code. Do not modify.
//  source: video/coordinator/broadcast_v1/broadcast.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'broadcast.pbenum.dart';

class RTMPOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'RTMPOptions',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.broadcast_v1'),
      createEmptyInstance: create)
    ..pPS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'urls')
    ..hasRequiredFields = false;

  RTMPOptions._() : super();
  factory RTMPOptions({
    $core.Iterable<$core.String>? urls,
  }) {
    final _result = create();
    if (urls != null) {
      _result.urls.addAll(urls);
    }
    return _result;
  }
  factory RTMPOptions.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RTMPOptions.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  RTMPOptions clone() => RTMPOptions()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  RTMPOptions copyWith(void Function(RTMPOptions) updates) =>
      super.copyWith((message) => updates(message as RTMPOptions))
          as RTMPOptions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RTMPOptions create() => RTMPOptions._();
  RTMPOptions createEmptyInstance() => create();
  static $pb.PbList<RTMPOptions> createRepeated() => $pb.PbList<RTMPOptions>();
  @$core.pragma('dart2js:noInline')
  static RTMPOptions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RTMPOptions>(create);
  static RTMPOptions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get urls => $_getList(0);
}

class Broadcast extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Broadcast',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'stream.video.coordinator.broadcast_v1'),
      createEmptyInstance: create)
    ..aOM<RTMPOptions>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'rtmp',
        subBuilder: RTMPOptions.create)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'hlsUrl')
    ..hasRequiredFields = false;

  Broadcast._() : super();
  factory Broadcast({
    RTMPOptions? rtmp,
    $core.String? hlsUrl,
  }) {
    final _result = create();
    if (rtmp != null) {
      _result.rtmp = rtmp;
    }
    if (hlsUrl != null) {
      _result.hlsUrl = hlsUrl;
    }
    return _result;
  }
  factory Broadcast.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Broadcast.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Broadcast clone() => Broadcast()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Broadcast copyWith(void Function(Broadcast) updates) =>
      super.copyWith((message) => updates(message as Broadcast))
          as Broadcast; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Broadcast create() => Broadcast._();
  Broadcast createEmptyInstance() => create();
  static $pb.PbList<Broadcast> createRepeated() => $pb.PbList<Broadcast>();
  @$core.pragma('dart2js:noInline')
  static Broadcast getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Broadcast>(create);
  static Broadcast? _defaultInstance;

  @$pb.TagNumber(1)
  RTMPOptions get rtmp => $_getN(0);
  @$pb.TagNumber(1)
  set rtmp(RTMPOptions v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRtmp() => $_has(0);
  @$pb.TagNumber(1)
  void clearRtmp() => clearField(1);
  @$pb.TagNumber(1)
  RTMPOptions ensureRtmp() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get hlsUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set hlsUrl($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasHlsUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearHlsUrl() => clearField(2);
}
