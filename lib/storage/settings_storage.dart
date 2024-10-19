import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {
  static final SettingsStorage _singleton = SettingsStorage._internal();

  Completer<SharedPreferences>? _completer;
  SharedPreferences? _prefs;

  final _storageSettingsThemeKey = "settings.theme_mode";
  final _storageSettingsShowValue = "settings.show_value";

  factory SettingsStorage() {
    return _singleton;
  }

  SettingsStorage._internal() {
    _afterPrefsInit();
  }

  Future<SharedPreferences> _afterPrefsInit() {
    if (_completer == null || _completer!.isCompleted) {
      _completer = Completer<SharedPreferences>();
      _initPrefs().then((value) {
        _prefs = value;
        _completer!.complete(value);
      });
    }
    return _completer!.future;
  }

  Future<SharedPreferences> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<SharedPreferences> afterInit() async {
    if (_prefs != null) {
      return Future.value(_prefs);
    } else {
      return _afterPrefsInit();
    }
  }

  ThemeMode getThemeMode() {
    ThemeMode theme = ThemeMode.system;
    if (_prefs != null) {
      var storedTheme = _prefs!.getInt(_storageSettingsThemeKey);
      if (storedTheme != null) {
        int themeIndex = storedTheme;
        theme = ThemeMode.values[themeIndex];
      }
    }
    return theme;
  }

  Future<bool> saveThemeMode(ThemeMode theme) async {
    var sharedPrefs = await afterInit();
    return sharedPrefs.setInt(_storageSettingsThemeKey, theme.index);
  }

  Future<bool?> isShowValue() async {
    var sharedPrefs = await afterInit();
    return sharedPrefs.getBool(_storageSettingsShowValue);
  }

  Future<bool> saveShowValue(bool showValue) async {
    var sharedPrefs = await afterInit();
    return sharedPrefs.setBool(_storageSettingsShowValue, showValue);
  }
}
