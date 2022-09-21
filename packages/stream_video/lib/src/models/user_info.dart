import 'package:stream_video/protobuf/google/protobuf/struct.pb.dart';

class UserInfo {
  final String id;
  final String name;
  final String? imageUrl; //Uri
  final Map<String, Object?>? extraData;
  UserInfo({
    required this.id,
    required this.name,
    this.imageUrl,
    this.extraData,
  });

  // Struct? get custom => extraData; //?.toStruct();

  @override
  String toString() => '$id $name $imageUrl $extraData';
}

// extension ExtraDataX on Map<String, Object?> {
//   Struct toStruct() =>
//       Struct(fields: map((key, value) => MapEntry(key, toValue(value))));
// }

// Value toValue(Object? value) {
//   if (value is String) {
//     return Value(stringValue: value);
//   } else if (value is double) {
//     return Value(numberValue: value);
//   } else if (value == null) {
//     return Value(nullValue: value as NullValue?);
//   } else if (value is List) {
//     return Value(listValue: value as ListValue);
//   } else if (value is bool) {
//     return Value(boolValue: value);
//   }

//   return Value(structValue: value as Struct);
// }
