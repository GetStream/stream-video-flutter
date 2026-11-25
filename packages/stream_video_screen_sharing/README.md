## Stream Video Screen Sharing
This plugin includes a native Swift implementation of `BroadcastSampleHandler`, essential for the `broadcast` screen sharing mode on iOS. For more information, you can refer to the relevant documentation [here](https://getstream.io/video/docs/flutter/advanced/screen_sharing/#ios).

The broadcast share has two sides:

- **This package**, linked into the app's broadcast upload extension target. `BroadcastSampleHandler` captures the screen and sends the frames to the app.
- **`stream_webrtc_flutter`**, in the app. It receives the frames and reports when the broadcast starts and stops.

This package has no Dart API.
