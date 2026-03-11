class CellPosition {
  final int row;
  final int col;

  const CellPosition({
    required this.row,
    required this.col,
  });

  Map<String, dynamic> toMap() {
    return {
      'row': row,
      'col': col,
    };
  }

  factory CellPosition.fromMap(Map<dynamic, dynamic> map) {
    return CellPosition(
      row: map['row'] as int,
      col: map['col'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CellPosition && other.row == row && other.col == col;
  }

  @override
  int get hashCode => Object.hash(row, col);
}