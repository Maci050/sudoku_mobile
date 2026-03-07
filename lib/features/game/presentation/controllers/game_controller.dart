import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/sudoku_generator.dart';
import '../../domain/difficulty.dart';
import '../../domain/game_board.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameBoard>((ref) {
  return GameController();
});

class GameController extends StateNotifier<GameBoard> {
  GameController() : super(SudokuGenerator().generate(Difficulty.easy)) {
    _startTimer();
  }

  final SudokuGenerator _generator = SudokuGenerator();
  Timer? _timer;

  void newGame(Difficulty difficulty) {
    state = _generator.generate(difficulty);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPaused && !isCompleted()) {
        state = state.copyWith(
          elapsed: state.elapsed + const Duration(seconds: 1),
        );
      }
    });
  }

  void pauseGame() {
    state = state.copyWith(isPaused: true);
  }

  void resumeGame() {
    state = state.copyWith(isPaused: false);
  }

  void togglePause() {
    state = state.copyWith(isPaused: !state.isPaused);
  }

  void selectCell(int row, int col) {
    if (state.isPaused) return;

    state = state.copyWith(
      selectedRow: row,
      selectedCol: col,
    );
  }

  void toggleNotesMode() {
    if (state.isPaused) return;

    state = state.copyWith(
      notesMode: !state.notesMode,
    );
  }

  void inputNumber(int number) {
    if (state.isPaused) return;

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
    if (state.isPaused) return;

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

  String formattedElapsed() {
    final totalSeconds = state.elapsed.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}