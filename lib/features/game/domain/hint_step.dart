import 'cell_position.dart';

enum HintTechnique {
  nakedSingle,
  hiddenSingle,
  nakedPair,
}

class HintStep {
  final HintTechnique technique;
  final String title;
  final String description;
  final List<CellPosition> focusCells;
  final List<CellPosition> relatedCells;

  const HintStep({
    required this.technique,
    required this.title,
    required this.description,
    this.focusCells = const [],
    this.relatedCells = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'technique': technique.index,
      'title': title,
      'description': description,
      'focusCells': focusCells.map((e) => e.toMap()).toList(),
      'relatedCells': relatedCells.map((e) => e.toMap()).toList(),
    };
  }

  factory HintStep.fromMap(Map<dynamic, dynamic> map) {
    return HintStep(
      technique: HintTechnique.values[map['technique'] as int],
      title: map['title'] as String,
      description: map['description'] as String,
      focusCells: (map['focusCells'] as List)
          .map((e) => CellPosition.fromMap(e as Map))
          .toList(),
      relatedCells: (map['relatedCells'] as List)
          .map((e) => CellPosition.fromMap(e as Map))
          .toList(),
    );
  }
}