import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeModeService {
  static const String _boxName = 'settings';
  static const String _key = 'themeMode';

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_key, mode.index);
  }

  static Future<ThemeMode> loadThemeMode() async {
    final box = await Hive.openBox(_boxName);
    final index = box.get(_key, defaultValue: ThemeMode.system.index) as int;
    return ThemeMode.values[index];
  }
}
