import 'package:hive_flutter/hive_flutter.dart';
import '../domain/achievement.dart';

class AchievementsStorage {
  static const _boxName = 'sudokuBox';
  static const _key = 'unlockedAchievements';

  Box get _box => Hive.box(_boxName);

  Set<String> loadUnlockedIds() {
    final raw = _box.get(_key);
    if (raw == null || raw is! List) return {};
    return raw.map((e) => e.toString()).toSet();
  }

  Future<void> saveUnlockedIds(Set<String> ids) async {
    await _box.put(_key, ids.toList());
  }

  bool isUnlocked(AchievementId id) {
    return loadUnlockedIds().contains(id.name);
  }
}