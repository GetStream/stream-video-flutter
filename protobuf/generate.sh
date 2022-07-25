#! /bin/bash

find . -name '*.proto' \
  -exec protoc -I=. \
  --twirp_out=paths=source_relative:. \
  --go_out=paths=source_relative:. \
  --validate_opt=paths=source_relative \
  --validate_out=lang=go:. \
  {} \;