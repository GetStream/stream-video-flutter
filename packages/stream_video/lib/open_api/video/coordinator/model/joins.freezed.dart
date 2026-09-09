// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joins.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Joins {
  Map<String, int> get disconnectReasons;
  Map<String, int> get failureStages;
  int? get joinAttempts;
  double? get joinSuccessRate;
  String get reason;

  /// Create a copy of Joins
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $JoinsCopyWith<Joins> get copyWith =>
      _$JoinsCopyWithImpl<Joins>(this as Joins, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Joins &&
            const DeepCollectionEquality().equals(
              other.disconnectReasons,
              disconnectReasons,
            ) &&
            const DeepCollectionEquality().equals(
              other.failureStages,
              failureStages,
            ) &&
            (identical(other.joinAttempts, joinAttempts) ||
                other.joinAttempts == joinAttempts) &&
            (identical(other.joinSuccessRate, joinSuccessRate) ||
                other.joinSuccessRate == joinSuccessRate) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(disconnectReasons),
    const DeepCollectionEquality().hash(failureStages),
    joinAttempts,
    joinSuccessRate,
    reason,
  );

  @override
  String toString() {
    return 'Joins(disconnectReasons: $disconnectReasons, failureStages: $failureStages, joinAttempts: $joinAttempts, joinSuccessRate: $joinSuccessRate, reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $JoinsCopyWith<$Res> {
  factory $JoinsCopyWith(Joins value, $Res Function(Joins) _then) =
      _$JoinsCopyWithImpl;
  @useResult
  $Res call({
    Map<String, int> disconnectReasons,
    Map<String, int> failureStages,
    int? joinAttempts,
    double? joinSuccessRate,
    String reason,
  });
}

/// @nodoc
class _$JoinsCopyWithImpl<$Res> implements $JoinsCopyWith<$Res> {
  _$JoinsCopyWithImpl(this._self, this._then);

  final Joins _self;
  final $Res Function(Joins) _then;

  /// Create a copy of Joins
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? disconnectReasons = null,
    Object? failureStages = null,
    Object? joinAttempts = freezed,
    Object? joinSuccessRate = freezed,
    Object? reason = null,
  }) {
    return _then(
      Joins(
        disconnectReasons: null == disconnectReasons
            ? _self.disconnectReasons
            : disconnectReasons // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        failureStages: null == failureStages
            ? _self.failureStages
            : failureStages // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        joinAttempts: freezed == joinAttempts
            ? _self.joinAttempts
            : joinAttempts // ignore: cast_nullable_to_non_nullable
                  as int?,
        joinSuccessRate: freezed == joinSuccessRate
            ? _self.joinSuccessRate
            : joinSuccessRate // ignore: cast_nullable_to_non_nullable
                  as double?,
        reason: null == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
