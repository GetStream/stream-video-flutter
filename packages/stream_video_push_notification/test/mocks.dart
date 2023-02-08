import 'package:flutter/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/call_notification_wrapper.dart';

class StreamVideoMock extends Mock implements StreamVideo {}

class CallNotificationWrapperMock extends Mock
    implements CallNotificationWrapper {}

class SharedPreferencesMock extends Mock implements SharedPreferences {}

class EventChannelMock extends Mock implements EventChannel {}
