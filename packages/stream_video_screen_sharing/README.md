## Stream Video Screen Sharing
This plugin includes a native Swift implementation of `BroadcastSampleHandler`, essential for the `broadcast` screen sharing mode on iOS. For more information, you can refer to the relevant documentation [here](https://getstream.io/video/docs/flutter/advanced/screen_sharing/#ios).

The broadcast share has two sides:

- **This package**, linked into the app's broadcast upload extension target. `BroadcastSampleHandler` sends the captured frames over a socket in the app group container and posts a Darwin notification when the broadcast starts and stops.
- **`stream_webrtc_flutter`**, in the app. It receives the frames and turns the Darwin notifications into the `onScreenSharingStarted` and `onScreenSharingStopped` platform events.

The extension cannot link the WebRTC plugin, so each side has its own copy of the notification names: `io.getstream.video.screen_sharing.broadcastStarted` and `io.getstream.video.screen_sharing.broadcastStopped`.

This package has no Dart API.
