// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'broadcast_digest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BroadcastDigest {
  Audience get audience;
  BroadcastInfo get broadcast;
  Coverage get coverage;
  Joins get joins;
  PoorTail get poorTail;
  Quality get quality;
  String get schemaVersion;
  Segments get segments;
  SourceHealth get source;
  ViewerBehavior get viewers;

  /// Create a copy of BroadcastDigest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BroadcastDigestCopyWith<BroadcastDigest> get copyWith =>
      _$BroadcastDigestCopyWithImpl<BroadcastDigest>(
        this as BroadcastDigest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BroadcastDigest &&
            (identical(other.audience, audience) ||
                other.audience == audience) &&
            (identical(other.broadcast, broadcast) ||
                other.broadcast == broadcast) &&
            (identical(other.coverage, coverage) ||
                other.coverage == coverage) &&
            (identical(other.joins, joins) || other.joins == joins) &&
            (identical(other.poorTail, poorTail) ||
                other.poorTail == poorTail) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.schemaVersion, schemaVersion) ||
                other.schemaVersion == schemaVersion) &&
            (identical(other.segments, segments) ||
                other.segments == segments) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.viewers, viewers) || other.viewers == viewers));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    audience,
    broadcast,
    coverage,
    joins,
    poorTail,
    quality,
    schemaVersion,
    segments,
    source,
    viewers,
  );

  @override
  String toString() {
    return 'BroadcastDigest(audience: $audience, broadcast: $broadcast, coverage: $coverage, joins: $joins, poorTail: $poorTail, quality: $quality, schemaVersion: $schemaVersion, segments: $segments, source: $source, viewers: $viewers)';
  }
}

/// @nodoc
abstract mixin class $BroadcastDigestCopyWith<$Res> {
  factory $BroadcastDigestCopyWith(
    BroadcastDigest value,
    $Res Function(BroadcastDigest) _then,
  ) = _$BroadcastDigestCopyWithImpl;
  @useResult
  $Res call({
    Audience audience,
    BroadcastInfo broadcast,
    Coverage coverage,
    Joins joins,
    PoorTail poorTail,
    Quality quality,
    String schemaVersion,
    Segments segments,
    SourceHealth source,
    ViewerBehavior viewers,
  });
}

/// @nodoc
class _$BroadcastDigestCopyWithImpl<$Res>
    implements $BroadcastDigestCopyWith<$Res> {
  _$BroadcastDigestCopyWithImpl(this._self, this._then);

  final BroadcastDigest _self;
  final $Res Function(BroadcastDigest) _then;

  /// Create a copy of BroadcastDigest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audience = null,
    Object? broadcast = null,
    Object? coverage = null,
    Object? joins = null,
    Object? poorTail = null,
    Object? quality = null,
    Object? schemaVersion = null,
    Object? segments = null,
    Object? source = null,
    Object? viewers = null,
  }) {
    return _then(
      BroadcastDigest(
        audience: null == audience
            ? _self.audience
            : audience // ignore: cast_nullable_to_non_nullable
                  as Audience,
        broadcast: null == broadcast
            ? _self.broadcast
            : broadcast // ignore: cast_nullable_to_non_nullable
                  as BroadcastInfo,
        coverage: null == coverage
            ? _self.coverage
            : coverage // ignore: cast_nullable_to_non_nullable
                  as Coverage,
        joins: null == joins
            ? _self.joins
            : joins // ignore: cast_nullable_to_non_nullable
                  as Joins,
        poorTail: null == poorTail
            ? _self.poorTail
            : poorTail // ignore: cast_nullable_to_non_nullable
                  as PoorTail,
        quality: null == quality
            ? _self.quality
            : quality // ignore: cast_nullable_to_non_nullable
                  as Quality,
        schemaVersion: null == schemaVersion
            ? _self.schemaVersion
            : schemaVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        segments: null == segments
            ? _self.segments
            : segments // ignore: cast_nullable_to_non_nullable
                  as Segments,
        source: null == source
            ? _self.source
            : source // ignore: cast_nullable_to_non_nullable
                  as SourceHealth,
        viewers: null == viewers
            ? _self.viewers
            : viewers // ignore: cast_nullable_to_non_nullable
                  as ViewerBehavior,
      ),
    );
  }
}
