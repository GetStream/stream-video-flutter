// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_stats_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageStatsResponse {
  List<CountByMinuteResponse>? get countOverTime;

  /// Create a copy of MessageStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageStatsResponseCopyWith<MessageStatsResponse> get copyWith =>
      _$MessageStatsResponseCopyWithImpl<MessageStatsResponse>(
        this as MessageStatsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageStatsResponse &&
            const DeepCollectionEquality().equals(
              other.countOverTime,
              countOverTime,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(countOverTime),
  );

  @override
  String toString() {
    return 'MessageStatsResponse(countOverTime: $countOverTime)';
  }
}

/// @nodoc
abstract mixin class $MessageStatsResponseCopyWith<$Res> {
  factory $MessageStatsResponseCopyWith(
    MessageStatsResponse value,
    $Res Function(MessageStatsResponse) _then,
  ) = _$MessageStatsResponseCopyWithImpl;
  @useResult
  $Res call({List<CountByMinuteResponse>? countOverTime});
}

/// @nodoc
class _$MessageStatsResponseCopyWithImpl<$Res>
    implements $MessageStatsResponseCopyWith<$Res> {
  _$MessageStatsResponseCopyWithImpl(this._self, this._then);

  final MessageStatsResponse _self;
  final $Res Function(MessageStatsResponse) _then;

  /// Create a copy of MessageStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? countOverTime = freezed}) {
    return _then(
      MessageStatsResponse(
        countOverTime: freezed == countOverTime
            ? _self.countOverTime
            : countOverTime // ignore: cast_nullable_to_non_nullable
                  as List<CountByMinuteResponse>?,
      ),
    );
  }
}
