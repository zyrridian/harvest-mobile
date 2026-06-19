import 'package:flutter/material.dart';

class LanguageConstants {
  static const String english = 'English';
  static const String indonesian = 'Bahasa Indonesia';
  static const String spanish = 'Español';
  static const String french = 'Français';
  static const String german = 'Deutsch';
  static const String japanese = '日本語';
  static const String korean = '한국어';
  static const String chinese = '中文';

  static const Map<String, String> languageCodeToName = {
    'en': english,
    'id': indonesian,
    'es': spanish,
    'fr': french,
    'de': german,
    'ja': japanese,
    'ko': korean,
    'zh': chinese,
  };

  static const Map<String, Locale> languageCodeToLocale = {
    'en': Locale('en', 'US'),
    'id': Locale('id', 'ID'),
    'es': Locale('es', 'ES'),
    'fr': Locale('fr', 'FR'),
    'de': Locale('de', 'DE'),
    'ja': Locale('ja', 'JP'),
    'ko': Locale('ko', 'KR'),
    'zh': Locale('zh', 'CN'),
  };

  static const Map<String, String> languageCodeToFlag = {
    'en': '🇺🇸',
    'id': '🇮🇩',
    'es': '🇪🇸',
    'fr': '🇫🇷',
    'de': '🇩🇪',
    'ja': '🇯🇵',
    'ko': '🇰🇷',
    'zh': '🇨🇳',
  };

  static String getLanguageName(String code) {
    return languageCodeToName[code] ?? english;
  }

  static Locale getLocale(String code) {
    return languageCodeToLocale[code] ?? const Locale('en', 'US');
  }

  static String getFlag(String code) {
    return languageCodeToFlag[code] ?? '🇺🇸';
  }
}
