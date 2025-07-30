// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_or_create_call_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetOrCreateCallRequest extends GetOrCreateCallRequest {
  @override
  final CallRequest? data;
  @override
  final int? membersLimit;
  @override
  final bool? notify;
  @override
  final bool? ring;
  @override
  final bool? video;

  factory _$GetOrCreateCallRequest(
          [void Function(GetOrCreateCallRequestBuilder)? updates]) =>
      (GetOrCreateCallRequestBuilder()..update(updates))._build();

  _$GetOrCreateCallRequest._(
      {this.data, this.membersLimit, this.notify, this.ring, this.video})
      : super._();
  @override
  GetOrCreateCallRequest rebuild(
          void Function(GetOrCreateCallRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetOrCreateCallRequestBuilder toBuilder() =>
      GetOrCreateCallRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetOrCreateCallRequest &&
        data == other.data &&
        membersLimit == other.membersLimit &&
        notify == other.notify &&
        ring == other.ring &&
        video == other.video;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, membersLimit.hashCode);
    _$hash = $jc(_$hash, notify.hashCode);
    _$hash = $jc(_$hash, ring.hashCode);
    _$hash = $jc(_$hash, video.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetOrCreateCallRequest')
          ..add('data', data)
          ..add('membersLimit', membersLimit)
          ..add('notify', notify)
          ..add('ring', ring)
          ..add('video', video))
        .toString();
  }
}

class GetOrCreateCallRequestBuilder
    implements Builder<GetOrCreateCallRequest, GetOrCreateCallRequestBuilder> {
  _$GetOrCreateCallRequest? _$v;

  CallRequestBuilder? _data;
  CallRequestBuilder get data => _$this._data ??= CallRequestBuilder();
  set data(CallRequestBuilder? data) => _$this._data = data;

  int? _membersLimit;
  int? get membersLimit => _$this._membersLimit;
  set membersLimit(int? membersLimit) => _$this._membersLimit = membersLimit;

  bool? _notify;
  bool? get notify => _$this._notify;
  set notify(bool? notify) => _$this._notify = notify;

  bool? _ring;
  bool? get ring => _$this._ring;
  set ring(bool? ring) => _$this._ring = ring;

  bool? _video;
  bool? get video => _$this._video;
  set video(bool? video) => _$this._video = video;

  GetOrCreateCallRequestBuilder() {
    GetOrCreateCallRequest._defaults(this);
  }

  GetOrCreateCallRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data?.toBuilder();
      _membersLimit = $v.membersLimit;
      _notify = $v.notify;
      _ring = $v.ring;
      _video = $v.video;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetOrCreateCallRequest other) {
    _$v = other as _$GetOrCreateCallRequest;
  }

  @override
  void update(void Function(GetOrCreateCallRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetOrCreateCallRequest build() => _build();

  _$GetOrCreateCallRequest _build() {
    _$GetOrCreateCallRequest _$result;
    try {
      _$result = _$v ??
          _$GetOrCreateCallRequest._(
            data: _data?.build(),
            membersLimit: membersLimit,
            notify: notify,
            ring: ring,
            video: video,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        _data?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetOrCreateCallRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
