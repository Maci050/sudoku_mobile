import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../game/domain/difficulty.dart';
import '../../game/presentation/controllers/game_controller.dart';
import '../../game/presentation/pages/game_page.dart';
import '../../history/presentation/history_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _openGame(BuildContext context, Difficulty difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GamePage(
          startDifficulty: difficulty,
          startDailyChallenge: false,
        ),
      ),
    );
  }

  void _openHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HistoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameControllerProvider.notifier);
    final dailyCompleted = controller.isTodayDailyChallengeCompleted();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'Elige cómo quieres jugar',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              const Text(
                'Nuevo juego',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: Difficulty.values.map((difficulty) {
                  return FilledButton.tonal(
                    onPressed: () => _openGame(context, difficulty),
                    child: Text(difficulty.label),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: dailyCompleted
                    ? null
                    : () {
                        final opened = controller.openDailyChallenge();

                        if (!opened) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ya has completado el desafío diario de hoy.'),
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GamePage(
                              startDailyChallenge: true,
                            ),
                          ),
                        );
                      },
                icon: Icon(
                  dailyCompleted ? Icons.check_circle : Icons.calendar_today,
                ),
                label: Text(
                  dailyCompleted
                      ? 'Desafío diario completado'
                      : 'Desafío diario',
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => _openHistory(context),
                icon: const Icon(Icons.history),
                label: const Text('Historial'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}