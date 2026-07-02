// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_call_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteCallRequest {
  bool? get hard;

  /// Create a copy of DeleteCallRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteCallRequestCopyWith<DeleteCallRequest> get copyWith =>
      _$DeleteCallRequestCopyWithImpl<DeleteCallRequest>(
        this as DeleteCallRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteCallRequest &&
            (identical(other.hard, hard) || other.hard == hard));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hard);

  @override
  String toString() {
    return 'DeleteCallRequest(hard: $hard)';
  }
}

/// @nodoc
abstract mixin class $DeleteCallRequestCopyWith<$Res> {
  factory $DeleteCallRequestCopyWith(
    DeleteCallRequest value,
    $Res Function(DeleteCallRequest) _then,
  ) = _$DeleteCallRequestCopyWithImpl;
  @useResult
  $Res call({bool? hard});
}

/// @nodoc
class _$DeleteCallRequestCopyWithImpl<$Res>
    implements $DeleteCallRequestCopyWith<$Res> {
  _$DeleteCallRequestCopyWithImpl(this._self, this._then);

  final DeleteCallRequest _self;
  final $Res Function(DeleteCallRequest) _then;

  /// Create a copy of DeleteCallRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? hard = freezed}) {
    return _then(
      DeleteCallRequest(
        hard: freezed == hard
            ? _self.hard
            : hard // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
