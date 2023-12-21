## Upcoming

* Added `custom` field to `CallParticipantState` with custom user data.

## 0.3.1

* Important: Fixes crash for CallKit on iOS.
* Added support for SFU migration to improve video resilience.
* Fixes for streaming flags in `CallState` (backstage, broadcasting, recording).

## 0.3.0

🚧 Breaking changes 

* The functionality from `stream_video_flutter_background` is now merged into `stream_video_flutter`. You no longer have to use the background plugin.
* Removed the `incomingCallerNameOverride` and `incomingCallerHandlerOverride` from `StreamVideoPushParams` in favor of the new `callerCustomizationCallback` in `StreamVideoPushNotificationManager`.

✅ Added

* Added `LivestreamPlayer` - a in-built widget that allows you to easily view livestreams.
* Added screen sharing functionality and related toggle option for both Android and iOS. Check [our documentation](https://getstream.io/video/docs/flutter/) for more details
* Exposed call coordinator events through the `coordinatorEvents` stream in the `Call` class.
* Added `StreamCallContentTheme` to video theme.
* `callerCustomizationCallback` to `StreamVideoPushNotificationManager` that allow dynamic customization of CallKit call screen.

Example usage:

```dart
pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
    ...
    callerCustomizationCallback: ({required callCid, callerHandle, callerName}) =>
          CallerCustomizationResponse(name: "Customized $callerName"),
    ),
```

* Added a `includeUserDetails` field to determine if user details should be passed to backend when connecting user.
* Added `team`, `notify`, and `custom` properties to `getOrCreate()` for `Call`.

🐞 Fixed

* Added Apple audio configuration to make audio work in silent mode.
* Fixed ringing call cancellation issues.

## 0.2.0

✅ Added

* `removeMembers` and `updateCallMembers` to `Call`
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

🔄 Changed

Breaking changes 🚧
* renamed `inviteUsers` to `addMembers` in `Call`
* renamed parameter name in `getOrCreateCall` from `participantIds` to `memberIds`

## 0.1.1

* Fixed call join bug
* Fixed CallKit call not ending bug
* Anonymous users can no longer connect to WS
* Users can no longer join a call twice
* Fixed landscape call control visibility

## 0.1.0

* Aligned SDK initialization with other SDKs
* Fixed callkit and push implementation for SDK
* Added parsing for CallPermissions
* Fix duplicate participants in call
* Hide debug stats in production
* Display call participants in lobby view
* General bug fixes and improvements

## 0.0.4

* Updated minimum supported `SDK` version to Flutter 3.10/Dart 3.0

## 0.0.3

* Fixed track subscription bug

## 0.0.2

* Updates for backend
* Support for reactions

## 0.0.1+1

* Fixed README

## 0.0.1

* Initial beta release of Stream Video 🚀
