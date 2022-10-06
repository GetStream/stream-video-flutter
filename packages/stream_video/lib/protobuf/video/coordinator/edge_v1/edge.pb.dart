///
//  Generated code. Do not modify.
//  source: video/coordinator/edge_v1/edge.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Credentials extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Credentials', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.edge_v1'), createEmptyInstance: create)
    ..aOM<EdgeServer>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'server', subBuilder: EdgeServer.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..pc<ICEServer>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iceServers', $pb.PbFieldType.PM, subBuilder: ICEServer.create)
    ..hasRequiredFields = false
  ;

  Credentials._() : super();
  factory Credentials({
    EdgeServer? server,
    $core.String? token,
    $core.Iterable<ICEServer>? iceServers,
  }) {
    final _result = create();
    if (server != null) {
      _result.server = server;
    }
    if (token != null) {
      _result.token = token;
    }
    if (iceServers != null) {
      _result.iceServers.addAll(iceServers);
    }
    return _result;
  }
  factory Credentials.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Credentials.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Credentials clone() => Credentials()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Credentials copyWith(void Function(Credentials) updates) => super.copyWith((message) => updates(message as Credentials)) as Credentials; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Credentials create() => Credentials._();
  Credentials createEmptyInstance() => create();
  static $pb.PbList<Credentials> createRepeated() => $pb.PbList<Credentials>();
  @$core.pragma('dart2js:noInline')
  static Credentials getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Credentials>(create);
  static Credentials? _defaultInstance;

  @$pb.TagNumber(1)
  EdgeServer get server => $_getN(0);
  @$pb.TagNumber(1)
  set server(EdgeServer v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasServer() => $_has(0);
  @$pb.TagNumber(1)
  void clearServer() => clearField(1);
  @$pb.TagNumber(1)
  EdgeServer ensureServer() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<ICEServer> get iceServers => $_getList(2);
}

class LatencyMeasurements extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LatencyMeasurements', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.edge_v1'), createEmptyInstance: create)
    ..m<$core.String, Latency>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'measurements', entryClassName: 'LatencyMeasurements.MeasurementsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: Latency.create, packageName: const $pb.PackageName('stream.video.coordinator.edge_v1'))
    ..hasRequiredFields = false
  ;

  LatencyMeasurements._() : super();
  factory LatencyMeasurements({
    $core.Map<$core.String, Latency>? measurements,
  }) {
    final _result = create();
    if (measurements != null) {
      _result.measurements.addAll(measurements);
    }
    return _result;
  }
  factory LatencyMeasurements.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LatencyMeasurements.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LatencyMeasurements clone() => LatencyMeasurements()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LatencyMeasurements copyWith(void Function(LatencyMeasurements) updates) => super.copyWith((message) => updates(message as LatencyMeasurements)) as LatencyMeasurements; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LatencyMeasurements create() => LatencyMeasurements._();
  LatencyMeasurements createEmptyInstance() => create();
  static $pb.PbList<LatencyMeasurements> createRepeated() => $pb.PbList<LatencyMeasurements>();
  @$core.pragma('dart2js:noInline')
  static LatencyMeasurements getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LatencyMeasurements>(create);
  static LatencyMeasurements? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, Latency> get measurements => $_getMap(0);
}

class Latency extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Latency', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.edge_v1'), createEmptyInstance: create)
    ..p<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'measurementsSeconds', $pb.PbFieldType.KD)
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

class Coordinates extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Coordinates', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.edge_v1'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lat', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'long', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  Coordinates._() : super();
  factory Coordinates({
    $core.double? lat,
    $core.double? long,
  }) {
    final _result = create();
    if (lat != null) {
      _result.lat = lat;
    }
    if (long != null) {
      _result.long = long;
    }
    return _result;
  }
  factory Coordinates.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Coordinates.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Coordinates clone() => Coordinates()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Coordinates copyWith(void Function(Coordinates) updates) => super.copyWith((message) => updates(message as Coordinates)) as Coordinates; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Coordinates create() => Coordinates._();
  Coordinates createEmptyInstance() => create();
  static $pb.PbList<Coordinates> createRepeated() => $pb.PbList<Coordinates>();
  @$core.pragma('dart2js:noInline')
  static Coordinates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Coordinates>(create);
  static Coordinates? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get lat => $_getN(0);
  @$pb.TagNumber(1)
  set lat($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLat() => $_has(0);
  @$pb.TagNumber(1)
  void clearLat() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get long => $_getN(1);
  @$pb.TagNumber(2)
  set long($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLong() => $_has(1);
  @$pb.TagNumber(2)
  void clearLong() => clearField(2);
}

class Edge extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Edge', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.edge_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latencyUrl')
    ..aOM<Coordinates>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coordinates', subBuilder: Coordinates.create)
    ..hasRequiredFields = false
  ;

  Edge._() : super();
  factory Edge({
    $core.String? name,
    $core.String? latencyUrl,
    Coordinates? coordinates,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (latencyUrl != null) {
      _result.latencyUrl = latencyUrl;
    }
    if (coordinates != null) {
      _result.coordinates = coordinates;
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

  @$pb.TagNumber(3)
  Coordinates get coordinates => $_getN(2);
  @$pb.TagNumber(3)
  set coordinates(Coordinates v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCoordinates() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoordinates() => clearField(3);
  @$pb.TagNumber(3)
  Coordinates ensureCoordinates() => $_ensure(2);
}

class ICEServer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ICEServer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.edge_v1'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'urls')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'password')
    ..hasRequiredFields = false
  ;

  ICEServer._() : super();
  factory ICEServer({
    $core.Iterable<$core.String>? urls,
    $core.String? username,
    $core.String? password,
  }) {
    final _result = create();
    if (urls != null) {
      _result.urls.addAll(urls);
    }
    if (username != null) {
      _result.username = username;
    }
    if (password != null) {
      _result.password = password;
    }
    return _result;
  }
  factory ICEServer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ICEServer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ICEServer clone() => ICEServer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ICEServer copyWith(void Function(ICEServer) updates) => super.copyWith((message) => updates(message as ICEServer)) as ICEServer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ICEServer create() => ICEServer._();
  ICEServer createEmptyInstance() => create();
  static $pb.PbList<ICEServer> createRepeated() => $pb.PbList<ICEServer>();
  @$core.pragma('dart2js:noInline')
  static ICEServer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ICEServer>(create);
  static ICEServer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get urls => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get password => $_getSZ(2);
  @$pb.TagNumber(3)
  set password($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassword() => clearField(3);
}

class EdgeServer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EdgeServer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'stream.video.coordinator.edge_v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'url')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'edgeName')
    ..hasRequiredFields = false
  ;

  EdgeServer._() : super();
  factory EdgeServer({
    $core.String? url,
    $core.String? edgeName,
  }) {
    final _result = create();
    if (url != null) {
      _result.url = url;
    }
    if (edgeName != null) {
      _result.edgeName = edgeName;
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

  @$pb.TagNumber(2)
  $core.String get edgeName => $_getSZ(1);
  @$pb.TagNumber(2)
  set edgeName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEdgeName() => $_has(1);
  @$pb.TagNumber(2)
  void clearEdgeName() => clearField(2);
}

