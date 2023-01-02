import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/models/closed_caption.dart';
import 'package:stream_video/stream_video.dart';



void main() {
  test('stream test', () async {
    final controller = ClosedCaptionsController();
    final cc1 = ClosedCaptionEvent(
        closedCaption: ClosedCaption(
            userId: "sacha@getstream.io",
            startTime: Time(),
            endTime: Time(seconds: 3),
            text: "I've seen things you people wouldn't believe."));

    final cc2 = ClosedCaptionEvent(
        closedCaption: ClosedCaption(
            userId: "sacha@getstream.io",
            startTime: Time(seconds: 3, milliseconds: 500),
            endTime: Time(seconds: 6),
            text: "Attack ships on fire off the shoulder of Orion."));

    final cc3 = ClosedCaptionEvent(
        closedCaption: ClosedCaption(
            startTime: Time(seconds: 6, milliseconds: 500),
            endTime: Time(seconds: 10),
            text:
                "I watched C-beams glitter in the dark near the Tannhäuser Gate.",
            userId: "sahil@getstream.io"));
    final cc4 = ClosedCaptionEvent(
        closedCaption: ClosedCaption(
            userId: "sacha@getstream.io",
            startTime: Time(seconds: 10, milliseconds: 500),
            endTime: Time(seconds: 14),
            text:
                "All those moments will be lost in time, like tears in rain."));
    final cc5 = ClosedCaptionEvent(
        closedCaption: ClosedCaption(
            userId: "sahil@getstream.io",
            startTime: Time(seconds: 14, milliseconds: 500),
            endTime: Time(seconds: 18),
            text: "Time to die."));

    controller.add(cc1);
    controller.add(cc2);
    controller.add(cc3);
    controller.add(cc4);
    controller.add(cc5);
    await expectLater(
        controller.stream,
        emits({
          CCKey(
              startTime: cc1.closedCaption.startTime,
              userId: cc1.closedCaption.userId): [cc1, cc2],
          CCKey(
              startTime: cc3.closedCaption.startTime,
              userId: cc3.closedCaption.userId): [cc3],
          CCKey(
              startTime: cc4.closedCaption.startTime,
              userId: cc4.closedCaption.userId): [cc4],
          CCKey(
              startTime: cc5.closedCaption.startTime,
              userId: cc5.closedCaption.userId): [cc5]
        }));

        expect(controller.recentCC, [cc5]);
        expectLater(controller.latestCCStream, emits([cc5]));

  });
}
