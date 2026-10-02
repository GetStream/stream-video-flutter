import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/utils/collection_changes.dart';

void main() {
  group('changedCapabilitiesByRoleOrNull', () {
    final current = {
      'host': ['send-audio', 'send-video'],
      'user': ['send-audio'],
    };

    test('returns null for the same contents in a new map', () {
      expect(
        changedCapabilitiesByRoleOrNull(current, {
          'user': ['send-audio'],
          'host': ['send-audio', 'send-video'],
        }),
        isNull,
      );
    });

    test('returns null when there is no new map', () {
      expect(changedCapabilitiesByRoleOrNull(current, null), isNull);
    });

    test('returns the new map when a role has other capabilities', () {
      final next = {
        'host': ['send-audio'],
        'user': ['send-audio'],
      };

      expect(changedCapabilitiesByRoleOrNull(current, next), same(next));
    });

    test('returns the new map when a role is added or replaced', () {
      final added = {
        ...current,
        'guest': <String>[],
      };
      final replaced = {
        'host': ['send-audio', 'send-video'],
        'guest': ['send-audio'],
      };

      expect(changedCapabilitiesByRoleOrNull(current, added), same(added));
      expect(
        changedCapabilitiesByRoleOrNull(current, replaced),
        same(replaced),
      );
    });

    test('returns an empty new map', () {
      final next = <String, List<String>>{};

      expect(changedCapabilitiesByRoleOrNull(current, next), same(next));
    });
  });
}
