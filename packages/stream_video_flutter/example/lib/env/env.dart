// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '../../../.env')
abstract class Env {
  @EnviedField(varName: 'SAMPLE_STREAM_VIDEO_API_KEY')
  static const streamVideoApiKey = _Env.streamVideoApiKey;
  @EnviedField(varName: 'SAMPLE_COORDINATOR_RPC_URL')
  static const streamCoordinatorRpcUrl = _Env.streamCoordinatorRpcUrl;
  @EnviedField(varName: 'SAMPLE_COORDINATOR_WS_URL')
  static const streamCoordinatorWSUrl = _Env.streamCoordinatorWSUrl;

  @EnviedField(varName: 'SAMPLE_USER_00_ID')
  static const sampleUserId00 = _Env.sampleUserId00;
  @EnviedField(varName: 'SAMPLE_USER_00_NAME')
  static const sampleUserName00 = _Env.sampleUserName00;
  @EnviedField(varName: 'SAMPLE_USER_00_ROLE')
  static const sampleUserRole00 = _Env.sampleUserRole00;
  @EnviedField(varName: 'SAMPLE_USER_00_IMAGE')
  static const sampleUserImage00 = _Env.sampleUserImage00;
  @EnviedField(varName: 'SAMPLE_USER_00_VIDEO_TOKEN')
  static const sampleUserVideoToken00 = _Env.sampleUserVideoToken00;

  @EnviedField(varName: 'SAMPLE_USER_01_ID')
  static const sampleUserId01 = _Env.sampleUserId01;
  @EnviedField(varName: 'SAMPLE_USER_01_NAME')
  static const sampleUserName01 = _Env.sampleUserName01;
  @EnviedField(varName: 'SAMPLE_USER_01_ROLE')
  static const sampleUserRole01 = _Env.sampleUserRole01;
  @EnviedField(varName: 'SAMPLE_USER_01_IMAGE')
  static const sampleUserImage01 = _Env.sampleUserImage01;
  @EnviedField(varName: 'SAMPLE_USER_01_VIDEO_TOKEN')
  static const sampleUserVideoToken01 = _Env.sampleUserVideoToken01;

  @EnviedField(varName: 'SAMPLE_USER_02_ID')
  static const sampleUserId02 = _Env.sampleUserId02;
  @EnviedField(varName: 'SAMPLE_USER_02_NAME')
  static const sampleUserName02 = _Env.sampleUserName02;
  @EnviedField(varName: 'SAMPLE_USER_02_ROLE')
  static const sampleUserRole02 = _Env.sampleUserRole02;
  @EnviedField(varName: 'SAMPLE_USER_02_IMAGE')
  static const sampleUserImage02 = _Env.sampleUserImage02;
  @EnviedField(varName: 'SAMPLE_USER_02_VIDEO_TOKEN')
  static const sampleUserVideoToken02 = _Env.sampleUserVideoToken02;

  @EnviedField(varName: 'SAMPLE_USER_03_ID')
  static const sampleUserId03 = _Env.sampleUserId03;
  @EnviedField(varName: 'SAMPLE_USER_03_NAME')
  static const sampleUserName03 = _Env.sampleUserName03;
  @EnviedField(varName: 'SAMPLE_USER_03_ROLE')
  static const sampleUserRole03 = _Env.sampleUserRole03;
  @EnviedField(varName: 'SAMPLE_USER_03_IMAGE')
  static const sampleUserImage03 = _Env.sampleUserImage03;
  @EnviedField(varName: 'SAMPLE_USER_03_VIDEO_TOKEN')
  static const sampleUserVideoToken03 = _Env.sampleUserVideoToken03;

  @EnviedField(varName: 'SAMPLE_USER_04_ID')
  static const sampleUserId04 = _Env.sampleUserId04;
  @EnviedField(varName: 'SAMPLE_USER_04_NAME')
  static const sampleUserName04 = _Env.sampleUserName04;
  @EnviedField(varName: 'SAMPLE_USER_04_ROLE')
  static const sampleUserRole04 = _Env.sampleUserRole04;
  @EnviedField(varName: 'SAMPLE_USER_04_IMAGE')
  static const sampleUserImage04 = _Env.sampleUserImage04;
  @EnviedField(varName: 'SAMPLE_USER_04_VIDEO_TOKEN')
  static const sampleUserVideoToken04 = _Env.sampleUserVideoToken04;

  @EnviedField(varName: 'SAMPLE_USER_05_ID')
  static const sampleUserId05 = _Env.sampleUserId05;
  @EnviedField(varName: 'SAMPLE_USER_05_NAME')
  static const sampleUserName05 = _Env.sampleUserName05;
  @EnviedField(varName: 'SAMPLE_USER_05_ROLE')
  static const sampleUserRole05 = _Env.sampleUserRole05;
  @EnviedField(varName: 'SAMPLE_USER_05_IMAGE')
  static const sampleUserImage05 = _Env.sampleUserImage05;
  @EnviedField(varName: 'SAMPLE_USER_05_VIDEO_TOKEN')
  static const sampleUserVideoToken05 = _Env.sampleUserVideoToken05;
}
