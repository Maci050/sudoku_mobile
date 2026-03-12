import 'package:hive_flutter/hive_flutter.dart';
import '../domain/app_settings.dart';

class SettingsStorage {
  static const _boxName = 'sudokuBox';
  static const _key = 'appSettings';

  Box get _box => Hive.box(_boxName);

  AppSettings loadSettings() {
    final raw = _box.get(_key);
    if (raw == null || raw is! Map) {
      return AppSettings.defaults();
    }
    return AppSettings.fromMap(raw);
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _box.put(_key, settings.toMap());
  }
}