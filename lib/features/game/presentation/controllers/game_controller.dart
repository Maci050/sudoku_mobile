import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/game_board.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameBoard>((ref) {
  return GameController();
});

class GameController extends StateNotifier<GameBoard> {
  GameController() : super(GameBoard.empty());

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

    if (state.notesMode) {
      final newNotes = state.notes.map((r) => r.map((s) => {...s}).toList()).toList();

      if (newNotes[row][col].contains(number)) {
        newNotes[row][col].remove(number);
      } else {
        newNotes[row][col].add(number);
      }

      state = state.copyWith(notes: newNotes);
      return;
    }

    final newValues = state.values.map((row) => [...row]).toList();
    final newNotes = state.notes.map((r) => r.map((s) => {...s}).toList()).toList();

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

    final newValues = state.values.map((r) => [...r]).toList();
    final newNotes = state.notes.map((r) => r.map((s) => {...s}).toList()).toList();

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
}