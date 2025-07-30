// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_permissions_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateUserPermissionsResponse extends UpdateUserPermissionsResponse {
  @override
  final String duration;

  factory _$UpdateUserPermissionsResponse(
          [void Function(UpdateUserPermissionsResponseBuilder)? updates]) =>
      (UpdateUserPermissionsResponseBuilder()..update(updates))._build();

  _$UpdateUserPermissionsResponse._({required this.duration}) : super._();
  @override
  UpdateUserPermissionsResponse rebuild(
          void Function(UpdateUserPermissionsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateUserPermissionsResponseBuilder toBuilder() =>
      UpdateUserPermissionsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateUserPermissionsResponse && duration == other.duration;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateUserPermissionsResponse')
          ..add('duration', duration))
        .toString();
  }
}

class UpdateUserPermissionsResponseBuilder
    implements
        Builder<UpdateUserPermissionsResponse,
            UpdateUserPermissionsResponseBuilder> {
  _$UpdateUserPermissionsResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  UpdateUserPermissionsResponseBuilder() {
    UpdateUserPermissionsResponse._defaults(this);
  }

  UpdateUserPermissionsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateUserPermissionsResponse other) {
    _$v = other as _$UpdateUserPermissionsResponse;
  }

  @override
  void update(void Function(UpdateUserPermissionsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateUserPermissionsResponse build() => _build();

  _$UpdateUserPermissionsResponse _build() {
    final _$result = _$v ??
        _$UpdateUserPermissionsResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'UpdateUserPermissionsResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
