// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/core/repos/app_preferences.dart';
import 'package:flutter_dogfooding/core/repos/token_service.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';

// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import '../di/injector.dart';

class EnvironmentSwitcher extends StatefulWidget {
  const EnvironmentSwitcher({
    super.key,
    required this.currentEnvironment,
  });

  final Environment currentEnvironment;

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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColorPalette.appGreen,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                selectedEnvironment.displayName,
                style: streamVideoTheme.textTheme.footnoteBold
                    .apply(color: AppColorPalette.appGreen),
              ),
            ),
          ),
          MenuAnchor(
            style: const MenuStyle(
              alignment: Alignment.bottomLeft,
              backgroundColor:
                  MaterialStatePropertyAll(AppColorPalette.backgroundColor),
            ),
            alignmentOffset: const Offset(-70, 0),
            builder: (
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
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              );
            },
            menuChildren: [
              ...Environment.values
                  .map(
                    (env) => MenuItemButton(
                      onPressed: () async {
                        await locator<AppPreferences>().setEnvironment(env);

                        setState(() {
                          selectedEnvironment = env;
                        });
                      },
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedEnvironment == env
                                ? AppColorPalette.appGreen
                                : Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            env.displayName,
                            style: TextStyle(
                                color: selectedEnvironment == env
                                    ? AppColorPalette.appGreen
                                    : Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ],
      ),
    );
  }
}

class EnvironmentBanner extends StatelessWidget {
  const EnvironmentBanner({
    super.key,
    required this.currentEnvironment,
  });

  final Environment currentEnvironment;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColorPalette.appGreen,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          currentEnvironment.displayName,
          style: streamVideoTheme.textTheme.footnoteBold
              .apply(color: AppColorPalette.appGreen),
        ),
      ),
    );
  }
}
