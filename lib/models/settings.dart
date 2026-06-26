import 'package:flutter/material.dart';

class AppSettings {
  final bool notificationsEnabled;
  final ThemeMode themeMode;

  const AppSettings({
    this.notificationsEnabled = true,
    this.themeMode = ThemeMode.system,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'themeMode': themeMode.name,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final themeName = json['themeMode'] as String?;
    return AppSettings(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      themeMode: _themeModeFromName(themeName),
    );
  }

  static ThemeMode _themeModeFromName(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  AppSettings copyWith({
    bool? notificationsEnabled,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
