// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_series_subscription_track_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantSeriesSubscriptionTrackMetrics {
  String? get publisherName;
  String get publisherUserId;
  String? get publisherUserSessionId;
  Map<String, List<ParticipantSeriesTrackMetrics>>? get tracks;

  /// Create a copy of ParticipantSeriesSubscriptionTrackMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantSeriesSubscriptionTrackMetricsCopyWith<
    ParticipantSeriesSubscriptionTrackMetrics
  >
  get copyWith =>
      _$ParticipantSeriesSubscriptionTrackMetricsCopyWithImpl<
        ParticipantSeriesSubscriptionTrackMetrics
      >(this as ParticipantSeriesSubscriptionTrackMetrics, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantSeriesSubscriptionTrackMetrics &&
            (identical(other.publisherName, publisherName) ||
                other.publisherName == publisherName) &&
            (identical(other.publisherUserId, publisherUserId) ||
                other.publisherUserId == publisherUserId) &&
            (identical(other.publisherUserSessionId, publisherUserSessionId) ||
                other.publisherUserSessionId == publisherUserSessionId) &&
            const DeepCollectionEquality().equals(other.tracks, tracks));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    publisherName,
    publisherUserId,
    publisherUserSessionId,
    const DeepCollectionEquality().hash(tracks),
  );

  @override
  String toString() {
    return 'ParticipantSeriesSubscriptionTrackMetrics(publisherName: $publisherName, publisherUserId: $publisherUserId, publisherUserSessionId: $publisherUserSessionId, tracks: $tracks)';
  }
}

/// @nodoc
abstract mixin class $ParticipantSeriesSubscriptionTrackMetricsCopyWith<$Res> {
  factory $ParticipantSeriesSubscriptionTrackMetricsCopyWith(
    ParticipantSeriesSubscriptionTrackMetrics value,
    $Res Function(ParticipantSeriesSubscriptionTrackMetrics) _then,
  ) = _$ParticipantSeriesSubscriptionTrackMetricsCopyWithImpl;
  @useResult
  $Res call({
    String? publisherName,
    String publisherUserId,
    String? publisherUserSessionId,
    Map<String, List<ParticipantSeriesTrackMetrics>>? tracks,
  });
}

/// @nodoc
class _$ParticipantSeriesSubscriptionTrackMetricsCopyWithImpl<$Res>
    implements $ParticipantSeriesSubscriptionTrackMetricsCopyWith<$Res> {
  _$ParticipantSeriesSubscriptionTrackMetricsCopyWithImpl(
    this._self,
    this._then,
  );

  final ParticipantSeriesSubscriptionTrackMetrics _self;
  final $Res Function(ParticipantSeriesSubscriptionTrackMetrics) _then;

  /// Create a copy of ParticipantSeriesSubscriptionTrackMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publisherName = freezed,
    Object? publisherUserId = null,
    Object? publisherUserSessionId = freezed,
    Object? tracks = freezed,
  }) {
    return _then(
      ParticipantSeriesSubscriptionTrackMetrics(
        publisherName: freezed == publisherName
            ? _self.publisherName
            : publisherName // ignore: cast_nullable_to_non_nullable
                  as String?,
        publisherUserId: null == publisherUserId
            ? _self.publisherUserId
            : publisherUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        publisherUserSessionId: freezed == publisherUserSessionId
            ? _self.publisherUserSessionId
            : publisherUserSessionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        tracks: freezed == tracks
            ? _self.tracks
            : tracks // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<ParticipantSeriesTrackMetrics>>?,
      ),
    );
  }
}
