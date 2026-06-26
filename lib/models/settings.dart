import 'package:flutter/material.dart';

class AppSettings {
  final bool notificationsEnabled;
  final bool showFloatingWidget;
  final ThemeMode themeMode;

  const AppSettings({
    this.notificationsEnabled = true,
    this.showFloatingWidget = true,
    this.themeMode = ThemeMode.system,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'showFloatingWidget': showFloatingWidget,
      'themeMode': themeMode.name,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final themeName = json['themeMode'] as String?;
    return AppSettings(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      showFloatingWidget: json['showFloatingWidget'] as bool? ?? true,
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
    bool? showFloatingWidget,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      showFloatingWidget: showFloatingWidget ?? this.showFloatingWidget,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
