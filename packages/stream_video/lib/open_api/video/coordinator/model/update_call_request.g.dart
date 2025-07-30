// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_call_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateCallRequest extends UpdateCallRequest {
  @override
  final BuiltMap<String, JsonObject?>? custom;
  @override
  final CallSettingsRequest? settingsOverride;
  @override
  final DateTime? startsAt;

  factory _$UpdateCallRequest(
          [void Function(UpdateCallRequestBuilder)? updates]) =>
      (UpdateCallRequestBuilder()..update(updates))._build();

  _$UpdateCallRequest._({this.custom, this.settingsOverride, this.startsAt})
      : super._();
  @override
  UpdateCallRequest rebuild(void Function(UpdateCallRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateCallRequestBuilder toBuilder() =>
      UpdateCallRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateCallRequest &&
        custom == other.custom &&
        settingsOverride == other.settingsOverride &&
        startsAt == other.startsAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, settingsOverride.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateCallRequest')
          ..add('custom', custom)
          ..add('settingsOverride', settingsOverride)
          ..add('startsAt', startsAt))
        .toString();
  }
}

class UpdateCallRequestBuilder
    implements Builder<UpdateCallRequest, UpdateCallRequestBuilder> {
  _$UpdateCallRequest? _$v;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  CallSettingsRequestBuilder? _settingsOverride;
  CallSettingsRequestBuilder get settingsOverride =>
      _$this._settingsOverride ??= CallSettingsRequestBuilder();
  set settingsOverride(CallSettingsRequestBuilder? settingsOverride) =>
      _$this._settingsOverride = settingsOverride;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  UpdateCallRequestBuilder() {
    UpdateCallRequest._defaults(this);
  }

  UpdateCallRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _custom = $v.custom?.toBuilder();
      _settingsOverride = $v.settingsOverride?.toBuilder();
      _startsAt = $v.startsAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateCallRequest other) {
    _$v = other as _$UpdateCallRequest;
  }

  @override
  void update(void Function(UpdateCallRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateCallRequest build() => _build();

  _$UpdateCallRequest _build() {
    _$UpdateCallRequest _$result;
    try {
      _$result = _$v ??
          _$UpdateCallRequest._(
            custom: _custom?.build(),
            settingsOverride: _settingsOverride?.build(),
            startsAt: startsAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        _custom?.build();
        _$failedField = 'settingsOverride';
        _settingsOverride?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdateCallRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
