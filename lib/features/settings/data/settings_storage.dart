import 'package:hive/hive.dart';
import '../domain/app_settings.dart';

class SettingsStorage {
  static const String _boxName = 'sudokuBox';
  static const String _settingsKey = 'appSettings';

  Box get _box => Hive.box(_boxName);

  AppSettings loadSettings() {
    try {
      final data = _box.get(_settingsKey);

      if (data == null || data is! Map) {
        return AppSettings.defaults();
      }

      return AppSettings.fromMap(data);
    } catch (_) {
      return AppSettings.defaults();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _box.put(_settingsKey, settings.toMap());
  }
}