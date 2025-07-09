import 'package:flutter/material.dart' show Locale, LocalizationsDelegate;
import 'package:test/core/language/app_localizations.dart';

// Defining a custom LocalizationsDelegate for AppLocalizations.
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  //Overrides method to check if given locale is supported by the app.
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  //Overrides method to locale the AppLocalizations for the given locale.
  @override
  Future<AppLocalizations> load(Locale locale) async {
    final appLocalizations = AppLocalizations(locale);
    await appLocalizations.load();
    return appLocalizations;
  }

  // Overrides method to determine whether the given localization should be reloaded.
  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
