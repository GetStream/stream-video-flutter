# Stream Video Flutter

Stream Video repository for Flutter.

# Getting started
Make sure you cloned and followed the instructions to run the backend stack in those repositories
- video-sfu
- video
 
`video$ APP_CONFIG_FILE=./configs/local.yaml go run cmd/coordinator/main.go`
`video_sfu$ go run cmd/video-sfu/main.go`
`ngrok http 26991` note the url

Once, it's done when instantiating the client `main.dart`, replace those endpoints:
```dart
  final client = StreamVideoClient(
    'key1',
    coordinatorUrl: //replace with the url obtained with ngrok http 26991 previously
        'http://05a8-2a01-cb20-87c-f00-710c-711a-2bbb-ef5.ngrok.io/rpc',
    coordinatorWs: //replace host with your local ip address
        'ws://192.168.1.17:8989/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
    //replace host with your local ip address
    sfuUrl: 'http://192.168.1.17:3031/twirp',
  );
```


# Generating protobuf
Go to the video-proto backend and follow the instructions to install the proto dependencies. Once it's done this is the command I use to generate the protos in the stream_video package:
`video_proto$ sh generate.sh dart ~/flutter-dev/stream-video-flutter/packages/stream_video/lib/protobuf`


# Possible Issues One Can Facing

## Token expiring 
If this happens, in the example, you need to update the `example/lib/demo_users` tokens using the command from the coordinator repo:
`video$ ctl auth token key1 secret1 <user_id>`