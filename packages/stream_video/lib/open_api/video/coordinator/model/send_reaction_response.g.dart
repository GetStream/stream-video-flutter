// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_reaction_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SendReactionResponse extends SendReactionResponse {
  @override
  final String duration;
  @override
  final ReactionResponse reaction;

  factory _$SendReactionResponse(
          [void Function(SendReactionResponseBuilder)? updates]) =>
      (SendReactionResponseBuilder()..update(updates))._build();

  _$SendReactionResponse._({required this.duration, required this.reaction})
      : super._();
  @override
  SendReactionResponse rebuild(
          void Function(SendReactionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SendReactionResponseBuilder toBuilder() =>
      SendReactionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SendReactionResponse &&
        duration == other.duration &&
        reaction == other.reaction;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, reaction.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SendReactionResponse')
          ..add('duration', duration)
          ..add('reaction', reaction))
        .toString();
  }
}

class SendReactionResponseBuilder
    implements Builder<SendReactionResponse, SendReactionResponseBuilder> {
  _$SendReactionResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  ReactionResponseBuilder? _reaction;
  ReactionResponseBuilder get reaction =>
      _$this._reaction ??= ReactionResponseBuilder();
  set reaction(ReactionResponseBuilder? reaction) =>
      _$this._reaction = reaction;

  SendReactionResponseBuilder() {
    SendReactionResponse._defaults(this);
  }

  SendReactionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _reaction = $v.reaction.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SendReactionResponse other) {
    _$v = other as _$SendReactionResponse;
  }

  @override
  void update(void Function(SendReactionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SendReactionResponse build() => _build();

  _$SendReactionResponse _build() {
    _$SendReactionResponse _$result;
    try {
      _$result = _$v ??
          _$SendReactionResponse._(
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'SendReactionResponse', 'duration'),
            reaction: reaction.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reaction';
        reaction.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SendReactionResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
