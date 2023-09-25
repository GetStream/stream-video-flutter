// import 'dart:async';
//
// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:stream_video/stream_video.dart';
//
// import 'package:stream_video_push_notification/src/call_notification_wrapper.dart';
//
// class StreamVideoMock extends Mock implements StreamVideo {}
//
// class CoordinatorClientMock extends Mock implements CoordinatorClient {}
//
// class CallNotificationWrapperMock extends Mock
//     implements CallNotificationWrapper {}
//
// class EventChannelMock extends Mock implements EventChannel {}

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  test('description', () {
    final controller = BehaviorSubject<int>();

    controller.listen((value) {
      print('value: $value');
    });

    print('Value 2: ${controller.valueOrNull}');

    controller.add(1);
  });
}
