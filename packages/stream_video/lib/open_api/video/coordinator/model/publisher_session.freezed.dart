// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'publisher_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublisherSession {
  double? get avgJitterMs;
  String? get browser;
  String? get deliveryZone;
  double get durationMin;
  EncodingProfile? get encoding;
  String? get ingest;
  String? get os;
  double? get sendQualityScore;
  double get startedOffsetMin;
  String? get tool;
  String get userId;
  String get userSessionId;

  /// Create a copy of PublisherSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PublisherSessionCopyWith<PublisherSession> get copyWith =>
      _$PublisherSessionCopyWithImpl<PublisherSession>(
        this as PublisherSession,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PublisherSession &&
            (identical(other.avgJitterMs, avgJitterMs) ||
                other.avgJitterMs == avgJitterMs) &&
            (identical(other.browser, browser) || other.browser == browser) &&
            (identical(other.deliveryZone, deliveryZone) ||
                other.deliveryZone == deliveryZone) &&
            (identical(other.durationMin, durationMin) ||
                other.durationMin == durationMin) &&
            (identical(other.encoding, encoding) ||
                other.encoding == encoding) &&
            (identical(other.ingest, ingest) || other.ingest == ingest) &&
            (identical(other.os, os) || other.os == os) &&
            (identical(other.sendQualityScore, sendQualityScore) ||
                other.sendQualityScore == sendQualityScore) &&
            (identical(other.startedOffsetMin, startedOffsetMin) ||
                other.startedOffsetMin == startedOffsetMin) &&
            (identical(other.tool, tool) || other.tool == tool) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userSessionId, userSessionId) ||
                other.userSessionId == userSessionId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    avgJitterMs,
    browser,
    deliveryZone,
    durationMin,
    encoding,
    ingest,
    os,
    sendQualityScore,
    startedOffsetMin,
    tool,
    userId,
    userSessionId,
  );

  @override
  String toString() {
    return 'PublisherSession(avgJitterMs: $avgJitterMs, browser: $browser, deliveryZone: $deliveryZone, durationMin: $durationMin, encoding: $encoding, ingest: $ingest, os: $os, sendQualityScore: $sendQualityScore, startedOffsetMin: $startedOffsetMin, tool: $tool, userId: $userId, userSessionId: $userSessionId)';
  }
}

/// @nodoc
abstract mixin class $PublisherSessionCopyWith<$Res> {
  factory $PublisherSessionCopyWith(
    PublisherSession value,
    $Res Function(PublisherSession) _then,
  ) = _$PublisherSessionCopyWithImpl;
  @useResult
  $Res call({
    double? avgJitterMs,
    String? browser,
    String? deliveryZone,
    double durationMin,
    EncodingProfile? encoding,
    String? ingest,
    String? os,
    double? sendQualityScore,
    double startedOffsetMin,
    String? tool,
    String userId,
    String userSessionId,
  });
}

/// @nodoc
class _$PublisherSessionCopyWithImpl<$Res>
    implements $PublisherSessionCopyWith<$Res> {
  _$PublisherSessionCopyWithImpl(this._self, this._then);

  final PublisherSession _self;
  final $Res Function(PublisherSession) _then;

  /// Create a copy of PublisherSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgJitterMs = freezed,
    Object? browser = freezed,
    Object? deliveryZone = freezed,
    Object? durationMin = null,
    Object? encoding = freezed,
    Object? ingest = freezed,
    Object? os = freezed,
    Object? sendQualityScore = freezed,
    Object? startedOffsetMin = null,
    Object? tool = freezed,
    Object? userId = null,
    Object? userSessionId = null,
  }) {
    return _then(
      PublisherSession(
        avgJitterMs: freezed == avgJitterMs
            ? _self.avgJitterMs
            : avgJitterMs // ignore: cast_nullable_to_non_nullable
                  as double?,
        browser: freezed == browser
            ? _self.browser
            : browser // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryZone: freezed == deliveryZone
            ? _self.deliveryZone
            : deliveryZone // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationMin: null == durationMin
            ? _self.durationMin
            : durationMin // ignore: cast_nullable_to_non_nullable
                  as double,
        encoding: freezed == encoding
            ? _self.encoding
            : encoding // ignore: cast_nullable_to_non_nullable
                  as EncodingProfile?,
        ingest: freezed == ingest
            ? _self.ingest
            : ingest // ignore: cast_nullable_to_non_nullable
                  as String?,
        os: freezed == os
            ? _self.os
            : os // ignore: cast_nullable_to_non_nullable
                  as String?,
        sendQualityScore: freezed == sendQualityScore
            ? _self.sendQualityScore
            : sendQualityScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        startedOffsetMin: null == startedOffsetMin
            ? _self.startedOffsetMin
            : startedOffsetMin // ignore: cast_nullable_to_non_nullable
                  as double,
        tool: freezed == tool
            ? _self.tool
            : tool // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userSessionId: null == userSessionId
            ? _self.userSessionId
            : userSessionId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
