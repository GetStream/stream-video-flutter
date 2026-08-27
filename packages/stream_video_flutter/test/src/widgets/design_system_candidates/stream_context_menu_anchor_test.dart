import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';

// The menu panel lives in an Overlay, and the capture Alchemist uses for the
// committed CI goldens drops overlay content — a snapshot of an open menu comes
// out blank instead of failing. So the panel is covered by assertions on its
// metrics here, and the field that opens it is covered by the goldens in
// `stream_select_input_test.dart`.
void main() {
  testWidgets('StreamContextMenuAnchor opens the menu on the anchor press', (
    tester,
  ) async {
    await tester.pumpWidget(const TestWrapper(child: _DeviceMenu()));

    expect(find.text('Microphone'), findsNothing);

    await tester.tap(find.byType(StreamSelectInput));
    await tester.pumpAndSettle();

    expect(find.text('Microphone'), findsOneWidget);
    expect(find.text('Speaker'), findsOneWidget);
  });

  testWidgets('StreamContextMenuAnchor sizes menu items to the design row', (
    tester,
  ) async {
    await tester.pumpWidget(const TestWrapper(child: _DeviceMenu()));

    await tester.tap(find.byType(StreamSelectInput));
    await tester.pumpAndSettle();

    // The design's `Web / Menu Item` is a 32px tall row with a 200px minimum
    // width, against the 40px and 242px stream_core_flutter defaults.
    final row = tester.getSize(
      find.byType(StreamContextMenuAction<void>).first,
    );
    expect(row.height, 32);
    expect(row.width, greaterThanOrEqualTo(200));
  });

  testWidgets('StreamContextMenuAnchor keeps the panel within its max width', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TestWrapper(
        child: _DeviceMenu(
          microphones: [
            'Studio Display Microphone (Conference Room, 4th floor, east wing)',
          ],
        ),
      ),
    );

    await tester.tap(find.byType(StreamSelectInput));
    await tester.pumpAndSettle();

    final row = tester.getSize(
      find.byType(StreamContextMenuAction<void>).first,
    );
    expect(
      row.width,
      lessThanOrEqualTo(StreamContextMenuAnchor.defaultConstraints.maxWidth),
    );
  });
}

/// The lobby's audio picker: one [StreamSelectInput] opening a menu that picks
/// both a microphone and a speaker.
class _DeviceMenu extends StatefulWidget {
  const _DeviceMenu({
    this.microphones = const ['MacBook Pro Microphone', 'Jabra Evolve2 65'],
  });

  final List<String> microphones;

  @override
  State<_DeviceMenu> createState() => _DeviceMenuState();
}

class _DeviceMenuState extends State<_DeviceMenu> {
  final _menuController = MenuController();
  bool _isOpen = false;

  static const _speakers = ['MacBook Pro Speakers'];

  @override
  Widget build(BuildContext context) {
    return StreamContextMenuAnchor(
      controller: _menuController,
      alignmentOffset: const Offset(0, 8),
      onOpen: () => setState(() => _isOpen = true),
      onClose: () => setState(() => _isOpen = false),
      menuChildren: StreamContextMenuAction.sectioned(
        sections: [
          _section('Microphone', widget.microphones),
          _section('Speaker', _speakers),
        ],
      ),
      builder: (context, controller, child) => SizedBox(
        width: 220,
        child: StreamSelectInput(
          leading: Icon(context.streamIcons.voiceFill),
          value: widget.microphones.first,
          hintText: 'Default',
          expanded: _isOpen,
          onPressed: () => controller.open(),
        ),
      ),
    );
  }

  List<Widget> _section(String heading, List<String> devices) => [
    StreamContextMenuHeading(label: Text(heading)),
    StreamContextMenuAction<void>(
      onTap: () {},
      leading: const StreamRadioIndicator(selected: false),
      label: const Text('System default'),
    ),
    for (final (index, device) in devices.indexed)
      StreamContextMenuAction<void>(
        onTap: () {},
        leading: StreamRadioIndicator(selected: index == 0),
        label: Text(device, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
  ];
}
