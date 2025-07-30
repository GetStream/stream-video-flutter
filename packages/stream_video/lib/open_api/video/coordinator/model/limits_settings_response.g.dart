// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'limits_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LimitsSettingsResponse extends LimitsSettingsResponse {
  @override
  final int? maxDurationSeconds;
  @override
  final int? maxParticipants;
  @override
  final bool? maxParticipantsExcludeOwner;
  @override
  final BuiltList<String> maxParticipantsExcludeRoles;

  factory _$LimitsSettingsResponse(
          [void Function(LimitsSettingsResponseBuilder)? updates]) =>
      (LimitsSettingsResponseBuilder()..update(updates))._build();

  _$LimitsSettingsResponse._(
      {this.maxDurationSeconds,
      this.maxParticipants,
      this.maxParticipantsExcludeOwner,
      required this.maxParticipantsExcludeRoles})
      : super._();
  @override
  LimitsSettingsResponse rebuild(
          void Function(LimitsSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LimitsSettingsResponseBuilder toBuilder() =>
      LimitsSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LimitsSettingsResponse &&
        maxDurationSeconds == other.maxDurationSeconds &&
        maxParticipants == other.maxParticipants &&
        maxParticipantsExcludeOwner == other.maxParticipantsExcludeOwner &&
        maxParticipantsExcludeRoles == other.maxParticipantsExcludeRoles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, maxDurationSeconds.hashCode);
    _$hash = $jc(_$hash, maxParticipants.hashCode);
    _$hash = $jc(_$hash, maxParticipantsExcludeOwner.hashCode);
    _$hash = $jc(_$hash, maxParticipantsExcludeRoles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LimitsSettingsResponse')
          ..add('maxDurationSeconds', maxDurationSeconds)
          ..add('maxParticipants', maxParticipants)
          ..add('maxParticipantsExcludeOwner', maxParticipantsExcludeOwner)
          ..add('maxParticipantsExcludeRoles', maxParticipantsExcludeRoles))
        .toString();
  }
}

class LimitsSettingsResponseBuilder
    implements Builder<LimitsSettingsResponse, LimitsSettingsResponseBuilder> {
  _$LimitsSettingsResponse? _$v;

  int? _maxDurationSeconds;
  int? get maxDurationSeconds => _$this._maxDurationSeconds;
  set maxDurationSeconds(int? maxDurationSeconds) =>
      _$this._maxDurationSeconds = maxDurationSeconds;

  int? _maxParticipants;
  int? get maxParticipants => _$this._maxParticipants;
  set maxParticipants(int? maxParticipants) =>
      _$this._maxParticipants = maxParticipants;

  bool? _maxParticipantsExcludeOwner;
  bool? get maxParticipantsExcludeOwner => _$this._maxParticipantsExcludeOwner;
  set maxParticipantsExcludeOwner(bool? maxParticipantsExcludeOwner) =>
      _$this._maxParticipantsExcludeOwner = maxParticipantsExcludeOwner;

  ListBuilder<String>? _maxParticipantsExcludeRoles;
  ListBuilder<String> get maxParticipantsExcludeRoles =>
      _$this._maxParticipantsExcludeRoles ??= ListBuilder<String>();
  set maxParticipantsExcludeRoles(
          ListBuilder<String>? maxParticipantsExcludeRoles) =>
      _$this._maxParticipantsExcludeRoles = maxParticipantsExcludeRoles;

  LimitsSettingsResponseBuilder() {
    LimitsSettingsResponse._defaults(this);
  }

  LimitsSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _maxDurationSeconds = $v.maxDurationSeconds;
      _maxParticipants = $v.maxParticipants;
      _maxParticipantsExcludeOwner = $v.maxParticipantsExcludeOwner;
      _maxParticipantsExcludeRoles = $v.maxParticipantsExcludeRoles.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LimitsSettingsResponse other) {
    _$v = other as _$LimitsSettingsResponse;
  }

  @override
  void update(void Function(LimitsSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LimitsSettingsResponse build() => _build();

  _$LimitsSettingsResponse _build() {
    _$LimitsSettingsResponse _$result;
    try {
      _$result = _$v ??
          _$LimitsSettingsResponse._(
            maxDurationSeconds: maxDurationSeconds,
            maxParticipants: maxParticipants,
            maxParticipantsExcludeOwner: maxParticipantsExcludeOwner,
            maxParticipantsExcludeRoles: maxParticipantsExcludeRoles.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'maxParticipantsExcludeRoles';
        maxParticipantsExcludeRoles.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LimitsSettingsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
