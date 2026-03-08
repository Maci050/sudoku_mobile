import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../history/presentation/history_page.dart';
import '../controllers/game_controller.dart';
import '../widgets/difficulty_selector.dart';
import '../widgets/game_toolbar.dart';
import '../widgets/keypad.dart';
import '../widgets/sudoku_grid.dart';
import '../widgets/timer_bar.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final dailyCompleted = controller.isTodayDailyChallengeCompleted();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TimerBar(
                    timeText: controller.formattedElapsed(),
                    isPaused: board.isPaused,
                    onTogglePause: () {
                      ref.read(gameControllerProvider.notifier).togglePause();
                    },
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: () {
                            ref.read(gameControllerProvider.notifier).startDailyChallenge();
                          },
                          icon: Icon(
                            dailyCompleted ? Icons.check_circle : Icons.calendar_today,
                          ),
                          label: Text(
                            dailyCompleted
                                ? 'Desafío diario completado'
                                : 'Jugar desafío diario',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  DifficultySelector(
                    currentDifficulty: board.difficulty,
                    onSelected: (difficulty) {
                      ref.read(gameControllerProvider.notifier).newGame(difficulty);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SudokuGrid(),
                  ),
                  const SizedBox(height: 20),
                  GameToolbar(
                    notesMode: board.notesMode,
                    onNewGame: () {
                      ref.read(gameControllerProvider.notifier).newGame(board.difficulty);
                    },
                    onToggleNotes: () {
                      ref.read(gameControllerProvider.notifier).toggleNotesMode();
                    },
                    onErase: () {
                      ref.read(gameControllerProvider.notifier).eraseSelectedCell();
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Keypad(
                      onPressed: (number) {
                        ref.read(gameControllerProvider.notifier).inputNumber(number);

                        if (controller.checkAndHandleCompletion()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                board.isDailyChallenge
                                    ? '¡Desafío diario completado!'
                                    : '¡Sudoku completado!',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            if (board.isPaused)
              Positioned.fill(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.pause_circle_filled,
                          size: 72,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Juego en pausa',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'El tablero está oculto para evitar trampas',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () {
                            ref.read(gameControllerProvider.notifier).resumeGame();
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Continuar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}