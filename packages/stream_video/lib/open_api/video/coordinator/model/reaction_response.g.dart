// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReactionResponse extends ReactionResponse {
  @override
  final BuiltMap<String, JsonObject?>? custom;
  @override
  final String? emojiCode;
  @override
  final String type;
  @override
  final UserResponse user;

  factory _$ReactionResponse(
          [void Function(ReactionResponseBuilder)? updates]) =>
      (ReactionResponseBuilder()..update(updates))._build();

  _$ReactionResponse._(
      {this.custom, this.emojiCode, required this.type, required this.user})
      : super._();
  @override
  ReactionResponse rebuild(void Function(ReactionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReactionResponseBuilder toBuilder() =>
      ReactionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReactionResponse &&
        custom == other.custom &&
        emojiCode == other.emojiCode &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, emojiCode.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReactionResponse')
          ..add('custom', custom)
          ..add('emojiCode', emojiCode)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class ReactionResponseBuilder
    implements Builder<ReactionResponse, ReactionResponseBuilder> {
  _$ReactionResponse? _$v;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  String? _emojiCode;
  String? get emojiCode => _$this._emojiCode;
  set emojiCode(String? emojiCode) => _$this._emojiCode = emojiCode;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  ReactionResponseBuilder() {
    ReactionResponse._defaults(this);
  }

  ReactionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _custom = $v.custom?.toBuilder();
      _emojiCode = $v.emojiCode;
      _type = $v.type;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReactionResponse other) {
    _$v = other as _$ReactionResponse;
  }

  @override
  void update(void Function(ReactionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReactionResponse build() => _build();

  _$ReactionResponse _build() {
    _$ReactionResponse _$result;
    try {
      _$result = _$v ??
          _$ReactionResponse._(
            custom: _custom?.build(),
            emojiCode: emojiCode,
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'ReactionResponse', 'type'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        _custom?.build();

        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReactionResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
