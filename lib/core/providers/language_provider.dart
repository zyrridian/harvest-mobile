import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/language_constants.dart';

const String _languageCodeKey = 'language_code';

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('en', 'US')) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey) ?? 'en';
    state = LanguageConstants.getLocale(languageCode);
  }

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
    state = LanguageConstants.getLocale(languageCode);
  }

  String get languageCode => state.languageCode;
  String get languageName => LanguageConstants.getLanguageName(languageCode);
}

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

// Provider for getting just the language name string
final currentLanguageNameProvider = Provider<String>((ref) {
  final languageCode = ref.watch(languageProvider).languageCode;
  return LanguageConstants.getLanguageName(languageCode);
});
