// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_client_event_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportClientEventRequest {
  List<ClientEvent> get events;

  /// Create a copy of ReportClientEventRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportClientEventRequestCopyWith<ReportClientEventRequest> get copyWith =>
      _$ReportClientEventRequestCopyWithImpl<ReportClientEventRequest>(
        this as ReportClientEventRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReportClientEventRequest &&
            const DeepCollectionEquality().equals(other.events, events));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(events));

  @override
  String toString() {
    return 'ReportClientEventRequest(events: $events)';
  }
}

/// @nodoc
abstract mixin class $ReportClientEventRequestCopyWith<$Res> {
  factory $ReportClientEventRequestCopyWith(
    ReportClientEventRequest value,
    $Res Function(ReportClientEventRequest) _then,
  ) = _$ReportClientEventRequestCopyWithImpl;
  @useResult
  $Res call({List<ClientEvent> events});
}

/// @nodoc
class _$ReportClientEventRequestCopyWithImpl<$Res>
    implements $ReportClientEventRequestCopyWith<$Res> {
  _$ReportClientEventRequestCopyWithImpl(this._self, this._then);

  final ReportClientEventRequest _self;
  final $Res Function(ReportClientEventRequest) _then;

  /// Create a copy of ReportClientEventRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? events = null}) {
    return _then(
      ReportClientEventRequest(
        events: null == events
            ? _self.events
            : events // ignore: cast_nullable_to_non_nullable
                  as List<ClientEvent>,
      ),
    );
  }
}
