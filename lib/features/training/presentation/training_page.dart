import 'package:flutter/material.dart';
import '../data/training_levels_data.dart';
import '../data/training_progress_storage.dart';
import '../domain/training_level.dart';
import 'training_session_page.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  String _difficultyLabel(TrainingDifficulty difficulty) {
    switch (difficulty) {
      case TrainingDifficulty.basic:
        return 'Básico';
      case TrainingDifficulty.intermediate:
        return 'Intermedio';
      case TrainingDifficulty.advanced:
        return 'Avanzado';
    }
  }

  IconData _difficultyIcon(TrainingDifficulty difficulty) {
    switch (difficulty) {
      case TrainingDifficulty.basic:
        return Icons.school_outlined;
      case TrainingDifficulty.intermediate:
        return Icons.psychology_outlined;
      case TrainingDifficulty.advanced:
        return Icons.workspace_premium_outlined;
    }
  }

  bool _isUnlocked(
    TrainingLevel level,
    List<TrainingLevel> levelsInGroup,
    Set<String> completed,
  ) {
    final index = levelsInGroup.indexWhere((l) => l.id == level.id);
    if (index <= 0) return true;

    final previous = levelsInGroup[index - 1];
    return completed.contains(previous.id);
  }

  @override
  Widget build(BuildContext context) {
    final completed = TrainingProgressStorage().loadCompletedLevels();

    final grouped = <TrainingDifficulty, List<TrainingLevel>>{};
    for (final level in trainingLevels) {
      grouped.putIfAbsent(level.difficulty, () => []).add(level);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrenamiento'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: TrainingDifficulty.values.map((difficulty) {
          final levels = grouped[difficulty] ?? [];

          final completedInGroup =
              levels.where((level) => completed.contains(level.id)).length;

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_difficultyIcon(difficulty)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _difficultyLabel(difficulty),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text('$completedInGroup/${levels.length}'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...levels.map((level) {
                      final unlocked = _isUnlocked(level, levels, completed);
                      final isCompleted = completed.contains(level.id);

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          isCompleted
                              ? Icons.check_circle
                              : unlocked
                                  ? Icons.play_circle_outline
                                  : Icons.lock_outline,
                        ),
                        title: Text('${level.title} · ${level.technique}'),
                        subtitle: Text(level.objective),
                        trailing: unlocked
                            ? const Icon(Icons.chevron_right)
                            : const Icon(Icons.lock),
                        onTap: unlocked
                            ? () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TrainingSessionPage(level: level),
                                  ),
                                );
                                if (!context.mounted) return;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TrainingPage(),
                                  ),
                                );
                              }
                            : null,
                      );
                    }),
                    if (completedInGroup == levels.length && levels.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Categoría completada 🏅',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}