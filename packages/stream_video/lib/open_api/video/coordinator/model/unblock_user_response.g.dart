// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unblock_user_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UnblockUserResponse extends UnblockUserResponse {
  @override
  final String duration;

  factory _$UnblockUserResponse(
          [void Function(UnblockUserResponseBuilder)? updates]) =>
      (UnblockUserResponseBuilder()..update(updates))._build();

  _$UnblockUserResponse._({required this.duration}) : super._();
  @override
  UnblockUserResponse rebuild(
          void Function(UnblockUserResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnblockUserResponseBuilder toBuilder() =>
      UnblockUserResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnblockUserResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'UnblockUserResponse')
          ..add('duration', duration))
        .toString();
  }
}

class UnblockUserResponseBuilder
    implements Builder<UnblockUserResponse, UnblockUserResponseBuilder> {
  _$UnblockUserResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  UnblockUserResponseBuilder() {
    UnblockUserResponse._defaults(this);
  }

  UnblockUserResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnblockUserResponse other) {
    _$v = other as _$UnblockUserResponse;
  }

  @override
  void update(void Function(UnblockUserResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnblockUserResponse build() => _build();

  _$UnblockUserResponse _build() {
    final _$result = _$v ??
        _$UnblockUserResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'UnblockUserResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
