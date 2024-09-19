# Stream Video Flutter Example App

This is an example app built using the [Stream Video Flutter](https://pub.dev/packages/stream_video_flutter) package, designed to showcase both core features of the package. It's a great starting point to explore how the Stream Video SDK works in real-world scenarios.

For a more advanced example of how to use the Stream Video Flutter package, check out the [dogfooding app here](https://github.com/GetStream/stream-video-flutter/tree/main/dogfooding).

## Features

- **Video Calls**: Test various aspects of video call functionality.
    - Create or join a video meeting (with or without a Lobby).
    - Make direct calls to other users (without CallKit integration - only in-app ringing screen)

## Getting Started

To set up and run the app, follow these steps:

1. Clone the repo and install the dependencies
First, clone the repository to your local machine and install the required Flutter packages:

```bash
git clone https://github.com/GetStream/stream-video-flutter.git
cd stream-video-flutter/packages/stream_video_flutter/example
flutter pub get
```

2. Run the app
Once the setup is complete, you can run the app using Flutter:

```bash
## Ensure you're in the example directory
flutter run
```

The app should now launch on your connected device or simulator.

## License

```
Copyright (c) 2014-2024 Stream.io Inc. All rights reserved.

Licensed under the Stream License;
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   https://github.com/GetStream/stream-video-android/blob/main/LICENSE

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```