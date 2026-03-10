enum AppThemeMode {
  system,
  light,
  dark,
}

class AppSettings {
  final bool vibrationEnabled;
  final bool soundEnabled;
  final bool animationsEnabled;
  final bool keepScreenOn;
  final AppThemeMode themeMode;

  const AppSettings({
    required this.vibrationEnabled,
    required this.soundEnabled,
    required this.animationsEnabled,
    required this.keepScreenOn,
    required this.themeMode,
  });

  factory AppSettings.defaults() {
    return const AppSettings(
      vibrationEnabled: true,
      soundEnabled: true,
      animationsEnabled: true,
      keepScreenOn: false,
      themeMode: AppThemeMode.system,
    );
  }

  AppSettings copyWith({
    bool? vibrationEnabled,
    bool? soundEnabled,
    bool? animationsEnabled,
    bool? keepScreenOn,
    AppThemeMode? themeMode,
  }) {
    return AppSettings(
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vibrationEnabled': vibrationEnabled,
      'soundEnabled': soundEnabled,
      'animationsEnabled': animationsEnabled,
      'keepScreenOn': keepScreenOn,
      'themeMode': themeMode.name,
    };
  }

  factory AppSettings.fromMap(Map<dynamic, dynamic> map) {
    return AppSettings(
      vibrationEnabled: map['vibrationEnabled'] as bool? ?? true,
      soundEnabled: map['soundEnabled'] as bool? ?? true,
      animationsEnabled: map['animationsEnabled'] as bool? ?? true,
      keepScreenOn: map['keepScreenOn'] as bool? ?? false,
      themeMode: AppThemeMode.values.firstWhere(
        (mode) => mode.name == map['themeMode'],
        orElse: () => AppThemeMode.system,
      ),
    );
  }
}