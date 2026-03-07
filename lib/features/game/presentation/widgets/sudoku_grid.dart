import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';

class SudokuGrid extends ConsumerWidget {
  const SudokuGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(gameControllerProvider);

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          children: List.generate(9, (row) {
            return Expanded(
              child: Row(
                children: List.generate(9, (col) {
                  final value = board.values[row][col];
                  final notes = board.notes[row][col];
                  final isSelected =
                      board.selectedRow == row && board.selectedCol == col;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(gameControllerProvider.notifier).selectCell(row, col);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: row % 3 == 0 ? Colors.black : Colors.grey,
                              width: row % 3 == 0 ? 2 : 0.5,
                            ),
                            left: BorderSide(
                              color: col % 3 == 0 ? Colors.black : Colors.grey,
                              width: col % 3 == 0 ? 2 : 0.5,
                            ),
                            right: BorderSide(
                              color: col == 8 ? Colors.black : Colors.grey,
                              width: col == 8 ? 2 : 0.5,
                            ),
                            bottom: BorderSide(
                              color: row == 8 ? Colors.black : Colors.grey,
                              width: row == 8 ? 2 : 0.5,
                            ),
                          ),
                        ),
                        child: Center(
                          child: value != null
                              ? Text(
                                  '$value',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : _NotesView(notes: notes),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NotesView extends StatelessWidget {
  final Set<int> notes;

  const _NotesView({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: List.generate(9, (index) {
          final number = index + 1;
          return Center(
            child: Text(
              notes.contains(number) ? '$number' : '',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          );
        }),
      ),
    );
  }
}