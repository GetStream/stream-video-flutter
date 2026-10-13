import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/src/screen_share/desktop_capturer_override.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';
import '../../screen_share/fake_desktop_capturer.dart';

void main() {
  final chosenWindow = FakeDesktopCapturerSource(
    id: 'window:42',
    name: 'Editor',
    type: SourceType.Window,
  );

  late MockCall call;
  late FakeDesktopCapturer capturer;
  late int selectorShown;

  setUpAll(() {
    registerFallbackValue(const ScreenShareConstraints());
  });

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.macOS;
    capturer = FakeDesktopCapturer();
    debugDesktopCapturerOverride = capturer;
    selectorShown = 0;

    call = MockCall();
    when(
      () => call.setScreenShareEnabled(
        enabled: any(named: 'enabled'),
        constraints: any(named: 'constraints'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
  });

  tearDown(() async {
    CurrentPlatform.debugCurrentPlatformOverride = null;
    debugDesktopCapturerOverride = null;
    await capturer.close();
  });

  Future<DesktopCapturerSource?> selector(BuildContext context) async {
    selectorShown++;
    return chosenWindow;
  }

  /// Runs [toggleScreenShare] from inside a widget tree and returns the
  /// constraints it handed to the call.
  Future<ScreenShareConstraints?> toggle(
    WidgetTester tester, {
    bool enabled = true,
    ScreenShareConstraints? constraints,
    DesktopScreenSharePickerType? pickerType,
  }) async {
    late BuildContext context;
    await tester.pumpWidget(
      TestWrapper(
        child: Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
      ),
    );

    if (pickerType == null) {
      await toggleScreenShare(
        context,
        call: call,
        enabled: enabled,
        constraints: constraints,
        desktopScreenSelectorBuilder: selector,
      );
    } else {
      await toggleScreenShare(
        context,
        call: call,
        enabled: enabled,
        constraints: constraints,
        desktopScreenSelectorBuilder: selector,
        desktopScreenPickerType: pickerType,
      );
    }

    return verify(
          () => call.setScreenShareEnabled(
            enabled: enabled,
            constraints: captureAny(named: 'constraints'),
          ),
        ).captured.single
        as ScreenShareConstraints?;
  }

  group('toggleScreenShare on desktop', () {
    testWidgets('uses the in-app selector by default', (tester) async {
      capturer.systemContentPickerSupported = true;

      final constraints = await toggle(tester);

      expect(selectorShown, 1);
      expect(constraints?.deviceId, chosenWindow.id);
    });

    testWidgets(
      'shares through the system picker when it is asked for and supported',
      (tester) async {
        capturer.systemContentPickerSupported = true;

        final constraints = await toggle(
          tester,
          pickerType: DesktopScreenSharePickerType.system,
        );

        expect(selectorShown, 0);
        expect(
          constraints?.deviceId,
          ScreenShareConstraints.systemPickerSourceId,
        );
      },
    );

    testWidgets('keeps the other constraints when using the system picker', (
      tester,
    ) async {
      capturer.systemContentPickerSupported = true;

      final constraints = await toggle(
        tester,
        constraints: const ScreenShareConstraints(maxFrameRate: 30),
        pickerType: DesktopScreenSharePickerType.system,
      );

      expect(
        constraints?.deviceId,
        ScreenShareConstraints.systemPickerSourceId,
      );
      expect(constraints?.maxFrameRate, 30);
    });

    testWidgets(
      'falls back to the in-app selector where the system picker is unsupported',
      (tester) async {
        capturer.systemContentPickerSupported = false;

        final constraints = await toggle(
          tester,
          pickerType: DesktopScreenSharePickerType.system,
        );

        expect(selectorShown, 1);
        expect(constraints?.deviceId, chosenWindow.id);
      },
    );

    testWidgets('stops sharing without showing a picker', (tester) async {
      capturer.systemContentPickerSupported = true;

      final constraints = await toggle(
        tester,
        enabled: false,
        pickerType: DesktopScreenSharePickerType.system,
      );

      expect(selectorShown, 0);
      expect(constraints, isNull);
    });
  });

  testWidgets('StreamScreenShareButton shares through the system picker', (
    tester,
  ) async {
    capturer.systemContentPickerSupported = true;

    final localParticipant = MockCallParticipantState();
    when(() => localParticipant.isScreenShareEnabled).thenReturn(false);

    await tester.pumpWidget(
      TestWrapper(
        child: StreamScreenShareButton(
          call: call,
          localParticipant: localParticipant,
          desktopScreenSelectorBuilder: selector,
          desktopScreenPickerType: DesktopScreenSharePickerType.system,
        ),
      ),
    );

    await tester.tap(find.byType(StreamScreenShareButton));
    await tester.pumpAndSettle();

    final constraints =
        verify(
              () => call.setScreenShareEnabled(
                enabled: true,
                constraints: captureAny(named: 'constraints'),
              ),
            ).captured.single
            as ScreenShareConstraints?;

    expect(selectorShown, 0);
    expect(constraints?.deviceId, ScreenShareConstraints.systemPickerSourceId);
  });
}
