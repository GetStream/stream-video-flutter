// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeviceResponse extends DeviceResponse {
  @override
  final DateTime createdAt;
  @override
  final bool? disabled;
  @override
  final String? disabledReason;
  @override
  final String id;
  @override
  final String pushProvider;
  @override
  final String? pushProviderName;
  @override
  final String userId;
  @override
  final bool? voip;

  factory _$DeviceResponse([void Function(DeviceResponseBuilder)? updates]) =>
      (DeviceResponseBuilder()..update(updates))._build();

  _$DeviceResponse._(
      {required this.createdAt,
      this.disabled,
      this.disabledReason,
      required this.id,
      required this.pushProvider,
      this.pushProviderName,
      required this.userId,
      this.voip})
      : super._();
  @override
  DeviceResponse rebuild(void Function(DeviceResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceResponseBuilder toBuilder() => DeviceResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceResponse &&
        createdAt == other.createdAt &&
        disabled == other.disabled &&
        disabledReason == other.disabledReason &&
        id == other.id &&
        pushProvider == other.pushProvider &&
        pushProviderName == other.pushProviderName &&
        userId == other.userId &&
        voip == other.voip;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, disabled.hashCode);
    _$hash = $jc(_$hash, disabledReason.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, pushProvider.hashCode);
    _$hash = $jc(_$hash, pushProviderName.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, voip.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceResponse')
          ..add('createdAt', createdAt)
          ..add('disabled', disabled)
          ..add('disabledReason', disabledReason)
          ..add('id', id)
          ..add('pushProvider', pushProvider)
          ..add('pushProviderName', pushProviderName)
          ..add('userId', userId)
          ..add('voip', voip))
        .toString();
  }
}

class DeviceResponseBuilder
    implements Builder<DeviceResponse, DeviceResponseBuilder> {
  _$DeviceResponse? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  bool? _disabled;
  bool? get disabled => _$this._disabled;
  set disabled(bool? disabled) => _$this._disabled = disabled;

  String? _disabledReason;
  String? get disabledReason => _$this._disabledReason;
  set disabledReason(String? disabledReason) =>
      _$this._disabledReason = disabledReason;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _pushProvider;
  String? get pushProvider => _$this._pushProvider;
  set pushProvider(String? pushProvider) => _$this._pushProvider = pushProvider;

  String? _pushProviderName;
  String? get pushProviderName => _$this._pushProviderName;
  set pushProviderName(String? pushProviderName) =>
      _$this._pushProviderName = pushProviderName;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  bool? _voip;
  bool? get voip => _$this._voip;
  set voip(bool? voip) => _$this._voip = voip;

  DeviceResponseBuilder() {
    DeviceResponse._defaults(this);
  }

  DeviceResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _disabled = $v.disabled;
      _disabledReason = $v.disabledReason;
      _id = $v.id;
      _pushProvider = $v.pushProvider;
      _pushProviderName = $v.pushProviderName;
      _userId = $v.userId;
      _voip = $v.voip;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceResponse other) {
    _$v = other as _$DeviceResponse;
  }

  @override
  void update(void Function(DeviceResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceResponse build() => _build();

  _$DeviceResponse _build() {
    final _$result = _$v ??
        _$DeviceResponse._(
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'DeviceResponse', 'createdAt'),
          disabled: disabled,
          disabledReason: disabledReason,
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'DeviceResponse', 'id'),
          pushProvider: BuiltValueNullFieldError.checkNotNull(
              pushProvider, r'DeviceResponse', 'pushProvider'),
          pushProviderName: pushProviderName,
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'DeviceResponse', 'userId'),
          voip: voip,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
