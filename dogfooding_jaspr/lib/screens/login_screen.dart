import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Minimal login: user id + call id, no auth beyond a token fetch.
class LoginScreen extends StatefulComponent {
  const LoginScreen({required this.onJoin, this.error, super.key});

  final void Function(String userId, String callId) onJoin;
  final String? error;

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String _userId = '';
  String _callId = 'jaspr-dogfooding';

  @override
  Component build(BuildContext context) {
    return div(classes: 'svj-login', [
      div(classes: 'svj-login-card', [
        const h1([.text('Stream Video — Jaspr Dogfooding')]),
        if (component.error != null)
          p(classes: 'svj-login-error', [.text(component.error!)]),
        label([
          const .text('User ID'),
          input<String>(
            type: InputType.text,
            value: _userId,
            onInput: (value) => setState(() => _userId = value),
          ),
        ]),
        label([
          const .text('Call ID'),
          input<String>(
            type: InputType.text,
            value: _callId,
            onInput: (value) => setState(() => _callId = value),
          ),
        ]),
        button(
          disabled: _userId.trim().isEmpty || _callId.trim().isEmpty,
          onClick: () => component.onJoin(_userId.trim(), _callId.trim()),
          const [.text('Join call')],
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.svj-login', [
      css('&').styles(
        display: .flex,
        width: 100.percent,
        height: 100.percent,
        alignItems: .center,
        justifyContent: .center,
        backgroundColor: const Color('#111'),
      ),
    ]),
    css('.svj-login-card', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        gap: Gap(row: 16.px, column: Unit.zero),
        padding: .all(32.px),
        radius: .circular(12.px),
        backgroundColor: const Color('#1c1c1c'),
        color: Colors.white,
        minWidth: 320.px,
      ),
      css('h1').styles(fontSize: 1.25.rem, margin: .zero),
      css('label').styles(
        display: .flex,
        flexDirection: .column,
        gap: Gap(row: 4.px, column: Unit.zero),
        fontSize: 0.85.rem,
      ),
      css('input').styles(
        padding: .all(8.px),
        radius: .circular(6.px),
        border: const Border.all(color: Color('#444')),
        backgroundColor: const Color('#2a2a2a'),
        color: Colors.white,
      ),
      css('button').styles(
        padding: .symmetric(vertical: 10.px),
        radius: .circular(6.px),
        border: Border.none,
        cursor: .pointer,
        backgroundColor: const Color('#3b82f6'),
        color: Colors.white,
        fontSize: 1.rem,
      ),
      css('button:disabled').styles(
        backgroundColor: const Color('#333'),
        cursor: .notAllowed,
      ),
    ]),
    css('.svj-login-error', [
      css('&').styles(color: const Color('#f87171'), fontSize: 0.85.rem),
    ]),
  ];
}
