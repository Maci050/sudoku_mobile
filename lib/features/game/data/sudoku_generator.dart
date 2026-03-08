import 'dart:math';
import '../domain/difficulty.dart';
import '../domain/game_board.dart';

class SudokuGenerator {
  final Random _random;

  SudokuGenerator({int? seed}) : _random = Random(seed);

  GameBoard generate(
    Difficulty difficulty, {
    bool isDailyChallenge = false,
    String? dailyChallengeId,
  }) {
    final solution = List.generate(9, (_) => List.filled(9, 0));
    _fillBoard(solution);

    final puzzle = solution.map((row) => [...row]).toList();
    _removeCells(puzzle, difficulty.cellsToRemove);

    return GameBoard.fromPuzzle(
      puzzle: puzzle,
      solution: solution,
      difficulty: difficulty,
      isDailyChallenge: isDailyChallenge,
      dailyChallengeId: dailyChallengeId,
    );
  }

  bool _fillBoard(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          final numbers = List.generate(9, (index) => index + 1)
            ..shuffle(_random);

          for (final number in numbers) {
            if (_isValid(board, row, col, number)) {
              board[row][col] = number;

              if (_fillBoard(board)) {
                return true;
              }

              board[row][col] = 0;
            }
          }

          return false;
        }
      }
    }

    return true;
  }

  void _removeCells(List<List<int>> board, int cellsToRemove) {
    int removed = 0;

    while (removed < cellsToRemove) {
      final row = _random.nextInt(9);
      final col = _random.nextInt(9);

      if (board[row][col] != 0) {
        board[row][col] = 0;
        removed++;
      }
    }
  }

  bool _isValid(List<List<int>> board, int row, int col, int number) {
    for (int i = 0; i < 9; i++) {
      if (board[row][i] == number) return false;
      if (board[i][col] == number) return false;
    }

    final startRow = (row ~/ 3) * 3;
    final startCol = (col ~/ 3) * 3;

    for (int r = startRow; r < startRow + 3; r++) {
      for (int c = startCol; c < startCol + 3; c++) {
        if (board[r][c] == number) return false;
      }
    }

    return true;
  }
}