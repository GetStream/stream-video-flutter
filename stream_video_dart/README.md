A simple command-line application.


## Protobuf generation

cd in example

protoc --tart_out=paths=source_relative:./client/lib/protobuf \
                --dart_out=./client/lib/protobuf \
                -I ./protobuf/ \
                ./protobuf/*/*.proto