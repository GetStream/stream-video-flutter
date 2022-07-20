# Stream Video Flutter

## Generating Protobufs
./generate.sh

## Calling SelectEdgeServer

Make sure you have GetStream/video server up and running

```bash
cd stream_video_dart
dart bin/client.dart
```


## TODOs
- [x] twirp code generation tool
- [x] SelectEdgeServer POC
- [ ] add protobuf submodule from GetStream/video instead of copy pasting every time
- [ ] LiveKit wrapper
- [ ] Sample app using LiveKit
- [ ] Sample app using lower level WebRTC client

## Notes

protoc-gen-tart is a fork from https://github.com/syncapod/tart/tree/main/protoc-gen-tart
Had to fix it because it was pretty broken
You don't need it unless you are building it from source
