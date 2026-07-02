// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'publisher_stats_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublisherStatsResponse {
  List<TrackStatsResponse>? get byTrack;
  int get total;
  int get unique;

  /// Create a copy of PublisherStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PublisherStatsResponseCopyWith<PublisherStatsResponse> get copyWith =>
      _$PublisherStatsResponseCopyWithImpl<PublisherStatsResponse>(
        this as PublisherStatsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PublisherStatsResponse &&
            const DeepCollectionEquality().equals(other.byTrack, byTrack) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.unique, unique) || other.unique == unique));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(byTrack),
    total,
    unique,
  );

  @override
  String toString() {
    return 'PublisherStatsResponse(byTrack: $byTrack, total: $total, unique: $unique)';
  }
}

/// @nodoc
abstract mixin class $PublisherStatsResponseCopyWith<$Res> {
  factory $PublisherStatsResponseCopyWith(
    PublisherStatsResponse value,
    $Res Function(PublisherStatsResponse) _then,
  ) = _$PublisherStatsResponseCopyWithImpl;
  @useResult
  $Res call({List<TrackStatsResponse>? byTrack, int total, int unique});
}

/// @nodoc
class _$PublisherStatsResponseCopyWithImpl<$Res>
    implements $PublisherStatsResponseCopyWith<$Res> {
  _$PublisherStatsResponseCopyWithImpl(this._self, this._then);

  final PublisherStatsResponse _self;
  final $Res Function(PublisherStatsResponse) _then;

  /// Create a copy of PublisherStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? byTrack = freezed,
    Object? total = null,
    Object? unique = null,
  }) {
    return _then(
      PublisherStatsResponse(
        byTrack: freezed == byTrack
            ? _self.byTrack
            : byTrack // ignore: cast_nullable_to_non_nullable
                  as List<TrackStatsResponse>?,
        total: null == total
            ? _self.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        unique: null == unique
            ? _self.unique
            : unique // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
