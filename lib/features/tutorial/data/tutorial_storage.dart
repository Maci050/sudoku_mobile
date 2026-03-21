import 'package:hive_flutter/hive_flutter.dart';

class TutorialStorage {
  static const String _boxName = 'sudokuBox';
  static const String _seenKey = 'tutorialSeen';

  Box get _box => Hive.box(_boxName);

  bool hasSeenTutorial() {
    return _box.get(_seenKey, defaultValue: false) as bool;
  }

  Future<void> markTutorialSeen() async {
    await _box.put(_seenKey, true);
  }

  Future<void> resetTutorial() async {
    await _box.put(_seenKey, false);
  }
}