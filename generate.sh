#!/usr/bin/env bash

SOURCE_PATH=../chat

if [ ! -d $SOURCE_PATH ]
then
  echo "cannot find chat path on the parent folder (${SOURCE_PATH}), do you have a copy of the API source?";
  exit 1;
fi

set -ex

# remove old generated code
rm -rf ./packages/stream_video/lib/open_api/video/coordinator/model/*

# cd in API repo, generate new spec and then generate code from it
(
  cd $SOURCE_PATH &&
  go run ./cmd/chat-manager openapi generate-spec -products video -version v1 -clientside -output releases/video-openapi-clientside -renamed-models ../stream-video-flutter/scripts/renamed-models.json &&
  go run ./cmd/chat-manager openapi generate-client --language dart --spec ./releases/video-openapi-clientside.yaml --output ../stream-video-flutter/packages/stream_video/lib/open_api/video/coordinator/
)

melos format
