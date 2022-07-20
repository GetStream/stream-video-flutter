PROTO_DIR=/usr/local/Cellar/protobuf/3.19.4/include
protoc --tart_out=paths=source_relative:./stream_video_dart/lib/protobuf \
                --dart_out=./stream_video_dart/lib/protobuf $PROTO_DIR/google/protobuf/timestamp.proto $PROTO_DIR/google/protobuf/duration.proto $PROTO_DIR/google/protobuf/timestamp.proto $PROTO_DIR/google/protobuf/struct.proto $PROTO_DIR/google/protobuf/wrappers.proto \
                -I ./protobuf/ \
                ./protobuf/*/*.proto