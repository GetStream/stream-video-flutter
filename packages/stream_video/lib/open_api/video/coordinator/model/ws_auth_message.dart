//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/connect_user_details_request.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ws_auth_message.g.dart';

/// Websocket auth message
///
/// Properties:
/// * [products]
/// * [token]
/// * [userDetails]
@BuiltValue()
abstract class WSAuthMessage
    implements Built<WSAuthMessage, WSAuthMessageBuilder> {
  @BuiltValueField(wireName: r'products')
  BuiltList<String>? get products;

  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'user_details')
  ConnectUserDetailsRequest get userDetails;

  WSAuthMessage._();

  factory WSAuthMessage([void updates(WSAuthMessageBuilder b)]) =
      _$WSAuthMessage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WSAuthMessageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WSAuthMessage> get serializer =>
      _$WSAuthMessageSerializer();
}

class _$WSAuthMessageSerializer implements PrimitiveSerializer<WSAuthMessage> {
  @override
  final Iterable<Type> types = const [WSAuthMessage, _$WSAuthMessage];

  @override
  final String wireName = r'WSAuthMessage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WSAuthMessage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.products != null) {
      yield r'products';
      yield serializers.serialize(
        object.products,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'user_details';
    yield serializers.serialize(
      object.userDetails,
      specifiedType: const FullType(ConnectUserDetailsRequest),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WSAuthMessage object, {
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
    required WSAuthMessageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'products':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.products.replace(valueDes);
          break;
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        case r'user_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ConnectUserDetailsRequest),
          ) as ConnectUserDetailsRequest;
          result.userDetails.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WSAuthMessage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WSAuthMessageBuilder();
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
