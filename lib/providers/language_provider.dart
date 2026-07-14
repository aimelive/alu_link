import 'package:flutter/material.dart';
import '../utils/app_strings.dart';

class LanguageProvider extends ChangeNotifier {
  String _lang = 'en';

  String get lang => _lang;
  bool get isFrench => _lang == 'fr';

  // Shortcut so screens can call context.read<LanguageProvider>().t('login')
  String t(String key) => AppStrings.get(key, _lang);

  void toggle() {
    _lang = _lang == 'en' ? 'fr' : 'en';
    notifyListeners();
  }
}