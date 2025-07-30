// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_updated_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppUpdatedEvent extends AppUpdatedEvent {
  @override
  final AppEventResponse app;
  @override
  final DateTime createdAt;
  @override
  final BuiltMap<String, JsonObject?> custom;
  @override
  final DateTime? receivedAt;
  @override
  final String type;

  factory _$AppUpdatedEvent([void Function(AppUpdatedEventBuilder)? updates]) =>
      (AppUpdatedEventBuilder()..update(updates))._build();

  _$AppUpdatedEvent._(
      {required this.app,
      required this.createdAt,
      required this.custom,
      this.receivedAt,
      required this.type})
      : super._();
  @override
  AppUpdatedEvent rebuild(void Function(AppUpdatedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppUpdatedEventBuilder toBuilder() => AppUpdatedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppUpdatedEvent &&
        app == other.app &&
        createdAt == other.createdAt &&
        custom == other.custom &&
        receivedAt == other.receivedAt &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, app.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, receivedAt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppUpdatedEvent')
          ..add('app', app)
          ..add('createdAt', createdAt)
          ..add('custom', custom)
          ..add('receivedAt', receivedAt)
          ..add('type', type))
        .toString();
  }
}

class AppUpdatedEventBuilder
    implements Builder<AppUpdatedEvent, AppUpdatedEventBuilder> {
  _$AppUpdatedEvent? _$v;

  AppEventResponseBuilder? _app;
  AppEventResponseBuilder get app => _$this._app ??= AppEventResponseBuilder();
  set app(AppEventResponseBuilder? app) => _$this._app = app;

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

  AppUpdatedEventBuilder() {
    AppUpdatedEvent._defaults(this);
  }

  AppUpdatedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _app = $v.app.toBuilder();
      _createdAt = $v.createdAt;
      _custom = $v.custom.toBuilder();
      _receivedAt = $v.receivedAt;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppUpdatedEvent other) {
    _$v = other as _$AppUpdatedEvent;
  }

  @override
  void update(void Function(AppUpdatedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppUpdatedEvent build() => _build();

  _$AppUpdatedEvent _build() {
    _$AppUpdatedEvent _$result;
    try {
      _$result = _$v ??
          _$AppUpdatedEvent._(
            app: app.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AppUpdatedEvent', 'createdAt'),
            custom: custom.build(),
            receivedAt: receivedAt,
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'AppUpdatedEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'app';
        app.build();

        _$failedField = 'custom';
        custom.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AppUpdatedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
