import 'package:flutter_test/flutter_test.dart';
import 'package:stream_webrtc_flutter/src/native/external_audio_device.dart';

void main() {
  bool external(String? groupId, {bool ios = false, bool android = false}) =>
      isExternalAudioDeviceFor(groupId, isIOS: ios, isAndroid: android);

  test('a device without a group is not external', () {
    expect(external(null, ios: true), isFalse);
    expect(external(null, android: true), isFalse);
    expect(external(null), isFalse);
  });

  test('on iOS, headphones, Bluetooth and car ports are external', () {
    for (final port in [
      'BluetoothA2DP',
      'bluetoothLE',
      'BluetoothHFP',
      'CarAudio',
      'Headphones',
    ]) {
      expect(external(port, ios: true), isTrue, reason: port);
    }
    expect(external('Speaker', ios: true), isFalse);
    expect(external('Receiver', ios: true), isFalse);
  });

  test('on Android, Bluetooth and wired headsets are external', () {
    expect(external('bluetooth-sco', android: true), isTrue);
    expect(external('wired-headset', android: true), isTrue);
    expect(external('speaker', android: true), isFalse);
    expect(external('earpiece', android: true), isFalse);
  });

  test('elsewhere, only Bluetooth devices are external', () {
    expect(external('Bluetooth Headset'), isTrue);
    expect(external('USB Audio'), isFalse);
  });
}
