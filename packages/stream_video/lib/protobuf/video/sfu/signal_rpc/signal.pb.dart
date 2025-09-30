// This is a generated file - do not edit.
//
// Generated from video/sfu/signal_rpc/signal.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../models/models.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class StartNoiseCancellationRequest extends $pb.GeneratedMessage {
  factory StartNoiseCancellationRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  StartNoiseCancellationRequest._();

  factory StartNoiseCancellationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartNoiseCancellationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartNoiseCancellationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartNoiseCancellationRequest clone() =>
      StartNoiseCancellationRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartNoiseCancellationRequest copyWith(
          void Function(StartNoiseCancellationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StartNoiseCancellationRequest))
          as StartNoiseCancellationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartNoiseCancellationRequest create() =>
      StartNoiseCancellationRequest._();
  @$core.override
  StartNoiseCancellationRequest createEmptyInstance() => create();
  static $pb.PbList<StartNoiseCancellationRequest> createRepeated() =>
      $pb.PbList<StartNoiseCancellationRequest>();
  @$core.pragma('dart2js:noInline')
  static StartNoiseCancellationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartNoiseCancellationRequest>(create);
  static StartNoiseCancellationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

class StartNoiseCancellationResponse extends $pb.GeneratedMessage {
  factory StartNoiseCancellationResponse({
    $0.Error? error,
  }) {
    final result = create();
    if (error != null) result.error = error;
    return result;
  }

  StartNoiseCancellationResponse._();

