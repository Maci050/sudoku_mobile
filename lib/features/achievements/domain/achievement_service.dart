import '../../history/data/history_storage.dart';
import '../../history/domain/completed_game.dart';
import '../../streak/data/streak_storage.dart';
import '../data/achievements_storage.dart';
import 'achievement.dart';

class AchievementService {
  final HistoryStorage _historyStorage = HistoryStorage();
  final StreakStorage _streakStorage = StreakStorage();
  final AchievementsStorage _achievementsStorage = AchievementsStorage();

  List<Achievement> loadUnlockedAchievements() {
    final unlocked = _achievementsStorage.loadUnlockedIds();
    return allAchievements
        .where((achievement) => unlocked.contains(achievement.id.name))
        .toList();
  }

  Future<List<Achievement>> evaluateAndUnlockNewAchievements() async {
    final history = _historyStorage.loadHistory();
    final unlockedIds = _achievementsStorage.loadUnlockedIds();
    final newlyUnlocked = <Achievement>[];

    final completedGames = history
        .where((g) => g.status == GameResultStatus.completed)
        .toList();

    final currentStreak = _streakStorage.getCurrentStreak();

    String difficultyText(dynamic difficulty) {
      final value = difficulty.toString().toLowerCase();

      if (value.contains('easy') || value.contains('fácil')) {
        return 'Fácil';
      }
      if (value.contains('medium') || value.contains('medio')) {
        return 'Medio';
      }
      if (value.contains('hard') || value.contains('difícil')) {
        return 'Difícil';
      }
      if (value.contains('expert') || value.contains('experto')) {
        return 'Experto';
      }
      if (value.contains('master') || value.contains('maestro')) {
        return 'Maestro';
      }
      if (value.contains('extreme') || value.contains('extremo')) {
        return 'Extremo';
      }

      return value;
    }

    bool hasDifficulty(String targetLabel) {
      return completedGames.any(
        (g) => difficultyText(g.difficulty).toLowerCase() == targetLabel.toLowerCase(),
      );
    }

    final noMistakeGames = completedGames.where((g) => g.mistakes == 0).length;
    final dailyCompleted = completedGames.where((g) => g.isDailyChallenge).length;

    void unlock(AchievementId id) {
      if (unlockedIds.contains(id.name)) return;
      unlockedIds.add(id.name);
      newlyUnlocked.add(allAchievements.firstWhere((a) => a.id == id));
    }

    if (completedGames.isNotEmpty) unlock(AchievementId.firstStep);
    if (completedGames.length >= 10) unlock(AchievementId.sudokuLover);
    if (completedGames.length >= 50) unlock(AchievementId.veteran50);
    if (completedGames.length >= 100) unlock(AchievementId.legend100);

    if (currentStreak >= 3) unlock(AchievementId.inARow3);
    if (currentStreak >= 7) unlock(AchievementId.streak7);
    if (currentStreak >= 14) unlock(AchievementId.streak14);
    if (currentStreak >= 30) unlock(AchievementId.streak30);

    if (completedGames.any((g) => g.time.inSeconds < 600)) {
      unlock(AchievementId.under10Minutes);
    }
    if (completedGames.any((g) => g.time.inSeconds < 420)) {
      unlock(AchievementId.under7Minutes);
    }
    if (completedGames.any((g) => g.time.inSeconds < 300)) {
      unlock(AchievementId.under5Minutes);
    }

    if (hasDifficulty('Difícil')) unlock(AchievementId.hardCompleted);
    if (hasDifficulty('Maestro')) unlock(AchievementId.masterCompleted);
    if (hasDifficulty('Extremo')) unlock(AchievementId.extremeCompleted);

    if (noMistakeGames >= 1) unlock(AchievementId.noMistakesOne);
    if (noMistakeGames >= 5) unlock(AchievementId.noMistakesFive);

    if (dailyCompleted >= 1) unlock(AchievementId.firstDaily);
    if (dailyCompleted >= 7) unlock(AchievementId.daily7);

    await _achievementsStorage.saveUnlockedIds(unlockedIds);

    return newlyUnlocked;
  }
}