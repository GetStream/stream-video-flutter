///
//  Generated code. Do not modify.
//  source: video_models/models.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../google/protobuf/struct.pb.dart' as $2;

import 'models.pbenum.dart';

export 'models.pbenum.dart';

class Edge extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Edge', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latencyUrl')
    ..hasRequiredFields = false
  ;

  Edge._() : super();
  factory Edge({
    $core.String? name,
    $core.String? latencyUrl,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (latencyUrl != null) {
      _result.latencyUrl = latencyUrl;
    }
    return _result;
  }
  factory Edge.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Edge.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Edge clone() => Edge()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Edge copyWith(void Function(Edge) updates) => super.copyWith((message) => updates(message as Edge)) as Edge; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Edge create() => Edge._();
  Edge createEmptyInstance() => create();
  static $pb.PbList<Edge> createRepeated() => $pb.PbList<Edge>();
  @$core.pragma('dart2js:noInline')
  static Edge getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Edge>(create);
  static Edge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get latencyUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set latencyUrl($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLatencyUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatencyUrl() => clearField(2);
}

class EdgeServer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EdgeServer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'url')
    ..hasRequiredFields = false
  ;

  EdgeServer._() : super();
  factory EdgeServer({
    $core.String? url,
  }) {
    final _result = create();
    if (url != null) {
      _result.url = url;
    }
    return _result;
  }
  factory EdgeServer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EdgeServer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EdgeServer clone() => EdgeServer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EdgeServer copyWith(void Function(EdgeServer) updates) => super.copyWith((message) => updates(message as EdgeServer)) as EdgeServer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EdgeServer create() => EdgeServer._();
  EdgeServer createEmptyInstance() => create();
  static $pb.PbList<EdgeServer> createRepeated() => $pb.PbList<EdgeServer>();
  @$core.pragma('dart2js:noInline')
  static EdgeServer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EdgeServer>(create);
  static EdgeServer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);
}

class Latency extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Latency', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..p<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'measurementsSeconds', $pb.PbFieldType.KF)
    ..hasRequiredFields = false
  ;

  Latency._() : super();
  factory Latency({
    $core.Iterable<$core.double>? measurementsSeconds,
  }) {
    final _result = create();
    if (measurementsSeconds != null) {
      _result.measurementsSeconds.addAll(measurementsSeconds);
    }
    return _result;
  }
  factory Latency.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Latency.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Latency clone() => Latency()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Latency copyWith(void Function(Latency) updates) => super.copyWith((message) => updates(message as Latency)) as Latency; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Latency create() => Latency._();
  Latency createEmptyInstance() => create();
  static $pb.PbList<Latency> createRepeated() => $pb.PbList<Latency>();
  @$core.pragma('dart2js:noInline')
  static Latency getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Latency>(create);
  static Latency? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.double> get measurementsSeconds => $_getList(0);
}

enum Broadcast_Details {
  rtmp, 
  hls, 
  record, 
  notSet
}

