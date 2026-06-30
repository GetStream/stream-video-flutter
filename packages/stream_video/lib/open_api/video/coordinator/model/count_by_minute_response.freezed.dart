// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'count_by_minute_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CountByMinuteResponse {
  int get count;
  DateTime get startTs;

  /// Create a copy of CountByMinuteResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CountByMinuteResponseCopyWith<CountByMinuteResponse> get copyWith =>
      _$CountByMinuteResponseCopyWithImpl<CountByMinuteResponse>(
        this as CountByMinuteResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CountByMinuteResponse &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.startTs, startTs) || other.startTs == startTs));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count, startTs);

  @override
  String toString() {
    return 'CountByMinuteResponse(count: $count, startTs: $startTs)';
  }
}

/// @nodoc
abstract mixin class $CountByMinuteResponseCopyWith<$Res> {
  factory $CountByMinuteResponseCopyWith(
    CountByMinuteResponse value,
    $Res Function(CountByMinuteResponse) _then,
  ) = _$CountByMinuteResponseCopyWithImpl;
  @useResult
  $Res call({int count, DateTime startTs});
}

/// @nodoc
class _$CountByMinuteResponseCopyWithImpl<$Res>
    implements $CountByMinuteResponseCopyWith<$Res> {
  _$CountByMinuteResponseCopyWithImpl(this._self, this._then);

  final CountByMinuteResponse _self;
  final $Res Function(CountByMinuteResponse) _then;

  /// Create a copy of CountByMinuteResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? count = null, Object? startTs = null}) {
    return _then(
      CountByMinuteResponse(
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        startTs: null == startTs
            ? _self.startTs
            : startTs // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
