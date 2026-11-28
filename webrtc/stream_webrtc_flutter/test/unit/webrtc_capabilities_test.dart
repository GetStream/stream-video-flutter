// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter_test/flutter_test.dart';
// The library itself, not the barrel, which needs a browser.
// ignore: implementation_imports
import 'package:stream_dart_webrtc/src/browser_capabilities.dart';
// ignore: implementation_imports
import 'package:stream_dart_webrtc/src/e2ee/encoded_transform_api.dart';
import 'package:stream_webrtc_flutter/src/native/native_webrtc_capabilities.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

enum _Platform { android, ios, macos, windows, linux, web }

WebRtcCapabilities _capabilitiesOf(_Platform platform) {
  if (platform == _Platform.web) {
    return browserWebRtcCapabilitiesFor(supportsAudioOutputSelection: true);
  }
  return nativeWebRtcCapabilitiesFor(
    isAndroid: platform == _Platform.android,
    isIOS: platform == _Platform.ios,
    isMacOS: platform == _Platform.macos,
    isWindows: platform == _Platform.windows,
    isLinux: platform == _Platform.linux,
  );
}

void main() {
  /// Each capability and the platforms that have it.
  final expected =
      <String, (bool Function(WebRtcCapabilities), Set<_Platform>)>{
        'supportsPerCallFactory': (
          (c) => c.supportsPerCallFactory,
          {_Platform.android, _Platform.ios, _Platform.macos},
        ),
        'supportsAudioPlayoutPause': (
          (c) => c.supportsAudioPlayoutPause,
          {_Platform.android, _Platform.ios, _Platform.macos, _Platform.web},
        ),
        'supportsAudioOutputSelection': (
          (c) => c.supportsAudioOutputSelection,
          _Platform.values.toSet(),
        ),
        'supportsCameraSwitch': (
          (c) => c.supportsCameraSwitch,
          _Platform.values.toSet()..remove(_Platform.web),
        ),
        'switchesAudioInputInPlace': (
          (c) => c.switchesAudioInputInPlace,
          _Platform.values.toSet()..remove(_Platform.web),
        ),
        'selectsAudioOutputPerElement': (
          (c) => c.selectsAudioOutputPerElement,
          {_Platform.web},
        ),
        'supportsBroadcastExtension': (
          (c) => c.supportsBroadcastExtension,
          {_Platform.ios},
        ),
        'supportsScreenShareSourceSelection': (
          (c) => c.supportsScreenShareSourceSelection,
          {_Platform.macos, _Platform.windows, _Platform.linux},
        ),
        'omitsEarpieceFromEnumeration': (
          (c) => c.omitsEarpieceFromEnumeration,
          {_Platform.ios},
        ),
        'usesExactDeviceIdConstraints': (
          (c) => c.usesExactDeviceIdConstraints,
          {_Platform.web},
        ),
        'reportsAudioInterruptions': (
          (c) => c.reportsAudioInterruptions,
          {_Platform.android, _Platform.ios},
        ),
        'supportsSystemManagedAudioFocus': (
          (c) => c.supportsSystemManagedAudioFocus,
          {_Platform.android},
        ),
        'needsRemoteAudioReattach': (
          (c) => c.needsRemoteAudioReattach,
          <_Platform>{},
        ),
        'supportsEncryption': (
          (c) => c.supportsEncryption,
          {_Platform.android, _Platform.ios, _Platform.macos},
        ),
        'supportsAudioModuleMicrophoneMute': (
          (c) => c.supportsAudioModuleMicrophoneMute,
          {_Platform.ios, _Platform.macos},
        ),
        'needsEncodedInsertableStreams': (
          (c) => c.needsEncodedInsertableStreams,
          <_Platform>{},
        ),
      };

  for (final MapEntry(key: name, value: (read, platforms))
      in expected.entries) {
    group(name, () {
      for (final platform in _Platform.values) {
        final has = platforms.contains(platform);
        test('is $has on ${platform.name}', () {
          expect(read(_capabilitiesOf(platform)), has);
        });
      }
    });
  }

  test('the browser reports audio output selection as probed', () {
    expect(
      browserWebRtcCapabilitiesFor(
        supportsAudioOutputSelection: false,
      ).supportsAudioOutputSelection,
      isFalse,
    );
  });

  test('a WebKit browser needs remote audio re-attached', () {
    expect(
      browserWebRtcCapabilitiesFor(
        supportsAudioOutputSelection: false,
        isWebKit: true,
      ).needsRemoteAudioReattach,
      isTrue,
    );
  });

  group('a browser with encoded transforms', () {
    WebRtcCapabilities withApi(EncodedTransformApi api) =>
        browserWebRtcCapabilitiesFor(
          supportsAudioOutputSelection: true,
          encodedTransformApi: api,
        );

    test('supports encryption', () {
      for (final api in EncodedTransformApi.values) {
        expect(withApi(api).supportsEncryption, isTrue, reason: api.name);
      }
    });

    test('needs the insertable streams flag only for insertable streams', () {
      expect(
        withApi(
          EncodedTransformApi.insertableStreams,
        ).needsEncodedInsertableStreams,
        isTrue,
      );
      expect(
        withApi(EncodedTransformApi.script).needsEncodedInsertableStreams,
        isFalse,
      );
    });
  });

  group('webRtcCapabilities', () {
    tearDown(() => debugWebRtcCapabilitiesOverride = null);

    test('is the override while one is set', () {
      final override = _capabilitiesOf(
        _Platform.ios,
      ).copyWith(supportsCameraSwitch: false);
      debugWebRtcCapabilitiesOverride = override;

      expect(webRtcCapabilities, same(override));
    });

    test('is the host platform without an override', () {
      expect(webRtcCapabilities, same(nativeWebRtcCapabilities));
    });
  });

  group('value', () {
    final base = _capabilitiesOf(_Platform.android);
    final flips = <String, WebRtcCapabilities Function(bool)>{
      'supportsPerCallFactory': (v) => base.copyWith(supportsPerCallFactory: v),
      'supportsAudioPlayoutPause': (v) =>
          base.copyWith(supportsAudioPlayoutPause: v),
      'supportsAudioOutputSelection': (v) =>
          base.copyWith(supportsAudioOutputSelection: v),
      'supportsCameraSwitch': (v) => base.copyWith(supportsCameraSwitch: v),
      'switchesAudioInputInPlace': (v) =>
          base.copyWith(switchesAudioInputInPlace: v),
      'selectsAudioOutputPerElement': (v) =>
          base.copyWith(selectsAudioOutputPerElement: v),
      'supportsBroadcastExtension': (v) =>
          base.copyWith(supportsBroadcastExtension: v),
      'supportsScreenShareSourceSelection': (v) =>
          base.copyWith(supportsScreenShareSourceSelection: v),
      'omitsEarpieceFromEnumeration': (v) =>
          base.copyWith(omitsEarpieceFromEnumeration: v),
      'usesExactDeviceIdConstraints': (v) =>
          base.copyWith(usesExactDeviceIdConstraints: v),
      'reportsAudioInterruptions': (v) =>
          base.copyWith(reportsAudioInterruptions: v),
      'supportsSystemManagedAudioFocus': (v) =>
          base.copyWith(supportsSystemManagedAudioFocus: v),
      'needsRemoteAudioReattach': (v) =>
          base.copyWith(needsRemoteAudioReattach: v),
      'supportsEncryption': (v) => base.copyWith(supportsEncryption: v),
      'supportsAudioModuleMicrophoneMute': (v) =>
          base.copyWith(supportsAudioModuleMicrophoneMute: v),
      'needsEncodedInsertableStreams': (v) =>
          base.copyWith(needsEncodedInsertableStreams: v),
    };

    for (final MapEntry(key: name, value: flip) in flips.entries) {
      test('$name takes part in equality and toString', () {
        final on = flip(true);
        final off = flip(false);

        expect(on, isNot(off));
        expect(on.hashCode, isNot(off.hashCode));
        expect(on.toString(), contains(name));
        expect(off.toString(), isNot(contains(name)));
      });
    }

    test('copyWith without arguments is equal', () {
      expect(base.copyWith(), base);
      expect(base.copyWith().hashCode, base.hashCode);
    });
  });
}
