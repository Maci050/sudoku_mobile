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

  void toggleVibration(bool value) {
    state = state.copyWith(vibrationEnabled: value);
    _save();
  }

  void toggleAnimations(bool value) {
    state = state.copyWith(animationsEnabled: value);
    _save();
  }

  void toggleKeepScreenOn(bool value) {
    state = state.copyWith(keepScreenOn: value);
    _save();
  }

  void setThemeMode(AppThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _save();
  }
}