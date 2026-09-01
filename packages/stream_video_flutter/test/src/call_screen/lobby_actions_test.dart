import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  group('LobbyActions', () {
    test('simple toggles the devices but does not pick them', () {
      final actions = LobbyActions.simple();

      expect(actions.controls, [
        isA<StreamLobbyMicrophoneToggle>(),
        isA<StreamLobbyCameraToggle>(),
      ]);
      expect(actions.settings, isEmpty);
    });

    test('regular puts the device choice on the toggles themselves', () {
      final actions = LobbyActions.regular();

      expect(actions.controls, [
        isA<StreamLobbyMicrophoneSplitButton>(),
        isA<StreamLobbyCameraSplitButton>(),
      ]);
      expect(actions.settings, isEmpty);
    });

    test('full adds a row of device fields', () {
      final actions = LobbyActions.full();

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
        LobbyActions.simple(
          extraControls: const [extraControl],
          extraSettings: const [extraSetting],
        ),
        LobbyActions.regular(
          extraControls: const [extraControl],
          extraSettings: const [extraSetting],
        ),
        LobbyActions.full(
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

      const actions = LobbyActions.custom(controls: [control]);

      expect(actions.controls, [same(control)]);
      expect(actions.settings, isEmpty);
    });
  });
}
