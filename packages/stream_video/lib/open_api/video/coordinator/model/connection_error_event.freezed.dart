// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_error_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConnectionErrorEvent {
  String get connectionId;
  DateTime get createdAt;
  String get type;

  /// Create a copy of ConnectionErrorEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConnectionErrorEventCopyWith<ConnectionErrorEvent> get copyWith =>
      _$ConnectionErrorEventCopyWithImpl<ConnectionErrorEvent>(
        this as ConnectionErrorEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConnectionErrorEvent &&
            (identical(other.connectionId, connectionId) ||
                other.connectionId == connectionId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, connectionId, createdAt, type);

  @override
  String toString() {
    return 'ConnectionErrorEvent(connectionId: $connectionId, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ConnectionErrorEventCopyWith<$Res> {
  factory $ConnectionErrorEventCopyWith(
    ConnectionErrorEvent value,
    $Res Function(ConnectionErrorEvent) _then,
  ) = _$ConnectionErrorEventCopyWithImpl;
  @useResult
  $Res call({String connectionId, DateTime createdAt, String type});
}

/// @nodoc
class _$ConnectionErrorEventCopyWithImpl<$Res>
    implements $ConnectionErrorEventCopyWith<$Res> {
  _$ConnectionErrorEventCopyWithImpl(this._self, this._then);

  final ConnectionErrorEvent _self;
  final $Res Function(ConnectionErrorEvent) _then;

  /// Create a copy of ConnectionErrorEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionId = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      ConnectionErrorEvent(
        connectionId: null == connectionId
            ? _self.connectionId
            : connectionId // ignore: cast_nullable_to_non_nullable
                  as String,
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
