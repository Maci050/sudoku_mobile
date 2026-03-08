import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/game_storage.dart';
import '../../data/sudoku_generator.dart';
import '../../domain/difficulty.dart';
import '../../domain/game_board.dart';
import '../../../history/data/history_storage.dart';
import '../../../history/domain/completed_game.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameBoard>((ref) {
  return GameController();
});

class GameController extends StateNotifier<GameBoard> {
  GameController() : super(GameBoard.empty()) {
    _restoreOrCreateGame();
  }

  final SudokuGenerator _generator = SudokuGenerator();
  final GameStorage _storage = GameStorage();
  final HistoryStorage _historyStorage = HistoryStorage();
  Timer? _timer;

  void _restoreOrCreateGame() {
    final savedGame = _storage.loadGame();

    if (savedGame != null) {
      state = savedGame;
    } else {
      state = _generator.generate(Difficulty.easy);
    }

    _startTimer();
    _saveGame();
  }

  Future<void> _saveGame() async {
    await _storage.saveGame(state);
  }

  void newGame(Difficulty difficulty) {
    state = _generator.generate(difficulty);
    _startTimer();
    _saveGame();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPaused && !state.isFinished) {
        state = state.copyWith(
          elapsed: state.elapsed + const Duration(seconds: 1),
        );
        _saveGame();
      }
    });
  }

  void pauseGame() {
    if (state.isFinished) return;
    state = state.copyWith(isPaused: true);
    _saveGame();
  }

  void resumeGame() {
    if (state.isFinished) return;
    state = state.copyWith(isPaused: false);
    _saveGame();
  }

  void togglePause() {
    if (state.isFinished) return;
    state = state.copyWith(isPaused: !state.isPaused);
    _saveGame();
  }

  void selectCell(int row, int col) {
    if (state.isPaused || state.isFinished) return;

    state = state.copyWith(
      selectedRow: row,
      selectedCol: col,
    );
    _saveGame();
  }

  void toggleNotesMode() {
    if (state.isPaused || state.isFinished) return;

    state = state.copyWith(
      notesMode: !state.notesMode,
    );
    _saveGame();
  }

  void inputNumber(int number) {
    if (state.isPaused || state.isFinished) return;

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
      _saveGame();
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
    _saveGame();
  }

  void eraseSelectedCell() {
    if (state.isPaused || state.isFinished) return;

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
    _saveGame();
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

  bool checkAndHandleCompletion() {
    if (state.isFinished) return false;
    if (!isCompleted()) return false;

    _historyStorage.addGame(
      CompletedGame(
        difficulty: state.difficulty,
        time: state.elapsed,
        completedAt: DateTime.now(),
      ),
    );

    state = state.copyWith(
      isFinished: true,
      isPaused: false,
    );
    _saveGame();

    return true;
  }

  String formattedElapsed() {
    final totalSeconds = state.elapsed.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> clearSavedGame() async {
    await _storage.clearGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}