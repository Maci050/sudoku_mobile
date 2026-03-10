import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/game_storage.dart';
import '../../data/sudoku_generator.dart';
import '../../domain/difficulty.dart';
import '../../domain/game_board.dart';
import '../../../history/data/history_storage.dart';
import '../../../history/domain/completed_game.dart';
import '../../../daily_challenge/data/daily_challenge_storage.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameBoard>((ref) {
  return GameController();
});

class GameController extends StateNotifier<GameBoard> {
  GameController() : super(GameBoard.empty());

  final GameStorage _storage = GameStorage();
  final HistoryStorage _historyStorage = HistoryStorage();
  final DailyChallengeStorage _dailyChallengeStorage = DailyChallengeStorage();
  Timer? _timer;

  bool _initialized = false;

  void surrenderGame() {
    if (state.isFinished) return;

    final solvedValues = state.solution
        .map<List<int?>>((row) => row.map<int?>((value) => value).toList())
        .toList();

    final clearedNotes = List.generate(
      9,
      (_) => List.generate(9, (_) => <int>{}),
    );

    _historyStorage.addGame(
      CompletedGame(
        difficulty: state.difficulty,
        time: state.elapsed,
        completedAt: DateTime.now(),
        status: GameResultStatus.surrendered,
      ),
    );

    state = state.copyWith(
      values: solvedValues,
      notes: clearedNotes,
      isFinished: true,
      isPaused: false,
      isSurrendered: true,
      selectedRow: null,
      selectedCol: null,
    );
    _saveGame();
  }

  void ensureInitialized() {
    if (_initialized) return;
    _initialized = true;

    final savedGame = _storage.loadGame();

    if (savedGame != null) {
      state = savedGame;
    } else {
      state = SudokuGenerator().generate(Difficulty.easy);
      _saveGame();
    }

    _startTimer();
  }

  Future<void> _saveGame() async {
    await _storage.saveGame(state);
  }

  void newGame(Difficulty difficulty) {
    ensureInitialized();
    state = SudokuGenerator().generate(difficulty);
    _startTimer();
    _saveGame();
  }

  String _buildChallengeId(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y$m$d';
  }

  bool isTodayDailyChallengeCompleted() {
    final challengeId = _buildChallengeId(DateTime.now());
    return _dailyChallengeStorage.isCompletedFor(challengeId);
  }

    bool openDailyChallenge() {
    final today = DateTime.now();

    if (isDailyChallengeCompletedForDate(today)) {
      return false;
    }

    return openDailyChallengeForDate(today);
  }

