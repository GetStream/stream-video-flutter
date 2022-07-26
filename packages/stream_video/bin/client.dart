import 'package:logging/logging.dart';
import 'package:stream_video/protobuf/video_coordinator_rpc/coordinator_service.pb.dart';
import 'package:stream_video/protobuf/video_models/models.pb.dart';
import 'package:stream_video/src/client/client.dart';
import 'package:stream_video/src/core/http/token.dart';
import 'package:stream_video/src/models/models.dart';

void main(List<String> arguments) async {
  final client = StreamVideoClient('something', logLevel: Level.INFO);
  final user = User(id: "whatever");
  final token = Token(
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoid2hhdGV2ZXIifQ.ros60dPlc_0hAIc0DbGjlvHYajBevgpUyqCLzvqHB3o");
  await client.setUser(user, token: token);
  await client.connectWs();

  await client.createCall(
      id: "123",
      participantIds: [
        "whatever",
      ],
      type: StreamCallType.video);
}
