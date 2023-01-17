import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/push_notification/call_notification_wrapper.dart';
import 'package:stream_video/src/stream_video.dart';

class StreamVideoMock extends Mock implements StreamVideo {}

class CallNotificationWrapperMock extends Mock
    implements CallNotificationWrapper {}
