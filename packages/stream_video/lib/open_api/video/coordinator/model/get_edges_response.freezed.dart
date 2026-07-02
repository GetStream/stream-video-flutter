// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_edges_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetEdgesResponse {
  String get duration;
  List<EdgeResponse> get edges;

  /// Create a copy of GetEdgesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetEdgesResponseCopyWith<GetEdgesResponse> get copyWith =>
      _$GetEdgesResponseCopyWithImpl<GetEdgesResponse>(
        this as GetEdgesResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetEdgesResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.edges, edges));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(edges),
  );

  @override
  String toString() {
    return 'GetEdgesResponse(duration: $duration, edges: $edges)';
  }
}

/// @nodoc
abstract mixin class $GetEdgesResponseCopyWith<$Res> {
  factory $GetEdgesResponseCopyWith(
    GetEdgesResponse value,
    $Res Function(GetEdgesResponse) _then,
  ) = _$GetEdgesResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<EdgeResponse> edges});
}

/// @nodoc
class _$GetEdgesResponseCopyWithImpl<$Res>
    implements $GetEdgesResponseCopyWith<$Res> {
  _$GetEdgesResponseCopyWithImpl(this._self, this._then);

  final GetEdgesResponse _self;
  final $Res Function(GetEdgesResponse) _then;

  /// Create a copy of GetEdgesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? edges = null}) {
    return _then(
      GetEdgesResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        edges: null == edges
            ? _self.edges
            : edges // ignore: cast_nullable_to_non_nullable
                  as List<EdgeResponse>,
      ),
    );
  }
}
