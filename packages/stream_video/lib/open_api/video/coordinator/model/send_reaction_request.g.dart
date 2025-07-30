// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_reaction_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SendReactionRequest extends SendReactionRequest {
  @override
  final BuiltMap<String, JsonObject?>? custom;
  @override
  final String? emojiCode;
  @override
  final String type;

  factory _$SendReactionRequest(
          [void Function(SendReactionRequestBuilder)? updates]) =>
      (SendReactionRequestBuilder()..update(updates))._build();

  _$SendReactionRequest._({this.custom, this.emojiCode, required this.type})
      : super._();
  @override
  SendReactionRequest rebuild(
          void Function(SendReactionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SendReactionRequestBuilder toBuilder() =>
      SendReactionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SendReactionRequest &&
        custom == other.custom &&
        emojiCode == other.emojiCode &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, emojiCode.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SendReactionRequest')
          ..add('custom', custom)
          ..add('emojiCode', emojiCode)
          ..add('type', type))
        .toString();
  }
}

class SendReactionRequestBuilder
    implements Builder<SendReactionRequest, SendReactionRequestBuilder> {
  _$SendReactionRequest? _$v;

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

  SendReactionRequestBuilder() {
    SendReactionRequest._defaults(this);
  }

  SendReactionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _custom = $v.custom?.toBuilder();
      _emojiCode = $v.emojiCode;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SendReactionRequest other) {
    _$v = other as _$SendReactionRequest;
  }

  @override
  void update(void Function(SendReactionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SendReactionRequest build() => _build();

  _$SendReactionRequest _build() {
    _$SendReactionRequest _$result;
    try {
      _$result = _$v ??
          _$SendReactionRequest._(
            custom: _custom?.build(),
            emojiCode: emojiCode,
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'SendReactionRequest', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        _custom?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SendReactionRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
