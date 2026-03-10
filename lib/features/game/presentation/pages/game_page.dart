import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/difficulty.dart';
import '../controllers/game_controller.dart';
import '../widgets/game_settings_sheet.dart';
import '../widgets/game_toolbar.dart';
import '../widgets/keypad.dart';
import '../widgets/sudoku_grid.dart';
import '../widgets/game_stats_header.dart';
import 'game_result_page.dart';
import '../../../settings/presentation/settings_page.dart';

class GamePage extends ConsumerStatefulWidget {
  final Difficulty? startDifficulty;
  final bool startDailyChallenge;

  const GamePage({
    super.key,
    this.startDifficulty,
    this.startDailyChallenge = false,
  });

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(gameControllerProvider.notifier);
      controller.ensureInitialized();

      if (!widget.startDailyChallenge && widget.startDifficulty != null) {
        controller.newGame(widget.startDifficulty!);
      }
    });
  }

  int _filledCells(List<List<int?>> values) {
    int count = 0;
    for (final row in values) {
      for (final cell in row) {
        if (cell != null) count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final board = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, _) {
        ref.read(gameControllerProvider.notifier).pauseGame();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(board.isDailyChallenge ? 'Desafío diario' : 'Sudoku'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref.read(gameControllerProvider.notifier).pauseGame();
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GameStatsHeader(
                      progress: _filledCells(board.values),
                      difficultyLabel:
                          board.isDailyChallenge ? 'Diario' : board.difficulty.label,
                      timeText: controller.formattedElapsed(),
                      isPaused: board.isPaused,
                      mistakesText: board.limitMistakesEnabled
                          ? '${board.mistakes}/${board.maxMistakes}'
                          : null,
                      onTogglePause: () {
                        ref.read(gameControllerProvider.notifier).togglePause();
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: const SudokuGrid(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GameToolbar(
                      notesMode: board.notesMode,
                      onNewGame: () {
                        ref.read(gameControllerProvider.notifier).restartCurrentGame();
                      },
                      onToggleNotes: () {
                        ref.read(gameControllerProvider.notifier).toggleNotesMode();
                      },
                      onErase: () {
                        ref.read(gameControllerProvider.notifier).eraseSelectedCell();
                      },
                      onOpenSettings: () {
                        showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          builder: (_) => const GameSettingsSheet(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Keypad(
                      disabledNumbers: controller.usedUpNumbers(),
                      onPressed: (number) {
                        final wasFinished = board.isFinished;

                        ref.read(gameControllerProvider.notifier).inputNumber(number);

                        final updatedController =
                            ref.read(gameControllerProvider.notifier);
                        final updatedBoard = ref.read(gameControllerProvider);

                        if (!wasFinished &&
                            updatedController.checkAndHandleCompletion()) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameResultPage(
                                won: true,
                                isDailyChallenge: updatedBoard.isDailyChallenge,
                                difficulty: updatedBoard.difficulty,
                                elapsed: updatedBoard.elapsed,
                                mistakes: updatedBoard.mistakes,
                              ),
                            ),
                          );
                        } else if (updatedBoard.limitMistakesEnabled &&
                            updatedBoard.mistakes >= updatedBoard.maxMistakes &&
                            updatedBoard.isFinished) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameResultPage(
                                won: false,
                                isDailyChallenge: updatedBoard.isDailyChallenge,
                                difficulty: updatedBoard.difficulty,
                                elapsed: updatedBoard.elapsed,
                                mistakes: updatedBoard.mistakes,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
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
      ),
    );
  }
}