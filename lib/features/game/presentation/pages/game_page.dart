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
import '../widgets/hint_banner.dart';

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

  Future<void> _confirmSurrender(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Quieres rendirte?'),
        content: const Text(
          'Se mostrará la solución completa y esta partida quedará marcada como rendida. No podrás volver a intentarla.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Rendirme'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(gameControllerProvider.notifier).surrenderGame();
    }
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

                  /// TABLERO
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

                  /// SI NO ESTÁ RENDIDO → MOSTRAR CONTROLES
                  if (!board.isSurrendered) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GameToolbar(
                        notesMode: board.notesMode,
                        onNewGame: () {
                          ref.read(gameControllerProvider.notifier).restartCurrentGame();

                          if (board.isSurrendered) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Esta partida quedó rendida. Empieza una nueva desde el inicio.',
                                ),
                              ),
                            );
                          }
                        },
                        onSurrender: () {
                          _confirmSurrender(context);
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
                        onHint:() {
                          final found = ref.read(gameControllerProvider.notifier).requestHint();

                          if (!found) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No se han encontrado pistas disponibles.'),
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    if (board.activeHint != null) ...[
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: HintBanner(
                          hint: board.activeHint!,
                          onClose: () {
                            ref.read(gameControllerProvider.notifier).clearHint();
                          },
                          onApply: board.activeHint!.canAutoApply
                              ? () {
                                  ref.read(gameControllerProvider.notifier).applyHintAction();
                                }
                              : null,
                        ),
                      ),
                    ],

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
                  ]

                  /// SI ESTÁ RENDIDO → MENSAJE
                  else ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                'Te has rendido',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Se muestra la solución completa de este Sudoku. Esta partida ha quedado registrada como rendida.',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Volver'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              /// PAUSA
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