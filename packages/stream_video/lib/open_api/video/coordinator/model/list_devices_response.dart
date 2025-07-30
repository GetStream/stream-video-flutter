//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/device_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'list_devices_response.g.dart';

/// List devices response
///
/// Properties:
/// * [devices] - List of devices
/// * [duration]
@BuiltValue()
abstract class ListDevicesResponse
    implements Built<ListDevicesResponse, ListDevicesResponseBuilder> {
  /// List of devices
  @BuiltValueField(wireName: r'devices')
  BuiltList<DeviceResponse> get devices;

  @BuiltValueField(wireName: r'duration')
  String get duration;

  ListDevicesResponse._();

  factory ListDevicesResponse([void updates(ListDevicesResponseBuilder b)]) =
      _$ListDevicesResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListDevicesResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListDevicesResponse> get serializer =>
      _$ListDevicesResponseSerializer();
}

class _$ListDevicesResponseSerializer
    implements PrimitiveSerializer<ListDevicesResponse> {
  @override
  final Iterable<Type> types = const [
    ListDevicesResponse,
    _$ListDevicesResponse
  ];

  @override
  final String wireName = r'ListDevicesResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListDevicesResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'devices';
    yield serializers.serialize(
      object.devices,
      specifiedType: const FullType(BuiltList, [FullType(DeviceResponse)]),
    );
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListDevicesResponse object, {
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
    required ListDevicesResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'devices':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(DeviceResponse)]),
          ) as BuiltList<DeviceResponse>;
          result.devices.replace(valueDes);
          break;
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListDevicesResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListDevicesResponseBuilder();
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
