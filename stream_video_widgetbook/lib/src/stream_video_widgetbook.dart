import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

import 'call_participants/index.dart';
import 'call_participants/indicators/audio_indicator.dart';
import 'call_participants/indicators/audio_level_indicator.dart';
import 'call_participants/indicators/connection_quality_indicator.dart';
import 'call_screen/incoming_call/incoming_call_content.dart';
import 'call_screen/outgoing_call/outgoing_call_content.dart';

class StreamVideoWidgetbook extends StatelessWidget {
  const StreamVideoWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook(
      appInfo: AppInfo(name: 'Stream Video Widgetbook'),
      themeBuilder: (context, theme, child) {
        return Theme(
          data: ThemeData(
            textTheme: GoogleFonts.robotoMonoTextTheme(),
            extensions: <ThemeExtension<dynamic>>[theme],
          ),
          child: child,
        );
      },
      themes: [
        WidgetbookTheme(
          name: 'Light',
          data: StreamVideoTheme.light(),
        ),
        WidgetbookTheme(
          name: 'Dark',
          data: StreamVideoTheme.dark(),
        ),
      ],
      appBuilder: (context, child) {
        final router = getRouter(child);
        return MaterialApp.router(
          color: Colors.transparent,
          builder: (context, childWidget) {
            return childWidget ?? child;
          },
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
        );
      },
      frames: const [
        WidgetbookFrame(
          name: 'Widgetbook',
          allowsDevices: true,
        ),
        WidgetbookFrame(
          name: 'Device Frame',
          allowsDevices: true,
        ),
      ],
      devices: const [
        Desktop.desktop1080p,
        Samsung.s10,
      ],
      categories: [
        WidgetbookCategory(
          name: 'UI Components',
          folders: [
            WidgetbookFolder(
              name: 'Call Participants',
              isExpanded: true,
              folders: [
                WidgetbookFolder(
                  name: 'Indicators',
                  isExpanded: true,
                  widgets: [
                    WidgetbookComponent(
                      name: 'Audio Indicator',
                      isExpanded: true,
                      useCases: [
                        WidgetbookUseCase(
                          name: 'Default',
                          builder: defaultAudioIndicator,
                        ),
                      ],
                    ),
                    WidgetbookComponent(
                      name: 'Audio Level Indicator',
                      isExpanded: true,
                      useCases: [
                        WidgetbookUseCase(
                          name: 'Default',
                          builder: defaultAudioLevelIndicator,
                        ),
                      ],
                    ),
                    WidgetbookComponent(
                      name: 'Connection Quality Indicator',
                      isExpanded: true,
                      useCases: [
                        WidgetbookUseCase(
                          name: 'Default',
                          builder: defaultConnectionQualityIndicator,
                        ),
                      ],
                    ),
                  ],
                ),
                WidgetbookFolder(
                  name: 'Layout',
                  isExpanded: true,
                  widgets: [
                    WidgetbookComponent(
                      name: 'Call Participants GridView',
                      isExpanded: true,
                      useCases: [
                        WidgetbookUseCase(
                          name: 'Mobile',
                          builder: mobileCallParticipantsGridView,
                        ),
                        WidgetbookUseCase(
                          name: 'Desktop',
                          builder: desktopCallParticipantsGridView,
                        ),
                      ],
                    ),
                    WidgetbookComponent(
                      name: 'Call Participants SpotlightView',
                      isExpanded: true,
                      useCases: [
                        WidgetbookUseCase(
                          name: 'Mobile',
                          builder: mobileCallParticipantsSpotlightView,
                        ),
                        WidgetbookUseCase(
                          name: 'Desktop',
                          builder: desktopCallParticipantsSpotlightView,
                        ),
                      ],
                    ),
                  ],
                )
              ],
              widgets: [
                WidgetbookComponent(
                  name: 'Call Participant',
                  isExpanded: true,
                  useCases: [
                    WidgetbookUseCase(
                      name: 'Default',
                      builder: defaultCallParticipant,
                    ),
                  ],
                ),
                WidgetbookComponent(
                  name: 'Call Participants',
                  isExpanded: true,
                  useCases: [
                    WidgetbookUseCase(
                      name: 'Default',
                      builder: defaultStreamCallParticipants,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
