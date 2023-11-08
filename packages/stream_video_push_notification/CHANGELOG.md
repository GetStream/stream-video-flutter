## Upcoming

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
