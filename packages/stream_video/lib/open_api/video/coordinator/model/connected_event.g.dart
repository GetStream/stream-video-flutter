// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connected_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConnectedEvent extends ConnectedEvent {
  @override
  final String connectionId;
  @override
  final DateTime createdAt;
  @override
  final OwnUserResponse me;
  @override
  final String type;

  factory _$ConnectedEvent([void Function(ConnectedEventBuilder)? updates]) =>
      (ConnectedEventBuilder()..update(updates))._build();

  _$ConnectedEvent._(
      {required this.connectionId,
      required this.createdAt,
      required this.me,
      required this.type})
      : super._();
  @override
  ConnectedEvent rebuild(void Function(ConnectedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConnectedEventBuilder toBuilder() => ConnectedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConnectedEvent &&
        connectionId == other.connectionId &&
        createdAt == other.createdAt &&
        me == other.me &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, connectionId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, me.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConnectedEvent')
          ..add('connectionId', connectionId)
          ..add('createdAt', createdAt)
          ..add('me', me)
          ..add('type', type))
        .toString();
  }
}

class ConnectedEventBuilder
    implements Builder<ConnectedEvent, ConnectedEventBuilder> {
  _$ConnectedEvent? _$v;

  String? _connectionId;
  String? get connectionId => _$this._connectionId;
  set connectionId(String? connectionId) => _$this._connectionId = connectionId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  OwnUserResponseBuilder? _me;
  OwnUserResponseBuilder get me => _$this._me ??= OwnUserResponseBuilder();
  set me(OwnUserResponseBuilder? me) => _$this._me = me;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  ConnectedEventBuilder() {
    ConnectedEvent._defaults(this);
  }

  ConnectedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _connectionId = $v.connectionId;
      _createdAt = $v.createdAt;
      _me = $v.me.toBuilder();
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConnectedEvent other) {
    _$v = other as _$ConnectedEvent;
  }

  @override
  void update(void Function(ConnectedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConnectedEvent build() => _build();

  _$ConnectedEvent _build() {
    _$ConnectedEvent _$result;
    try {
      _$result = _$v ??
          _$ConnectedEvent._(
            connectionId: BuiltValueNullFieldError.checkNotNull(
                connectionId, r'ConnectedEvent', 'connectionId'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ConnectedEvent', 'createdAt'),
            me: me.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'ConnectedEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'me';
        me.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ConnectedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
