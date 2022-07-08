protoc --tart_out=paths=source_relative:./stream_video_dart/lib/protobuf \
                --dart_out=./stream_video_dart/lib/protobuf \
                -I ./protobuf/ \
                ./protobuf/*/*.proto