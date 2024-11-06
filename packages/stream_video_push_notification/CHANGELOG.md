## 0.6.0

🔄 Dependency updates
* Updated firebase dependencies to fix Xcode 16 build issues

## 0.5.5
* Sync version with `stream_video_flutter` 0.5.5

## 0.5.4

* Dependency updates
    * **Flutter SDK** constraint updated to >=3.22.0 (**Dart SDK** to >=3.4.0 <4.0.0)
    * **json_annotation** updated from ^4.8.0 to ^4.9.0
    * **firebase_core updated** from ^2.15.1 to ^3.4.0
    * **firebase_messaging** updated from ^14.5.0 to ^15.1.1

## 0.5.3
* Sync version with `stream_video_flutter` 0.5.3

## 0.5.2

🐞 Fixed
* Fixed CallKit integration on iOS when app is in a terminated state. It now correctly openes the app when the call is accepted.

## 0.5.1
* Sync version with `stream_video_flutter` 0.5.1

## 0.5.0

🐞 Fixed
* Fixed an issue where the microphone was being muted when the app was running in the background on Android versions greater than 14.

## 0.4.4
* Sync version with `stream_video_flutter` 0.4.4

## 0.4.3

✅ Added

- CallKit now displays appropriate video and audio call labels.

## 0.4.2
* Sync version with `stream_video_flutter` 0.4.2

## 0.4.1
* Sync version with `stream_video_flutter` 0.4.1

## 0.4.0

🚧 Breaking changes
* Updated minimum supported dart SDK version to `3.3.0` (which requires min Flutter SDK `3.19.0`)

## 0.3.9
* Sync version with `stream_video_flutter` 0.3.9

## 0.3.8
* Sync version with `stream_video_flutter` 0.3.8

## 0.3.7
* Updated minimum supported SDK version to Flutter 3.16

## 0.3.6
* Sync version with `stream_video_flutter` 0.3.6

## 0.3.5
* Sync version with `stream_video_flutter` 0.3.5

## 0.3.4
* Sync version with `stream_video_flutter` 0.3.4

## 0.3.3

* Added `StreamCallType` class that replaces depricated String `type` parameter

## 0.3.2

🐞 Fixed

* Various fixes to call ringing and push notifications.
- Fixes call ringing cancellation when app is terminated on iOS (requires additional setup - check Step 6 of the [APNS integration](https://getstream.io/video/docs/flutter/advanced/ringing_and_callkit/#integrating-apns-for-ios)) in our documentation.
- Fixes late push notification handling on Android, where already ended call was ringing if the device was offline and the push was delivered with a delay.
- Fixes call ringing cancellation when caller timed out while calling
* Fixed action tap callback on Android call notification.

## 0.3.1

* Important: Fixes crash for CallKit on iOS.

## 0.3.0

✅ Added

* `callerCustomizationCallback` to `StreamVideoPushNotificationManager` that allow dynamic customization of CallKit call screen.

Example usage:
```dart
pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
    ...
    callerCustomizationCallback: ({required callCid, callerHandle, callerName}) =>
          CallerCustomizationResponse(name: "Customized $callerName"),
    ),
```

🐞 Fixed

* Fixed ringing call cancellation issues.

🚧 Breaking changes

* Removed the `incomingCallerNameOverride` and `incomingCallerHandlerOverride` from `StreamVideoPushParams` in favor of the new `callerCustomizationCallback` in `StreamVideoPushNotificationManager`.

## 0.2.0

 ✅ Added

 * `incomingCallerNameOverride` and `incomingCallerHandlerOverride` to `StreamVideoPushParams` to allow customization of CallKit call screen
 * `participantsAvatarBuilder` and `participantsDisplayNameBuilder` to `StreamOutgoingCallContent` and `StreamIncomingCallContent` to allow customiztion of Incoming and Outgoing call screens

Example usage:
 ```dart
 StreamCallContainer(
    ...
    outgoingCallBuilder: (context, call, callState) =>
            StreamOutgoingCallContent(
                call: call,
                callState: callState,
                participantsDisplayNameBuilder:
                    (context, call, callState, participants) => your widget here,
            ),
 )
 ```

 🐞 Fixed

 * App icon in CallKit screen is now visible in dedicated button when correctly configured.

## 0.1.1

* Aligned version with other Stream Video packages

## 0.1.0

* Added helper class for iOS native push initialization
* Fixes for iOS CallKit implementation
* Fixes for Android ringing implementation
* Added event listeners for call state changes

## 0.0.4

* Updated minimum supported `SDK` version to Flutter 3.10/Dart 3.0
* Updated `stream_video` dependency to [`0.0.3`](https://pub.dev/packages/stream_video/changelog).

## 0.0.3

* Adds ability to update provider names for Firebase and APNS

## 0.0.2

* Updates for backend

## 0.0.1

* Initial beta release of Stream Video 🚀 
