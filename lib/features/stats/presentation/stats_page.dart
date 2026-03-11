import 'package:flutter/material.dart';
import '../../achievements/domain/achievement.dart';
import '../../achievements/domain/achievement_service.dart';
import '../../achievements/presentation/achievements_page.dart';
import '../../history/data/history_storage.dart';
import '../../history/domain/completed_game.dart';
import '../../streak/data/streak_storage.dart';
import '../../activity/data/activity_storage.dart';
import '../../game/presentation/widgets/activity_calendar.dart'; 

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  String _difficultyLabel(dynamic difficulty) {
    final value = difficulty.toString().toLowerCase();

    if (value.contains('easy') || value.contains('fácil')) return 'Fácil';
    if (value.contains('medium') || value.contains('medio')) return 'Medio';
    if (value.contains('hard') || value.contains('difícil')) return 'Difícil';
    if (value.contains('expert') || value.contains('experto')) return 'Experto';
    if (value.contains('master') || value.contains('maestro')) return 'Maestro';
    if (value.contains('extreme') || value.contains('extremo')) return 'Extremo';

    return difficulty.toString();
  }

  @override
  Widget build(BuildContext context) {
    final history = HistoryStorage().loadHistory();
    final streakStorage = StreakStorage();
    final currentStreak = streakStorage.getCurrentStreak();
    final bestStreak = streakStorage.getBestStreak();
    final unlockedAchievements =
        AchievementService().loadUnlockedAchievements().length;
    final activityDates = ActivityStorage().loadActivityDates();
    final activeDays = activityDates
        .map((e) => DateTime.parse(e))
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();

    final completedGames = history
        .where((g) => g.status == GameResultStatus.completed)
        .toList();

    final surrenderedGames = history
        .where((g) => g.status == GameResultStatus.surrendered)
        .toList();

    final totalPlayed = history.length;
    final totalCompleted = completedGames.length;
    final totalSurrendered = surrenderedGames.length;
    final totalDailyCompleted =
        completedGames.where((g) => g.isDailyChallenge).length;

    Duration? bestTime;
    Duration? averageTime;

    if (completedGames.isNotEmpty) {
      bestTime = completedGames
          .map((e) => e.time)
          .reduce((a, b) => a.inSeconds < b.inSeconds ? a : b);

      averageTime = Duration(
        seconds: completedGames
                .map((e) => e.time.inSeconds)
                .reduce((a, b) => a + b) ~/
            completedGames.length,
      );
    }

    final byDifficulty = <String, int>{};
    for (final game in completedGames) {
      final label = _difficultyLabel(game.difficulty);
      byDifficulty[label] = (byDifficulty[label] ?? 0) + 1;
    }

    final orderedDifficulties = [
      'Fácil',
      'Medio',
      'Difícil',
      'Experto',
      'Maestro',
      'Extremo',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(title: 'Progreso'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_fire_department),
              title: const Text('Racha actual'),
              trailing: Text(
                '$currentStreak días',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: const Text('Mejor racha'),
              trailing: Text(
                '$bestStreak días',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: const Text('Logros desbloqueados'),
              trailing: Text(
                '$unlockedAchievements/${allAchievements.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AchievementsPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          ActivityCalendar(activeDays: activeDays),
          const SizedBox(height: 24),
          _SectionTitle(title: 'Partidas'),
          _StatCard(
            title: 'Sudokus jugados',
            value: '$totalPlayed',
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Sudokus completados',
            value: '$totalCompleted',
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Sudokus rendidos',
            value: '$totalSurrendered',
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Desafíos diarios completados',
            value: '$totalDailyCompleted',
          ),
          const SizedBox(height: 24),
          _SectionTitle(title: 'Tiempos'),
          _StatCard(
            title: 'Mejor tiempo',
            value: bestTime != null ? _formatDuration(bestTime) : '--:--',
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Tiempo medio',
            value: averageTime != null ? _formatDuration(averageTime) : '--:--',
          ),
          const SizedBox(height: 24),
          _SectionTitle(title: 'Por dificultad'),
          if (byDifficulty.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Aún no hay Sudokus completados.'),
              ),
            )
          else
            ...orderedDifficulties
                .where((difficulty) => byDifficulty.containsKey(difficulty))
                .map(
                  (difficulty) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _StatCard(
                      title: difficulty,
                      value: '${byDifficulty[difficulty]}',
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}