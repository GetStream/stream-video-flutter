// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_call_event_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SendCallEventResponse extends SendCallEventResponse {
  @override
  final String duration;

  factory _$SendCallEventResponse(
          [void Function(SendCallEventResponseBuilder)? updates]) =>
      (SendCallEventResponseBuilder()..update(updates))._build();

  _$SendCallEventResponse._({required this.duration}) : super._();
  @override
  SendCallEventResponse rebuild(
          void Function(SendCallEventResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SendCallEventResponseBuilder toBuilder() =>
      SendCallEventResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SendCallEventResponse && duration == other.duration;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SendCallEventResponse')
          ..add('duration', duration))
        .toString();
  }
}

class SendCallEventResponseBuilder
    implements Builder<SendCallEventResponse, SendCallEventResponseBuilder> {
  _$SendCallEventResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  SendCallEventResponseBuilder() {
    SendCallEventResponse._defaults(this);
  }

  SendCallEventResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SendCallEventResponse other) {
    _$v = other as _$SendCallEventResponse;
  }

  @override
  void update(void Function(SendCallEventResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SendCallEventResponse build() => _build();

  _$SendCallEventResponse _build() {
    final _$result = _$v ??
        _$SendCallEventResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'SendCallEventResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
