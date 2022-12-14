import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pbenum.dart';
import 'package:stream_video/src/event_emitter.dart';
import 'package:stream_video/src/internal/events.dart';
import 'package:stream_video/src/track/local/local.dart';
import 'package:stream_video/src/track/local/video.dart';
import 'package:stream_video/src/track/options.dart';

main() {
  test('description', () async {
    final a = {'hello', 'sahil'};

    print(a);

    a.add('hello');

    print(a);
  });
}