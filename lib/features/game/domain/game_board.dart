class GameBoard {
  final List<List<int?>> values;
  final List<List<bool>> fixedCells;
  final List<List<int>> solution;
  final int? selectedRow;
  final int? selectedCol;
  final bool notesMode;
  final List<List<Set<int>>> notes;

  const GameBoard({
    required this.values,
    required this.fixedCells,
    required this.solution,
    required this.notes,
    this.selectedRow,
    this.selectedCol,
    this.notesMode = false,
  });

  GameBoard copyWith({
    List<List<int?>>? values,
    List<List<bool>>? fixedCells,
    List<List<int>>? solution,
    List<List<Set<int>>>? notes,
    int? selectedRow,
    int? selectedCol,
    bool? notesMode,
  }) {
    return GameBoard(
      values: values ?? this.values,
      fixedCells: fixedCells ?? this.fixedCells,
      solution: solution ?? this.solution,
      notes: notes ?? this.notes,
      selectedRow: selectedRow,
      selectedCol: selectedCol,
      notesMode: notesMode ?? this.notesMode,
    );
  }

  factory GameBoard.fromPuzzle({
    required List<List<int>> puzzle,
    required List<List<int>> solution,
  }) {
    return GameBoard(
      values: puzzle
          .map((row) => row.map((value) => value == 0 ? null : value).toList())
          .toList(),
      fixedCells: puzzle
          .map((row) => row.map((value) => value != 0).toList())
          .toList(),
      solution: solution,
      notes: List.generate(
        9,
        (_) => List.generate(9, (_) => <int>{}),
      ),
    );
  }

  factory GameBoard.empty() {
    return GameBoard(
      values: List.generate(9, (_) => List.generate(9, (_) => null)),
      fixedCells: List.generate(9, (_) => List.generate(9, (_) => false)),
      solution: List.generate(9, (_) => List.generate(9, (_) => 0)),
      notes: List.generate(
        9,
        (_) => List.generate(9, (_) => <int>{}),
      ),
    );
  }
}