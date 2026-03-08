import 'package:hive/hive.dart';
import '../domain/daily_challenge_info.dart';

class DailyChallengeStorage {
  static const String _boxName = 'sudokuBox';
  static const String _dailyChallengeKey = 'dailyChallengeStatus';

  Box get _box => Hive.box(_boxName);

  DailyChallengeInfo? loadInfo() {
    final data = _box.get(_dailyChallengeKey);
    if (data == null || data is! Map) return null;

    return DailyChallengeInfo.fromMap(data);
  }

  Future<void> saveInfo(DailyChallengeInfo info) async {
    await _box.put(_dailyChallengeKey, info.toMap());
  }

  Future<void> markCompleted(String challengeId) async {
    await saveInfo(
      DailyChallengeInfo(
        challengeId: challengeId,
        completed: true,
      ),
    );
  }

  bool isCompletedFor(String challengeId) {
    final info = loadInfo();
    if (info == null) return false;
    return info.challengeId == challengeId && info.completed;
  }
}