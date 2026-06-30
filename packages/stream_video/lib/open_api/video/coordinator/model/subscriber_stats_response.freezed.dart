// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscriber_stats_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubscriberStatsResponse {
  int get total;
  int get totalSubscribedDurationSeconds;
  int get unique;

  /// Create a copy of SubscriberStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubscriberStatsResponseCopyWith<SubscriberStatsResponse> get copyWith =>
      _$SubscriberStatsResponseCopyWithImpl<SubscriberStatsResponse>(
        this as SubscriberStatsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubscriberStatsResponse &&
            (identical(other.total, total) || other.total == total) &&
            (identical(
                  other.totalSubscribedDurationSeconds,
                  totalSubscribedDurationSeconds,
                ) ||
                other.totalSubscribedDurationSeconds ==
                    totalSubscribedDurationSeconds) &&
            (identical(other.unique, unique) || other.unique == unique));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, total, totalSubscribedDurationSeconds, unique);

  @override
  String toString() {
    return 'SubscriberStatsResponse(total: $total, totalSubscribedDurationSeconds: $totalSubscribedDurationSeconds, unique: $unique)';
  }
}

/// @nodoc
abstract mixin class $SubscriberStatsResponseCopyWith<$Res> {
  factory $SubscriberStatsResponseCopyWith(
    SubscriberStatsResponse value,
    $Res Function(SubscriberStatsResponse) _then,
  ) = _$SubscriberStatsResponseCopyWithImpl;
  @useResult
  $Res call({int total, int totalSubscribedDurationSeconds, int unique});
}

/// @nodoc
class _$SubscriberStatsResponseCopyWithImpl<$Res>
    implements $SubscriberStatsResponseCopyWith<$Res> {
  _$SubscriberStatsResponseCopyWithImpl(this._self, this._then);

  final SubscriberStatsResponse _self;
  final $Res Function(SubscriberStatsResponse) _then;

  /// Create a copy of SubscriberStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? totalSubscribedDurationSeconds = null,
    Object? unique = null,
  }) {
    return _then(
      SubscriberStatsResponse(
        total: null == total
            ? _self.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSubscribedDurationSeconds: null == totalSubscribedDurationSeconds
            ? _self.totalSubscribedDurationSeconds
            : totalSubscribedDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        unique: null == unique
            ? _self.unique
            : unique // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
