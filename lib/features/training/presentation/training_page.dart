import 'package:flutter/material.dart';
import '../data/training_levels_data.dart';
import '../data/training_progress_storage.dart';
import '../domain/training_level.dart';
import 'training_session_page.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  static const List<TrainingSkill> _skillOrder = [
    TrainingSkill.nakedSingle,
    TrainingSkill.hiddenSingle,
    TrainingSkill.nakedPair,
    TrainingSkill.hiddenPair,
    TrainingSkill.pointingPair,
    TrainingSkill.boxLineReduction,
  ];

  IconData _skillIcon(TrainingSkill skill) {
    switch (skill) {
      case TrainingSkill.nakedSingle:
        return Icons.filter_1_outlined;
      case TrainingSkill.hiddenSingle:
        return Icons.visibility_outlined;
      case TrainingSkill.nakedPair:
        return Icons.looks_two_outlined;
      case TrainingSkill.hiddenPair:
        return Icons.auto_awesome_outlined;
      case TrainingSkill.pointingPair:
        return Icons.call_made_outlined;
      case TrainingSkill.boxLineReduction:
        return Icons.grid_view_outlined;
    }
  }

  bool _isSkillUnlocked(
    TrainingSkill skill,
    Map<TrainingSkill, List<TrainingLevel>> grouped,
    Set<String> completed,
  ) {
    final index = _skillOrder.indexOf(skill);
    if (index <= 0) return true;

    final previousSkill = _skillOrder[index - 1];
    final previousLevels = grouped[previousSkill] ?? [];

    return previousLevels.isNotEmpty &&
        previousLevels.every((level) => completed.contains(level.id));
  }

  bool _isLevelUnlocked(
    TrainingLevel level,
    List<TrainingLevel> levelsInSkill,
    Set<String> completed,
  ) {
    final sorted = [...levelsInSkill]..sort((a, b) => a.order.compareTo(b.order));
    final index = sorted.indexWhere((l) => l.id == level.id);

    if (index <= 0) return true;

    final previous = sorted[index - 1];
    return completed.contains(previous.id);
  }

  String _lockedMessage(
    TrainingSkill skill,
    Map<TrainingSkill, List<TrainingLevel>> grouped,
  ) {
    final index = _skillOrder.indexOf(skill);
    if (index <= 0) return '';

    final previousSkill = _skillOrder[index - 1];
    return 'Completa todos los ejercicios de ${previousSkill.label} para desbloquear esta sección.';
  }

  @override
  Widget build(BuildContext context) {
    final completed = TrainingProgressStorage().loadCompletedLevels();

    final grouped = <TrainingSkill, List<TrainingLevel>>{};
    for (final level in trainingLevels) {
      grouped.putIfAbsent(level.skill, () => []).add(level);
    }

    for (final entry in grouped.entries) {
      entry.value.sort((a, b) => a.order.compareTo(b.order));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrenamiento'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _skillOrder.map((skill) {
          final levels = grouped[skill] ?? [];
          final skillUnlocked = _isSkillUnlocked(skill, grouped, completed);
          final completedInSkill =
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
                        Icon(_skillIcon(skill)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            skill.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text('$completedInSkill/${levels.length}'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      skill.shortDescription,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (!skillUnlocked) ...[
                      const SizedBox(height: 10),
                      Text(
                        _lockedMessage(skill, grouped),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    ...levels.map((level) {
                      final unlocked =
                          skillUnlocked && _isLevelUnlocked(level, levels, completed);
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
                        title: Text(level.title),
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
                    if (completedInSkill == levels.length && levels.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Skill completada',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
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