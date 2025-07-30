// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_settings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PrivacySettings extends PrivacySettings {
  @override
  final ReadReceipts? readReceipts;
  @override
  final TypingIndicators? typingIndicators;

  factory _$PrivacySettings([void Function(PrivacySettingsBuilder)? updates]) =>
      (PrivacySettingsBuilder()..update(updates))._build();

  _$PrivacySettings._({this.readReceipts, this.typingIndicators}) : super._();
  @override
  PrivacySettings rebuild(void Function(PrivacySettingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PrivacySettingsBuilder toBuilder() => PrivacySettingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PrivacySettings &&
        readReceipts == other.readReceipts &&
        typingIndicators == other.typingIndicators;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, readReceipts.hashCode);
    _$hash = $jc(_$hash, typingIndicators.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PrivacySettings')
          ..add('readReceipts', readReceipts)
          ..add('typingIndicators', typingIndicators))
        .toString();
  }
}

class PrivacySettingsBuilder
    implements Builder<PrivacySettings, PrivacySettingsBuilder> {
  _$PrivacySettings? _$v;

  ReadReceiptsBuilder? _readReceipts;
  ReadReceiptsBuilder get readReceipts =>
      _$this._readReceipts ??= ReadReceiptsBuilder();
  set readReceipts(ReadReceiptsBuilder? readReceipts) =>
      _$this._readReceipts = readReceipts;

  TypingIndicatorsBuilder? _typingIndicators;
  TypingIndicatorsBuilder get typingIndicators =>
      _$this._typingIndicators ??= TypingIndicatorsBuilder();
  set typingIndicators(TypingIndicatorsBuilder? typingIndicators) =>
      _$this._typingIndicators = typingIndicators;

  PrivacySettingsBuilder() {
    PrivacySettings._defaults(this);
  }

  PrivacySettingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _readReceipts = $v.readReceipts?.toBuilder();
      _typingIndicators = $v.typingIndicators?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PrivacySettings other) {
    _$v = other as _$PrivacySettings;
  }

  @override
  void update(void Function(PrivacySettingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PrivacySettings build() => _build();

  _$PrivacySettings _build() {
    _$PrivacySettings _$result;
    try {
      _$result = _$v ??
          _$PrivacySettings._(
            readReceipts: _readReceipts?.build(),
            typingIndicators: _typingIndicators?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'readReceipts';
        _readReceipts?.build();
        _$failedField = 'typingIndicators';
        _typingIndicators?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PrivacySettings', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
