//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/frame_recording_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/egress_rtmp_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/egress_hls_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'egress_response.g.dart';

/// EgressResponse
///
/// Properties:
/// * [broadcasting]
/// * [frameRecording]
/// * [hls]
/// * [rtmps]
@BuiltValue()
abstract class EgressResponse
    implements Built<EgressResponse, EgressResponseBuilder> {
  @BuiltValueField(wireName: r'broadcasting')
  bool get broadcasting;

  @BuiltValueField(wireName: r'frame_recording')
  FrameRecordingResponse? get frameRecording;

  @BuiltValueField(wireName: r'hls')
  EgressHLSResponse? get hls;

  @BuiltValueField(wireName: r'rtmps')
  BuiltList<EgressRTMPResponse> get rtmps;

  EgressResponse._();

  factory EgressResponse([void updates(EgressResponseBuilder b)]) =
      _$EgressResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EgressResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EgressResponse> get serializer =>
      _$EgressResponseSerializer();
}

class _$EgressResponseSerializer
    implements PrimitiveSerializer<EgressResponse> {
  @override
  final Iterable<Type> types = const [EgressResponse, _$EgressResponse];

  @override
  final String wireName = r'EgressResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EgressResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'broadcasting';
    yield serializers.serialize(
      object.broadcasting,
      specifiedType: const FullType(bool),
    );
    if (object.frameRecording != null) {
      yield r'frame_recording';
      yield serializers.serialize(
        object.frameRecording,
        specifiedType: const FullType(FrameRecordingResponse),
      );
    }
    if (object.hls != null) {
      yield r'hls';
      yield serializers.serialize(
        object.hls,
        specifiedType: const FullType(EgressHLSResponse),
      );
    }
    yield r'rtmps';
    yield serializers.serialize(
      object.rtmps,
      specifiedType: const FullType(BuiltList, [FullType(EgressRTMPResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EgressResponse object, {
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
    required EgressResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'broadcasting':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.broadcasting = valueDes;
          break;
        case r'frame_recording':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FrameRecordingResponse),
          ) as FrameRecordingResponse;
          result.frameRecording.replace(valueDes);
          break;
        case r'hls':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EgressHLSResponse),
          ) as EgressHLSResponse;
          result.hls.replace(valueDes);
          break;
        case r'rtmps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(EgressRTMPResponse)]),
          ) as BuiltList<EgressRTMPResponse>;
          result.rtmps.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EgressResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EgressResponseBuilder();
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
