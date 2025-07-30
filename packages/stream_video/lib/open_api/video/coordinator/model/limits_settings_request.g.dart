// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'limits_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LimitsSettingsRequest extends LimitsSettingsRequest {
  @override
  final int? maxDurationSeconds;
  @override
  final int? maxParticipants;
  @override
  final bool? maxParticipantsExcludeOwner;
  @override
  final BuiltList<String>? maxParticipantsExcludeRoles;

  factory _$LimitsSettingsRequest(
          [void Function(LimitsSettingsRequestBuilder)? updates]) =>
      (LimitsSettingsRequestBuilder()..update(updates))._build();

  _$LimitsSettingsRequest._(
      {this.maxDurationSeconds,
      this.maxParticipants,
      this.maxParticipantsExcludeOwner,
      this.maxParticipantsExcludeRoles})
      : super._();
  @override
  LimitsSettingsRequest rebuild(
          void Function(LimitsSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LimitsSettingsRequestBuilder toBuilder() =>
      LimitsSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LimitsSettingsRequest &&
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
    return (newBuiltValueToStringHelper(r'LimitsSettingsRequest')
          ..add('maxDurationSeconds', maxDurationSeconds)
          ..add('maxParticipants', maxParticipants)
          ..add('maxParticipantsExcludeOwner', maxParticipantsExcludeOwner)
          ..add('maxParticipantsExcludeRoles', maxParticipantsExcludeRoles))
        .toString();
  }
}

class LimitsSettingsRequestBuilder
    implements Builder<LimitsSettingsRequest, LimitsSettingsRequestBuilder> {
  _$LimitsSettingsRequest? _$v;

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

  LimitsSettingsRequestBuilder() {
    LimitsSettingsRequest._defaults(this);
  }

  LimitsSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _maxDurationSeconds = $v.maxDurationSeconds;
      _maxParticipants = $v.maxParticipants;
      _maxParticipantsExcludeOwner = $v.maxParticipantsExcludeOwner;
      _maxParticipantsExcludeRoles =
          $v.maxParticipantsExcludeRoles?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LimitsSettingsRequest other) {
    _$v = other as _$LimitsSettingsRequest;
  }

  @override
  void update(void Function(LimitsSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LimitsSettingsRequest build() => _build();

  _$LimitsSettingsRequest _build() {
    _$LimitsSettingsRequest _$result;
    try {
      _$result = _$v ??
          _$LimitsSettingsRequest._(
            maxDurationSeconds: maxDurationSeconds,
            maxParticipants: maxParticipants,
            maxParticipantsExcludeOwner: maxParticipantsExcludeOwner,
            maxParticipantsExcludeRoles: _maxParticipantsExcludeRoles?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'maxParticipantsExcludeRoles';
        _maxParticipantsExcludeRoles?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LimitsSettingsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
