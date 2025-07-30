// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bound.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Bound extends Bound {
  @override
  final bool inclusive;
  @override
  final double value;

  factory _$Bound([void Function(BoundBuilder)? updates]) =>
      (BoundBuilder()..update(updates))._build();

  _$Bound._({required this.inclusive, required this.value}) : super._();
  @override
  Bound rebuild(void Function(BoundBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BoundBuilder toBuilder() => BoundBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Bound &&
        inclusive == other.inclusive &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, inclusive.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Bound')
          ..add('inclusive', inclusive)
          ..add('value', value))
        .toString();
  }
}

class BoundBuilder implements Builder<Bound, BoundBuilder> {
  _$Bound? _$v;

  bool? _inclusive;
  bool? get inclusive => _$this._inclusive;
  set inclusive(bool? inclusive) => _$this._inclusive = inclusive;

  double? _value;
  double? get value => _$this._value;
  set value(double? value) => _$this._value = value;

  BoundBuilder() {
    Bound._defaults(this);
  }

  BoundBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _inclusive = $v.inclusive;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Bound other) {
    _$v = other as _$Bound;
  }

  @override
  void update(void Function(BoundBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Bound build() => _build();

  _$Bound _build() {
    final _$result = _$v ??
        _$Bound._(
          inclusive: BuiltValueNullFieldError.checkNotNull(
              inclusive, r'Bound', 'inclusive'),
          value:
              BuiltValueNullFieldError.checkNotNull(value, r'Bound', 'value'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
