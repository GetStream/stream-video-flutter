import 'package:flutter/widgets.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

/// The name of a [TranscriptionSettingsLanguage] in the app's language.
extension TranscriptionSettingsLanguageLabel on TranscriptionSettingsLanguage {
  /// The language's name in the app's language, for example "Dutch", or
  /// "Automatic" for [TranscriptionSettingsLanguage.auto].
  String label(BuildContext context) {
    final translations = context.translations;
    return switch (this) {
      .auto => translations.transcriptionLanguageAuto,
      .en => translations.transcriptionLanguageEn,
      .fr => translations.transcriptionLanguageFr,
      .es => translations.transcriptionLanguageEs,
      .de => translations.transcriptionLanguageDe,
      .it => translations.transcriptionLanguageIt,
      .nl => translations.transcriptionLanguageNl,
      .pt => translations.transcriptionLanguagePt,
      .pl => translations.transcriptionLanguagePl,
      .ca => translations.transcriptionLanguageCa,
      .cs => translations.transcriptionLanguageCs,
      .da => translations.transcriptionLanguageDa,
      .el => translations.transcriptionLanguageEl,
      .fi => translations.transcriptionLanguageFi,
      .id => translations.transcriptionLanguageId,
      .ja => translations.transcriptionLanguageJa,
      .ru => translations.transcriptionLanguageRu,
      .sv => translations.transcriptionLanguageSv,
      .ta => translations.transcriptionLanguageTa,
      .th => translations.transcriptionLanguageTh,
      .tr => translations.transcriptionLanguageTr,
      .hu => translations.transcriptionLanguageHu,
      .ro => translations.transcriptionLanguageRo,
      .zh => translations.transcriptionLanguageZh,
      .ar => translations.transcriptionLanguageAr,
      .tl => translations.transcriptionLanguageTl,
      .he => translations.transcriptionLanguageHe,
      .hi => translations.transcriptionLanguageHi,
      .hr => translations.transcriptionLanguageHr,
      .ko => translations.transcriptionLanguageKo,
      .ms => translations.transcriptionLanguageMs,
      .no => translations.transcriptionLanguageNo,
      .uk => translations.transcriptionLanguageUk,
      .bg => translations.transcriptionLanguageBg,
      .et => translations.transcriptionLanguageEt,
      .sl => translations.transcriptionLanguageSl,
      .sk => translations.transcriptionLanguageSk,
    };
  }
}
