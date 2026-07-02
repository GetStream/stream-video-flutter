// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_ingress_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallIngressResponse {
  RTMPIngress get rtmp;
  SRTIngress get srt;
  WHIPIngress get whip;

  /// Create a copy of CallIngressResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallIngressResponseCopyWith<CallIngressResponse> get copyWith =>
      _$CallIngressResponseCopyWithImpl<CallIngressResponse>(
        this as CallIngressResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallIngressResponse &&
            (identical(other.rtmp, rtmp) || other.rtmp == rtmp) &&
            (identical(other.srt, srt) || other.srt == srt) &&
            (identical(other.whip, whip) || other.whip == whip));
  }

  @override
  int get hashCode => Object.hash(runtimeType, rtmp, srt, whip);

  @override
  String toString() {
    return 'CallIngressResponse(rtmp: $rtmp, srt: $srt, whip: $whip)';
  }
}

/// @nodoc
abstract mixin class $CallIngressResponseCopyWith<$Res> {
  factory $CallIngressResponseCopyWith(
    CallIngressResponse value,
    $Res Function(CallIngressResponse) _then,
  ) = _$CallIngressResponseCopyWithImpl;
  @useResult
  $Res call({RTMPIngress rtmp, SRTIngress srt, WHIPIngress whip});
}

/// @nodoc
class _$CallIngressResponseCopyWithImpl<$Res>
    implements $CallIngressResponseCopyWith<$Res> {
  _$CallIngressResponseCopyWithImpl(this._self, this._then);

  final CallIngressResponse _self;
  final $Res Function(CallIngressResponse) _then;

  /// Create a copy of CallIngressResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? rtmp = null, Object? srt = null, Object? whip = null}) {
    return _then(
      CallIngressResponse(
        rtmp: null == rtmp
            ? _self.rtmp
            : rtmp // ignore: cast_nullable_to_non_nullable
                  as RTMPIngress,
        srt: null == srt
            ? _self.srt
            : srt // ignore: cast_nullable_to_non_nullable
                  as SRTIngress,
        whip: null == whip
            ? _self.whip
            : whip // ignore: cast_nullable_to_non_nullable
                  as WHIPIngress,
      ),
    );
  }
}
