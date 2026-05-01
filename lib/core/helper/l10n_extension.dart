import 'package:flutter/material.dart';
import 'package:rafiq/l10n/app_localizations.dart' show AppLocalizations;

extension L10nExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}