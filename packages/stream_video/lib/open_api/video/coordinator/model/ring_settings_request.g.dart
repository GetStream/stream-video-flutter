// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ring_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RingSettingsRequest extends RingSettingsRequest {
  @override
  final int autoCancelTimeoutMs;
  @override
  final int incomingCallTimeoutMs;
  @override
  final int? missedCallTimeoutMs;

  factory _$RingSettingsRequest(
          [void Function(RingSettingsRequestBuilder)? updates]) =>
      (RingSettingsRequestBuilder()..update(updates))._build();

  _$RingSettingsRequest._(
      {required this.autoCancelTimeoutMs,
      required this.incomingCallTimeoutMs,
      this.missedCallTimeoutMs})
      : super._();
  @override
  RingSettingsRequest rebuild(
          void Function(RingSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RingSettingsRequestBuilder toBuilder() =>
      RingSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RingSettingsRequest &&
        autoCancelTimeoutMs == other.autoCancelTimeoutMs &&
        incomingCallTimeoutMs == other.incomingCallTimeoutMs &&
        missedCallTimeoutMs == other.missedCallTimeoutMs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, autoCancelTimeoutMs.hashCode);
    _$hash = $jc(_$hash, incomingCallTimeoutMs.hashCode);
    _$hash = $jc(_$hash, missedCallTimeoutMs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RingSettingsRequest')
          ..add('autoCancelTimeoutMs', autoCancelTimeoutMs)
          ..add('incomingCallTimeoutMs', incomingCallTimeoutMs)
          ..add('missedCallTimeoutMs', missedCallTimeoutMs))
        .toString();
  }
}

class RingSettingsRequestBuilder
    implements Builder<RingSettingsRequest, RingSettingsRequestBuilder> {
  _$RingSettingsRequest? _$v;

  int? _autoCancelTimeoutMs;
  int? get autoCancelTimeoutMs => _$this._autoCancelTimeoutMs;
  set autoCancelTimeoutMs(int? autoCancelTimeoutMs) =>
      _$this._autoCancelTimeoutMs = autoCancelTimeoutMs;

  int? _incomingCallTimeoutMs;
  int? get incomingCallTimeoutMs => _$this._incomingCallTimeoutMs;
  set incomingCallTimeoutMs(int? incomingCallTimeoutMs) =>
      _$this._incomingCallTimeoutMs = incomingCallTimeoutMs;

  int? _missedCallTimeoutMs;
  int? get missedCallTimeoutMs => _$this._missedCallTimeoutMs;
  set missedCallTimeoutMs(int? missedCallTimeoutMs) =>
      _$this._missedCallTimeoutMs = missedCallTimeoutMs;

  RingSettingsRequestBuilder() {
    RingSettingsRequest._defaults(this);
  }

  RingSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _autoCancelTimeoutMs = $v.autoCancelTimeoutMs;
      _incomingCallTimeoutMs = $v.incomingCallTimeoutMs;
      _missedCallTimeoutMs = $v.missedCallTimeoutMs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RingSettingsRequest other) {
    _$v = other as _$RingSettingsRequest;
  }

  @override
  void update(void Function(RingSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RingSettingsRequest build() => _build();

  _$RingSettingsRequest _build() {
    final _$result = _$v ??
        _$RingSettingsRequest._(
          autoCancelTimeoutMs: BuiltValueNullFieldError.checkNotNull(
              autoCancelTimeoutMs,
              r'RingSettingsRequest',
              'autoCancelTimeoutMs'),
          incomingCallTimeoutMs: BuiltValueNullFieldError.checkNotNull(
              incomingCallTimeoutMs,
              r'RingSettingsRequest',
              'incomingCallTimeoutMs'),
          missedCallTimeoutMs: missedCallTimeoutMs,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
