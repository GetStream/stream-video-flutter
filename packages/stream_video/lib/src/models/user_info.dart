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

  @override
  String toString() => '$id $name $imageUrl $extraData';
}
