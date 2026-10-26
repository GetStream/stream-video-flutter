# dart-webrtc

A webrtc interface wrapped in dart language.

Use the [dart/js](https://pub.dev/packages/js) library to re-wrap the [webrtc](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API) js interface of the browser, to adapted common browsers.

This library will be used for [flutter-webrtc](https://github.com/flutter-webrtc/flutter-webrtc) for [flutter web](https://flutter.dev/web) plugin.

## compile E2EE worker

```bash
dart compile js ./lib/src/e2ee.worker/e2ee.worker.dart -o web/e2ee.worker.dart.js
```

## How to develop

* `git clone https://github.com/flutter-webrtc/dart-webrtc && cd dart-webrtc`
* `dart pub get`
* `dart pub global activate webdev`
* `webdev serve --auto=refresh`
