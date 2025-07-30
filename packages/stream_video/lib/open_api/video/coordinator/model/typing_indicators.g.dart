// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_indicators.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TypingIndicators extends TypingIndicators {
  @override
  final bool enabled;

  factory _$TypingIndicators(
          [void Function(TypingIndicatorsBuilder)? updates]) =>
      (TypingIndicatorsBuilder()..update(updates))._build();

  _$TypingIndicators._({required this.enabled}) : super._();
  @override
  TypingIndicators rebuild(void Function(TypingIndicatorsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TypingIndicatorsBuilder toBuilder() =>
      TypingIndicatorsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TypingIndicators && enabled == other.enabled;
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
    return (newBuiltValueToStringHelper(r'TypingIndicators')
          ..add('enabled', enabled))
        .toString();
  }
}

class TypingIndicatorsBuilder
    implements Builder<TypingIndicators, TypingIndicatorsBuilder> {
  _$TypingIndicators? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  TypingIndicatorsBuilder() {
    TypingIndicators._defaults(this);
  }

  TypingIndicatorsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TypingIndicators other) {
    _$v = other as _$TypingIndicators;
  }

  @override
  void update(void Function(TypingIndicatorsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TypingIndicators build() => _build();

  _$TypingIndicators _build() {
    final _$result = _$v ??
        _$TypingIndicators._(
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'TypingIndicators', 'enabled'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
