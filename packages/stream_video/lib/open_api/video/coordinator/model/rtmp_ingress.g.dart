// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtmp_ingress.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RTMPIngress extends RTMPIngress {
  @override
  final String address;

  factory _$RTMPIngress([void Function(RTMPIngressBuilder)? updates]) =>
      (RTMPIngressBuilder()..update(updates))._build();

  _$RTMPIngress._({required this.address}) : super._();
  @override
  RTMPIngress rebuild(void Function(RTMPIngressBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RTMPIngressBuilder toBuilder() => RTMPIngressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RTMPIngress && address == other.address;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RTMPIngress')
          ..add('address', address))
        .toString();
  }
}

class RTMPIngressBuilder implements Builder<RTMPIngress, RTMPIngressBuilder> {
  _$RTMPIngress? _$v;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  RTMPIngressBuilder() {
    RTMPIngress._defaults(this);
  }

  RTMPIngressBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _address = $v.address;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RTMPIngress other) {
    _$v = other as _$RTMPIngress;
  }

  @override
  void update(void Function(RTMPIngressBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RTMPIngress build() => _build();

  _$RTMPIngress _build() {
    final _$result = _$v ??
        _$RTMPIngress._(
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'RTMPIngress', 'address'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
