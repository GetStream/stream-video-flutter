# Dogfooding

This is a Dogfooding App - demo application built using the [Stream Video Flutter](https://pub.dev/packages/stream_video_flutter) package. It showcases the core features of the package and serves as an internal testing tool for the Stream team. It's a great starting point to explore how the Stream Video SDK works in real-world scenarios.

## Features

- **Video Calls**: Test various aspects of video call functionality.
    - Create or join a video meeting.
    - Make direct calls to other users with ringing.

- **Screen Sharing**: Experience seamless screen sharing between participants.

- **Picture-in-Picture (PiP)**: Test Picture-in-Picture mode on both iOS and Android devices.

- **Chat Integration**: Send and receive messages during calls.

- **Testing Ground**: Used by Stream developers for feature validation and bug testing.

## Getting Started

To set up and run the app, follow these steps:

1. Clone the repo and install the dependencies
First, clone the repository to your local machine and install the required Flutter packages:

```bash
git clone https://github.com/GetStream/stream-video-flutter.git
cd stream-video-flutter/dogfooding
flutter pub get
```

2. (iOS setup) Open iOS project in Xcode

```bash
cd ios
open Runner.xcworkspace
```

3. (iOS setup) Update the Bundle Identifier and Configure Signing

- In Xcode, go to the Signing & Capabilities tab.
- Under Team, select your own development team.
- Update the bundle identifier for both Runner and ScreenSharing targets to something unique:
    - Example: `com.yourname.StreamDogfooding`
    - Example (ScreenSharing): com.yourname.StreamDogfooding.ScreenSharing
- Update the App Group for both targets:
    - Remove the existing group.
    - Create a new app group based on your updated bundle identifier.
    - Example: `group.com.yourname.StreamDogfooding`

4. Run the app
Once the setup is complete, you can run the app using Flutter:

```bash
## Ensure you're in the dogfooding directory
flutter run
```

The app should now launch on your connected device or simulator.

:::note
When logging in with an email address, note that the user_id for the created user will automatically replace the `@` and `.` characters with underscores (`_`).

For example, if you log in with `test@test.com`, the corresponding `user_id` will be `test_test_com`.

This is crucial to keep in mind, especially when testing direct calls, as you'll need to reference the correct `user_id`.
:::

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