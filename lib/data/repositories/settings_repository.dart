import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

class SettingsRepository {
  static const String _storageKey = 'gps_lens_app_settings_v1';

  Future<AppSettings> loadSettings() async {
    final preferences = await SharedPreferences.getInstance();
    final savedJson = preferences.getString(_storageKey);

    if (savedJson == null || savedJson.isEmpty) {
      return const AppSettings();
    }

    try {
      final decoded = jsonDecode(savedJson);

      if (decoded is! Map) {
        return const AppSettings();
      }

      return AppSettings.fromJson(Map<String, dynamic>.from(decoded));
    } catch (_) {
      // Recover safely if saved settings are invalid or outdated.
      return const AppSettings();
    }
  }

  Future<bool> saveSettings(AppSettings settings) async {
    final preferences = await SharedPreferences.getInstance();

    final encodedJson = jsonEncode(settings.toJson());

    return preferences.setString(_storageKey, encodedJson);
  }

  Future<void> resetSettings() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_storageKey);
  }
}
