import '../data/streak_storage.dart';

class StreakService {
  final StreakStorage storage = StreakStorage();

  Future<int> registerPlay() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final last = storage.getLastPlayedDate();
    int streak = storage.getCurrentStreak();
    int bestStreak = storage.getBestStreak();

    if (last == null) {
      streak = 1;
    } else {
      final lastDay = DateTime(last.year, last.month, last.day);
      final difference = today.difference(lastDay).inDays;

      if (difference == 0) {
        return streak;
      } else if (difference == 1) {
        streak += 1;
      } else {
        streak = 1;
      }
    }

    if (streak > bestStreak) {
      bestStreak = streak;
      await storage.saveBestStreak(bestStreak);
    }

    await storage.saveLastPlayed(today);
    await storage.saveStreak(streak);

    return streak;
  }
}