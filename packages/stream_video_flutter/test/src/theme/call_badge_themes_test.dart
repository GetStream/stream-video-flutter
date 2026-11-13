import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';

/// How one of the call badge themes is built and read, so the three share a
/// single set of tests.
///
/// Each is driven through its `contentHeight`, which every badge style has
/// and which interpolates.
class _BadgeTheme<D> {
  const _BadgeTheme({
    required this.name,
    required this.data,
    required this.height,
    required this.of,
    required this.inherited,
    required this.notifies,
    required this.lerp,
    required this.inVideoTheme,
    required this.fromVideoTheme,
  });

  final String name;
  final D Function(double? height) data;
  final double? Function(D data) height;
  final D Function(BuildContext context) of;
  final InheritedTheme Function(D data, Widget child) inherited;
  final bool Function(D a, D b) notifies;
  final D? Function(D a, D b, double t) lerp;
  final StreamVideoTheme Function(StreamVideoTheme theme, D data) inVideoTheme;
  final D Function(StreamVideoTheme theme) fromVideoTheme;
}

final _callBadgeTheme = _BadgeTheme<StreamCallBadgeThemeData>(
  name: 'StreamCallBadgeTheme',
  data: (height) => StreamCallBadgeThemeData(
    style: StreamCallBadgeStyle(contentHeight: height),
  ),
  height: (data) => data.style?.contentHeight,
  of: StreamCallBadgeTheme.of,
  inherited: (data, child) => StreamCallBadgeTheme(data: data, child: child),
  notifies: (a, b) =>
      StreamCallBadgeTheme(
        data: a,
        child: const SizedBox.shrink(),
      ).updateShouldNotify(
        StreamCallBadgeTheme(data: b, child: const SizedBox.shrink()),
      ),
  lerp: StreamCallBadgeThemeData.lerp,
  inVideoTheme: (theme, data) => theme.copyWith(callBadgeTheme: data),
  fromVideoTheme: (theme) => theme.callBadgeTheme,
);

final _participantsBadgeTheme =
    _BadgeTheme<StreamCallParticipantsBadgeThemeData>(
      name: 'StreamCallParticipantsBadgeTheme',
      data: (height) => StreamCallParticipantsBadgeThemeData(
        style: StreamCallParticipantsBadgeStyle(contentHeight: height),
      ),
      height: (data) => data.style?.contentHeight,
      of: StreamCallParticipantsBadgeTheme.of,
      inherited: (data, child) =>
          StreamCallParticipantsBadgeTheme(data: data, child: child),
      notifies: (a, b) =>
          StreamCallParticipantsBadgeTheme(
            data: a,
            child: const SizedBox.shrink(),
          ).updateShouldNotify(
            StreamCallParticipantsBadgeTheme(
              data: b,
              child: const SizedBox.shrink(),
            ),
          ),
      lerp: StreamCallParticipantsBadgeThemeData.lerp,
      inVideoTheme: (theme, data) =>
          theme.copyWith(callParticipantsBadgeTheme: data),
      fromVideoTheme: (theme) => theme.callParticipantsBadgeTheme,
    );

final _latencyBadgeTheme = _BadgeTheme<StreamCallLatencyBadgeThemeData>(
  name: 'StreamCallLatencyBadgeTheme',
  data: (height) => StreamCallLatencyBadgeThemeData(
    style: StreamCallLatencyBadgeStyle(contentHeight: height),
  ),
  height: (data) => data.style?.contentHeight,
  of: StreamCallLatencyBadgeTheme.of,
  inherited: (data, child) =>
      StreamCallLatencyBadgeTheme(data: data, child: child),
  notifies: (a, b) =>
      StreamCallLatencyBadgeTheme(
        data: a,
        child: const SizedBox.shrink(),
      ).updateShouldNotify(
        StreamCallLatencyBadgeTheme(data: b, child: const SizedBox.shrink()),
      ),
  lerp: StreamCallLatencyBadgeThemeData.lerp,
  inVideoTheme: (theme, data) => theme.copyWith(callLatencyBadgeTheme: data),
  fromVideoTheme: (theme) => theme.callLatencyBadgeTheme,
);

void main() {
  Widget app({required StreamVideoTheme theme, required Widget home}) =>
      MaterialApp(
        theme: streamTestTheme().copyWith(
          extensions: [StreamTheme.light(), theme],
        ),
        home: home,
      );

  _run(_callBadgeTheme, app);
  _run(_participantsBadgeTheme, app);
  _run(_latencyBadgeTheme, app);
}

void _run<D extends Object>(
  _BadgeTheme<D> t,
  Widget Function({required StreamVideoTheme theme, required Widget home}) app,
) {
  group(t.name, () {
    testWidgets('resolves the global theme when no ancestor is present', (
      tester,
    ) async {
      late D resolved;

      await tester.pumpWidget(
        app(
          theme: t.inVideoTheme(StreamVideoTheme.light(), t.data(24)),
          home: Builder(
            builder: (context) {
              resolved = t.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(t.height(resolved), 24);
    });

    testWidgets('a local theme wins over the global one', (tester) async {
      late D resolved;

      await tester.pumpWidget(
        app(
          theme: t.inVideoTheme(StreamVideoTheme.light(), t.data(24)),
          home: t.inherited(
            t.data(28),
            Builder(
              builder: (context) {
                resolved = t.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(t.height(resolved), 28);
    });

    testWidgets('wrap carries the theme into another subtree', (tester) async {
      late D resolved;

      await tester.pumpWidget(
        app(
          theme: StreamVideoTheme.light(),
          home: Builder(
            builder: (context) => t
                .inherited(t.data(28), const SizedBox.shrink())
                .wrap(
                  context,
                  Builder(
                    builder: (context) {
                      resolved = t.of(context);
                      return const SizedBox.shrink();
                    },
                  ),
                ),
          ),
        ),
      );

      expect(t.height(resolved), 28);
    });

    test('updateShouldNotify follows the data', () {
      expect(t.notifies(t.data(24), t.data(24)), isFalse);
      expect(t.notifies(t.data(24), t.data(28)), isTrue);
    });

    test('lerp interpolates the style it carries', () {
      expect(t.height(t.lerp(t.data(20), t.data(30), 0.5)!), 25);
    });

    test('StreamVideoTheme defaults it to an empty instance', () {
      expect(t.height(t.fromVideoTheme(StreamVideoTheme.light())), isNull);
    });

    test('StreamVideoTheme lerps it', () {
      final a = t.inVideoTheme(StreamVideoTheme.light(), t.data(20));
      final b = t.inVideoTheme(StreamVideoTheme.light(), t.data(30));

      final mid = a.lerp(b, 0.5) as StreamVideoTheme;

      expect(t.height(t.fromVideoTheme(mid)), 25);
    });

    test('StreamVideoTheme merges it', () {
      final base = t.inVideoTheme(StreamVideoTheme.light(), t.data(20));
      final other = t.inVideoTheme(StreamVideoTheme.light(), t.data(30));

      expect(t.height(t.fromVideoTheme(base.merge(other))), 30);
    });
  });
}
