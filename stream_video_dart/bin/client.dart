import 'package:stream_video_dart/protobuf/video_coordinator_rpc/coordinator_service.pbserver.dart';
import 'package:stream_video_dart/src/client/client.dart';

void main(List<String> arguments) async {
  final client = StreamVideoClient('something');
  final edgeServerResponse =
      await client.selectEdgeServer(request: SelectEdgeServerRequest());
  print("edgeServer.url ${edgeServerResponse.edgeServer.url}");
  print("token ${edgeServerResponse.token}");
}
