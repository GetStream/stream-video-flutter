// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'go_live_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoLiveResponse {
  CallResponse get call;
  String get duration;

  /// Create a copy of GoLiveResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoLiveResponseCopyWith<GoLiveResponse> get copyWith =>
      _$GoLiveResponseCopyWithImpl<GoLiveResponse>(
        this as GoLiveResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoLiveResponse &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, call, duration);

  @override
  String toString() {
    return 'GoLiveResponse(call: $call, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $GoLiveResponseCopyWith<$Res> {
  factory $GoLiveResponseCopyWith(
    GoLiveResponse value,
    $Res Function(GoLiveResponse) _then,
  ) = _$GoLiveResponseCopyWithImpl;
  @useResult
  $Res call({CallResponse call, String duration});
}

/// @nodoc
class _$GoLiveResponseCopyWithImpl<$Res>
    implements $GoLiveResponseCopyWith<$Res> {
  _$GoLiveResponseCopyWithImpl(this._self, this._then);

  final GoLiveResponse _self;
  final $Res Function(GoLiveResponse) _then;

  /// Create a copy of GoLiveResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? call = null, Object? duration = null}) {
    return _then(
      GoLiveResponse(
        call: null == call
            ? _self.call
            : call // ignore: cast_nullable_to_non_nullable
                  as CallResponse,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
