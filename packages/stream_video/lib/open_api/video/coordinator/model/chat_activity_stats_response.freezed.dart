// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_activity_stats_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatActivityStatsResponse {
  MessageStatsResponse? get messages;

  /// Create a copy of ChatActivityStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatActivityStatsResponseCopyWith<ChatActivityStatsResponse> get copyWith =>
      _$ChatActivityStatsResponseCopyWithImpl<ChatActivityStatsResponse>(
        this as ChatActivityStatsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatActivityStatsResponse &&
            (identical(other.messages, messages) ||
                other.messages == messages));
  }

  @override
  int get hashCode => Object.hash(runtimeType, messages);

  @override
  String toString() {
    return 'ChatActivityStatsResponse(messages: $messages)';
  }
}

/// @nodoc
abstract mixin class $ChatActivityStatsResponseCopyWith<$Res> {
  factory $ChatActivityStatsResponseCopyWith(
    ChatActivityStatsResponse value,
    $Res Function(ChatActivityStatsResponse) _then,
  ) = _$ChatActivityStatsResponseCopyWithImpl;
  @useResult
  $Res call({MessageStatsResponse? messages});
}

/// @nodoc
class _$ChatActivityStatsResponseCopyWithImpl<$Res>
    implements $ChatActivityStatsResponseCopyWith<$Res> {
  _$ChatActivityStatsResponseCopyWithImpl(this._self, this._then);

  final ChatActivityStatsResponse _self;
  final $Res Function(ChatActivityStatsResponse) _then;

  /// Create a copy of ChatActivityStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? messages = freezed}) {
    return _then(
      ChatActivityStatsResponse(
        messages: freezed == messages
            ? _self.messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as MessageStatsResponse?,
      ),
    );
  }
}
