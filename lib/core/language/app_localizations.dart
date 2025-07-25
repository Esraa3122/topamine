import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test/core/language/app_localizations_delegate.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;

  // Static methods to retrieve the AppLocalizations instance
  // from the mearest BuildContext.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static constants that holds the delegate for this localizations.
  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  // Map to store the localizations strings.
  late Map<String, String> _localizedStrings;

  // Map to load the localized strings from JSON files.
  Future<void> load() async {
    final jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    _localizedStrings = jsonMap.map<String, String>((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  // Method to translate a given key into the corresponding localized string.
  String? translate(String key) => _localizedStrings[key];

  // Getter method to check if the current locale is English
  bool get isEnLocal => locale.languageCode == 'en';
}
