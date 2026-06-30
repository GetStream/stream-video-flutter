// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'closed_caption_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClosedCaptionEvent {
  String get callCid;
  CallClosedCaption get closedCaption;
  DateTime get createdAt;
  String get type;

  /// Create a copy of ClosedCaptionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClosedCaptionEventCopyWith<ClosedCaptionEvent> get copyWith =>
      _$ClosedCaptionEventCopyWithImpl<ClosedCaptionEvent>(
        this as ClosedCaptionEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ClosedCaptionEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.closedCaption, closedCaption) ||
                other.closedCaption == closedCaption) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, callCid, closedCaption, createdAt, type);

  @override
  String toString() {
    return 'ClosedCaptionEvent(callCid: $callCid, closedCaption: $closedCaption, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ClosedCaptionEventCopyWith<$Res> {
  factory $ClosedCaptionEventCopyWith(
    ClosedCaptionEvent value,
    $Res Function(ClosedCaptionEvent) _then,
  ) = _$ClosedCaptionEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    CallClosedCaption closedCaption,
    DateTime createdAt,
    String type,
  });
}

/// @nodoc
class _$ClosedCaptionEventCopyWithImpl<$Res>
    implements $ClosedCaptionEventCopyWith<$Res> {
  _$ClosedCaptionEventCopyWithImpl(this._self, this._then);

  final ClosedCaptionEvent _self;
  final $Res Function(ClosedCaptionEvent) _then;

  /// Create a copy of ClosedCaptionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? closedCaption = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      ClosedCaptionEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        closedCaption: null == closedCaption
            ? _self.closedCaption
            : closedCaption // ignore: cast_nullable_to_non_nullable
                  as CallClosedCaption,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
