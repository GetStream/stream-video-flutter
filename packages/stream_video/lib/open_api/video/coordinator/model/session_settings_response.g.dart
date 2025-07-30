// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SessionSettingsResponse extends SessionSettingsResponse {
  @override
  final int inactivityTimeoutSeconds;

  factory _$SessionSettingsResponse(
          [void Function(SessionSettingsResponseBuilder)? updates]) =>
      (SessionSettingsResponseBuilder()..update(updates))._build();

  _$SessionSettingsResponse._({required this.inactivityTimeoutSeconds})
      : super._();
  @override
  SessionSettingsResponse rebuild(
          void Function(SessionSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SessionSettingsResponseBuilder toBuilder() =>
      SessionSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SessionSettingsResponse &&
        inactivityTimeoutSeconds == other.inactivityTimeoutSeconds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, inactivityTimeoutSeconds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SessionSettingsResponse')
          ..add('inactivityTimeoutSeconds', inactivityTimeoutSeconds))
        .toString();
  }
}

class SessionSettingsResponseBuilder
    implements
        Builder<SessionSettingsResponse, SessionSettingsResponseBuilder> {
  _$SessionSettingsResponse? _$v;

  int? _inactivityTimeoutSeconds;
  int? get inactivityTimeoutSeconds => _$this._inactivityTimeoutSeconds;
  set inactivityTimeoutSeconds(int? inactivityTimeoutSeconds) =>
      _$this._inactivityTimeoutSeconds = inactivityTimeoutSeconds;

  SessionSettingsResponseBuilder() {
    SessionSettingsResponse._defaults(this);
  }

  SessionSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _inactivityTimeoutSeconds = $v.inactivityTimeoutSeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SessionSettingsResponse other) {
    _$v = other as _$SessionSettingsResponse;
  }

  @override
  void update(void Function(SessionSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SessionSettingsResponse build() => _build();

  _$SessionSettingsResponse _build() {
    final _$result = _$v ??
        _$SessionSettingsResponse._(
          inactivityTimeoutSeconds: BuiltValueNullFieldError.checkNotNull(
              inactivityTimeoutSeconds,
              r'SessionSettingsResponse',
              'inactivityTimeoutSeconds'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
