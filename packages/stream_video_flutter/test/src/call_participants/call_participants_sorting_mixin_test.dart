import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

CallParticipantState _participant(
  String userId, {
  bool isSpeaking = false,
}) {
  return CallParticipantState(
    userId: userId,
    roles: const [],
    name: userId,
    custom: const {},
    sessionId: '$userId-session',
    trackIdPrefix: '$userId-prefix',
    isSpeaking: isSpeaking,
  );
}

/// Minimal host for the mixin: it has no call, it just records how often the
/// mixin asked to repaint.
class _Host extends StatefulWidget {
  const _Host({super.key, this.filter, this.sort});

  final CallParticipantFilter<CallParticipantState>? filter;
  final CallParticipantSort<CallParticipantState>? sort;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> with CallParticipantsSortingMixin {
  int builds = 0;

  @override
  CallParticipantFilter<CallParticipantState>? get participantFilter =>
      widget.filter;

  @override
  CallParticipantSort<CallParticipantState>? get participantSort => widget.sort;

  @override
  Widget build(BuildContext context) {
    builds++;
    return const SizedBox.shrink();
  }
}

Future<_HostState> _pumpHost(
  WidgetTester tester, {
  CallParticipantFilter<CallParticipantState>? filter,
  CallParticipantSort<CallParticipantState>? sort,
}) async {
  final key = GlobalKey<_HostState>();
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: _Host(key: key, filter: filter, sort: sort),
    ),
  );
  return key.currentState!;
}

void main() {
  testWidgets('keeps arrival order and appends newcomers', (tester) async {
    final host = await _pumpHost(tester);

    host.recalculateParticipants([_participant('a'), _participant('b')]);
    await tester.pump();
    expect(host.sortedParticipants.map((it) => it.userId), ['a', 'b']);

    // A newcomer goes to the end even when the source lists it first.
    host.recalculateParticipants([
      _participant('c'),
      _participant('b'),
      _participant('a'),
    ]);
    await tester.pump();
    expect(host.sortedParticipants.map((it) => it.userId), ['a', 'b', 'c']);
  });

  testWidgets('a participant leaving does not reorder the rest', (
    tester,
  ) async {
    final host = await _pumpHost(tester);

    host.recalculateParticipants([
      _participant('a'),
      _participant('b'),
      _participant('c'),
    ]);
    await tester.pump();

    host.recalculateParticipants([_participant('c'), _participant('a')]);
    await tester.pump();
    expect(host.sortedParticipants.map((it) => it.userId), ['a', 'c']);
  });

  testWidgets('the sort is stable across equal participants', (tester) async {
    // Everyone compares equal, so the previous order has to survive.
    final host = await _pumpHost(
      tester,
      sort: CallParticipantSort((_, __) => 0),
    );

    host.recalculateParticipants([
      _participant('a'),
      _participant('b'),
      _participant('c'),
    ]);
    await tester.pump();

    host.recalculateParticipants([
      _participant('c'),
      _participant('b'),
      _participant('a'),
    ]);
    await tester.pump();
    expect(host.sortedParticipants.map((it) => it.userId), ['a', 'b', 'c']);
  });

  testWidgets('the sort comparator wins over arrival order', (tester) async {
    final host = await _pumpHost(
      tester,
      sort: CallParticipantSort((a, b) => a.userId.compareTo(b.userId)),
    );

    host.recalculateParticipants([
      _participant('c'),
      _participant('a'),
      _participant('b'),
    ]);
    await tester.pump();
    expect(host.sortedParticipants.map((it) => it.userId), ['a', 'b', 'c']);
  });

  testWidgets('the filter is applied', (tester) async {
    final host = await _pumpHost(tester, filter: (it) => it.isSpeaking);

    host.recalculateParticipants([
      _participant('a', isSpeaking: true),
      _participant('b'),
    ]);
    await tester.pump();
    expect(host.sortedParticipants.map((it) => it.userId), ['a']);
  });

  testWidgets('does not repaint when the same instances come back', (
    tester,
  ) async {
    final host = await _pumpHost(tester);
    final participants = [_participant('a'), _participant('b')];

    host.recalculateParticipants(participants);
    await tester.pump();
    final buildsAfterFirst = host.builds;

    host.recalculateParticipants([...participants]);
    await tester.pump();

    expect(
      host.builds,
      buildsAfterFirst,
      reason: 'identical participants must not trigger setState',
    );
  });

  testWidgets('repaints when a participant instance changes', (tester) async {
    final host = await _pumpHost(tester);

    host.recalculateParticipants([_participant('a')]);
    await tester.pump();
    final buildsAfterFirst = host.builds;

    host.recalculateParticipants([_participant('a', isSpeaking: true)]);
    await tester.pump();

    expect(host.builds, greaterThan(buildsAfterFirst));
  });
}
