import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

/// Extension to make translations easier to access
/// Usage: context.l10n.home instead of AppLocalizations.of(context)!.home
extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Shorthand for translate
  String tr(String key) => AppLocalizations.of(this)!.translate(key);
}

/// Global function for translations outside of BuildContext
/// Usage: tr(context, 'key')
String tr(BuildContext context, String key) {
  return AppLocalizations.of(context)!.translate(key);
}
