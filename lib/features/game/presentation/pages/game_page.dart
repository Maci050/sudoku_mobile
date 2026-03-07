import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../widgets/game_toolbar.dart';
import '../widgets/keypad.dart';
import '../widgets/sudoku_grid.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SudokuGrid(),
            ),
            const SizedBox(height: 20),
            GameToolbar(
              notesMode: board.notesMode,
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

                  if (controller.isCompleted()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Sudoku completado!'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}