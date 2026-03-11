import 'package:flutter/material.dart';

class TrainingGrid extends StatelessWidget {
  final List<List<int?>> values;
  final int targetRow;
  final int targetCol;
  final int? selectedRow;
  final int? selectedCol;
  final void Function(int row, int col) onCellTap;

  const TrainingGrid({
    super.key,
    required this.values,
    required this.targetRow,
    required this.targetCol,
    required this.selectedRow,
    required this.selectedCol,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 81,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
        ),
        itemBuilder: (context, index) {
          final row = index ~/ 9;
          final col = index % 9;
          final value = values[row][col];
          final isTarget = row == targetRow && col == targetCol;
          final isSelected = row == selectedRow && col == selectedCol;
          final isFixed = value != null && !isTarget;

          Color? background;
          if (isTarget) {
            background = Colors.amber.withValues(alpha: 0.35);
          }
          if (isSelected) {
            background = Theme.of(context).colorScheme.primary.withValues(alpha: 0.20);
          }

          return GestureDetector(
            onTap: () => onCellTap(row, col),
            child: Container(
              decoration: BoxDecoration(
                color: background,
                border: Border(
                  top: BorderSide(width: row % 3 == 0 ? 2 : 0.5),
                  left: BorderSide(width: col % 3 == 0 ? 2 : 0.5),
                  right: BorderSide(width: col == 8 ? 2 : 0.5),
                  bottom: BorderSide(width: row == 8 ? 2 : 0.5),
                ),
              ),
              child: Center(
                child: Text(
                  value?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isFixed
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}