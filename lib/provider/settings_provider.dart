import 'package:flutter/material.dart';

import '/storage/settings_storage.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsStorage _settingsStorage = SettingsStorage();
  ThemeMode _themeMode = ThemeMode.system;
  bool _isShowValue = true;

  SettingsProvider() {
    _settingsStorage.afterInit().then((value) {
      _themeMode = _settingsStorage.getThemeMode();
      _settingsStorage.isShowValue().then((value) {
        if (value != null) {
          isShowValue = value;
          notifyListeners();
        }
      });
      notifyListeners();
    });
  }

  ThemeMode get themeMode => _themeMode;
  bool get isShowValue => _isShowValue;

  set isShowValue(bool showValue) {
    _isShowValue = showValue;
    _settingsStorage.saveShowValue(showValue);
    notifyListeners();
  }

  set themeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
    _settingsStorage.saveThemeMode(value);
  }

  Brightness getSelectedBrightness(Brightness brightness) {
    switch (_themeMode) {
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.system:
        return brightness;
    }
  }
}
