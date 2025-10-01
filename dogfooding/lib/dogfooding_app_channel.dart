import 'package:flutter/services.dart';

class DogfoodingAppChannel {
  static const platform = MethodChannel(
    'io.getstream.video.flutter.dogfooding.channel',
  );

  Future<void> registerGreyscaleEffect() async {
    await platform.invokeMethod('registerGreyscaleEffect');
  }
}
