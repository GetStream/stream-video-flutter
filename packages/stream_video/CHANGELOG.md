## 0.3.4
* Sync version with `stream_video_flutter` 0.3.4

## 0.3.3

* Added `StreamCallType` class that replaces depricated String `type` parameter
* Exapanded `CallStats` class with more structured WebRTC statistics as `stats` field
* Changed `raw` statistics in `CallStats` to be of a Map<Stirng, dynamic> type
* Added `publisherStats`, `subsciberStats` and `latencyHistory` to the `CallState` that hold some of the processed statistcs 

Bug fixes
* Fixes incoming call behavior when both CallKit and Stream incoming screen component is used 
* Fixes the issue on Android that caused missed call notification when ringing with reused call id

## 0.3.2

🐞 Fixed

* Various fixes to call ringing and push notifications.
- Fixes call ringing cancellation when app is terminated on iOS (requires additional setup - check Step 6 of the [APNS integration](https://getstream.io/video/docs/flutter/advanced/adding_ringing_and_callkit/#integrating-apns-for-ios)) in our documentation.
- Fixes late push notification handling on Android, where already ended call was ringing if the device was offline and the push was delivered with a delay.
- Fixes call ringing cancellation when caller timed out while calling
* Fixed action tap callback on Android call notification.
* Fixes possible crashes for Android SDKs versions <26.
* Fixed screen sharing on iOS when screen sharing mode was switched between `in-app` and `broadcast`.
* Changed the version range of `intl` package to >=0.18.1 <=0.19.0 because it was causing isses with other packages.

✅ Added

* Added `custom` field to `CallParticipantState` with custom user data.
* Added `CallType` to statically track the type of call (audio, video, screen share).

## 0.3.1

* Important: Fixes crash for CallKit on iOS.
* Added support for SFU migration to improve video resilience.
* Fixes for streaming flags in `CallState` (backstage, broadcasting, recording).

## 0.3.0

🚧 Breaking changes

* Removed the `incomingCallerNameOverride` and `incomingCallerHandlerOverride` from `StreamVideoPushParams` in favor of the new `callerCustomizationCallback` in `StreamVideoPushNotificationManager`.

✅ Added

* `callerCustomizationCallback` to `StreamVideoPushNotificationManager` that allow dynamic customization of CallKit call screen

Example usage:

```dart
pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
    ...
    callerCustomizationCallback: ({required callCid, callerHandle, callerName}) =>
          CallerCustomizationResponse(name: "Customized $callerName"),
    ),
```

* Added a `includeUserDetails` field to determine if user details should be passed to backend when connecting user.
* Exposed call coordinator events through the `coordinatorEvents` stream in the `Call` class.
* Added `team`, `notify`, and `custom` properties to `getOrCreate()` for `Call`.

🐞 Fixed

* Added Apple audio configuration to make audio work in silent mode.
* Fixes `queryCalls` response mapping.

🔄 Changed


## 0.2.0

✅ Added

* `removeMembers` and `updateCallMembers` to `Call`

🔄 Changed

Breaking changes 🚧
* renamed `inviteUsers` to `addMembers` in `Call`
* renamed parameter name in `getOrCreateCall` from `participantIds` to `memberIds`

## 0.1.1

* Fixed call join bug
* Fixed CallKit call not ending bug
* Anonymous users can no longer connect to WS
* Users can no longer join a call twice

## 0.1.0

* Aligned SDK initialization with other SDKs
* Fixed callkit and push implementation for SDK
* Added parsing for CallPermissions
* Fix duplicate participants in call
* General bug fixes and improvements

## 0.0.3

* Updated minimum supported `SDK` version to Flutter 3.10/Dart 3.0

## 0.0.2

* Updates for backend
* Support for reactions

## 0.0.1+1

* Fixed README

## 0.0.1

* Initial beta release of Stream Video 🚀