  void restartCurrentGame() {
    ensureInitialized();

    if (state.isSurrendered) {
      return;
    }

    if (state.isDailyChallenge && state.dailyChallengeId != null) {
      final challengeId = state.dailyChallengeId!;
      final seed = int.parse(challengeId);

      state = SudokuGenerator(seed: seed).generate(
        Difficulty.expert,
        isDailyChallenge: true,
        dailyChallengeId: challengeId,
      );
    } else {
      state = SudokuGenerator().generate(state.difficulty);
    }

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

  void toggleLimitMistakes(bool value) {
    state = state.copyWith(limitMistakesEnabled: value);
    _saveGame();
  }

  void toggleHighlightErrors(bool value) {
    state = state.copyWith(highlightErrors: value);
    _saveGame();
  }

  void toggleHighlightDuplicates(bool value) {
    state = state.copyWith(highlightDuplicates: value);
    _saveGame();
  }

  void toggleHideUsedNumbers(bool value) {
    state = state.copyWith(hideUsedNumbers: value);
    _saveGame();
  }

  void toggleHighlightRegions(bool value) {
    state = state.copyWith(highlightRegions: value);
    _saveGame();
  }

  void toggleHighlightSameNumbers(bool value) {
    state = state.copyWith(highlightSameNumbers: value);
    _saveGame();
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

    final isWrong = number != state.solution[row][col];

    newValues[row][col] = number;
    newNotes[row][col].clear();

    state = state.copyWith(
      values: newValues,
      notes: newNotes,
      mistakes: (state.limitMistakesEnabled && isWrong)
          ? state.mistakes + 1
          : state.mistakes,
    );

    if (state.limitMistakesEnabled && state.mistakes >= state.maxMistakes) {
      state = state.copyWith(
        isFinished: true,
        isPaused: false,
      );
    }

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
    if (!state.highlightErrors) return false;

    final value = state.values[row][col];
    if (value == null) return false;
    if (state.fixedCells[row][col]) return false;
    return value != state.solution[row][col];
  }

  bool hasDuplicate(int row, int col) {
    if (!state.highlightDuplicates) return false;

    final value = state.values[row][col];
    if (value == null) return false;

    for (int i = 0; i < 9; i++) {
      if (i != col && state.values[row][i] == value) return true;
      if (i != row && state.values[i][col] == value) return true;
    }

    final startRow = (row ~/ 3) * 3;
    final startCol = (col ~/ 3) * 3;

    for (int r = startRow; r < startRow + 3; r++) {
      for (int c = startCol; c < startCol + 3; c++) {
        if ((r != row || c != col) && state.values[r][c] == value) {
          return true;
        }
      }
    }

    return false;
  }

  bool shouldHighlightCell(int row, int col) {
    final selectedRow = state.selectedRow;
    final selectedCol = state.selectedCol;

    if (selectedRow == null || selectedCol == null) return false;
    if (selectedRow == row && selectedCol == col) return true;

    if (state.highlightRegions) {
      final sameRow = selectedRow == row;
      final sameCol = selectedCol == col;
      final sameBox =
          (selectedRow ~/ 3 == row ~/ 3) && (selectedCol ~/ 3 == col ~/ 3);

      if (sameRow || sameCol || sameBox) return true;
    }

    if (state.highlightSameNumbers) {
      final selectedValue = state.values[selectedRow][selectedCol];
      final currentValue = state.values[row][col];
      if (selectedValue != null &&
          currentValue != null &&
          selectedValue == currentValue) {
        return true;
      }
    }

    return false;
  }

  Set<int> usedUpNumbers() {
    if (!state.hideUsedNumbers) return {};

    final counts = <int, int>{for (int i = 1; i <= 9; i++) i: 0};

    for (final row in state.values) {
      for (final value in row) {
        if (value != null) {
          counts[value] = counts[value]! + 1;
        }
      }
    }

    return counts.entries
        .where((entry) => entry.value >= 9)
        .map((entry) => entry.key)
        .toSet();
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
        status: GameResultStatus.completed,
      ),
    );

    if (state.isDailyChallenge && state.dailyChallengeId != null) {
      _dailyChallengeStorage.markCompleted(state.dailyChallengeId!);
    }

    state = state.copyWith(
      isFinished: true,
      isPaused: false,
    );
    _saveGame();

    return true;
  }

  bool openDailyChallengeForDate(DateTime date) {
  ensureInitialized();

    final challengeId = _buildChallengeId(date);

    final savedGame = _storage.loadGame();

    if (savedGame != null &&
        savedGame.isDailyChallenge &&
        savedGame.dailyChallengeId == challengeId &&
        !savedGame.isFinished) {
      state = savedGame;
      _startTimer();
      _saveGame();
      return true;
    }

    final seed = int.parse(challengeId);

    state = SudokuGenerator(seed: seed).generate(
      Difficulty.expert,
      isDailyChallenge: true,
      dailyChallengeId: challengeId,
    );

    _startTimer();
    _saveGame();
    return true;
  }

  bool isDailyChallengeCompletedForDate(DateTime date) {
    final challengeId = _buildChallengeId(date);
    return _dailyChallengeStorage.isCompletedFor(challengeId);
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