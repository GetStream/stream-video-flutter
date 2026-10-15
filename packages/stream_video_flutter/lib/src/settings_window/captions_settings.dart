import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';
import 'settings_switch_row.dart';

/// The captions tab of a [StreamModalWindow]: a switch for closed captions
/// and the language spoken in the call, under the label "Captions".
class StreamCaptionsSettingsTab extends StreamModalWindowTab {
  /// Creates the captions tab.
  ///
  /// [icon] and [label] replace the default caption icon and "Captions".
  StreamCaptionsSettingsTab({
    required Call call,
    Widget? icon,
    Widget? label,
  }) : super(
         icon: icon ?? const _CaptionsTabIcon(),
         label: label ?? const _CaptionsTabLabel(),
         builder: (context) => StreamCaptionsSettings(call: call),
       );
}

class _CaptionsTabIcon extends StatelessWidget {
  const _CaptionsTabIcon();

  @override
  Widget build(BuildContext context) => Icon(context.streamIcons.captionFill);
}

class _CaptionsTabLabel extends StatelessWidget {
  const _CaptionsTabLabel();

  @override
  Widget build(BuildContext context) =>
      Text(context.translations.settingsCaptionsTab);
}

/// The call's closed captions: a switch to turn them on and off and, while
/// they are on, the language spoken in the call.
///
/// The content of [StreamCaptionsSettingsTab], and usable on its own.
///
/// The switch is disabled where the call has captions turned off, and where
/// the user may not start or stop them. The language is the call's: changing
/// it changes it for everyone in the call, which needs the
/// `update-call-settings` permission.
class StreamCaptionsSettings extends StatefulWidget {
  /// Creates the captions settings.
  const StreamCaptionsSettings({super.key, required this.call});

  /// The call whose captions are set.
  final Call call;

  static _Captions _captions(CallState state) {
    final transcription = state.settings.transcription;
    final capabilities = state.ownCapabilities;
    return (
      available:
          transcription.closedCaptionMode != ClosedCaptionSettingsMode.disabled,
      on: state.isCaptioning,
      canStart: capabilities.contains(CallPermission.startClosedCaptionsCall),
      canStop: capabilities.contains(CallPermission.stopClosedCaptionsCall),
      canChangeLanguage: capabilities.contains(
        CallPermission.updateCallSettings,
      ),
      language: transcription.language,
      closedCaptionMode: transcription.closedCaptionMode,
      transcriptionMode: transcription.transcriptionMode,
    );
  }

  @override
  State<StreamCaptionsSettings> createState() => _StreamCaptionsSettingsState();
}

class _StreamCaptionsSettingsState extends State<StreamCaptionsSettings> {
  static final _logger = taggedLogger(tag: 'SV:CaptionsSettings');

  // Set while a start or stop is in flight, so a second tap doesn't send
  // another.
  bool _switching = false;

  Call get call => widget.call;

  Future<void> _setCaptioning(
    bool on,
    TranscriptionSettingsLanguage? language,
  ) async {
    if (_switching) return;
    _switching = true;
    try {
      final result = on
          ? await call.startClosedCaptions(language: language)
          : await call.stopClosedCaptions();
      if (result case Failure(:final error)) {
        _logger.e(
          () => 'Could not turn captions ${on ? 'on' : 'off'}: $error',
        );
      }
    } finally {
      _switching = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;

    return PartialCallStateBuilder(
      call: call,
      selector: StreamCaptionsSettings._captions,
      builder: (context, captions) {
        final canSwitch =
            captions.available &&
            (captions.on ? captions.canStop : captions.canStart);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.streamSpacing.xxl,
          children: [
            StreamSettingsSwitchRow(
              title: translations.captionsSettingsTurnOn,
              description: translations.captionsSettingsTurnOnDescription,
              value: captions.on,
              onChanged: canSwitch
                  ? (on) => _setCaptioning(on, captions.language)
                  : null,
            ),
            if (captions.on)
              _LanguageCard(
                call: call,
                captions: captions,
              ),
          ],
        );
      },
    );
  }
}

typedef _Captions = ({
  bool available,
  bool on,
  bool canStart,
  bool canStop,
  bool canChangeLanguage,
  TranscriptionSettingsLanguage? language,
  ClosedCaptionSettingsMode closedCaptionMode,
  TranscriptionSettingsMode transcriptionMode,
});

/// The language spoken in the call, on a card.
class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.call, required this.captions});

  final Call call;
  final _Captions captions;

  static final _logger = taggedLogger(tag: 'SV:CaptionsSettings');

  /// Null sets the call back to no language of its own.
  Future<void> _setLanguage(TranscriptionSettingsLanguage? language) async {
    final result = await call.update(
      // Sent whole, so the modes in use go along with the new language rather
      // than being reset to their defaults.
      transcription: StreamTranscriptionSettings(
        closedCaptionMode: captions.closedCaptionMode,
        transcriptionMode: captions.transcriptionMode,
        language: language,
      ),
    );
    if (result case Failure(:final error)) {
      _logger.e(() => 'Could not change the captions language: $error');
    }
  }

  static String _label(
    BuildContext context,
    TranscriptionSettingsLanguage? language,
  ) =>
      language?.label(context) ??
      context.translations.captionsSettingsLanguageDefault;

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;
    final spacing = context.streamSpacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.streamColorScheme.backgroundSurfaceCard,
        borderRadius: BorderRadius.all(context.streamRadius.xxxl),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: StreamAdaptiveMenuAnchor(
          title: translations.captionsSettingsLanguage,
          matchAnchorWidth: true,
          sections: [
            StreamMenuSection(
              options: [
                for (final language in [
                  null,
                  ...TranscriptionSettingsLanguage.values,
                ])
                  StreamMenuOption(
                    label: _label(context, language),
                    selected: language == captions.language,
                    onSelected: () => _setLanguage(language),
                  ),
              ],
            ),
          ],
          builder: (context, handle) => StreamSelectInput(
            labelText: translations.captionsSettingsLanguage,
            leading: Icon(context.streamIcons.translate),
            value: _label(context, captions.language),
            expanded: handle.isOpen,
            onPressed: captions.canChangeLanguage ? handle.toggle : null,
          ),
        ),
      ),
    );
  }
}
