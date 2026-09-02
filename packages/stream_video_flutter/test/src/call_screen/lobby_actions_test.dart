import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  group('StreamLobbyActions', () {
    test('simple toggles the devices but does not pick them', () {
      final actions = StreamLobbyActions.simple();

      expect(actions.controls, [
        isA<StreamLobbyMicrophoneToggle>(),
        isA<StreamLobbyCameraToggle>(),
      ]);
      expect(actions.settings, isEmpty);
    });

    test('regular puts the device choice on the toggles themselves', () {
      final actions = StreamLobbyActions.regular();

      expect(actions.controls, [
        isA<StreamLobbyMicrophoneSplitButton>(),
        isA<StreamLobbyCameraSplitButton>(),
      ]);
      expect(actions.settings, isEmpty);
    });

    test('full adds a row of device fields', () {
      final actions = StreamLobbyActions.full();

      expect(actions.controls, [
        isA<StreamLobbyMicrophoneToggle>(),
        isA<StreamLobbyCameraToggle>(),
      ]);
      expect(actions.settings, [
        isA<StreamLobbyMicrophoneSelect>(),
        isA<StreamLobbyCameraSelect>(),
      ]);
    });

    // Both extension points on every preset is what lets a host add one button
    // or one field without respelling the whole list.
    test('every preset takes extras in both lanes', () {
      const extraControl = StreamLobbyParticipantsControl();
      const extraSetting = StreamLobbyCameraSelect();

      final presets = [
        StreamLobbyActions.simple(
          extraControls: const [extraControl],
          extraSettings: const [extraSetting],
        ),
        StreamLobbyActions.regular(
          extraControls: const [extraControl],
          extraSettings: const [extraSetting],
        ),
        StreamLobbyActions.full(
          extraControls: const [extraControl],
          extraSettings: const [extraSetting],
        ),
      ];

      for (final actions in presets) {
        expect(actions.controls.last, same(extraControl));
        expect(actions.settings.last, same(extraSetting));
      }
    });

    test('custom shows exactly what it is given', () {
      const control = StreamLobbyMicrophoneToggle();

      const actions = StreamLobbyActions.custom(controls: [control]);

      expect(actions.controls, [same(control)]);
      expect(actions.settings, isEmpty);
    });

    test('a preset hands over lanes nothing can mutate', () {
      // The class is @immutable, and a growable list handed straight out
      // would have made that a false claim.
      expect(
        () => StreamLobbyActions.simple().controls.add(
          const StreamLobbyCameraToggle(),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => StreamLobbyActions.full().settings.clear(),
        throwsUnsupportedError,
      );
    });
  });
}
