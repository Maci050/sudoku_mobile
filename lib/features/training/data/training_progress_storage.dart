import 'package:hive_flutter/hive_flutter.dart';

class TrainingProgressStorage {
  static const _boxName = 'sudokuBox';
  static const _completedKey = 'trainingCompletedLevels';

  Box get _box => Hive.box(_boxName);

  Set<String> loadCompletedLevels() {
    final raw = _box.get(_completedKey);
    if (raw == null || raw is! List) return {};
    return raw.map((e) => e.toString()).toSet();
  }

  Future<void> markCompleted(String levelId) async {
    final completed = loadCompletedLevels();
    completed.add(levelId);
    await _box.put(_completedKey, completed.toList());
  }

  bool isCompleted(String levelId) {
    return loadCompletedLevels().contains(levelId);
  }
}