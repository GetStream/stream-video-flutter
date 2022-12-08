# Stream Video Flutter

Stream Video repository for Flutter.

# Getting started

Make sure you cloned and followed the instructions to run the backend stack in those repositories

- [video-sfu](https://github.com/GetStream/video-sfu)
- [video](https://github.com/GetStream/video)

```bash
video$ APP_CONFIG_FILE=./configs/local.yaml go run cmd/coordinator/main.go
video_sfu$ go run cmd/video-sfu/main.go
ngrok http 26991 #note the url
```

Once it's done, when instantiating the client `main.dart`, replace those endpoints:

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

If you are developing with a physical device (recommended), make sure it's connected to the same WiFi as your laptop.

Finally, you can run the Flutter sample app in `stream_video/packages/stream_video_flutter`

# Generating protobuf

Go to the [video-proto](https://github.com/GetStream/video-proto) backend repository and follow the instructions there to install the proto dependencies. Once it's done, this is the command (depending on where is your Flutter projects folder) I use to generate the protos in the `stream_video` package:

```bash
video_proto$ sh generate.sh dart ~/flutter-dev/stream-video-flutter/packages/stream_video/lib/protobuf
```

# Possible Issues One Can Facing

## Token expiring

If this happens, in the example, you need to update the `example/lib/demo_users` tokens using the command from the coordinator repository:

```bash
video$ ctl auth token key1 secret1 <user_id>
```
