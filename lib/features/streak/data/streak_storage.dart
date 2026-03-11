import 'package:hive_flutter/hive_flutter.dart';

class StreakStorage {
  static const _boxName = 'sudokuBox';

  int getCurrentStreak() {
    final box = Hive.box(_boxName);
    return box.get('streak', defaultValue: 0);
  }

  int getBestStreak() {
    final box = Hive.box(_boxName);
    return box.get('bestStreak', defaultValue: 0);
  }

  DateTime? getLastPlayedDate() {
    final box = Hive.box(_boxName);
    final value = box.get('lastPlayedDate');
    if (value == null) return null;
    return DateTime.parse(value);
  }

  Future<void> saveStreak(int streak) async {
    final box = Hive.box(_boxName);
    await box.put('streak', streak);
  }

  Future<void> saveBestStreak(int streak) async {
    final box = Hive.box(_boxName);
    await box.put('bestStreak', streak);
  }

  Future<void> saveLastPlayed(DateTime date) async {
    final box = Hive.box(_boxName);
    await box.put('lastPlayedDate', date.toIso8601String());
  }
} 