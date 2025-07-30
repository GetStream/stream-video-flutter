// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_ingress_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallIngressResponse extends CallIngressResponse {
  @override
  final RTMPIngress rtmp;

  factory _$CallIngressResponse(
          [void Function(CallIngressResponseBuilder)? updates]) =>
      (CallIngressResponseBuilder()..update(updates))._build();

  _$CallIngressResponse._({required this.rtmp}) : super._();
  @override
  CallIngressResponse rebuild(
          void Function(CallIngressResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallIngressResponseBuilder toBuilder() =>
      CallIngressResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallIngressResponse && rtmp == other.rtmp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rtmp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallIngressResponse')
          ..add('rtmp', rtmp))
        .toString();
  }
}

class CallIngressResponseBuilder
    implements Builder<CallIngressResponse, CallIngressResponseBuilder> {
  _$CallIngressResponse? _$v;

  RTMPIngressBuilder? _rtmp;
  RTMPIngressBuilder get rtmp => _$this._rtmp ??= RTMPIngressBuilder();
  set rtmp(RTMPIngressBuilder? rtmp) => _$this._rtmp = rtmp;

  CallIngressResponseBuilder() {
    CallIngressResponse._defaults(this);
  }

  CallIngressResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rtmp = $v.rtmp.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallIngressResponse other) {
    _$v = other as _$CallIngressResponse;
  }

  @override
  void update(void Function(CallIngressResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallIngressResponse build() => _build();

  _$CallIngressResponse _build() {
    _$CallIngressResponse _$result;
    try {
      _$result = _$v ??
          _$CallIngressResponse._(
            rtmp: rtmp.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rtmp';
        rtmp.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallIngressResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
