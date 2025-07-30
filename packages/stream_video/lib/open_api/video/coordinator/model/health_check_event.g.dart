// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_check_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HealthCheckEvent extends HealthCheckEvent {
  @override
  final String? cid;
  @override
  final String connectionId;
  @override
  final DateTime createdAt;
  @override
  final BuiltMap<String, JsonObject?> custom;
  @override
  final DateTime? receivedAt;
  @override
  final String type;

  factory _$HealthCheckEvent(
          [void Function(HealthCheckEventBuilder)? updates]) =>
      (HealthCheckEventBuilder()..update(updates))._build();

  _$HealthCheckEvent._(
      {this.cid,
      required this.connectionId,
      required this.createdAt,
      required this.custom,
      this.receivedAt,
      required this.type})
      : super._();
  @override
  HealthCheckEvent rebuild(void Function(HealthCheckEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HealthCheckEventBuilder toBuilder() =>
      HealthCheckEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthCheckEvent &&
        cid == other.cid &&
        connectionId == other.connectionId &&
        createdAt == other.createdAt &&
        custom == other.custom &&
        receivedAt == other.receivedAt &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cid.hashCode);
    _$hash = $jc(_$hash, connectionId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, receivedAt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HealthCheckEvent')
          ..add('cid', cid)
          ..add('connectionId', connectionId)
          ..add('createdAt', createdAt)
          ..add('custom', custom)
          ..add('receivedAt', receivedAt)
          ..add('type', type))
        .toString();
  }
}

class HealthCheckEventBuilder
    implements Builder<HealthCheckEvent, HealthCheckEventBuilder> {
  _$HealthCheckEvent? _$v;

  String? _cid;
  String? get cid => _$this._cid;
  set cid(String? cid) => _$this._cid = cid;

  String? _connectionId;
  String? get connectionId => _$this._connectionId;
  set connectionId(String? connectionId) => _$this._connectionId = connectionId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  DateTime? _receivedAt;
  DateTime? get receivedAt => _$this._receivedAt;
  set receivedAt(DateTime? receivedAt) => _$this._receivedAt = receivedAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  HealthCheckEventBuilder() {
    HealthCheckEvent._defaults(this);
  }

  HealthCheckEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cid = $v.cid;
      _connectionId = $v.connectionId;
      _createdAt = $v.createdAt;
      _custom = $v.custom.toBuilder();
      _receivedAt = $v.receivedAt;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HealthCheckEvent other) {
    _$v = other as _$HealthCheckEvent;
  }

  @override
  void update(void Function(HealthCheckEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HealthCheckEvent build() => _build();

  _$HealthCheckEvent _build() {
    _$HealthCheckEvent _$result;
    try {
      _$result = _$v ??
          _$HealthCheckEvent._(
            cid: cid,
            connectionId: BuiltValueNullFieldError.checkNotNull(
                connectionId, r'HealthCheckEvent', 'connectionId'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'HealthCheckEvent', 'createdAt'),
            custom: custom.build(),
            receivedAt: receivedAt,
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'HealthCheckEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        custom.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'HealthCheckEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
