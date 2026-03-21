enum TutorialStepType {
  info,
  selectCell,
  placeNumber,
  toggleNotes,
  addNotes,
  finish,
}

class TutorialCellPosition {
  final int row;
  final int col;

  const TutorialCellPosition(this.row, this.col);

  @override
  bool operator ==(Object other) {
    return other is TutorialCellPosition &&
        other.row == row &&
        other.col == col;
  }

  @override
  int get hashCode => Object.hash(row, col);
}

class TutorialStep {
  final String title;
  final String message;
  final TutorialStepType type;
  final List<TutorialCellPosition> focusCells;
  final TutorialCellPosition? targetCell;
  final int? expectedNumber;
  final List<int> expectedNotes;

  const TutorialStep({
    required this.title,
    required this.message,
    required this.type,
    this.focusCells = const [],
    this.targetCell,
    this.expectedNumber,
    this.expectedNotes = const [],
  });
}