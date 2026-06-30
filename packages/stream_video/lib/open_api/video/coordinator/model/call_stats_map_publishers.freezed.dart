// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_map_publishers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallStatsMapPublishers {
  List<CallStatsMapPublisher> get publishers;

  /// Create a copy of CallStatsMapPublishers
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallStatsMapPublishersCopyWith<CallStatsMapPublishers> get copyWith =>
      _$CallStatsMapPublishersCopyWithImpl<CallStatsMapPublishers>(
        this as CallStatsMapPublishers,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallStatsMapPublishers &&
            const DeepCollectionEquality().equals(
              other.publishers,
              publishers,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(publishers));

  @override
  String toString() {
    return 'CallStatsMapPublishers(publishers: $publishers)';
  }
}

/// @nodoc
abstract mixin class $CallStatsMapPublishersCopyWith<$Res> {
  factory $CallStatsMapPublishersCopyWith(
    CallStatsMapPublishers value,
    $Res Function(CallStatsMapPublishers) _then,
  ) = _$CallStatsMapPublishersCopyWithImpl;
  @useResult
  $Res call({List<CallStatsMapPublisher> publishers});
}

/// @nodoc
class _$CallStatsMapPublishersCopyWithImpl<$Res>
    implements $CallStatsMapPublishersCopyWith<$Res> {
  _$CallStatsMapPublishersCopyWithImpl(this._self, this._then);

  final CallStatsMapPublishers _self;
  final $Res Function(CallStatsMapPublishers) _then;

  /// Create a copy of CallStatsMapPublishers
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? publishers = null}) {
    return _then(
      CallStatsMapPublishers(
        publishers: null == publishers
            ? _self.publishers
            : publishers // ignore: cast_nullable_to_non_nullable
                  as List<CallStatsMapPublisher>,
      ),
    );
  }
}
