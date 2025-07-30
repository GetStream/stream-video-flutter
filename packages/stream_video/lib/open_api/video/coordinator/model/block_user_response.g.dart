// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_user_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BlockUserResponse extends BlockUserResponse {
  @override
  final String duration;

  factory _$BlockUserResponse(
          [void Function(BlockUserResponseBuilder)? updates]) =>
      (BlockUserResponseBuilder()..update(updates))._build();

  _$BlockUserResponse._({required this.duration}) : super._();
  @override
  BlockUserResponse rebuild(void Function(BlockUserResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BlockUserResponseBuilder toBuilder() =>
      BlockUserResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlockUserResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'BlockUserResponse')
          ..add('duration', duration))
        .toString();
  }
}

class BlockUserResponseBuilder
    implements Builder<BlockUserResponse, BlockUserResponseBuilder> {
  _$BlockUserResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  BlockUserResponseBuilder() {
    BlockUserResponse._defaults(this);
  }

  BlockUserResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BlockUserResponse other) {
    _$v = other as _$BlockUserResponse;
  }

  @override
  void update(void Function(BlockUserResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BlockUserResponse build() => _build();

  _$BlockUserResponse _build() {
    final _$result = _$v ??
        _$BlockUserResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'BlockUserResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
