// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_call_event_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SendCallEventRequest extends SendCallEventRequest {
  @override
  final BuiltMap<String, JsonObject?>? custom;

  factory _$SendCallEventRequest(
          [void Function(SendCallEventRequestBuilder)? updates]) =>
      (SendCallEventRequestBuilder()..update(updates))._build();

  _$SendCallEventRequest._({this.custom}) : super._();
  @override
  SendCallEventRequest rebuild(
          void Function(SendCallEventRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SendCallEventRequestBuilder toBuilder() =>
      SendCallEventRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SendCallEventRequest && custom == other.custom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SendCallEventRequest')
          ..add('custom', custom))
        .toString();
  }
}

class SendCallEventRequestBuilder
    implements Builder<SendCallEventRequest, SendCallEventRequestBuilder> {
  _$SendCallEventRequest? _$v;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  SendCallEventRequestBuilder() {
    SendCallEventRequest._defaults(this);
  }

  SendCallEventRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _custom = $v.custom?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SendCallEventRequest other) {
    _$v = other as _$SendCallEventRequest;
  }

  @override
  void update(void Function(SendCallEventRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SendCallEventRequest build() => _build();

  _$SendCallEventRequest _build() {
    _$SendCallEventRequest _$result;
    try {
      _$result = _$v ??
          _$SendCallEventRequest._(
            custom: _custom?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        _custom?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SendCallEventRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
