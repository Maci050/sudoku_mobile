import '../../history/data/history_storage.dart';
import '../../history/domain/completed_game.dart';
import '../../streak/data/streak_storage.dart';
import '../../training/data/training_levels_data.dart';
import '../../training/data/training_progress_storage.dart';
import '../../training/domain/training_level.dart';
import '../data/achievements_storage.dart';
import 'achievement.dart';

class AchievementService {
  final HistoryStorage _historyStorage = HistoryStorage();
  final StreakStorage _streakStorage = StreakStorage();
  final AchievementsStorage _achievementsStorage = AchievementsStorage();
  final TrainingProgressStorage _trainingProgressStorage =
      TrainingProgressStorage();

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

      if (value.contains('easy') || value.contains('fácil')) return 'Fácil';
      if (value.contains('medium') || value.contains('medio')) return 'Medio';
      if (value.contains('hard') || value.contains('difícil')) return 'Difícil';
      if (value.contains('expert') || value.contains('experto')) return 'Experto';
      if (value.contains('master') || value.contains('maestro')) return 'Maestro';
      if (value.contains('extreme') || value.contains('extremo')) return 'Extremo';

      return value;
    }

    bool hasDifficulty(String targetLabel) {
      return completedGames.any(
        (g) => difficultyText(g.difficulty).toLowerCase() == targetLabel.toLowerCase(),
      );
    }

    final noMistakeGames = completedGames.where((g) => g.mistakes == 0).length;
    final dailyCompleted = completedGames.where((g) => g.isDailyChallenge).length;

    final noHintGames = completedGames.where((g) => g.hintsUsed == 0).length;
    final totalHintsUsed = history.fold<int>(0, (sum, g) => sum + g.hintsUsed);
    final perfectGames = completedGames
        .where((g) => g.mistakes == 0 && g.hintsUsed == 0)
        .length;
    final usedAnyHint = history.any((g) => g.hintsUsed > 0);

    final completedTraining = _trainingProgressStorage.loadCompletedLevels();

    final basicLevels = trainingLevels
        .where((level) => level.difficulty == TrainingDifficulty.basic)
        .toList();
    final intermediateLevels = trainingLevels
        .where((level) => level.difficulty == TrainingDifficulty.intermediate)
        .toList();
    final advancedLevels = trainingLevels
        .where((level) => level.difficulty == TrainingDifficulty.advanced)
        .toList();

    final allTrainingLevels = trainingLevels.map((level) => level.id).toList();

    final basicCompleted = basicLevels.isNotEmpty &&
        basicLevels.every((level) => completedTraining.contains(level.id));

    final intermediateCompleted = intermediateLevels.isNotEmpty &&
        intermediateLevels.every((level) => completedTraining.contains(level.id));

    final advancedCompleted = advancedLevels.isNotEmpty &&
        advancedLevels.every((level) => completedTraining.contains(level.id));

    final allTrainingCompleted = allTrainingLevels.isNotEmpty &&
        allTrainingLevels.every((id) => completedTraining.contains(id));

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

    if (noHintGames >= 1) unlock(AchievementId.noHintsOne);
    if (noHintGames >= 10) unlock(AchievementId.noHintsTen);
    if (noHintGames >= 50) unlock(AchievementId.noHintsFifty);

    if (usedAnyHint) unlock(AchievementId.firstHintUsed);
    if (totalHintsUsed >= 25) unlock(AchievementId.hints25);
    if (totalHintsUsed >= 100) unlock(AchievementId.hints100);

    if (perfectGames >= 1) unlock(AchievementId.perfectRun);

    if (basicCompleted) unlock(AchievementId.trainingBasicCompleted);
    if (intermediateCompleted) {
      unlock(AchievementId.trainingIntermediateCompleted);
    }
    if (advancedCompleted) unlock(AchievementId.trainingAdvancedCompleted);
    if (allTrainingCompleted) unlock(AchievementId.trainingAllCompleted);

    await _achievementsStorage.saveUnlockedIds(unlockedIds);
    return newlyUnlocked;
  }
}