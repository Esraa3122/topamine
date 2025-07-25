import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/core/service/shared_pref/pref_keys.dart';
import 'package:test/core/service/shared_pref/shared_pref.dart';

part 'app_state.dart';
part 'app_cubit.freezed.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState.initial());

  bool isDark = false;
  String currentLangCode = 'ar';

  // Theme Mode
  Future<void> changeAppThemeMode({bool? sharedMode}) async {
    if (sharedMode != null) {
      isDark = sharedMode;
      emit(AppState.themeChangeMode(isDark: isDark));
    } else {
      isDark = !isDark;
      await SharedPref()
          .setBoolean(PrefKeys.themeMode, isDark)
          .then(
            (value) => emit(
              AppState.themeChangeMode(isDark: isDark),
            ),
          );
    }
  }

  // Language Change
  void getSavedLanguage() {
    final result = SharedPref().containPreference(PrefKeys.language)
        ? SharedPref().getString(PrefKeys.language)
        : 'ar';

    currentLangCode = result!;
    emit(AppState.languageChange(locale: Locale(currentLangCode)));
  }

  Future<void> _changeLange(String langCode) async {
    await SharedPref().setString(PrefKeys.language, langCode);
    currentLangCode = langCode;
    emit(AppState.languageChange(locale: Locale(currentLangCode)));
  }

  void toArabic() => _changeLange('ar');
  void toEnglish() => _changeLange('en');
}
