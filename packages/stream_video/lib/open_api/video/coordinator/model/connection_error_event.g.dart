// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_error_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConnectionErrorEvent extends ConnectionErrorEvent {
  @override
  final String connectionId;
  @override
  final DateTime createdAt;
  @override
  final APIError error;
  @override
  final String type;

  factory _$ConnectionErrorEvent(
          [void Function(ConnectionErrorEventBuilder)? updates]) =>
      (ConnectionErrorEventBuilder()..update(updates))._build();

  _$ConnectionErrorEvent._(
      {required this.connectionId,
      required this.createdAt,
      required this.error,
      required this.type})
      : super._();
  @override
  ConnectionErrorEvent rebuild(
          void Function(ConnectionErrorEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConnectionErrorEventBuilder toBuilder() =>
      ConnectionErrorEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConnectionErrorEvent &&
        connectionId == other.connectionId &&
        createdAt == other.createdAt &&
        error == other.error &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, connectionId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConnectionErrorEvent')
          ..add('connectionId', connectionId)
          ..add('createdAt', createdAt)
          ..add('error', error)
          ..add('type', type))
        .toString();
  }
}

class ConnectionErrorEventBuilder
    implements Builder<ConnectionErrorEvent, ConnectionErrorEventBuilder> {
  _$ConnectionErrorEvent? _$v;

  String? _connectionId;
  String? get connectionId => _$this._connectionId;
  set connectionId(String? connectionId) => _$this._connectionId = connectionId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  APIErrorBuilder? _error;
  APIErrorBuilder get error => _$this._error ??= APIErrorBuilder();
  set error(APIErrorBuilder? error) => _$this._error = error;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  ConnectionErrorEventBuilder() {
    ConnectionErrorEvent._defaults(this);
  }

  ConnectionErrorEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _connectionId = $v.connectionId;
      _createdAt = $v.createdAt;
      _error = $v.error.toBuilder();
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConnectionErrorEvent other) {
    _$v = other as _$ConnectionErrorEvent;
  }

  @override
  void update(void Function(ConnectionErrorEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConnectionErrorEvent build() => _build();

  _$ConnectionErrorEvent _build() {
    _$ConnectionErrorEvent _$result;
    try {
      _$result = _$v ??
          _$ConnectionErrorEvent._(
            connectionId: BuiltValueNullFieldError.checkNotNull(
                connectionId, r'ConnectionErrorEvent', 'connectionId'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ConnectionErrorEvent', 'createdAt'),
            error: error.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'ConnectionErrorEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'error';
        error.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ConnectionErrorEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
