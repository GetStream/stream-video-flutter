import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart';
import 'package:stream_video/src/call/call.dart';
import 'package:stream_video/src/push_notification/call_notification_wrapper.dart';
import 'package:stream_video/src/stream_video.dart';

class StreamVideoMock extends Mock implements StreamVideo {}

class CallNotificationWrapperMock extends Mock
    implements CallNotificationWrapper {}

class SharedPreferencesMock extends Mock implements SharedPreferences {}

class CallMock extends Mock implements Call {}

class SendEventResponseMock extends Mock implements SendEventResponse {}
