import 'difficulty.dart';

class GameBoard {
  final List<List<int?>> values;
  final List<List<bool>> fixedCells;
  final List<List<int>> solution;
  final Difficulty difficulty;
  final int? selectedRow;
  final int? selectedCol;
  final bool notesMode;
  final List<List<Set<int>>> notes;
  final Duration elapsed;
  final bool isPaused;

  const GameBoard({
    required this.values,
    required this.fixedCells,
    required this.solution,
    required this.difficulty,
    required this.notes,
    required this.elapsed,
    required this.isPaused,
    this.selectedRow,
    this.selectedCol,
    this.notesMode = false,
  });

  GameBoard copyWith({
    List<List<int?>>? values,
    List<List<bool>>? fixedCells,
    List<List<int>>? solution,
    Difficulty? difficulty,
    List<List<Set<int>>>? notes,
    Duration? elapsed,
    bool? isPaused,
    int? selectedRow,
    int? selectedCol,
    bool? notesMode,
  }) {
    return GameBoard(
      values: values ?? this.values,
      fixedCells: fixedCells ?? this.fixedCells,
      solution: solution ?? this.solution,
      difficulty: difficulty ?? this.difficulty,
      notes: notes ?? this.notes,
      elapsed: elapsed ?? this.elapsed,
      isPaused: isPaused ?? this.isPaused,
      selectedRow: selectedRow ?? this.selectedRow,
      selectedCol: selectedCol ?? this.selectedCol,
      notesMode: notesMode ?? this.notesMode,
    );
  }

  factory GameBoard.fromPuzzle({
    required List<List<int>> puzzle,
    required List<List<int>> solution,
    required Difficulty difficulty,
  }) {
    return GameBoard(
      values: puzzle
          .map((row) => row.map((value) => value == 0 ? null : value).toList())
          .toList(),
      fixedCells: puzzle
          .map((row) => row.map((value) => value != 0).toList())
          .toList(),
      solution: solution,
      difficulty: difficulty,
      notes: List.generate(
        9,
        (_) => List.generate(9, (_) => <int>{}),
      ),
      elapsed: Duration.zero,
      isPaused: false,
    );
  }

  factory GameBoard.empty() {
    return GameBoard(
      values: List.generate(9, (_) => List.generate(9, (_) => null)),
      fixedCells: List.generate(9, (_) => List.generate(9, (_) => false)),
      solution: List.generate(9, (_) => List.generate(9, (_) => 0)),
      difficulty: Difficulty.easy,
      notes: List.generate(
        9,
        (_) => List.generate(9, (_) => <int>{}),
      ),
      elapsed: Duration.zero,
      isPaused: false,
    );
  }
}