class Broadcast extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Broadcast_Details> _Broadcast_DetailsByTag = {
    2 : Broadcast_Details.rtmp,
    3 : Broadcast_Details.hls,
    4 : Broadcast_Details.record,
    0 : Broadcast_Details.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Broadcast', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOM<RTMPBroadcast>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rtmp', subBuilder: RTMPBroadcast.create)
    ..aOM<HLSBroadcast>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hls', subBuilder: HLSBroadcast.create)
    ..aOM<RecordBroadcast>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'record', subBuilder: RecordBroadcast.create)
    ..hasRequiredFields = false
  ;

  Broadcast._() : super();
  factory Broadcast({
    $core.String? id,
    RTMPBroadcast? rtmp,
    HLSBroadcast? hls,
    RecordBroadcast? record,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (rtmp != null) {
      _result.rtmp = rtmp;
    }
    if (hls != null) {
      _result.hls = hls;
    }
    if (record != null) {
      _result.record = record;
    }
    return _result;
  }
  factory Broadcast.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Broadcast.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Broadcast clone() => Broadcast()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Broadcast copyWith(void Function(Broadcast) updates) => super.copyWith((message) => updates(message as Broadcast)) as Broadcast; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Broadcast create() => Broadcast._();
  Broadcast createEmptyInstance() => create();
  static $pb.PbList<Broadcast> createRepeated() => $pb.PbList<Broadcast>();
  @$core.pragma('dart2js:noInline')
  static Broadcast getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Broadcast>(create);
  static Broadcast? _defaultInstance;

  Broadcast_Details whichDetails() => _Broadcast_DetailsByTag[$_whichOneof(0)]!;
  void clearDetails() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  RTMPBroadcast get rtmp => $_getN(1);
  @$pb.TagNumber(2)
  set rtmp(RTMPBroadcast v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRtmp() => $_has(1);
  @$pb.TagNumber(2)
  void clearRtmp() => clearField(2);
  @$pb.TagNumber(2)
  RTMPBroadcast ensureRtmp() => $_ensure(1);

  @$pb.TagNumber(3)
  HLSBroadcast get hls => $_getN(2);
  @$pb.TagNumber(3)
  set hls(HLSBroadcast v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasHls() => $_has(2);
  @$pb.TagNumber(3)
  void clearHls() => clearField(3);
  @$pb.TagNumber(3)
  HLSBroadcast ensureHls() => $_ensure(2);

  @$pb.TagNumber(4)
  RecordBroadcast get record => $_getN(3);
  @$pb.TagNumber(4)
  set record(RecordBroadcast v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasRecord() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecord() => clearField(4);
  @$pb.TagNumber(4)
  RecordBroadcast ensureRecord() => $_ensure(3);
}

class RTMPBroadcast extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RTMPBroadcast', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callId')
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rtmpurls')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'width', $pb.PbFieldType.O3)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'height', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  RTMPBroadcast._() : super();
  factory RTMPBroadcast({
    $core.String? callId,
    $core.Iterable<$core.String>? rtmpurls,
    $core.int? width,
    $core.int? height,
  }) {
    final _result = create();
    if (callId != null) {
      _result.callId = callId;
    }
    if (rtmpurls != null) {
      _result.rtmpurls.addAll(rtmpurls);
    }
    if (width != null) {
      _result.width = width;
    }
    if (height != null) {
      _result.height = height;
    }
    return _result;
  }
  factory RTMPBroadcast.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RTMPBroadcast.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RTMPBroadcast clone() => RTMPBroadcast()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RTMPBroadcast copyWith(void Function(RTMPBroadcast) updates) => super.copyWith((message) => updates(message as RTMPBroadcast)) as RTMPBroadcast; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RTMPBroadcast create() => RTMPBroadcast._();
  RTMPBroadcast createEmptyInstance() => create();
  static $pb.PbList<RTMPBroadcast> createRepeated() => $pb.PbList<RTMPBroadcast>();
  @$core.pragma('dart2js:noInline')
  static RTMPBroadcast getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RTMPBroadcast>(create);
  static RTMPBroadcast? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callId => $_getSZ(0);
  @$pb.TagNumber(1)
  set callId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get rtmpurls => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get width => $_getIZ(2);
  @$pb.TagNumber(3)
  set width($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidth() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(3);
  @$pb.TagNumber(4)
  set height($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => clearField(4);
}

class HLSBroadcast extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HLSBroadcast', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  HLSBroadcast._() : super();
  factory HLSBroadcast() => create();
  factory HLSBroadcast.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HLSBroadcast.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HLSBroadcast clone() => HLSBroadcast()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HLSBroadcast copyWith(void Function(HLSBroadcast) updates) => super.copyWith((message) => updates(message as HLSBroadcast)) as HLSBroadcast; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HLSBroadcast create() => HLSBroadcast._();
  HLSBroadcast createEmptyInstance() => create();
  static $pb.PbList<HLSBroadcast> createRepeated() => $pb.PbList<HLSBroadcast>();
  @$core.pragma('dart2js:noInline')
  static HLSBroadcast getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HLSBroadcast>(create);
  static HLSBroadcast? _defaultInstance;
}

class File extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'File', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'composite')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'url')
    ..hasRequiredFields = false
  ;

  File._() : super();
  factory File({
    $core.String? type,
    $core.bool? composite,
    $core.String? userId,
    $core.String? url,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (composite != null) {
      _result.composite = composite;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    if (url != null) {
      _result.url = url;
    }
    return _result;
  }
  factory File.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File clone() => File()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File copyWith(void Function(File) updates) => super.copyWith((message) => updates(message as File)) as File; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static File create() => File._();
  File createEmptyInstance() => create();
  static $pb.PbList<File> createRepeated() => $pb.PbList<File>();
  @$core.pragma('dart2js:noInline')
  static File getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File>(create);
  static File? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get composite => $_getBF(1);
  @$pb.TagNumber(2)
  set composite($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasComposite() => $_has(1);
  @$pb.TagNumber(2)
  void clearComposite() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => clearField(4);
}

class RecordBroadcast extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecordBroadcast', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'composite')
    ..pc<File>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'files', $pb.PbFieldType.PM, subBuilder: File.create)
    ..hasRequiredFields = false
  ;

  RecordBroadcast._() : super();
  factory RecordBroadcast({
    $core.bool? composite,
    $core.Iterable<File>? files,
  }) {
    final _result = create();
    if (composite != null) {
      _result.composite = composite;
    }
    if (files != null) {
      _result.files.addAll(files);
    }
    return _result;
  }
  factory RecordBroadcast.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecordBroadcast.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecordBroadcast clone() => RecordBroadcast()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecordBroadcast copyWith(void Function(RecordBroadcast) updates) => super.copyWith((message) => updates(message as RecordBroadcast)) as RecordBroadcast; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RecordBroadcast create() => RecordBroadcast._();
  RecordBroadcast createEmptyInstance() => create();
  static $pb.PbList<RecordBroadcast> createRepeated() => $pb.PbList<RecordBroadcast>();
  @$core.pragma('dart2js:noInline')
  static RecordBroadcast getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecordBroadcast>(create);
  static RecordBroadcast? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get composite => $_getBF(0);
  @$pb.TagNumber(1)
  set composite($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasComposite() => $_has(0);
  @$pb.TagNumber(1)
  void clearComposite() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<File> get files => $_getList(1);
}

class User extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'User', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'teams')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'role')
    ..aOM<$2.Struct>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'custom', subBuilder: $2.Struct.create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'profileImageUrl')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt')
    ..hasRequiredFields = false
  ;

  User._() : super();
  factory User({
    $core.String? id,
    $core.Iterable<$core.String>? teams,
    $core.String? role,
    $2.Struct? custom,
    $core.String? name,
    $core.String? profileImageUrl,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (teams != null) {
      _result.teams.addAll(teams);
    }
    if (role != null) {
      _result.role = role;
    }
    if (custom != null) {
      _result.custom = custom;
    }
    if (name != null) {
      _result.name = name;
    }
    if (profileImageUrl != null) {
      _result.profileImageUrl = profileImageUrl;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    return _result;
  }
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User)) as User; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get teams => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => clearField(3);

  @$pb.TagNumber(4)
  $2.Struct get custom => $_getN(3);
  @$pb.TagNumber(4)
  set custom($2.Struct v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCustom() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustom() => clearField(4);
  @$pb.TagNumber(4)
  $2.Struct ensureCustom() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get profileImageUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set profileImageUrl($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasProfileImageUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearProfileImageUrl() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get createdAt => $_getSZ(6);
  @$pb.TagNumber(7)
  set createdAt($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get updatedAt => $_getSZ(7);
  @$pb.TagNumber(8)
  set updatedAt($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => clearField(8);
}

class UserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UserRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'teams')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'role')
    ..aOM<$2.Struct>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'custom', subBuilder: $2.Struct.create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'profileImageUrl')
    ..hasRequiredFields = false
  ;

  UserRequest._() : super();
  factory UserRequest({
    $core.String? id,
    $core.Iterable<$core.String>? teams,
    $core.String? role,
    $2.Struct? custom,
    $core.String? name,
    $core.String? profileImageUrl,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (teams != null) {
      _result.teams.addAll(teams);
    }
    if (role != null) {
      _result.role = role;
    }
    if (custom != null) {
      _result.custom = custom;
    }
    if (name != null) {
      _result.name = name;
    }
    if (profileImageUrl != null) {
      _result.profileImageUrl = profileImageUrl;
    }
    return _result;
  }
  factory UserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserRequest clone() => UserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserRequest copyWith(void Function(UserRequest) updates) => super.copyWith((message) => updates(message as UserRequest)) as UserRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UserRequest create() => UserRequest._();
  UserRequest createEmptyInstance() => create();
  static $pb.PbList<UserRequest> createRepeated() => $pb.PbList<UserRequest>();
  @$core.pragma('dart2js:noInline')
  static UserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserRequest>(create);
  static UserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get teams => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => clearField(3);

  @$pb.TagNumber(4)
  $2.Struct get custom => $_getN(3);
  @$pb.TagNumber(4)
  set custom($2.Struct v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCustom() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustom() => clearField(4);
  @$pb.TagNumber(4)
  $2.Struct ensureCustom() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get profileImageUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set profileImageUrl($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasProfileImageUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearProfileImageUrl() => clearField(6);
}

class Device extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Device', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'disabled')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'disabledReason')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pushProviderName')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt')
    ..hasRequiredFields = false
  ;

  Device._() : super();
  factory Device({
    $core.String? userId,
    $core.String? id,
    $core.bool? disabled,
    $core.String? disabledReason,
    $core.String? pushProviderName,
    $core.String? createdAt,
    $core.String? updatedAt,
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
  factory Device.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Device.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Device clone() => Device()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Device copyWith(void Function(Device) updates) => super.copyWith((message) => updates(message as Device)) as Device; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Device create() => Device._();
  Device createEmptyInstance() => create();
  static $pb.PbList<Device> createRepeated() => $pb.PbList<Device>();
  @$core.pragma('dart2js:noInline')
  static Device getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Device>(create);
  static Device? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get disabled => $_getBF(2);
  @$pb.TagNumber(3)
  set disabled($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDisabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisabled() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get disabledReason => $_getSZ(3);
  @$pb.TagNumber(4)
  set disabledReason($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDisabledReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisabledReason() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get pushProviderName => $_getSZ(4);
  @$pb.TagNumber(5)
  set pushProviderName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPushProviderName() => $_has(4);
  @$pb.TagNumber(5)
  void clearPushProviderName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get createdAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set createdAt($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get updatedAt => $_getSZ(6);
  @$pb.TagNumber(7)
  set updatedAt($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => clearField(7);
}

class DeviceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeviceRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'disabled')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'disabledReason')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pushProviderName')
    ..hasRequiredFields = false
  ;

  DeviceRequest._() : super();
  factory DeviceRequest({
    $core.String? userId,
    $core.String? id,
    $core.bool? disabled,
    $core.String? disabledReason,
    $core.String? pushProviderName,
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
    return _result;
  }
  factory DeviceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeviceRequest clone() => DeviceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeviceRequest copyWith(void Function(DeviceRequest) updates) => super.copyWith((message) => updates(message as DeviceRequest)) as DeviceRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceRequest create() => DeviceRequest._();
  DeviceRequest createEmptyInstance() => create();
  static $pb.PbList<DeviceRequest> createRepeated() => $pb.PbList<DeviceRequest>();
  @$core.pragma('dart2js:noInline')
  static DeviceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceRequest>(create);
  static DeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get disabled => $_getBF(2);
  @$pb.TagNumber(3)
  set disabled($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDisabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisabled() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get disabledReason => $_getSZ(3);
  @$pb.TagNumber(4)
  set disabledReason($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDisabledReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisabledReason() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get pushProviderName => $_getSZ(4);
  @$pb.TagNumber(5)
  set pushProviderName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPushProviderName() => $_has(4);
  @$pb.TagNumber(5)
  void clearPushProviderName() => clearField(5);
}

class RecordingStorageOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecordingStorageOptions', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..e<RecordingStorage>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'storage', $pb.PbFieldType.OE, defaultOrMaker: RecordingStorage.RECORDING_STORAGE_S3_UNSPECIFIED, valueOf: RecordingStorage.valueOf, enumValues: RecordingStorage.values)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accessKey')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'secretKey')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bucketName')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'region')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path')
    ..hasRequiredFields = false
  ;

  RecordingStorageOptions._() : super();
  factory RecordingStorageOptions({
    RecordingStorage? storage,
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
  factory RecordingStorageOptions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecordingStorageOptions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecordingStorageOptions clone() => RecordingStorageOptions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecordingStorageOptions copyWith(void Function(RecordingStorageOptions) updates) => super.copyWith((message) => updates(message as RecordingStorageOptions)) as RecordingStorageOptions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RecordingStorageOptions create() => RecordingStorageOptions._();
  RecordingStorageOptions createEmptyInstance() => create();
  static $pb.PbList<RecordingStorageOptions> createRepeated() => $pb.PbList<RecordingStorageOptions>();
  @$core.pragma('dart2js:noInline')
  static RecordingStorageOptions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecordingStorageOptions>(create);
  static RecordingStorageOptions? _defaultInstance;

  @$pb.TagNumber(2)
  RecordingStorage get storage => $_getN(0);
  @$pb.TagNumber(2)
  set storage(RecordingStorage v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStorage() => $_has(0);
  @$pb.TagNumber(2)
  void clearStorage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get accessKey => $_getSZ(1);
  @$pb.TagNumber(3)
  set accessKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasAccessKey() => $_has(1);
  @$pb.TagNumber(3)
  void clearAccessKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get secretKey => $_getSZ(2);
  @$pb.TagNumber(4)
  set secretKey($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasSecretKey() => $_has(2);
  @$pb.TagNumber(4)
  void clearSecretKey() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get bucketName => $_getSZ(3);
  @$pb.TagNumber(5)
  set bucketName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasBucketName() => $_has(3);
  @$pb.TagNumber(5)
  void clearBucketName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get region => $_getSZ(4);
  @$pb.TagNumber(6)
  set region($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasRegion() => $_has(4);
  @$pb.TagNumber(6)
  void clearRegion() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get path => $_getSZ(5);
  @$pb.TagNumber(7)
  set path($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasPath() => $_has(5);
  @$pb.TagNumber(7)
  void clearPath() => clearField(7);
}

class BroadcastOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastOptions', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rtmpUrl')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hlsUrl')
    ..hasRequiredFields = false
  ;

  BroadcastOptions._() : super();
  factory BroadcastOptions({
    $core.String? rtmpUrl,
    $core.String? hlsUrl,
  }) {
    final _result = create();
    if (rtmpUrl != null) {
      _result.rtmpUrl = rtmpUrl;
    }
    if (hlsUrl != null) {
      _result.hlsUrl = hlsUrl;
    }
    return _result;
  }
  factory BroadcastOptions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BroadcastOptions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BroadcastOptions clone() => BroadcastOptions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BroadcastOptions copyWith(void Function(BroadcastOptions) updates) => super.copyWith((message) => updates(message as BroadcastOptions)) as BroadcastOptions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BroadcastOptions create() => BroadcastOptions._();
  BroadcastOptions createEmptyInstance() => create();
  static $pb.PbList<BroadcastOptions> createRepeated() => $pb.PbList<BroadcastOptions>();
  @$core.pragma('dart2js:noInline')
  static BroadcastOptions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BroadcastOptions>(create);
  static BroadcastOptions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rtmpUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set rtmpUrl($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRtmpUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearRtmpUrl() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get hlsUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set hlsUrl($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHlsUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearHlsUrl() => clearField(2);
}

class TranscribeOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TranscribeOptions', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  TranscribeOptions._() : super();
  factory TranscribeOptions() => create();
  factory TranscribeOptions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TranscribeOptions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TranscribeOptions clone() => TranscribeOptions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TranscribeOptions copyWith(void Function(TranscribeOptions) updates) => super.copyWith((message) => updates(message as TranscribeOptions)) as TranscribeOptions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TranscribeOptions create() => TranscribeOptions._();
  TranscribeOptions createEmptyInstance() => create();
  static $pb.PbList<TranscribeOptions> createRepeated() => $pb.PbList<TranscribeOptions>();
  @$core.pragma('dart2js:noInline')
  static TranscribeOptions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TranscribeOptions>(create);
  static TranscribeOptions? _defaultInstance;
}

class CallType extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallType', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOM<Security>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'security', subBuilder: Security.create)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcast')
    ..pc<BroadcastOptions>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcastOptions', $pb.PbFieldType.PM, subBuilder: BroadcastOptions.create)
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transcribe')
    ..aOM<TranscribeOptions>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transcribeOptions', subBuilder: TranscribeOptions.create)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt')
    ..hasRequiredFields = false
  ;

  CallType._() : super();
  factory CallType({
    $core.String? name,
    Security? security,
    $core.bool? broadcast,
    $core.Iterable<BroadcastOptions>? broadcastOptions,
    $core.bool? transcribe,
    TranscribeOptions? transcribeOptions,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (security != null) {
      _result.security = security;
    }
    if (broadcast != null) {
      _result.broadcast = broadcast;
    }
    if (broadcastOptions != null) {
      _result.broadcastOptions.addAll(broadcastOptions);
    }
    if (transcribe != null) {
      _result.transcribe = transcribe;
    }
    if (transcribeOptions != null) {
      _result.transcribeOptions = transcribeOptions;
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
  Security get security => $_getN(1);
  @$pb.TagNumber(2)
  set security(Security v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSecurity() => $_has(1);
  @$pb.TagNumber(2)
  void clearSecurity() => clearField(2);
  @$pb.TagNumber(2)
  Security ensureSecurity() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get broadcast => $_getBF(2);
  @$pb.TagNumber(3)
  set broadcast($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBroadcast() => $_has(2);
  @$pb.TagNumber(3)
  void clearBroadcast() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<BroadcastOptions> get broadcastOptions => $_getList(3);

  @$pb.TagNumber(5)
  $core.bool get transcribe => $_getBF(4);
  @$pb.TagNumber(5)
  set transcribe($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTranscribe() => $_has(4);
  @$pb.TagNumber(5)
  void clearTranscribe() => clearField(5);

  @$pb.TagNumber(6)
  TranscribeOptions get transcribeOptions => $_getN(5);
  @$pb.TagNumber(6)
  set transcribeOptions(TranscribeOptions v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasTranscribeOptions() => $_has(5);
  @$pb.TagNumber(6)
  void clearTranscribeOptions() => clearField(6);
  @$pb.TagNumber(6)
  TranscribeOptions ensureTranscribeOptions() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get createdAt => $_getSZ(6);
  @$pb.TagNumber(7)
  set createdAt($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get updatedAt => $_getSZ(7);
  @$pb.TagNumber(8)
  set updatedAt($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => clearField(8);
}

class Security extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Security', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hideProfilePictures')
    ..e<Security_IsAllowed>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'shareScreen', $pb.PbFieldType.OE, defaultOrMaker: Security_IsAllowed.IS_ALLOWED_YES_UNSPECIFIED, valueOf: Security_IsAllowed.valueOf, enumValues: Security_IsAllowed.values)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'renameUser')
    ..e<Security_IsAllowed>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'unmute', $pb.PbFieldType.OE, defaultOrMaker: Security_IsAllowed.IS_ALLOWED_YES_UNSPECIFIED, valueOf: Security_IsAllowed.valueOf, enumValues: Security_IsAllowed.values)
    ..e<Security_IsAllowed>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startVideo', $pb.PbFieldType.OE, defaultOrMaker: Security_IsAllowed.IS_ALLOWED_YES_UNSPECIFIED, valueOf: Security_IsAllowed.valueOf, enumValues: Security_IsAllowed.values)
    ..e<Security_IsAllowed>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'screenShare', $pb.PbFieldType.OE, defaultOrMaker: Security_IsAllowed.IS_ALLOWED_YES_UNSPECIFIED, valueOf: Security_IsAllowed.valueOf, enumValues: Security_IsAllowed.values)
    ..e<Security_IsAllowed>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'record', $pb.PbFieldType.OE, defaultOrMaker: Security_IsAllowed.IS_ALLOWED_YES_UNSPECIFIED, valueOf: Security_IsAllowed.valueOf, enumValues: Security_IsAllowed.values)
    ..e<Security_IsAllowed>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcast', $pb.PbFieldType.OE, defaultOrMaker: Security_IsAllowed.IS_ALLOWED_YES_UNSPECIFIED, valueOf: Security_IsAllowed.valueOf, enumValues: Security_IsAllowed.values)
    ..hasRequiredFields = false
  ;

  Security._() : super();
  factory Security({
    $core.bool? hideProfilePictures,
    Security_IsAllowed? shareScreen,
    $core.bool? renameUser,
    Security_IsAllowed? unmute,
    Security_IsAllowed? startVideo,
    Security_IsAllowed? screenShare,
    Security_IsAllowed? record,
    Security_IsAllowed? broadcast,
  }) {
    final _result = create();
    if (hideProfilePictures != null) {
      _result.hideProfilePictures = hideProfilePictures;
    }
    if (shareScreen != null) {
      _result.shareScreen = shareScreen;
    }
    if (renameUser != null) {
      _result.renameUser = renameUser;
    }
    if (unmute != null) {
      _result.unmute = unmute;
    }
    if (startVideo != null) {
      _result.startVideo = startVideo;
    }
    if (screenShare != null) {
      _result.screenShare = screenShare;
    }
    if (record != null) {
      _result.record = record;
    }
    if (broadcast != null) {
      _result.broadcast = broadcast;
    }
    return _result;
  }
  factory Security.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Security.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Security clone() => Security()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Security copyWith(void Function(Security) updates) => super.copyWith((message) => updates(message as Security)) as Security; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Security create() => Security._();
  Security createEmptyInstance() => create();
  static $pb.PbList<Security> createRepeated() => $pb.PbList<Security>();
  @$core.pragma('dart2js:noInline')
  static Security getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Security>(create);
  static Security? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get hideProfilePictures => $_getBF(0);
  @$pb.TagNumber(1)
  set hideProfilePictures($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHideProfilePictures() => $_has(0);
  @$pb.TagNumber(1)
  void clearHideProfilePictures() => clearField(1);

  @$pb.TagNumber(2)
  Security_IsAllowed get shareScreen => $_getN(1);
  @$pb.TagNumber(2)
  set shareScreen(Security_IsAllowed v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasShareScreen() => $_has(1);
  @$pb.TagNumber(2)
  void clearShareScreen() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get renameUser => $_getBF(2);
  @$pb.TagNumber(3)
  set renameUser($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRenameUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearRenameUser() => clearField(3);

  @$pb.TagNumber(4)
  Security_IsAllowed get unmute => $_getN(3);
  @$pb.TagNumber(4)
  set unmute(Security_IsAllowed v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasUnmute() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnmute() => clearField(4);

  @$pb.TagNumber(5)
  Security_IsAllowed get startVideo => $_getN(4);
  @$pb.TagNumber(5)
  set startVideo(Security_IsAllowed v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasStartVideo() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartVideo() => clearField(5);

  @$pb.TagNumber(6)
  Security_IsAllowed get screenShare => $_getN(5);
  @$pb.TagNumber(6)
  set screenShare(Security_IsAllowed v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasScreenShare() => $_has(5);
  @$pb.TagNumber(6)
  void clearScreenShare() => clearField(6);

  @$pb.TagNumber(7)
  Security_IsAllowed get record => $_getN(6);
  @$pb.TagNumber(7)
  set record(Security_IsAllowed v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasRecord() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecord() => clearField(7);

  @$pb.TagNumber(8)
  Security_IsAllowed get broadcast => $_getN(7);
  @$pb.TagNumber(8)
  set broadcast(Security_IsAllowed v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasBroadcast() => $_has(7);
  @$pb.TagNumber(8)
  void clearBroadcast() => clearField(8);
}

class Participant extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Participant', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'role')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'online')
    ..aOM<$2.Struct>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'custom', subBuilder: $2.Struct.create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt')
    ..hasRequiredFields = false
  ;

  Participant._() : super();
  factory Participant({
    $core.String? userId,
    $core.String? role,
    $core.bool? online,
    $2.Struct? custom,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (role != null) {
      _result.role = role;
    }
    if (online != null) {
      _result.online = online;
    }
    if (custom != null) {
      _result.custom = custom;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    return _result;
  }
  factory Participant.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Participant.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Participant clone() => Participant()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Participant copyWith(void Function(Participant) updates) => super.copyWith((message) => updates(message as Participant)) as Participant; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Participant create() => Participant._();
  Participant createEmptyInstance() => create();
  static $pb.PbList<Participant> createRepeated() => $pb.PbList<Participant>();
  @$core.pragma('dart2js:noInline')
  static Participant getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Participant>(create);
  static Participant? _defaultInstance;

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
  $core.bool get online => $_getBF(2);
  @$pb.TagNumber(3)
  set online($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOnline() => $_has(2);
  @$pb.TagNumber(3)
  void clearOnline() => clearField(3);

  @$pb.TagNumber(4)
  $2.Struct get custom => $_getN(3);
  @$pb.TagNumber(4)
  set custom($2.Struct v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCustom() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustom() => clearField(4);
  @$pb.TagNumber(4)
  $2.Struct ensureCustom() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get createdAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set createdAt($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get updatedAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set updatedAt($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasUpdatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdatedAt() => clearField(6);
}

class ParticipantRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ParticipantRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'role')
    ..aOM<$2.Struct>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'custom', subBuilder: $2.Struct.create)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt')
    ..hasRequiredFields = false
  ;

  ParticipantRequest._() : super();
  factory ParticipantRequest({
    $core.String? userId,
    $core.String? role,
    $2.Struct? custom,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (role != null) {
      _result.role = role;
    }
    if (custom != null) {
      _result.custom = custom;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    return _result;
  }
  factory ParticipantRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ParticipantRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ParticipantRequest clone() => ParticipantRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ParticipantRequest copyWith(void Function(ParticipantRequest) updates) => super.copyWith((message) => updates(message as ParticipantRequest)) as ParticipantRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ParticipantRequest create() => ParticipantRequest._();
  ParticipantRequest createEmptyInstance() => create();
  static $pb.PbList<ParticipantRequest> createRepeated() => $pb.PbList<ParticipantRequest>();
  @$core.pragma('dart2js:noInline')
  static ParticipantRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParticipantRequest>(create);
  static ParticipantRequest? _defaultInstance;

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
  $2.Struct get custom => $_getN(2);
  @$pb.TagNumber(3)
  set custom($2.Struct v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCustom() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustom() => clearField(3);
  @$pb.TagNumber(3)
  $2.Struct ensureCustom() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get createdAt => $_getSZ(3);
  @$pb.TagNumber(4)
  set createdAt($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCreatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedAt() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get updatedAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set updatedAt($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUpdatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdatedAt() => clearField(5);
}

class CallState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CallState', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..pc<Participant>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'participants', $pb.PbFieldType.PM, subBuilder: Participant.create)
    ..hasRequiredFields = false
  ;

  CallState._() : super();
  factory CallState({
    $core.Iterable<Participant>? participants,
  }) {
    final _result = create();
    if (participants != null) {
      _result.participants.addAll(participants);
    }
    return _result;
  }
  factory CallState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallState clone() => CallState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallState copyWith(void Function(CallState) updates) => super.copyWith((message) => updates(message as CallState)) as CallState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CallState create() => CallState._();
  CallState createEmptyInstance() => create();
  static $pb.PbList<CallState> createRepeated() => $pb.PbList<CallState>();
  @$core.pragma('dart2js:noInline')
  static CallState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallState>(create);
  static CallState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Participant> get participants => $_getList(0);
}

class Call extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Call', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdByUserId')
    ..aOM<$2.Struct>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'custom', subBuilder: $2.Struct.create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt')
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcast')
    ..pc<BroadcastOptions>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'broadcastOptions', $pb.PbFieldType.PM, subBuilder: BroadcastOptions.create)
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transcribe')
    ..aOM<TranscribeOptions>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transcribeOptions', subBuilder: TranscribeOptions.create)
    ..hasRequiredFields = false
  ;

  Call._() : super();
  factory Call({
    $core.String? type,
    $core.String? id,
    $core.String? createdByUserId,
    $2.Struct? custom,
    $core.String? createdAt,
    $core.String? updatedAt,
    $core.bool? broadcast,
    $core.Iterable<BroadcastOptions>? broadcastOptions,
    $core.bool? transcribe,
    TranscribeOptions? transcribeOptions,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (id != null) {
      _result.id = id;
    }
    if (createdByUserId != null) {
      _result.createdByUserId = createdByUserId;
    }
    if (custom != null) {
      _result.custom = custom;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    if (broadcast != null) {
      _result.broadcast = broadcast;
    }
    if (broadcastOptions != null) {
      _result.broadcastOptions.addAll(broadcastOptions);
    }
    if (transcribe != null) {
      _result.transcribe = transcribe;
    }
    if (transcribeOptions != null) {
      _result.transcribeOptions = transcribeOptions;
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
  $core.String get createdByUserId => $_getSZ(2);
  @$pb.TagNumber(3)
  set createdByUserId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCreatedByUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedByUserId() => clearField(3);

  @$pb.TagNumber(4)
  $2.Struct get custom => $_getN(3);
  @$pb.TagNumber(4)
  set custom($2.Struct v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCustom() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustom() => clearField(4);
  @$pb.TagNumber(4)
  $2.Struct ensureCustom() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get createdAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set createdAt($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get updatedAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set updatedAt($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasUpdatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdatedAt() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get broadcast => $_getBF(6);
  @$pb.TagNumber(7)
  set broadcast($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasBroadcast() => $_has(6);
  @$pb.TagNumber(7)
  void clearBroadcast() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<BroadcastOptions> get broadcastOptions => $_getList(7);

  @$pb.TagNumber(9)
  $core.bool get transcribe => $_getBF(8);
  @$pb.TagNumber(9)
  set transcribe($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTranscribe() => $_has(8);
  @$pb.TagNumber(9)
  void clearTranscribe() => clearField(9);

  @$pb.TagNumber(10)
  TranscribeOptions get transcribeOptions => $_getN(9);
  @$pb.TagNumber(10)
  set transcribeOptions(TranscribeOptions v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasTranscribeOptions() => $_has(9);
  @$pb.TagNumber(10)
  void clearTranscribeOptions() => clearField(10);
  @$pb.TagNumber(10)
  TranscribeOptions ensureTranscribeOptions() => $_ensure(9);
}

