import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../core/model/environment.dart';
import '../core/repos/app_preferences.dart';
import '../di/injector.dart';

class EnvironmentSwitcher extends StatefulWidget {
  const EnvironmentSwitcher({
    super.key,
    required this.currentEnvironment,
    this.onEnvironmentChanged,
  });

  final Environment currentEnvironment;

  /// Called after the user selects a different environment.
  final ValueChanged<Environment>? onEnvironmentChanged;

  @override
  State<EnvironmentSwitcher> createState() => _EnvironmentSwitcherState();
}

class _EnvironmentSwitcherState extends State<EnvironmentSwitcher> {
  late Environment selectedEnvironment;

  @override
  void initState() {
    selectedEnvironment = widget.currentEnvironment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final colorScheme = StreamTheme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.accentSuccess,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                selectedEnvironment.displayName,
                style: streamVideoTheme.textTheme.footnoteBold.apply(
                  color: colorScheme.accentSuccess,
                ),
              ),
            ),
          ),
          MenuAnchor(
            style: MenuStyle(
              alignment: Alignment.bottomLeft,
              backgroundColor: WidgetStatePropertyAll(
                colorScheme.backgroundApp,
              ),
            ),
            alignmentOffset: const Offset(-70, 0),
            builder:
                (
                  BuildContext context,
                  MenuController controller,
                  Widget? child,
                ) {
                  return IconButton(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: const Icon(Icons.settings, color: Colors.white),
                  );
                },
            menuChildren: [
              ...Environment.values
                  .where((e) => e != Environment.livestream)
                  .map(
                    (env) => MenuItemButton(
                      onPressed: () async {
                        await locator<AppPreferences>().setEnvironment(env);

                        setState(() {
                          selectedEnvironment = env;
                        });

                        widget.onEnvironmentChanged?.call(env);
                      },
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedEnvironment == env
                                ? colorScheme.accentSuccess
                                : Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            env.displayName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selectedEnvironment == env
                                  ? colorScheme.accentSuccess
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class EnvironmentBanner extends StatelessWidget {
  const EnvironmentBanner({super.key, required this.currentEnvironment});

  final Environment currentEnvironment;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final colorScheme = StreamTheme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.accentSuccess, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          currentEnvironment.displayName,
          style: streamVideoTheme.textTheme.footnoteBold.apply(
            color: colorScheme.accentSuccess,
          ),
        ),
      ),
    );
  }
}