  factory StartNoiseCancellationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartNoiseCancellationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartNoiseCancellationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOM<$0.Error>(1, _omitFieldNames ? '' : 'error',
        subBuilder: $0.Error.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartNoiseCancellationResponse clone() =>
      StartNoiseCancellationResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartNoiseCancellationResponse copyWith(
          void Function(StartNoiseCancellationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StartNoiseCancellationResponse))
          as StartNoiseCancellationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartNoiseCancellationResponse create() =>
      StartNoiseCancellationResponse._();
  @$core.override
  StartNoiseCancellationResponse createEmptyInstance() => create();
  static $pb.PbList<StartNoiseCancellationResponse> createRepeated() =>
      $pb.PbList<StartNoiseCancellationResponse>();
  @$core.pragma('dart2js:noInline')
  static StartNoiseCancellationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartNoiseCancellationResponse>(create);
  static StartNoiseCancellationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(1)
  set error($0.Error value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Error ensureError() => $_ensure(0);
}

class StopNoiseCancellationRequest extends $pb.GeneratedMessage {
  factory StopNoiseCancellationRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  StopNoiseCancellationRequest._();

  factory StopNoiseCancellationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopNoiseCancellationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopNoiseCancellationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopNoiseCancellationRequest clone() =>
      StopNoiseCancellationRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopNoiseCancellationRequest copyWith(
          void Function(StopNoiseCancellationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StopNoiseCancellationRequest))
          as StopNoiseCancellationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopNoiseCancellationRequest create() =>
      StopNoiseCancellationRequest._();
  @$core.override
  StopNoiseCancellationRequest createEmptyInstance() => create();
  static $pb.PbList<StopNoiseCancellationRequest> createRepeated() =>
      $pb.PbList<StopNoiseCancellationRequest>();
  @$core.pragma('dart2js:noInline')
  static StopNoiseCancellationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopNoiseCancellationRequest>(create);
  static StopNoiseCancellationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

class StopNoiseCancellationResponse extends $pb.GeneratedMessage {
  factory StopNoiseCancellationResponse({
    $0.Error? error,
  }) {
    final result = create();
    if (error != null) result.error = error;
    return result;
  }

  StopNoiseCancellationResponse._();

  factory StopNoiseCancellationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopNoiseCancellationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopNoiseCancellationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOM<$0.Error>(1, _omitFieldNames ? '' : 'error',
        subBuilder: $0.Error.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopNoiseCancellationResponse clone() =>
      StopNoiseCancellationResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopNoiseCancellationResponse copyWith(
          void Function(StopNoiseCancellationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StopNoiseCancellationResponse))
          as StopNoiseCancellationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopNoiseCancellationResponse create() =>
      StopNoiseCancellationResponse._();
  @$core.override
  StopNoiseCancellationResponse createEmptyInstance() => create();
  static $pb.PbList<StopNoiseCancellationResponse> createRepeated() =>
      $pb.PbList<StopNoiseCancellationResponse>();
  @$core.pragma('dart2js:noInline')
  static StopNoiseCancellationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopNoiseCancellationResponse>(create);
  static StopNoiseCancellationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(1)
  set error($0.Error value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Error ensureError() => $_ensure(0);
}

class Reconnection extends $pb.GeneratedMessage {
  factory Reconnection({
    $core.double? timeSeconds,
    $0.WebsocketReconnectStrategy? strategy,
  }) {
    final result = create();
    if (timeSeconds != null) result.timeSeconds = timeSeconds;
    if (strategy != null) result.strategy = strategy;
    return result;
  }

  Reconnection._();

  factory Reconnection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Reconnection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Reconnection',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..a<$core.double>(
        1, _omitFieldNames ? '' : 'timeSeconds', $pb.PbFieldType.OF)
    ..e<$0.WebsocketReconnectStrategy>(
        2, _omitFieldNames ? '' : 'strategy', $pb.PbFieldType.OE,
        defaultOrMaker: $0.WebsocketReconnectStrategy
            .WEBSOCKET_RECONNECT_STRATEGY_UNSPECIFIED,
        valueOf: $0.WebsocketReconnectStrategy.valueOf,
        enumValues: $0.WebsocketReconnectStrategy.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reconnection clone() => Reconnection()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reconnection copyWith(void Function(Reconnection) updates) =>
      super.copyWith((message) => updates(message as Reconnection))
          as Reconnection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reconnection create() => Reconnection._();
  @$core.override
  Reconnection createEmptyInstance() => create();
  static $pb.PbList<Reconnection> createRepeated() =>
      $pb.PbList<Reconnection>();
  @$core.pragma('dart2js:noInline')
  static Reconnection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Reconnection>(create);
  static Reconnection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get timeSeconds => $_getN(0);
  @$pb.TagNumber(1)
  set timeSeconds($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimeSeconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimeSeconds() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.WebsocketReconnectStrategy get strategy => $_getN(1);
  @$pb.TagNumber(2)
  set strategy($0.WebsocketReconnectStrategy value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStrategy() => $_has(1);
  @$pb.TagNumber(2)
  void clearStrategy() => $_clearField(2);
}

enum Telemetry_Data { connectionTimeSeconds, reconnection, notSet }

class Telemetry extends $pb.GeneratedMessage {
  factory Telemetry({
    $core.double? connectionTimeSeconds,
    Reconnection? reconnection,
  }) {
    final result = create();
    if (connectionTimeSeconds != null)
      result.connectionTimeSeconds = connectionTimeSeconds;
    if (reconnection != null) result.reconnection = reconnection;
    return result;
  }

  Telemetry._();

  factory Telemetry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Telemetry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Telemetry_Data> _Telemetry_DataByTag = {
    1: Telemetry_Data.connectionTimeSeconds,
    2: Telemetry_Data.reconnection,
    0: Telemetry_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Telemetry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..a<$core.double>(
        1, _omitFieldNames ? '' : 'connectionTimeSeconds', $pb.PbFieldType.OF)
    ..aOM<Reconnection>(2, _omitFieldNames ? '' : 'reconnection',
        subBuilder: Reconnection.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Telemetry clone() => Telemetry()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Telemetry copyWith(void Function(Telemetry) updates) =>
      super.copyWith((message) => updates(message as Telemetry)) as Telemetry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Telemetry create() => Telemetry._();
  @$core.override
  Telemetry createEmptyInstance() => create();
  static $pb.PbList<Telemetry> createRepeated() => $pb.PbList<Telemetry>();
  @$core.pragma('dart2js:noInline')
  static Telemetry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Telemetry>(create);
  static Telemetry? _defaultInstance;

  Telemetry_Data whichData() => _Telemetry_DataByTag[$_whichOneof(0)]!;
  void clearData() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.double get connectionTimeSeconds => $_getN(0);
  @$pb.TagNumber(1)
  set connectionTimeSeconds($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConnectionTimeSeconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnectionTimeSeconds() => $_clearField(1);

  @$pb.TagNumber(2)
  Reconnection get reconnection => $_getN(1);
  @$pb.TagNumber(2)
  set reconnection(Reconnection value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReconnection() => $_has(1);
  @$pb.TagNumber(2)
  void clearReconnection() => $_clearField(2);
  @$pb.TagNumber(2)
  Reconnection ensureReconnection() => $_ensure(1);
}

enum SendStatsRequest_DeviceState { android, apple, notSet }

class SendStatsRequest extends $pb.GeneratedMessage {
  factory SendStatsRequest({
    $core.String? sessionId,
    $core.String? subscriberStats,
    $core.String? publisherStats,
    $core.String? webrtcVersion,
    $core.String? sdk,
    $core.String? sdkVersion,
    $0.InputDevices? audioDevices,
    $0.InputDevices? videoDevices,
    $0.AndroidState? android,
    $0.AppleState? apple,
    Telemetry? telemetry,
    $0.RTMPIngress? rtmp,
    @$core.Deprecated('This field is deprecated.')
    $core.String? subscriberRtcStats,
    @$core.Deprecated('This field is deprecated.')
    $core.String? publisherRtcStats,
    $core.String? rtcStats,
    $core.Iterable<$0.PerformanceStats>? encodeStats,
    $core.Iterable<$0.PerformanceStats>? decodeStats,
    $core.String? unifiedSessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (subscriberStats != null) result.subscriberStats = subscriberStats;
    if (publisherStats != null) result.publisherStats = publisherStats;
    if (webrtcVersion != null) result.webrtcVersion = webrtcVersion;
    if (sdk != null) result.sdk = sdk;
    if (sdkVersion != null) result.sdkVersion = sdkVersion;
    if (audioDevices != null) result.audioDevices = audioDevices;
    if (videoDevices != null) result.videoDevices = videoDevices;
    if (android != null) result.android = android;
    if (apple != null) result.apple = apple;
    if (telemetry != null) result.telemetry = telemetry;
    if (rtmp != null) result.rtmp = rtmp;
    if (subscriberRtcStats != null)
      result.subscriberRtcStats = subscriberRtcStats;
    if (publisherRtcStats != null) result.publisherRtcStats = publisherRtcStats;
    if (rtcStats != null) result.rtcStats = rtcStats;
    if (encodeStats != null) result.encodeStats.addAll(encodeStats);
    if (decodeStats != null) result.decodeStats.addAll(decodeStats);
    if (unifiedSessionId != null) result.unifiedSessionId = unifiedSessionId;
    return result;
  }

  SendStatsRequest._();

  factory SendStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SendStatsRequest_DeviceState>
      _SendStatsRequest_DeviceStateByTag = {
    9: SendStatsRequest_DeviceState.android,
    10: SendStatsRequest_DeviceState.apple,
    0: SendStatsRequest_DeviceState.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..oo(0, [9, 10])
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'subscriberStats')
    ..aOS(3, _omitFieldNames ? '' : 'publisherStats')
    ..aOS(4, _omitFieldNames ? '' : 'webrtcVersion')
    ..aOS(5, _omitFieldNames ? '' : 'sdk')
    ..aOS(6, _omitFieldNames ? '' : 'sdkVersion')
    ..aOM<$0.InputDevices>(7, _omitFieldNames ? '' : 'audioDevices',
        subBuilder: $0.InputDevices.create)
    ..aOM<$0.InputDevices>(8, _omitFieldNames ? '' : 'videoDevices',
        subBuilder: $0.InputDevices.create)
    ..aOM<$0.AndroidState>(9, _omitFieldNames ? '' : 'android',
        subBuilder: $0.AndroidState.create)
    ..aOM<$0.AppleState>(10, _omitFieldNames ? '' : 'apple',
        subBuilder: $0.AppleState.create)
    ..aOM<Telemetry>(11, _omitFieldNames ? '' : 'telemetry',
        subBuilder: Telemetry.create)
    ..aOM<$0.RTMPIngress>(12, _omitFieldNames ? '' : 'rtmp',
        subBuilder: $0.RTMPIngress.create)
    ..aOS(13, _omitFieldNames ? '' : 'subscriberRtcStats')
    ..aOS(14, _omitFieldNames ? '' : 'publisherRtcStats')
    ..aOS(15, _omitFieldNames ? '' : 'rtcStats')
    ..pc<$0.PerformanceStats>(
        16, _omitFieldNames ? '' : 'encodeStats', $pb.PbFieldType.PM,
        subBuilder: $0.PerformanceStats.create)
    ..pc<$0.PerformanceStats>(
        17, _omitFieldNames ? '' : 'decodeStats', $pb.PbFieldType.PM,
        subBuilder: $0.PerformanceStats.create)
    ..aOS(18, _omitFieldNames ? '' : 'unifiedSessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendStatsRequest clone() => SendStatsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendStatsRequest copyWith(void Function(SendStatsRequest) updates) =>
      super.copyWith((message) => updates(message as SendStatsRequest))
          as SendStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendStatsRequest create() => SendStatsRequest._();
  @$core.override
  SendStatsRequest createEmptyInstance() => create();
  static $pb.PbList<SendStatsRequest> createRepeated() =>
      $pb.PbList<SendStatsRequest>();
  @$core.pragma('dart2js:noInline')
  static SendStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendStatsRequest>(create);
  static SendStatsRequest? _defaultInstance;

  SendStatsRequest_DeviceState whichDeviceState() =>
      _SendStatsRequest_DeviceStateByTag[$_whichOneof(0)]!;
  void clearDeviceState() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subscriberStats => $_getSZ(1);
  @$pb.TagNumber(2)
  set subscriberStats($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubscriberStats() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubscriberStats() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get publisherStats => $_getSZ(2);
  @$pb.TagNumber(3)
  set publisherStats($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPublisherStats() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublisherStats() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get webrtcVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set webrtcVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWebrtcVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearWebrtcVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sdk => $_getSZ(4);
  @$pb.TagNumber(5)
  set sdk($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSdk() => $_has(4);
  @$pb.TagNumber(5)
  void clearSdk() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sdkVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set sdkVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSdkVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearSdkVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.InputDevices get audioDevices => $_getN(6);
  @$pb.TagNumber(7)
  set audioDevices($0.InputDevices value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAudioDevices() => $_has(6);
  @$pb.TagNumber(7)
  void clearAudioDevices() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.InputDevices ensureAudioDevices() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.InputDevices get videoDevices => $_getN(7);
  @$pb.TagNumber(8)
  set videoDevices($0.InputDevices value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasVideoDevices() => $_has(7);
  @$pb.TagNumber(8)
  void clearVideoDevices() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.InputDevices ensureVideoDevices() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.AndroidState get android => $_getN(8);
  @$pb.TagNumber(9)
  set android($0.AndroidState value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAndroid() => $_has(8);
  @$pb.TagNumber(9)
  void clearAndroid() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.AndroidState ensureAndroid() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.AppleState get apple => $_getN(9);
  @$pb.TagNumber(10)
  set apple($0.AppleState value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasApple() => $_has(9);
  @$pb.TagNumber(10)
  void clearApple() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.AppleState ensureApple() => $_ensure(9);

  @$pb.TagNumber(11)
  Telemetry get telemetry => $_getN(10);
  @$pb.TagNumber(11)
  set telemetry(Telemetry value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasTelemetry() => $_has(10);
  @$pb.TagNumber(11)
  void clearTelemetry() => $_clearField(11);
  @$pb.TagNumber(11)
  Telemetry ensureTelemetry() => $_ensure(10);

  @$pb.TagNumber(12)
  $0.RTMPIngress get rtmp => $_getN(11);
  @$pb.TagNumber(12)
  set rtmp($0.RTMPIngress value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasRtmp() => $_has(11);
  @$pb.TagNumber(12)
  void clearRtmp() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.RTMPIngress ensureRtmp() => $_ensure(11);

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(13)
  $core.String get subscriberRtcStats => $_getSZ(12);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(13)
  set subscriberRtcStats($core.String value) => $_setString(12, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(13)
  $core.bool hasSubscriberRtcStats() => $_has(12);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(13)
  void clearSubscriberRtcStats() => $_clearField(13);

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(14)
  $core.String get publisherRtcStats => $_getSZ(13);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(14)
  set publisherRtcStats($core.String value) => $_setString(13, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(14)
  $core.bool hasPublisherRtcStats() => $_has(13);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(14)
  void clearPublisherRtcStats() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get rtcStats => $_getSZ(14);
  @$pb.TagNumber(15)
  set rtcStats($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasRtcStats() => $_has(14);
  @$pb.TagNumber(15)
  void clearRtcStats() => $_clearField(15);

  /// Encode stats for the publisher
  @$pb.TagNumber(16)
  $pb.PbList<$0.PerformanceStats> get encodeStats => $_getList(15);

  /// Decode stats for the subscriber
  @$pb.TagNumber(17)
  $pb.PbList<$0.PerformanceStats> get decodeStats => $_getList(16);

  /// user_session id can change during reconnects, this helps us to
  /// identify the user across reconnects and should remain consistent until the user explicitly
  /// disconnects, is kicked or the call is ended.
  @$pb.TagNumber(18)
  $core.String get unifiedSessionId => $_getSZ(17);
  @$pb.TagNumber(18)
  set unifiedSessionId($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasUnifiedSessionId() => $_has(17);
  @$pb.TagNumber(18)
  void clearUnifiedSessionId() => $_clearField(18);
}

class SendStatsResponse extends $pb.GeneratedMessage {
  factory SendStatsResponse({
    $0.Error? error,
  }) {
    final result = create();
    if (error != null) result.error = error;
    return result;
  }

  SendStatsResponse._();

  factory SendStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOM<$0.Error>(1, _omitFieldNames ? '' : 'error',
        subBuilder: $0.Error.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendStatsResponse clone() => SendStatsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendStatsResponse copyWith(void Function(SendStatsResponse) updates) =>
      super.copyWith((message) => updates(message as SendStatsResponse))
          as SendStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendStatsResponse create() => SendStatsResponse._();
  @$core.override
  SendStatsResponse createEmptyInstance() => create();
  static $pb.PbList<SendStatsResponse> createRepeated() =>
      $pb.PbList<SendStatsResponse>();
  @$core.pragma('dart2js:noInline')
  static SendStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendStatsResponse>(create);
  static SendStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(1)
  set error($0.Error value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Error ensureError() => $_ensure(0);
}

class ICERestartRequest extends $pb.GeneratedMessage {
  factory ICERestartRequest({
    $core.String? sessionId,
    $0.PeerType? peerType,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (peerType != null) result.peerType = peerType;
    return result;
  }

  ICERestartRequest._();

  factory ICERestartRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ICERestartRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ICERestartRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..e<$0.PeerType>(2, _omitFieldNames ? '' : 'peerType', $pb.PbFieldType.OE,
        defaultOrMaker: $0.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED,
        valueOf: $0.PeerType.valueOf,
        enumValues: $0.PeerType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ICERestartRequest clone() => ICERestartRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ICERestartRequest copyWith(void Function(ICERestartRequest) updates) =>
      super.copyWith((message) => updates(message as ICERestartRequest))
          as ICERestartRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ICERestartRequest create() => ICERestartRequest._();
  @$core.override
  ICERestartRequest createEmptyInstance() => create();
  static $pb.PbList<ICERestartRequest> createRepeated() =>
      $pb.PbList<ICERestartRequest>();
  @$core.pragma('dart2js:noInline')
  static ICERestartRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ICERestartRequest>(create);
  static ICERestartRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.PeerType get peerType => $_getN(1);
  @$pb.TagNumber(2)
  set peerType($0.PeerType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeerType() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeerType() => $_clearField(2);
}

class ICERestartResponse extends $pb.GeneratedMessage {
  factory ICERestartResponse({
    $0.Error? error,
  }) {
    final result = create();
    if (error != null) result.error = error;
    return result;
  }

  ICERestartResponse._();

  factory ICERestartResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ICERestartResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ICERestartResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOM<$0.Error>(1, _omitFieldNames ? '' : 'error',
        subBuilder: $0.Error.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ICERestartResponse clone() => ICERestartResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ICERestartResponse copyWith(void Function(ICERestartResponse) updates) =>
      super.copyWith((message) => updates(message as ICERestartResponse))
          as ICERestartResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ICERestartResponse create() => ICERestartResponse._();
  @$core.override
  ICERestartResponse createEmptyInstance() => create();
  static $pb.PbList<ICERestartResponse> createRepeated() =>
      $pb.PbList<ICERestartResponse>();
  @$core.pragma('dart2js:noInline')
  static ICERestartResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ICERestartResponse>(create);
  static ICERestartResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(1)
  set error($0.Error value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Error ensureError() => $_ensure(0);
}

class UpdateMuteStatesRequest extends $pb.GeneratedMessage {
  factory UpdateMuteStatesRequest({
    $core.String? sessionId,
    $core.Iterable<TrackMuteState>? muteStates,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (muteStates != null) result.muteStates.addAll(muteStates);
    return result;
  }

  UpdateMuteStatesRequest._();

  factory UpdateMuteStatesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateMuteStatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMuteStatesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..pc<TrackMuteState>(
        3, _omitFieldNames ? '' : 'muteStates', $pb.PbFieldType.PM,
        subBuilder: TrackMuteState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMuteStatesRequest clone() =>
      UpdateMuteStatesRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMuteStatesRequest copyWith(
          void Function(UpdateMuteStatesRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateMuteStatesRequest))
          as UpdateMuteStatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateMuteStatesRequest create() => UpdateMuteStatesRequest._();
  @$core.override
  UpdateMuteStatesRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateMuteStatesRequest> createRepeated() =>
      $pb.PbList<UpdateMuteStatesRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateMuteStatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMuteStatesRequest>(create);
  static UpdateMuteStatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(3)
  $pb.PbList<TrackMuteState> get muteStates => $_getList(1);
}

class UpdateMuteStatesResponse extends $pb.GeneratedMessage {
  factory UpdateMuteStatesResponse({
    $0.Error? error,
  }) {
    final result = create();
    if (error != null) result.error = error;
    return result;
  }

  UpdateMuteStatesResponse._();

  factory UpdateMuteStatesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateMuteStatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMuteStatesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOM<$0.Error>(4, _omitFieldNames ? '' : 'error',
        subBuilder: $0.Error.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMuteStatesResponse clone() =>
      UpdateMuteStatesResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMuteStatesResponse copyWith(
          void Function(UpdateMuteStatesResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateMuteStatesResponse))
          as UpdateMuteStatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateMuteStatesResponse create() => UpdateMuteStatesResponse._();
  @$core.override
  UpdateMuteStatesResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateMuteStatesResponse> createRepeated() =>
      $pb.PbList<UpdateMuteStatesResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateMuteStatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMuteStatesResponse>(create);
  static UpdateMuteStatesResponse? _defaultInstance;

  @$pb.TagNumber(4)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(4)
  set error($0.Error value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(4)
  void clearError() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Error ensureError() => $_ensure(0);
}

class TrackMuteState extends $pb.GeneratedMessage {
  factory TrackMuteState({
    $0.TrackType? trackType,
    $core.bool? muted,
  }) {
    final result = create();
    if (trackType != null) result.trackType = trackType;
    if (muted != null) result.muted = muted;
    return result;
  }

  TrackMuteState._();

  factory TrackMuteState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrackMuteState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrackMuteState',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..e<$0.TrackType>(1, _omitFieldNames ? '' : 'trackType', $pb.PbFieldType.OE,
        defaultOrMaker: $0.TrackType.TRACK_TYPE_UNSPECIFIED,
        valueOf: $0.TrackType.valueOf,
        enumValues: $0.TrackType.values)
    ..aOB(2, _omitFieldNames ? '' : 'muted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackMuteState clone() => TrackMuteState()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackMuteState copyWith(void Function(TrackMuteState) updates) =>
      super.copyWith((message) => updates(message as TrackMuteState))
          as TrackMuteState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrackMuteState create() => TrackMuteState._();
  @$core.override
  TrackMuteState createEmptyInstance() => create();
  static $pb.PbList<TrackMuteState> createRepeated() =>
      $pb.PbList<TrackMuteState>();
  @$core.pragma('dart2js:noInline')
  static TrackMuteState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrackMuteState>(create);
  static TrackMuteState? _defaultInstance;

  @$pb.TagNumber(1)
  $0.TrackType get trackType => $_getN(0);
  @$pb.TagNumber(1)
  set trackType($0.TrackType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrackType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get muted => $_getBF(1);
  @$pb.TagNumber(2)
  set muted($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMuted() => $_has(1);
  @$pb.TagNumber(2)
  void clearMuted() => $_clearField(2);
}

class AudioMuteChanged extends $pb.GeneratedMessage {
  factory AudioMuteChanged({
    $core.bool? muted,
  }) {
    final result = create();
    if (muted != null) result.muted = muted;
    return result;
  }

  AudioMuteChanged._();

  factory AudioMuteChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AudioMuteChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AudioMuteChanged',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'muted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioMuteChanged clone() => AudioMuteChanged()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioMuteChanged copyWith(void Function(AudioMuteChanged) updates) =>
      super.copyWith((message) => updates(message as AudioMuteChanged))
          as AudioMuteChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AudioMuteChanged create() => AudioMuteChanged._();
  @$core.override
  AudioMuteChanged createEmptyInstance() => create();
  static $pb.PbList<AudioMuteChanged> createRepeated() =>
      $pb.PbList<AudioMuteChanged>();
  @$core.pragma('dart2js:noInline')
  static AudioMuteChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AudioMuteChanged>(create);
  static AudioMuteChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get muted => $_getBF(0);
  @$pb.TagNumber(1)
  set muted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMuted() => $_has(0);
  @$pb.TagNumber(1)
  void clearMuted() => $_clearField(1);
}

class VideoMuteChanged extends $pb.GeneratedMessage {
  factory VideoMuteChanged({
    $core.bool? muted,
  }) {
    final result = create();
    if (muted != null) result.muted = muted;
    return result;
  }

  VideoMuteChanged._();

  factory VideoMuteChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VideoMuteChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoMuteChanged',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOB(2, _omitFieldNames ? '' : 'muted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoMuteChanged clone() => VideoMuteChanged()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoMuteChanged copyWith(void Function(VideoMuteChanged) updates) =>
      super.copyWith((message) => updates(message as VideoMuteChanged))
          as VideoMuteChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoMuteChanged create() => VideoMuteChanged._();
  @$core.override
  VideoMuteChanged createEmptyInstance() => create();
  static $pb.PbList<VideoMuteChanged> createRepeated() =>
      $pb.PbList<VideoMuteChanged>();
  @$core.pragma('dart2js:noInline')
  static VideoMuteChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoMuteChanged>(create);
  static VideoMuteChanged? _defaultInstance;

  @$pb.TagNumber(2)
  $core.bool get muted => $_getBF(0);
  @$pb.TagNumber(2)
  set muted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(2)
  $core.bool hasMuted() => $_has(0);
  @$pb.TagNumber(2)
  void clearMuted() => $_clearField(2);
}

class UpdateSubscriptionsRequest extends $pb.GeneratedMessage {
  factory UpdateSubscriptionsRequest({
    $core.String? sessionId,
    $core.Iterable<TrackSubscriptionDetails>? tracks,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (tracks != null) result.tracks.addAll(tracks);
    return result;
  }

  UpdateSubscriptionsRequest._();

  factory UpdateSubscriptionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSubscriptionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSubscriptionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..pc<TrackSubscriptionDetails>(
        3, _omitFieldNames ? '' : 'tracks', $pb.PbFieldType.PM,
        subBuilder: TrackSubscriptionDetails.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSubscriptionsRequest clone() =>
      UpdateSubscriptionsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSubscriptionsRequest copyWith(
          void Function(UpdateSubscriptionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateSubscriptionsRequest))
          as UpdateSubscriptionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSubscriptionsRequest create() => UpdateSubscriptionsRequest._();
  @$core.override
  UpdateSubscriptionsRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateSubscriptionsRequest> createRepeated() =>
      $pb.PbList<UpdateSubscriptionsRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateSubscriptionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSubscriptionsRequest>(create);
  static UpdateSubscriptionsRequest? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<TrackSubscriptionDetails> get tracks => $_getList(1);
}

class UpdateSubscriptionsResponse extends $pb.GeneratedMessage {
  factory UpdateSubscriptionsResponse({
    $0.Error? error,
  }) {
    final result = create();
    if (error != null) result.error = error;
    return result;
  }

  UpdateSubscriptionsResponse._();

  factory UpdateSubscriptionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSubscriptionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSubscriptionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOM<$0.Error>(4, _omitFieldNames ? '' : 'error',
        subBuilder: $0.Error.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSubscriptionsResponse clone() =>
      UpdateSubscriptionsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSubscriptionsResponse copyWith(
          void Function(UpdateSubscriptionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateSubscriptionsResponse))
          as UpdateSubscriptionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSubscriptionsResponse create() =>
      UpdateSubscriptionsResponse._();
  @$core.override
  UpdateSubscriptionsResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateSubscriptionsResponse> createRepeated() =>
      $pb.PbList<UpdateSubscriptionsResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateSubscriptionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSubscriptionsResponse>(create);
  static UpdateSubscriptionsResponse? _defaultInstance;

  @$pb.TagNumber(4)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(4)
  set error($0.Error value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(4)
  void clearError() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Error ensureError() => $_ensure(0);
}

class TrackSubscriptionDetails extends $pb.GeneratedMessage {
  factory TrackSubscriptionDetails({
    $core.String? userId,
    $core.String? sessionId,
    $0.TrackType? trackType,
    $0.VideoDimension? dimension,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (sessionId != null) result.sessionId = sessionId;
    if (trackType != null) result.trackType = trackType;
    if (dimension != null) result.dimension = dimension;
    return result;
  }

  TrackSubscriptionDetails._();

  factory TrackSubscriptionDetails.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrackSubscriptionDetails.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrackSubscriptionDetails',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..e<$0.TrackType>(3, _omitFieldNames ? '' : 'trackType', $pb.PbFieldType.OE,
        defaultOrMaker: $0.TrackType.TRACK_TYPE_UNSPECIFIED,
        valueOf: $0.TrackType.valueOf,
        enumValues: $0.TrackType.values)
    ..aOM<$0.VideoDimension>(4, _omitFieldNames ? '' : 'dimension',
        subBuilder: $0.VideoDimension.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackSubscriptionDetails clone() =>
      TrackSubscriptionDetails()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackSubscriptionDetails copyWith(
          void Function(TrackSubscriptionDetails) updates) =>
      super.copyWith((message) => updates(message as TrackSubscriptionDetails))
          as TrackSubscriptionDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrackSubscriptionDetails create() => TrackSubscriptionDetails._();
  @$core.override
  TrackSubscriptionDetails createEmptyInstance() => create();
  static $pb.PbList<TrackSubscriptionDetails> createRepeated() =>
      $pb.PbList<TrackSubscriptionDetails>();
  @$core.pragma('dart2js:noInline')
  static TrackSubscriptionDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrackSubscriptionDetails>(create);
  static TrackSubscriptionDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.TrackType get trackType => $_getN(2);
  @$pb.TagNumber(3)
  set trackType($0.TrackType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTrackType() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrackType() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.VideoDimension get dimension => $_getN(3);
  @$pb.TagNumber(4)
  set dimension($0.VideoDimension value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDimension() => $_has(3);
  @$pb.TagNumber(4)
  void clearDimension() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.VideoDimension ensureDimension() => $_ensure(3);
}

class SendAnswerRequest extends $pb.GeneratedMessage {
  factory SendAnswerRequest({
    $0.PeerType? peerType,
    $core.String? sdp,
    $core.String? sessionId,
  }) {
    final result = create();
    if (peerType != null) result.peerType = peerType;
    if (sdp != null) result.sdp = sdp;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  SendAnswerRequest._();

  factory SendAnswerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendAnswerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendAnswerRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..e<$0.PeerType>(1, _omitFieldNames ? '' : 'peerType', $pb.PbFieldType.OE,
        defaultOrMaker: $0.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED,
        valueOf: $0.PeerType.valueOf,
        enumValues: $0.PeerType.values)
    ..aOS(2, _omitFieldNames ? '' : 'sdp')
    ..aOS(3, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendAnswerRequest clone() => SendAnswerRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendAnswerRequest copyWith(void Function(SendAnswerRequest) updates) =>
      super.copyWith((message) => updates(message as SendAnswerRequest))
          as SendAnswerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendAnswerRequest create() => SendAnswerRequest._();
  @$core.override
  SendAnswerRequest createEmptyInstance() => create();
  static $pb.PbList<SendAnswerRequest> createRepeated() =>
      $pb.PbList<SendAnswerRequest>();
  @$core.pragma('dart2js:noInline')
  static SendAnswerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendAnswerRequest>(create);
  static SendAnswerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.PeerType get peerType => $_getN(0);
  @$pb.TagNumber(1)
  set peerType($0.PeerType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sdp => $_getSZ(1);
  @$pb.TagNumber(2)
  set sdp($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSdp() => $_has(1);
  @$pb.TagNumber(2)
  void clearSdp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sessionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sessionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionId() => $_clearField(3);
}

class SendAnswerResponse extends $pb.GeneratedMessage {
  factory SendAnswerResponse({
    $0.Error? error,
  }) {
    final result = create();
    if (error != null) result.error = error;
    return result;
  }

  SendAnswerResponse._();

  factory SendAnswerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendAnswerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendAnswerResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOM<$0.Error>(4, _omitFieldNames ? '' : 'error',
        subBuilder: $0.Error.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendAnswerResponse clone() => SendAnswerResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendAnswerResponse copyWith(void Function(SendAnswerResponse) updates) =>
      super.copyWith((message) => updates(message as SendAnswerResponse))
          as SendAnswerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendAnswerResponse create() => SendAnswerResponse._();
  @$core.override
  SendAnswerResponse createEmptyInstance() => create();
  static $pb.PbList<SendAnswerResponse> createRepeated() =>
      $pb.PbList<SendAnswerResponse>();
  @$core.pragma('dart2js:noInline')
  static SendAnswerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendAnswerResponse>(create);
  static SendAnswerResponse? _defaultInstance;

  @$pb.TagNumber(4)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(4)
  set error($0.Error value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(4)
  void clearError() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Error ensureError() => $_ensure(0);
}

class ICETrickleResponse extends $pb.GeneratedMessage {
  factory ICETrickleResponse({
    $0.Error? error,
  }) {
    final result = create();
    if (error != null) result.error = error;
    return result;
  }

  ICETrickleResponse._();

  factory ICETrickleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ICETrickleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ICETrickleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOM<$0.Error>(4, _omitFieldNames ? '' : 'error',
        subBuilder: $0.Error.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ICETrickleResponse clone() => ICETrickleResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ICETrickleResponse copyWith(void Function(ICETrickleResponse) updates) =>
      super.copyWith((message) => updates(message as ICETrickleResponse))
          as ICETrickleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ICETrickleResponse create() => ICETrickleResponse._();
  @$core.override
  ICETrickleResponse createEmptyInstance() => create();
  static $pb.PbList<ICETrickleResponse> createRepeated() =>
      $pb.PbList<ICETrickleResponse>();
  @$core.pragma('dart2js:noInline')
  static ICETrickleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ICETrickleResponse>(create);
  static ICETrickleResponse? _defaultInstance;

  @$pb.TagNumber(4)
  $0.Error get error => $_getN(0);
  @$pb.TagNumber(4)
  set error($0.Error value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(4)
  void clearError() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Error ensureError() => $_ensure(0);
}

class SetPublisherRequest extends $pb.GeneratedMessage {
  factory SetPublisherRequest({
    $core.String? sdp,
    $core.String? sessionId,
    $core.Iterable<$0.TrackInfo>? tracks,
  }) {
    final result = create();
    if (sdp != null) result.sdp = sdp;
    if (sessionId != null) result.sessionId = sessionId;
    if (tracks != null) result.tracks.addAll(tracks);
    return result;
  }

  SetPublisherRequest._();

  factory SetPublisherRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetPublisherRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetPublisherRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sdp')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..pc<$0.TrackInfo>(3, _omitFieldNames ? '' : 'tracks', $pb.PbFieldType.PM,
        subBuilder: $0.TrackInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPublisherRequest clone() => SetPublisherRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPublisherRequest copyWith(void Function(SetPublisherRequest) updates) =>
      super.copyWith((message) => updates(message as SetPublisherRequest))
          as SetPublisherRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetPublisherRequest create() => SetPublisherRequest._();
  @$core.override
  SetPublisherRequest createEmptyInstance() => create();
  static $pb.PbList<SetPublisherRequest> createRepeated() =>
      $pb.PbList<SetPublisherRequest>();
  @$core.pragma('dart2js:noInline')
  static SetPublisherRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetPublisherRequest>(create);
  static SetPublisherRequest? _defaultInstance;

  /// sdp offer
  @$pb.TagNumber(1)
  $core.String get sdp => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdp($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSdp() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$0.TrackInfo> get tracks => $_getList(2);
}

class SetPublisherResponse extends $pb.GeneratedMessage {
  factory SetPublisherResponse({
    $core.String? sdp,
    $core.String? sessionId,
    $core.bool? iceRestart,
    $0.Error? error,
  }) {
    final result = create();
    if (sdp != null) result.sdp = sdp;
    if (sessionId != null) result.sessionId = sessionId;
    if (iceRestart != null) result.iceRestart = iceRestart;
    if (error != null) result.error = error;
    return result;
  }

  SetPublisherResponse._();

  factory SetPublisherResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetPublisherResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetPublisherResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'stream.video.sfu.signal'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sdp')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOB(3, _omitFieldNames ? '' : 'iceRestart')
    ..aOM<$0.Error>(4, _omitFieldNames ? '' : 'error',
        subBuilder: $0.Error.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPublisherResponse clone() =>
      SetPublisherResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPublisherResponse copyWith(void Function(SetPublisherResponse) updates) =>
      super.copyWith((message) => updates(message as SetPublisherResponse))
          as SetPublisherResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetPublisherResponse create() => SetPublisherResponse._();
  @$core.override
  SetPublisherResponse createEmptyInstance() => create();
  static $pb.PbList<SetPublisherResponse> createRepeated() =>
      $pb.PbList<SetPublisherResponse>();
  @$core.pragma('dart2js:noInline')
  static SetPublisherResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetPublisherResponse>(create);
  static SetPublisherResponse? _defaultInstance;

  /// sdp answer
  @$pb.TagNumber(1)
  $core.String get sdp => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdp($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSdp() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get iceRestart => $_getBF(2);
  @$pb.TagNumber(3)
  set iceRestart($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIceRestart() => $_has(2);
  @$pb.TagNumber(3)
  void clearIceRestart() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Error get error => $_getN(3);
  @$pb.TagNumber(4)
  set error($0.Error value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(3);
  @$pb.TagNumber(4)
  void clearError() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Error ensureError() => $_ensure(3);
}

class SignalServerApi {
  final $pb.RpcClient _client;

  SignalServerApi(this._client);

  /// SetPublisher sends the WebRTC offer for the peer connection used to publish A/V
  $async.Future<SetPublisherResponse> setPublisher(
          $pb.ClientContext? ctx, SetPublisherRequest request) =>
      _client.invoke<SetPublisherResponse>(
          ctx, 'SignalServer', 'SetPublisher', request, SetPublisherResponse());

  /// answer is sent by the client to the SFU after receiving a subscriber_offer.
  $async.Future<SendAnswerResponse> sendAnswer(
          $pb.ClientContext? ctx, SendAnswerRequest request) =>
      _client.invoke<SendAnswerResponse>(
          ctx, 'SignalServer', 'SendAnswer', request, SendAnswerResponse());

  /// SendICECandidate sends an ICE candidate to the client
  $async.Future<ICETrickleResponse> iceTrickle(
          $pb.ClientContext? ctx, $0.ICETrickle request) =>
      _client.invoke<ICETrickleResponse>(
          ctx, 'SignalServer', 'IceTrickle', request, ICETrickleResponse());

  /// UpdateSubscribers is used to notify the SFU about the list of video subscriptions
  /// TODO: sync subscriptions based on this + update tracks using the dimension info sent by the user
  $async.Future<UpdateSubscriptionsResponse> updateSubscriptions(
          $pb.ClientContext? ctx, UpdateSubscriptionsRequest request) =>
      _client.invoke<UpdateSubscriptionsResponse>(ctx, 'SignalServer',
          'UpdateSubscriptions', request, UpdateSubscriptionsResponse());
  $async.Future<UpdateMuteStatesResponse> updateMuteStates(
          $pb.ClientContext? ctx, UpdateMuteStatesRequest request) =>
      _client.invoke<UpdateMuteStatesResponse>(ctx, 'SignalServer',
          'UpdateMuteStates', request, UpdateMuteStatesResponse());
  $async.Future<ICERestartResponse> iceRestart(
          $pb.ClientContext? ctx, ICERestartRequest request) =>
      _client.invoke<ICERestartResponse>(
          ctx, 'SignalServer', 'IceRestart', request, ICERestartResponse());
  $async.Future<SendStatsResponse> sendStats(
          $pb.ClientContext? ctx, SendStatsRequest request) =>
      _client.invoke<SendStatsResponse>(
          ctx, 'SignalServer', 'SendStats', request, SendStatsResponse());
  $async.Future<StartNoiseCancellationResponse> startNoiseCancellation(
          $pb.ClientContext? ctx, StartNoiseCancellationRequest request) =>
      _client.invoke<StartNoiseCancellationResponse>(ctx, 'SignalServer',
          'StartNoiseCancellation', request, StartNoiseCancellationResponse());
  $async.Future<StopNoiseCancellationResponse> stopNoiseCancellation(
          $pb.ClientContext? ctx, StopNoiseCancellationRequest request) =>
      _client.invoke<StopNoiseCancellationResponse>(ctx, 'SignalServer',
          'StopNoiseCancellation', request, StopNoiseCancellationResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
