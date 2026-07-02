// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ban_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BanResponse {
  String get duration;

  /// Create a copy of BanResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BanResponseCopyWith<BanResponse> get copyWith =>
      _$BanResponseCopyWithImpl<BanResponse>(this as BanResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BanResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration);

  @override
  String toString() {
    return 'BanResponse(duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $BanResponseCopyWith<$Res> {
  factory $BanResponseCopyWith(
    BanResponse value,
    $Res Function(BanResponse) _then,
  ) = _$BanResponseCopyWithImpl;
  @useResult
  $Res call({String duration});
}

/// @nodoc
class _$BanResponseCopyWithImpl<$Res> implements $BanResponseCopyWith<$Res> {
  _$BanResponseCopyWithImpl(this._self, this._then);

  final BanResponse _self;
  final $Res Function(BanResponse) _then;

  /// Create a copy of BanResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null}) {
    return _then(
      BanResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
