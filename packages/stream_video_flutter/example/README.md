# Stream Video Flutter Example App

This example app showcases core features of the [Stream Video Flutter](https://pub.dev/packages/stream_video_flutter) package. It's a great starting point to see how the Stream Video SDK works in real-world scenarios.

For a more advanced example of how to use the Stream Video Flutter package, check out the [dogfooding app here](https://github.com/GetStream/stream-video-flutter/tree/main/dogfooding).

## Features

- **Video calls**: Explore core calling functionality.
    - Create or join a meeting (with or without a lobby).
    - Make direct calls to other users (with CallKit/ringing integration; calls work in the background).

> Note: In this example, ringing does not work when the app is terminated. For a more robust implementation of ringing with background capabilities, see the [dogfooding app](https://github.com/GetStream/stream-video-flutter/tree/main/dogfooding).

## Prerequisites

- Flutter installed and available on your PATH
- A connected device or simulator/emulator

## Getting Started

To set up and run the app, follow these steps:

1. Clone the repository and install dependencies
First, clone the repository to your local machine and install the required Flutter packages:

```bash
git clone https://github.com/GetStream/stream-video-flutter.git
cd stream-video-flutter/packages/stream_video_flutter/example
flutter pub get
```

2. Run the example
Once the setup is complete, you can run the app using Flutter:

```bash
flutter run
```

The app should now launch on your connected device or simulator.

## License

```
Copyright (c) 2014-2024 Stream.io Inc. All rights reserved.

Licensed under the Stream License;
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   https://github.com/GetStream/stream-video-flutter/blob/main/LICENSE

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## Links

- Package on pub.dev: https://pub.dev/packages/stream_video_flutter
- Docs: https://getstream.io/video/docs/flutter/
- Advanced example (dogfooding app): https://github.com/GetStream/stream-video-flutter/tree/main/dogfooding