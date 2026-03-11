import 'package:hive_flutter/hive_flutter.dart';

class ActivityStorage {
  static const _boxName = 'sudokuBox';
  static const _key = 'activityDates';

  Box get _box => Hive.box(_boxName);

  List<String> loadActivityDates() {
    final raw = _box.get(_key);
    if (raw == null || raw is! List) return [];
    return raw.map((e) => e.toString()).toList();
  }

  Future<void> saveActivityDates(List<String> dates) async {
    await _box.put(_key, dates);
  }

  Future<void> registerTodayActivity() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayKey = today.toIso8601String();

    final dates = loadActivityDates();
    dates.add(todayKey);

    await saveActivityDates(dates);
  }
}