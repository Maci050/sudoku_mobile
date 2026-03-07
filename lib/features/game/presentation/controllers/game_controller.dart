import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/game_board.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameBoard>((ref) {
  return GameController();
});

class GameController extends StateNotifier<GameBoard> {
  GameController() : super(_buildTestBoard());

  static GameBoard _buildTestBoard() {
    final puzzle = [
      [5, 3, 0, 0, 7, 0, 0, 0, 0],
      [6, 0, 0, 1, 9, 5, 0, 0, 0],
      [0, 9, 8, 0, 0, 0, 0, 6, 0],
      [8, 0, 0, 0, 6, 0, 0, 0, 3],
      [4, 0, 0, 8, 0, 3, 0, 0, 1],
      [7, 0, 0, 0, 2, 0, 0, 0, 6],
      [0, 6, 0, 0, 0, 0, 2, 8, 0],
      [0, 0, 0, 4, 1, 9, 0, 0, 5],
      [0, 0, 0, 0, 8, 0, 0, 7, 9],
    ];

    final solution = [
      [5, 3, 4, 6, 7, 8, 9, 1, 2],
      [6, 7, 2, 1, 9, 5, 3, 4, 8],
      [1, 9, 8, 3, 4, 2, 5, 6, 7],
      [8, 5, 9, 7, 6, 1, 4, 2, 3],
      [4, 2, 6, 8, 5, 3, 7, 9, 1],
      [7, 1, 3, 9, 2, 4, 8, 5, 6],
      [9, 6, 1, 5, 3, 7, 2, 8, 4],
      [2, 8, 7, 4, 1, 9, 6, 3, 5],
      [3, 4, 5, 2, 8, 6, 1, 7, 9],
    ];

    return GameBoard.fromPuzzle(
      puzzle: puzzle,
      solution: solution,
    );
  }

  void selectCell(int row, int col) {
    state = state.copyWith(
      selectedRow: row,
      selectedCol: col,
    );
  }

  void toggleNotesMode() {
    state = state.copyWith(
      notesMode: !state.notesMode,
    );
  }

  void inputNumber(int number) {
    final row = state.selectedRow;
    final col = state.selectedCol;

    if (row == null || col == null) return;
    if (state.fixedCells[row][col]) return;

    if (state.notesMode) {
      final newNotes = state.notes
          .map((r) => r.map((s) => {...s}).toList())
          .toList();

      if (newNotes[row][col].contains(number)) {
        newNotes[row][col].remove(number);
      } else {
        newNotes[row][col].add(number);
      }

      state = state.copyWith(notes: newNotes);
      return;
    }

    final newValues = state.values.map((row) => [...row]).toList();
    final newNotes = state.notes
        .map((r) => r.map((s) => {...s}).toList())
        .toList();

    newValues[row][col] = number;
    newNotes[row][col].clear();

    state = state.copyWith(
      values: newValues,
      notes: newNotes,
    );
  }

  void eraseSelectedCell() {
    final row = state.selectedRow;
    final col = state.selectedCol;

    if (row == null || col == null) return;
    if (state.fixedCells[row][col]) return;

    final newValues = state.values.map((r) => [...r]).toList();
    final newNotes = state.notes
        .map((r) => r.map((s) => {...s}).toList())
        .toList();

    if (state.notesMode) {
      newNotes[row][col].clear();
    } else {
      newValues[row][col] = null;
      newNotes[row][col].clear();
    }

    state = state.copyWith(
      values: newValues,
      notes: newNotes,
    );
  }

  bool isWrongValue(int row, int col) {
    final value = state.values[row][col];
    if (value == null) return false;
    if (state.fixedCells[row][col]) return false;
    return value != state.solution[row][col];
  }

  bool isCompleted() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (state.values[row][col] != state.solution[row][col]) {
          return false;
        }
      }
    }
    return true;
  }
}