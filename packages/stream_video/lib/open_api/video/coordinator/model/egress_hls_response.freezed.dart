// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'egress_hls_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EgressHLSResponse {
  String get playlistUrl;
  String get status;

  /// Create a copy of EgressHLSResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EgressHLSResponseCopyWith<EgressHLSResponse> get copyWith =>
      _$EgressHLSResponseCopyWithImpl<EgressHLSResponse>(
        this as EgressHLSResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EgressHLSResponse &&
            (identical(other.playlistUrl, playlistUrl) ||
                other.playlistUrl == playlistUrl) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playlistUrl, status);

  @override
  String toString() {
    return 'EgressHLSResponse(playlistUrl: $playlistUrl, status: $status)';
  }
}

/// @nodoc
abstract mixin class $EgressHLSResponseCopyWith<$Res> {
  factory $EgressHLSResponseCopyWith(
    EgressHLSResponse value,
    $Res Function(EgressHLSResponse) _then,
  ) = _$EgressHLSResponseCopyWithImpl;
  @useResult
  $Res call({String playlistUrl, String status});
}

/// @nodoc
class _$EgressHLSResponseCopyWithImpl<$Res>
    implements $EgressHLSResponseCopyWith<$Res> {
  _$EgressHLSResponseCopyWithImpl(this._self, this._then);

  final EgressHLSResponse _self;
  final $Res Function(EgressHLSResponse) _then;

  /// Create a copy of EgressHLSResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playlistUrl = null, Object? status = null}) {
    return _then(
      EgressHLSResponse(
        playlistUrl: null == playlistUrl
            ? _self.playlistUrl
            : playlistUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
