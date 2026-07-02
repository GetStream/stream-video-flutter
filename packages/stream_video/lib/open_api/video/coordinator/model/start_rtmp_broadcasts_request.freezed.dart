// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'start_rtmp_broadcasts_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StartRTMPBroadcastsRequest {
  List<RTMPBroadcastRequest> get broadcasts;

  /// Create a copy of StartRTMPBroadcastsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StartRTMPBroadcastsRequestCopyWith<StartRTMPBroadcastsRequest>
  get copyWith =>
      _$StartRTMPBroadcastsRequestCopyWithImpl<StartRTMPBroadcastsRequest>(
        this as StartRTMPBroadcastsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StartRTMPBroadcastsRequest &&
            const DeepCollectionEquality().equals(
              other.broadcasts,
              broadcasts,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(broadcasts));

  @override
  String toString() {
    return 'StartRTMPBroadcastsRequest(broadcasts: $broadcasts)';
  }
}

/// @nodoc
abstract mixin class $StartRTMPBroadcastsRequestCopyWith<$Res> {
  factory $StartRTMPBroadcastsRequestCopyWith(
    StartRTMPBroadcastsRequest value,
    $Res Function(StartRTMPBroadcastsRequest) _then,
  ) = _$StartRTMPBroadcastsRequestCopyWithImpl;
  @useResult
  $Res call({List<RTMPBroadcastRequest> broadcasts});
}

/// @nodoc
class _$StartRTMPBroadcastsRequestCopyWithImpl<$Res>
    implements $StartRTMPBroadcastsRequestCopyWith<$Res> {
  _$StartRTMPBroadcastsRequestCopyWithImpl(this._self, this._then);

  final StartRTMPBroadcastsRequest _self;
  final $Res Function(StartRTMPBroadcastsRequest) _then;

  /// Create a copy of StartRTMPBroadcastsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? broadcasts = null}) {
    return _then(
      StartRTMPBroadcastsRequest(
        broadcasts: null == broadcasts
            ? _self.broadcasts
            : broadcasts // ignore: cast_nullable_to_non_nullable
                  as List<RTMPBroadcastRequest>,
      ),
    );
  }
}
