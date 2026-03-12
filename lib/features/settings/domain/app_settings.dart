import 'package:flutter/material.dart';

enum AppThemeModeSetting {
  system,
  light,
  dark,
}

extension AppThemeModeSettingX on AppThemeModeSetting {
  ThemeMode get flutterThemeMode {
    switch (this) {
      case AppThemeModeSetting.system:
        return ThemeMode.system;
      case AppThemeModeSetting.light:
        return ThemeMode.light;
      case AppThemeModeSetting.dark:
        return ThemeMode.dark;
    }
  }

  String get label {
    switch (this) {
      case AppThemeModeSetting.system:
        return 'Sistema';
      case AppThemeModeSetting.light:
        return 'Claro';
      case AppThemeModeSetting.dark:
        return 'Oscuro';
    }
  }
}

class AppSettings {
  final bool vibrationEnabled;
  final bool animationsEnabled;
  final bool keepScreenOn;
  final bool showTimer;
  final bool confirmBeforeRestart;
  final bool confirmBeforeSurrender;
  final bool autoSelectHintCell;
  final AppThemeModeSetting themeMode;

  const AppSettings({
    required this.vibrationEnabled,
    required this.animationsEnabled,
    required this.keepScreenOn,
    required this.showTimer,
    required this.confirmBeforeRestart,
    required this.confirmBeforeSurrender,
    required this.autoSelectHintCell,
    required this.themeMode,
  });

  AppSettings copyWith({
    bool? vibrationEnabled,
    bool? animationsEnabled,
    bool? keepScreenOn,
    bool? showTimer,
    bool? confirmBeforeRestart,
    bool? confirmBeforeSurrender,
    bool? autoSelectHintCell,
    AppThemeModeSetting? themeMode,
  }) {
    return AppSettings(
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      showTimer: showTimer ?? this.showTimer,
      confirmBeforeRestart: confirmBeforeRestart ?? this.confirmBeforeRestart,
      confirmBeforeSurrender:
          confirmBeforeSurrender ?? this.confirmBeforeSurrender,
      autoSelectHintCell: autoSelectHintCell ?? this.autoSelectHintCell,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  factory AppSettings.defaults() {
    return const AppSettings(
      vibrationEnabled: true,
      animationsEnabled: true,
      keepScreenOn: false,
      showTimer: true,
      confirmBeforeRestart: true,
      confirmBeforeSurrender: true,
      autoSelectHintCell: true,
      themeMode: AppThemeModeSetting.system,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vibrationEnabled': vibrationEnabled,
      'animationsEnabled': animationsEnabled,
      'keepScreenOn': keepScreenOn,
      'showTimer': showTimer,
      'confirmBeforeRestart': confirmBeforeRestart,
      'confirmBeforeSurrender': confirmBeforeSurrender,
      'autoSelectHintCell': autoSelectHintCell,
      'themeMode': themeMode.name,
    };
  }

  factory AppSettings.fromMap(Map<dynamic, dynamic> map) {
    AppThemeModeSetting parsedThemeMode() {
      final raw = map['themeMode']?.toString() ?? 'system';
      for (final value in AppThemeModeSetting.values) {
        if (value.name == raw) return value;
      }
      return AppThemeModeSetting.system;
    }

    return AppSettings(
      vibrationEnabled: map['vibrationEnabled'] as bool? ?? true,
      animationsEnabled: map['animationsEnabled'] as bool? ?? true,
      keepScreenOn: map['keepScreenOn'] as bool? ?? false,
      showTimer: map['showTimer'] as bool? ?? true,
      confirmBeforeRestart: map['confirmBeforeRestart'] as bool? ?? true,
      confirmBeforeSurrender: map['confirmBeforeSurrender'] as bool? ?? true,
      autoSelectHintCell: map['autoSelectHintCell'] as bool? ?? true,
      themeMode: parsedThemeMode(),
    );
  }
}