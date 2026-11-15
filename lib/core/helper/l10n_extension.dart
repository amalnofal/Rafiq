import 'package:material_ui/material_ui.dart';
import 'package:rafiq/l10n/app_localizations.dart' show AppLocalizations;

extension L10nExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}