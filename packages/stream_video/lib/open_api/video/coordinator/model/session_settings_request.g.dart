// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SessionSettingsRequest extends SessionSettingsRequest {
  @override
  final int inactivityTimeoutSeconds;

  factory _$SessionSettingsRequest(
          [void Function(SessionSettingsRequestBuilder)? updates]) =>
      (SessionSettingsRequestBuilder()..update(updates))._build();

  _$SessionSettingsRequest._({required this.inactivityTimeoutSeconds})
      : super._();
  @override
  SessionSettingsRequest rebuild(
          void Function(SessionSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SessionSettingsRequestBuilder toBuilder() =>
      SessionSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SessionSettingsRequest &&
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
    return (newBuiltValueToStringHelper(r'SessionSettingsRequest')
          ..add('inactivityTimeoutSeconds', inactivityTimeoutSeconds))
        .toString();
  }
}

class SessionSettingsRequestBuilder
    implements Builder<SessionSettingsRequest, SessionSettingsRequestBuilder> {
  _$SessionSettingsRequest? _$v;

  int? _inactivityTimeoutSeconds;
  int? get inactivityTimeoutSeconds => _$this._inactivityTimeoutSeconds;
  set inactivityTimeoutSeconds(int? inactivityTimeoutSeconds) =>
      _$this._inactivityTimeoutSeconds = inactivityTimeoutSeconds;

  SessionSettingsRequestBuilder() {
    SessionSettingsRequest._defaults(this);
  }

  SessionSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _inactivityTimeoutSeconds = $v.inactivityTimeoutSeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SessionSettingsRequest other) {
    _$v = other as _$SessionSettingsRequest;
  }

  @override
  void update(void Function(SessionSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SessionSettingsRequest build() => _build();

  _$SessionSettingsRequest _build() {
    final _$result = _$v ??
        _$SessionSettingsRequest._(
          inactivityTimeoutSeconds: BuiltValueNullFieldError.checkNotNull(
              inactivityTimeoutSeconds,
              r'SessionSettingsRequest',
              'inactivityTimeoutSeconds'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
