# Dogfooding App

The Dogfooding App is built using the [Stream Video Flutter](https://pub.dev/packages/stream_video_flutter) package, designed to showcase both core and advanced features of the package. It also serves as an internal testing tool for the Stream team.

For a more basic example of how to use the Stream Video Flutter package, check out the [example app here](https://github.com/GetStream/stream-video-flutter/tree/main/packages/stream_video_flutter/example).

## Features

- **Video Calls**: Test various aspects of video call functionality.
    - Create or join a video meeting.
    - Make direct calls to other users with ringing.

- **Screen Sharing**: Experience seamless screen sharing between participants.

- **Picture-in-Picture (PiP)**: Test Picture-in-Picture mode on both iOS and Android devices.

- **Chat Integration**: Send and receive messages during calls.

- **Testing Ground**: Used by Stream developers for feature validation and bug testing.

- **Closed Captions**: Test closed captions during video calls.

## Getting Started

Follow these steps to set up and run the app:

### 1. Clone the Repository & Install Dependencies

First, clone the repository and install the required Flutter packages:

```bash
git clone https://github.com/GetStream/stream-video-flutter.git
cd stream-video-flutter/dogfooding
flutter pub get
```

### 2. iOS Setup

#### Open the iOS Project in Xcode

```bash
cd ios
open Runner.xcworkspace
```

#### Update the Bundle Identifier & Configure Signing

- In Xcode, go to the **Signing & Capabilities** tab.
- Under **Team**, select your development team.
- Update the **Bundle Identifier** for both `Runner` and `ScreenSharing` targets:
    - Example: `com.yourname.StreamDogfooding`
    - Example (ScreenSharing): `com.yourname.StreamDogfooding.ScreenSharing`
- Update the **App Group** for both targets:
    - Remove the existing group.
    - Create a new app group based on your updated bundle identifier.
    - Example: `group.com.yourname.StreamDogfooding`

### 3. macOS Setup

To run the macOS app the FlutterFire CLI tool needs to be installed. Install using:

```bash
dart pub global activate flutterfire_cli
```

### 4. Android setup

Please ensure that you have JDK version 17 or lower installed on your machine. The build process may fail with JDK versions higher than 17.

If you have multiple JDK versions installed, you can specify which version to use by running the following command:

```bash
## Ensure you're in the dogfooding directory
flutter config --jdk-dir="path/to/jdk"
```

You can also try setting the JDK path in the `gradle.properties` file:

```properties
## Located in the dogfooding/android directory
org.gradle.java.home=/path/to/jdk
```

Run `clean` and `doctor` commands to ensure everything is set up correctly:

```bash
## Ensure you're in the dogfooding directory
flutter clean
flutter doctor -v
```

In the output go to the `Android toolchain` section and ensure that the JDK version is correct.

### 5. Run the app

Once the setup is complete, launch the app:

```bash
## Ensure you're in the dogfooding directory
flutter run
```

The app should now start on your connected device or simulator.

### 6. Important notes

#### Email-Based Login & User ID Conversion

When logging in with an email, the user_id automatically replaces @ and . with underscores (_).
For example:

- Email: test@test.com
- User ID: test_test_com

This is crucial for testing direct calls, as you'll need to reference the correct user_id.

## Custom Environment Setup

The **Dogfooding** app is primarily for Stream employees to test the Video SDK internally. You can use one of our environments (prefereably `demo` which is most stable one) for testing, however, it is recommended to configure a custom environment if you have a **Stream app** created in the **Stream Dashboard**.

With **Dogfooding** connected yo your own **Stream app** you will have access to full configuration as well as **Call Stats**, **Events Logs** etc.

Additionaly **APN Push Provider** used for ringing on **iOS devices** is tied to the iOS app **bundle identifier**. Since you will have to change the identifier to run the Dogfooding app using your own Apple Developer account, ringing won't work on iOS with the default environments.
Using your **Stream app** will allow you to create an iOS certificate and APN provider configuration bound to your bundle ID and fully experience the ringing flow.

### Steps to Set Up a Custom Environment

1. Modify the `custom_environment_loader.dart` file:
    - Replace the global variable `customEnvironmentLoader` with your own `CustomEnvironmentLoader` implementation.
    - This should return hardcoded tokens or fetch tokens from your backend.
    - You can manually generate tokens using [this form](https://getstream.io/chat/docs/flutter-dart/tokens_and_authentication/#manually-generating-tokens).

2. Run the Dogfooding App:
    - On the login page, select `custom` from the environment switcher in the top-right corner.

3. Set Up Push Providers (if not configured yet):
    - [Firebase Push Provider for Android](https://getstream.io/video/docs/flutter/advanced/incoming-calls/providers-configuration/#creating-firebase-provider)
    - [APN Push Provider for iOS](https://getstream.io/video/docs/flutter/advanced/incoming-calls/providers-configuration/#creating-apns-provider)

4. Update Push Providers in `injector.dart`: 
    - Replace the default provider names in the `_initStreamVideo()` method with the ones you created.

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