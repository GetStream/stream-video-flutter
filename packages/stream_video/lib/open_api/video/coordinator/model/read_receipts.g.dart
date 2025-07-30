// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_receipts.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReadReceipts extends ReadReceipts {
  @override
  final bool enabled;

  factory _$ReadReceipts([void Function(ReadReceiptsBuilder)? updates]) =>
      (ReadReceiptsBuilder()..update(updates))._build();

  _$ReadReceipts._({required this.enabled}) : super._();
  @override
  ReadReceipts rebuild(void Function(ReadReceiptsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReadReceiptsBuilder toBuilder() => ReadReceiptsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReadReceipts && enabled == other.enabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReadReceipts')
          ..add('enabled', enabled))
        .toString();
  }
}

class ReadReceiptsBuilder
    implements Builder<ReadReceipts, ReadReceiptsBuilder> {
  _$ReadReceipts? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  ReadReceiptsBuilder() {
    ReadReceipts._defaults(this);
  }

  ReadReceiptsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReadReceipts other) {
    _$v = other as _$ReadReceipts;
  }

  @override
  void update(void Function(ReadReceiptsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReadReceipts build() => _build();

  _$ReadReceipts _build() {
    final _$result = _$v ??
        _$ReadReceipts._(
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'ReadReceipts', 'enabled'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
