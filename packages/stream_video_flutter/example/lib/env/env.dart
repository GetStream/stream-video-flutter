// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '../../../.env')
abstract class Env {
  @EnviedField(varName: 'SAMPLE_STREAM_VIDEO_API_KEY')
  static const String streamVideoApiKey = _Env.streamVideoApiKey;

  @EnviedField(varName: 'SAMPLE_USER_00_ID')
  static const String sampleUserId00 = _Env.sampleUserId00;
  @EnviedField(varName: 'SAMPLE_USER_00_NAME')
  static const String sampleUserName00 = _Env.sampleUserName00;
  @EnviedField(varName: 'SAMPLE_USER_00_ROLE')
  static const String sampleUserRole00 = _Env.sampleUserRole00;
  @EnviedField(varName: 'SAMPLE_USER_00_IMAGE')
  static const String sampleUserImage00 = _Env.sampleUserImage00;
  @EnviedField(varName: 'SAMPLE_USER_00_VIDEO_TOKEN')
  static const String sampleUserVideoToken00 = _Env.sampleUserVideoToken00;

  @EnviedField(varName: 'SAMPLE_USER_01_ID')
  static const String sampleUserId01 = _Env.sampleUserId01;
  @EnviedField(varName: 'SAMPLE_USER_01_NAME')
  static const String sampleUserName01 = _Env.sampleUserName01;
  @EnviedField(varName: 'SAMPLE_USER_01_ROLE')
  static const String sampleUserRole01 = _Env.sampleUserRole01;
  @EnviedField(varName: 'SAMPLE_USER_01_IMAGE')
  static const String sampleUserImage01 = _Env.sampleUserImage01;
  @EnviedField(varName: 'SAMPLE_USER_01_VIDEO_TOKEN')
  static const String sampleUserVideoToken01 = _Env.sampleUserVideoToken01;

  @EnviedField(varName: 'SAMPLE_USER_02_ID')
  static const String sampleUserId02 = _Env.sampleUserId02;
  @EnviedField(varName: 'SAMPLE_USER_02_NAME')
  static const String sampleUserName02 = _Env.sampleUserName02;
  @EnviedField(varName: 'SAMPLE_USER_02_ROLE')
  static const String sampleUserRole02 = _Env.sampleUserRole02;
  @EnviedField(varName: 'SAMPLE_USER_02_IMAGE')
  static const String sampleUserImage02 = _Env.sampleUserImage02;
  @EnviedField(varName: 'SAMPLE_USER_02_VIDEO_TOKEN')
  static const String sampleUserVideoToken02 = _Env.sampleUserVideoToken02;

  @EnviedField(varName: 'SAMPLE_USER_03_ID')
  static const String sampleUserId03 = _Env.sampleUserId03;
  @EnviedField(varName: 'SAMPLE_USER_03_NAME')
  static const String sampleUserName03 = _Env.sampleUserName03;
  @EnviedField(varName: 'SAMPLE_USER_03_ROLE')
  static const String sampleUserRole03 = _Env.sampleUserRole03;
  @EnviedField(varName: 'SAMPLE_USER_03_IMAGE')
  static const String sampleUserImage03 = _Env.sampleUserImage03;
  @EnviedField(varName: 'SAMPLE_USER_03_VIDEO_TOKEN')
  static const String sampleUserVideoToken03 = _Env.sampleUserVideoToken03;

  @EnviedField(varName: 'SAMPLE_USER_04_ID')
  static const String sampleUserId04 = _Env.sampleUserId04;
  @EnviedField(varName: 'SAMPLE_USER_04_NAME')
  static const String sampleUserName04 = _Env.sampleUserName04;
  @EnviedField(varName: 'SAMPLE_USER_04_ROLE')
  static const String sampleUserRole04 = _Env.sampleUserRole04;
  @EnviedField(varName: 'SAMPLE_USER_04_IMAGE')
  static const String sampleUserImage04 = _Env.sampleUserImage04;
  @EnviedField(varName: 'SAMPLE_USER_04_VIDEO_TOKEN')
  static const String sampleUserVideoToken04 = _Env.sampleUserVideoToken04;

  @EnviedField(varName: 'SAMPLE_USER_05_ID')
  static const String sampleUserId05 = _Env.sampleUserId05;
  @EnviedField(varName: 'SAMPLE_USER_05_NAME')
  static const String sampleUserName05 = _Env.sampleUserName05;
  @EnviedField(varName: 'SAMPLE_USER_05_ROLE')
  static const String sampleUserRole05 = _Env.sampleUserRole05;
  @EnviedField(varName: 'SAMPLE_USER_05_IMAGE')
  static const String sampleUserImage05 = _Env.sampleUserImage05;
  @EnviedField(varName: 'SAMPLE_USER_05_VIDEO_TOKEN')
  static const String sampleUserVideoToken05 = _Env.sampleUserVideoToken05;
}
