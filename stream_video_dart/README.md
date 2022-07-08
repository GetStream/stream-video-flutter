A simple command-line application.


## Protobuf generation

in the root repo

```bash
./generate.sh
```

OR

```bash
protoc --tart_out=paths=source_relative:./client/lib/protobuf \
                --dart_out=./client/lib/protobuf \
                -I ./protobuf/ \
                ./protobuf/*/*.proto
```