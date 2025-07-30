// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_permission_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RequestPermissionResponse extends RequestPermissionResponse {
  @override
  final String duration;

  factory _$RequestPermissionResponse(
          [void Function(RequestPermissionResponseBuilder)? updates]) =>
      (RequestPermissionResponseBuilder()..update(updates))._build();

  _$RequestPermissionResponse._({required this.duration}) : super._();
  @override
  RequestPermissionResponse rebuild(
          void Function(RequestPermissionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RequestPermissionResponseBuilder toBuilder() =>
      RequestPermissionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RequestPermissionResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'RequestPermissionResponse')
          ..add('duration', duration))
        .toString();
  }
}

class RequestPermissionResponseBuilder
    implements
        Builder<RequestPermissionResponse, RequestPermissionResponseBuilder> {
  _$RequestPermissionResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  RequestPermissionResponseBuilder() {
    RequestPermissionResponse._defaults(this);
  }

  RequestPermissionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RequestPermissionResponse other) {
    _$v = other as _$RequestPermissionResponse;
  }

  @override
  void update(void Function(RequestPermissionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RequestPermissionResponse build() => _build();

  _$RequestPermissionResponse _build() {
    final _$result = _$v ??
        _$RequestPermissionResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'RequestPermissionResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
