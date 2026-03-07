class GameBoard {
  final List<List<int?>> values;
  final int? selectedRow;
  final int? selectedCol;
  final bool notesMode;
  final List<List<Set<int>>> notes;

  const GameBoard({
    required this.values,
    required this.notes,
    this.selectedRow,
    this.selectedCol,
    this.notesMode = false,
  });

  GameBoard copyWith({
    List<List<int?>>? values,
    List<List<Set<int>>>? notes,
    int? selectedRow,
    int? selectedCol,
    bool? notesMode,
  }) {
    return GameBoard(
      values: values ?? this.values,
      notes: notes ?? this.notes,
      selectedRow: selectedRow,
      selectedCol: selectedCol,
      notesMode: notesMode ?? this.notesMode,
    );
  }

  factory GameBoard.empty() {
    return GameBoard(
      values: List.generate(9, (_) => List.generate(9, (_) => null)),
      notes: List.generate(
        9,
        (_) => List.generate(9, (_) => <int>{}),
      ),
    );
  }
}