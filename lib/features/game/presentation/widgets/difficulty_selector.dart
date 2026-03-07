import 'package:flutter/material.dart';
import '../../domain/difficulty.dart';

class DifficultySelector extends StatelessWidget {
  final Difficulty currentDifficulty;
  final ValueChanged<Difficulty> onSelected;

  const DifficultySelector({
    super.key,
    required this.currentDifficulty,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children: Difficulty.values.map((difficulty) {
        final isSelected = difficulty == currentDifficulty;

        return ChoiceChip(
          label: Text(difficulty.label),
          selected: isSelected,
          onSelected: (_) => onSelected(difficulty),
        );
      }).toList(),
    );
  }
}