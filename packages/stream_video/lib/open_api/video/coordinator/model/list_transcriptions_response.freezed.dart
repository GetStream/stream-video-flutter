// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_transcriptions_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListTranscriptionsResponse {
  String get duration;
  List<CallTranscription> get transcriptions;

  /// Create a copy of ListTranscriptionsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ListTranscriptionsResponseCopyWith<ListTranscriptionsResponse>
  get copyWith =>
      _$ListTranscriptionsResponseCopyWithImpl<ListTranscriptionsResponse>(
        this as ListTranscriptionsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListTranscriptionsResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(
              other.transcriptions,
              transcriptions,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(transcriptions),
  );

  @override
  String toString() {
    return 'ListTranscriptionsResponse(duration: $duration, transcriptions: $transcriptions)';
  }
}

/// @nodoc
abstract mixin class $ListTranscriptionsResponseCopyWith<$Res> {
  factory $ListTranscriptionsResponseCopyWith(
    ListTranscriptionsResponse value,
    $Res Function(ListTranscriptionsResponse) _then,
  ) = _$ListTranscriptionsResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<CallTranscription> transcriptions});
}

/// @nodoc
class _$ListTranscriptionsResponseCopyWithImpl<$Res>
    implements $ListTranscriptionsResponseCopyWith<$Res> {
  _$ListTranscriptionsResponseCopyWithImpl(this._self, this._then);

  final ListTranscriptionsResponse _self;
  final $Res Function(ListTranscriptionsResponse) _then;

  /// Create a copy of ListTranscriptionsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? transcriptions = null}) {
    return _then(
      ListTranscriptionsResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        transcriptions: null == transcriptions
            ? _self.transcriptions
            : transcriptions // ignore: cast_nullable_to_non_nullable
                  as List<CallTranscription>,
      ),
    );
  }
}
