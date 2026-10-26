import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/utils/user_agent.dart';

void main() {
  group('isWebKitUserAgent', () {
    const webKit = {
      'macOS Safari':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 '
          '(KHTML, like Gecko) Version/26.0 Safari/605.1.15',
      'iOS Safari':
          'Mozilla/5.0 (iPhone; CPU iPhone OS 26_0 like Mac OS X) '
          'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Mobile/15E148 '
          'Safari/604.1',
      'iOS WKWebView':
          'Mozilla/5.0 (iPhone; CPU iPhone OS 26_0 like Mac OS X) '
          'AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
      'iOS Chrome':
          'Mozilla/5.0 (iPhone; CPU iPhone OS 26_0 like Mac OS X) '
          'AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/140.0.0.0 '
          'Mobile/15E148 Safari/604.1',
      'iOS Firefox':
          'Mozilla/5.0 (iPhone; CPU iPhone OS 26_0 like Mac OS X) '
          'AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/140.0 Mobile/15E148 '
          'Safari/605.1.15',
    };

    const notWebKit = {
      'macOS Chrome':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36',
      'Windows Edge':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0',
      'Linux Chromium':
          'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chromium/140.0.0.0 Safari/537.36',
      'Android Chrome':
          'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36',
      'Android WebView':
          'Mozilla/5.0 (Linux; Android 15; wv) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Version/4.0 Mobile Safari/537.36',
      'Firefox':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:140.0) '
          'Gecko/20100101 Firefox/140.0',
      'empty': '',
    };

    for (final MapEntry(key: name, value: userAgent) in webKit.entries) {
      test('is true for $name', () {
        expect(isWebKitUserAgent(userAgent), isTrue);
      });
    }

    for (final MapEntry(key: name, value: userAgent) in notWebKit.entries) {
      test('is false for $name', () {
        expect(isWebKitUserAgent(userAgent), isFalse);
      });
    }
  });
}
