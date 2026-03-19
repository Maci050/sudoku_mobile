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

enum SudokuBoardTheme {
  classic,
  paper,
  darkBlue,
  forest,
  sunset,
}

extension SudokuBoardThemeX on SudokuBoardTheme {
  String get label {
    switch (this) {
      case SudokuBoardTheme.classic:
        return 'Clásico';
      case SudokuBoardTheme.paper:
        return 'Papel';
      case SudokuBoardTheme.darkBlue:
        return 'Azul Oscuro';
      case SudokuBoardTheme.forest:
        return 'Bosque';
      case SudokuBoardTheme.sunset:
        return 'Atardecer';
    }
  }
}

class AppSettings {
  final bool vibrationEnabled;
  final bool animationsEnabled;
  final bool keepScreenOn;
  final bool showTimer;
  final bool confirmBeforeSurrender;
  final bool autoSelectHintCell;
  final AppThemeModeSetting themeMode;
  final SudokuBoardTheme boardTheme;
  const AppSettings({
    required this.vibrationEnabled,
    required this.animationsEnabled,
    required this.keepScreenOn,
    required this.showTimer,
    required this.confirmBeforeSurrender,
    required this.autoSelectHintCell,
    required this.themeMode,
    required this.boardTheme,
  });

  AppSettings copyWith({
    bool? vibrationEnabled,
    bool? animationsEnabled,
    bool? keepScreenOn,
    bool? showTimer,
    bool? confirmBeforeSurrender,
    bool? autoSelectHintCell,
    AppThemeModeSetting? themeMode,
    SudokuBoardTheme? boardTheme,
  }) {
    return AppSettings(
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      showTimer: showTimer ?? this.showTimer,
      confirmBeforeSurrender:
          confirmBeforeSurrender ?? this.confirmBeforeSurrender,
      autoSelectHintCell: autoSelectHintCell ?? this.autoSelectHintCell,
      themeMode: themeMode ?? this.themeMode,
      boardTheme: boardTheme ?? this.boardTheme,
    );
  }

  factory AppSettings.defaults() {
    return const AppSettings(
      vibrationEnabled: true,
      animationsEnabled: true,
      keepScreenOn: false,
      showTimer: true,
      confirmBeforeSurrender: true,
      autoSelectHintCell: true,
      themeMode: AppThemeModeSetting.system,
      boardTheme: SudokuBoardTheme.classic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vibrationEnabled': vibrationEnabled,
      'animationsEnabled': animationsEnabled,
      'keepScreenOn': keepScreenOn,
      'showTimer': showTimer,
      'confirmBeforeSurrender': confirmBeforeSurrender,
      'autoSelectHintCell': autoSelectHintCell,
      'themeMode': themeMode.name,
      'boardTheme': boardTheme.name,
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
      confirmBeforeSurrender: map['confirmBeforeSurrender'] as bool? ?? true,
      autoSelectHintCell: map['autoSelectHintCell'] as bool? ?? true,
      themeMode: parsedThemeMode(),
      boardTheme: SudokuBoardTheme.values.firstWhere(
        (e) => e.name == map['boardTheme'],
        orElse: () => SudokuBoardTheme.classic,
      ),
    );
  }
}