import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/settings_storage.dart';
import '../domain/app_settings.dart';

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AppSettings>((ref) {
  return SettingsController();
});

class SettingsController extends StateNotifier<AppSettings> {
  SettingsController() : super(AppSettings.defaults()) {
    _load();
  }

  final SettingsStorage _storage = SettingsStorage();

  void _load() {
    state = _storage.loadSettings();
  }

  Future<void> _save() async {
    await _storage.saveSettings(state);
  }

  void setVibrationEnabled(bool value) {
    state = state.copyWith(vibrationEnabled: value);
    _save();
  }

  void setAnimationsEnabled(bool value) {
    state = state.copyWith(animationsEnabled: value);
    _save();
  }

  void setKeepScreenOn(bool value) {
    state = state.copyWith(keepScreenOn: value);
    _save();
  }

  void setShowTimer(bool value) {
    state = state.copyWith(showTimer: value);
    _save();
  }

  void setConfirmBeforeSurrender(bool value) {
    state = state.copyWith(confirmBeforeSurrender: value);
    _save();
  }

  void setAutoSelectHintCell(bool value) {
    state = state.copyWith(autoSelectHintCell: value);
    _save();
  }

  void setThemeMode(AppThemeModeSetting value) {
    state = state.copyWith(themeMode: value);
    _save();
  }

  void setBoardTheme(SudokuBoardTheme value) {
    state = state.copyWith(boardTheme: value);
    _save();
  }

  void setBackgroundTheme(AppBackgroundTheme value) {
    state = state.copyWith(backgroundTheme: value);
    _save();
  }

}