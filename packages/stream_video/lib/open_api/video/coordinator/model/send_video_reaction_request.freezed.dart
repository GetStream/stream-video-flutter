// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_video_reaction_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendVideoReactionRequest {
  Map<String, Object?>? get custom;
  String? get emojiCode;
  String get type;

  /// Create a copy of SendVideoReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SendVideoReactionRequestCopyWith<SendVideoReactionRequest> get copyWith =>
      _$SendVideoReactionRequestCopyWithImpl<SendVideoReactionRequest>(
        this as SendVideoReactionRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendVideoReactionRequest &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.emojiCode, emojiCode) ||
                other.emojiCode == emojiCode) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(custom),
    emojiCode,
    type,
  );

  @override
  String toString() {
    return 'SendVideoReactionRequest(custom: $custom, emojiCode: $emojiCode, type: $type)';
  }
}

/// @nodoc
abstract mixin class $SendVideoReactionRequestCopyWith<$Res> {
  factory $SendVideoReactionRequestCopyWith(
    SendVideoReactionRequest value,
    $Res Function(SendVideoReactionRequest) _then,
  ) = _$SendVideoReactionRequestCopyWithImpl;
  @useResult
  $Res call({Map<String, Object?>? custom, String? emojiCode, String type});
}

/// @nodoc
class _$SendVideoReactionRequestCopyWithImpl<$Res>
    implements $SendVideoReactionRequestCopyWith<$Res> {
  _$SendVideoReactionRequestCopyWithImpl(this._self, this._then);

  final SendVideoReactionRequest _self;
  final $Res Function(SendVideoReactionRequest) _then;

  /// Create a copy of SendVideoReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? custom = freezed,
    Object? emojiCode = freezed,
    Object? type = null,
  }) {
    return _then(
      SendVideoReactionRequest(
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        emojiCode: freezed == emojiCode
            ? _self.emojiCode
            : emojiCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
