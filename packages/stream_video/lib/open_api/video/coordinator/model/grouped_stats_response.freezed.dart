// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouped_stats_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupedStatsResponse {
  String get name;
  int get unique;

  /// Create a copy of GroupedStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupedStatsResponseCopyWith<GroupedStatsResponse> get copyWith =>
      _$GroupedStatsResponseCopyWithImpl<GroupedStatsResponse>(
        this as GroupedStatsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupedStatsResponse &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.unique, unique) || other.unique == unique));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, unique);

  @override
  String toString() {
    return 'GroupedStatsResponse(name: $name, unique: $unique)';
  }
}

/// @nodoc
abstract mixin class $GroupedStatsResponseCopyWith<$Res> {
  factory $GroupedStatsResponseCopyWith(
    GroupedStatsResponse value,
    $Res Function(GroupedStatsResponse) _then,
  ) = _$GroupedStatsResponseCopyWithImpl;
  @useResult
  $Res call({String name, int unique});
}

/// @nodoc
class _$GroupedStatsResponseCopyWithImpl<$Res>
    implements $GroupedStatsResponseCopyWith<$Res> {
  _$GroupedStatsResponseCopyWithImpl(this._self, this._then);

  final GroupedStatsResponse _self;
  final $Res Function(GroupedStatsResponse) _then;

  /// Create a copy of GroupedStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? unique = null}) {
    return _then(
      GroupedStatsResponse(
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        unique: null == unique
            ? _self.unique
            : unique // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
