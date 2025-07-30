// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_devices_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListDevicesResponse extends ListDevicesResponse {
  @override
  final BuiltList<DeviceResponse> devices;
  @override
  final String duration;

  factory _$ListDevicesResponse(
          [void Function(ListDevicesResponseBuilder)? updates]) =>
      (ListDevicesResponseBuilder()..update(updates))._build();

  _$ListDevicesResponse._({required this.devices, required this.duration})
      : super._();
  @override
  ListDevicesResponse rebuild(
          void Function(ListDevicesResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListDevicesResponseBuilder toBuilder() =>
      ListDevicesResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListDevicesResponse &&
        devices == other.devices &&
        duration == other.duration;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, devices.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListDevicesResponse')
          ..add('devices', devices)
          ..add('duration', duration))
        .toString();
  }
}

class ListDevicesResponseBuilder
    implements Builder<ListDevicesResponse, ListDevicesResponseBuilder> {
  _$ListDevicesResponse? _$v;

  ListBuilder<DeviceResponse>? _devices;
  ListBuilder<DeviceResponse> get devices =>
      _$this._devices ??= ListBuilder<DeviceResponse>();
  set devices(ListBuilder<DeviceResponse>? devices) =>
      _$this._devices = devices;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  ListDevicesResponseBuilder() {
    ListDevicesResponse._defaults(this);
  }

  ListDevicesResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _devices = $v.devices.toBuilder();
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListDevicesResponse other) {
    _$v = other as _$ListDevicesResponse;
  }

  @override
  void update(void Function(ListDevicesResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListDevicesResponse build() => _build();

  _$ListDevicesResponse _build() {
    _$ListDevicesResponse _$result;
    try {
      _$result = _$v ??
          _$ListDevicesResponse._(
            devices: devices.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'ListDevicesResponse', 'duration'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'devices';
        devices.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListDevicesResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
