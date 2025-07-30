// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_call_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JoinCallRequest extends JoinCallRequest {
  @override
  final bool? create;
  @override
  final CallRequest? data;
  @override
  final String location;
  @override
  final int? membersLimit;
  @override
  final String? migratingFrom;
  @override
  final bool? notify;
  @override
  final bool? ring;
  @override
  final bool? video;

  factory _$JoinCallRequest([void Function(JoinCallRequestBuilder)? updates]) =>
      (JoinCallRequestBuilder()..update(updates))._build();

  _$JoinCallRequest._(
      {this.create,
      this.data,
      required this.location,
      this.membersLimit,
      this.migratingFrom,
      this.notify,
      this.ring,
      this.video})
      : super._();
  @override
  JoinCallRequest rebuild(void Function(JoinCallRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JoinCallRequestBuilder toBuilder() => JoinCallRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JoinCallRequest &&
        create == other.create &&
        data == other.data &&
        location == other.location &&
        membersLimit == other.membersLimit &&
        migratingFrom == other.migratingFrom &&
        notify == other.notify &&
        ring == other.ring &&
        video == other.video;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, create.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, membersLimit.hashCode);
    _$hash = $jc(_$hash, migratingFrom.hashCode);
    _$hash = $jc(_$hash, notify.hashCode);
    _$hash = $jc(_$hash, ring.hashCode);
    _$hash = $jc(_$hash, video.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JoinCallRequest')
          ..add('create', create)
          ..add('data', data)
          ..add('location', location)
          ..add('membersLimit', membersLimit)
          ..add('migratingFrom', migratingFrom)
          ..add('notify', notify)
          ..add('ring', ring)
          ..add('video', video))
        .toString();
  }
}

class JoinCallRequestBuilder
    implements Builder<JoinCallRequest, JoinCallRequestBuilder> {
  _$JoinCallRequest? _$v;

  bool? _create;
  bool? get create => _$this._create;
  set create(bool? create) => _$this._create = create;

  CallRequestBuilder? _data;
  CallRequestBuilder get data => _$this._data ??= CallRequestBuilder();
  set data(CallRequestBuilder? data) => _$this._data = data;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  int? _membersLimit;
  int? get membersLimit => _$this._membersLimit;
  set membersLimit(int? membersLimit) => _$this._membersLimit = membersLimit;

  String? _migratingFrom;
  String? get migratingFrom => _$this._migratingFrom;
  set migratingFrom(String? migratingFrom) =>
      _$this._migratingFrom = migratingFrom;

  bool? _notify;
  bool? get notify => _$this._notify;
  set notify(bool? notify) => _$this._notify = notify;

  bool? _ring;
  bool? get ring => _$this._ring;
  set ring(bool? ring) => _$this._ring = ring;

  bool? _video;
  bool? get video => _$this._video;
  set video(bool? video) => _$this._video = video;

  JoinCallRequestBuilder() {
    JoinCallRequest._defaults(this);
  }

  JoinCallRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _create = $v.create;
      _data = $v.data?.toBuilder();
      _location = $v.location;
      _membersLimit = $v.membersLimit;
      _migratingFrom = $v.migratingFrom;
      _notify = $v.notify;
      _ring = $v.ring;
      _video = $v.video;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JoinCallRequest other) {
    _$v = other as _$JoinCallRequest;
  }

  @override
  void update(void Function(JoinCallRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JoinCallRequest build() => _build();

  _$JoinCallRequest _build() {
    _$JoinCallRequest _$result;
    try {
      _$result = _$v ??
          _$JoinCallRequest._(
            create: create,
            data: _data?.build(),
            location: BuiltValueNullFieldError.checkNotNull(
                location, r'JoinCallRequest', 'location'),
            membersLimit: membersLimit,
            migratingFrom: migratingFrom,
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
            r'JoinCallRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
