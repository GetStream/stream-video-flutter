import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart';
import 'package:stream_video/src/call/call.dart';
import 'package:stream_video/src/v2/coordinator/models/coordinator_models.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/call_notification_wrapper.dart';

class StreamVideoV2Mock extends Mock implements StreamVideoV2 {}

class CallNotificationWrapperMock extends Mock
    implements CallNotificationWrapper {}

class SharedPreferencesMock extends Mock implements SharedPreferences {}

class CallMock extends Mock implements Call {}

class SendEventResponseMock extends Mock implements SendEventResponse {}

class CallMetadataMock extends Mock implements CallMetadata {}
