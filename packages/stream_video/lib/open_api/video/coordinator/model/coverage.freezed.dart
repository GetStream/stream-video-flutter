// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coverage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Coverage {
  List<AbsentMetric> get absent;
  MetricsPct get metricsPct;
  int get publisherEncodingProfiles;

  /// Create a copy of Coverage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CoverageCopyWith<Coverage> get copyWith =>
      _$CoverageCopyWithImpl<Coverage>(this as Coverage, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Coverage &&
            const DeepCollectionEquality().equals(other.absent, absent) &&
            (identical(other.metricsPct, metricsPct) ||
                other.metricsPct == metricsPct) &&
            (identical(
                  other.publisherEncodingProfiles,
                  publisherEncodingProfiles,
                ) ||
                other.publisherEncodingProfiles == publisherEncodingProfiles));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(absent),
    metricsPct,
    publisherEncodingProfiles,
  );

  @override
  String toString() {
    return 'Coverage(absent: $absent, metricsPct: $metricsPct, publisherEncodingProfiles: $publisherEncodingProfiles)';
  }
}

/// @nodoc
abstract mixin class $CoverageCopyWith<$Res> {
  factory $CoverageCopyWith(Coverage value, $Res Function(Coverage) _then) =
      _$CoverageCopyWithImpl;
  @useResult
  $Res call({
    List<AbsentMetric> absent,
    MetricsPct metricsPct,
    int publisherEncodingProfiles,
  });
}

/// @nodoc
class _$CoverageCopyWithImpl<$Res> implements $CoverageCopyWith<$Res> {
  _$CoverageCopyWithImpl(this._self, this._then);

  final Coverage _self;
  final $Res Function(Coverage) _then;

  /// Create a copy of Coverage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? absent = null,
    Object? metricsPct = null,
    Object? publisherEncodingProfiles = null,
  }) {
    return _then(
      Coverage(
        absent: null == absent
            ? _self.absent
            : absent // ignore: cast_nullable_to_non_nullable
                  as List<AbsentMetric>,
        metricsPct: null == metricsPct
            ? _self.metricsPct
            : metricsPct // ignore: cast_nullable_to_non_nullable
                  as MetricsPct,
        publisherEncodingProfiles: null == publisherEncodingProfiles
            ? _self.publisherEncodingProfiles
            : publisherEncodingProfiles // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
