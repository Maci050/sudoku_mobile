import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../../../settings/presentation/settings_controller.dart';
import 'sudoku_board_theme.dart';

class SudokuGrid extends ConsumerWidget {
  const SudokuGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final settings = ref.watch(settingsControllerProvider);
    final palette = paletteForBoardTheme(settings.boardTheme);

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: palette.boardBackground,
          border: Border.all(color: palette.thickLine, width: 2),
        ),
        child: Column(
          children: List.generate(9, (row) {
            return Expanded(
              child: Row(
                children: List.generate(9, (col) {
                  final value = board.values[row][col];
                  final notes = board.notes[row][col];
                  final isFixed = board.fixedCells[row][col];
                  final isSelected =
                      board.selectedRow == row && board.selectedCol == col;
                  final hasError = controller.isWrongValue(row, col);
                  final hasDuplicate = controller.hasDuplicate(row, col);
                  final isDuplicateConflictGroup =
                      controller.isInDuplicateConflictGroup(row, col);
                  final isHighlighted = controller.shouldHighlightCell(row, col);
                  final hint = board.activeHint;

                  final isHintFocus = hint?.focusCells.any(
                        (cell) => cell.row == row && cell.col == col,
                      ) ??
                      false;

                  final isHintRelated = hint?.relatedCells.any(
                        (cell) => cell.row == row && cell.col == col,
                      ) ??
                      false;

                  final hasConflict =
                      hasError || hasDuplicate || isDuplicateConflictGroup;

                  Color backgroundColor = palette.cellBackground;

                  if (isHighlighted) {
                    backgroundColor = palette.highlightedCell;
                  }

                  if (hasDuplicate || isDuplicateConflictGroup) {
                    backgroundColor = palette.errorCell;
                  }

                  if (hasError) {
                    backgroundColor = palette.errorCell;
                  }

                  if (isHintFocus) {
                    backgroundColor = palette.hintFocusCell;
                  } else if (isHintRelated) {
                    backgroundColor = palette.hintRelatedCell;
                  }

                  if (isSelected && !hasConflict) {
                    backgroundColor = palette.selectedCell;
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(gameControllerProvider.notifier)
                            .selectCell(row, col);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border(
                            top: BorderSide(
                              color: row % 3 == 0 ? palette.thickLine : palette.thinLine,
                              width: row % 3 == 0 ? 2 : 0.5,
                            ),
                            left: BorderSide(
                              color: col % 3 == 0 ? palette.thickLine : palette.thinLine,
                              width: col % 3 == 0 ? 2 : 0.5,
                            ),
                            right: BorderSide(
                              color: col == 8 ? palette.thickLine : palette.thinLine,
                              width: col == 8 ? 2 : 0.5,
                            ),
                            bottom: BorderSide(
                              color: row == 8 ? palette.thickLine : palette.thinLine,
                              width: row == 8 ? 2 : 0.5,
                            ),
                          ),
                        ),
                        child: Center(
                          child: value != null
                              ? Text(
                                  '$value',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: isFixed
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: hasConflict
                                        ? palette.errorCell
                                        : (isFixed
                                            ? palette.fixedNumber
                                            : palette.userNumber),
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
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          );
        }),
      ),
    );
  }
}