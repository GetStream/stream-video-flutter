//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'start_hls_broadcasting_response.g.dart';

/// StartHLSBroadcastingResponse is the payload for starting an HLS broadcasting.
///
/// Properties:
/// * [duration]
/// * [playlistUrl] - the URL of the HLS playlist
@BuiltValue()
abstract class StartHLSBroadcastingResponse
    implements
        Built<StartHLSBroadcastingResponse,
            StartHLSBroadcastingResponseBuilder> {
  @BuiltValueField(wireName: r'duration')
  String get duration;

  /// the URL of the HLS playlist
  @BuiltValueField(wireName: r'playlist_url')
  String get playlistUrl;

  StartHLSBroadcastingResponse._();

  factory StartHLSBroadcastingResponse(
          [void updates(StartHLSBroadcastingResponseBuilder b)]) =
      _$StartHLSBroadcastingResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StartHLSBroadcastingResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StartHLSBroadcastingResponse> get serializer =>
      _$StartHLSBroadcastingResponseSerializer();
}

class _$StartHLSBroadcastingResponseSerializer
    implements PrimitiveSerializer<StartHLSBroadcastingResponse> {
  @override
  final Iterable<Type> types = const [
    StartHLSBroadcastingResponse,
    _$StartHLSBroadcastingResponse
  ];

  @override
  final String wireName = r'StartHLSBroadcastingResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StartHLSBroadcastingResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    yield r'playlist_url';
    yield serializers.serialize(
      object.playlistUrl,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StartHLSBroadcastingResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StartHLSBroadcastingResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        case r'playlist_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.playlistUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StartHLSBroadcastingResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StartHLSBroadcastingResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
