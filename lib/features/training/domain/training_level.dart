import '../../game/domain/cell_position.dart';

enum TrainingSkill {
  nakedSingle,
  hiddenSingle,
  nakedPair,
  hiddenPair,
  pointingPair,
  boxLineReduction,
}

extension TrainingSkillX on TrainingSkill {
  String get label {
    switch (this) {
      case TrainingSkill.nakedSingle:
        return 'Naked Single';
      case TrainingSkill.hiddenSingle:
        return 'Hidden Single';
      case TrainingSkill.nakedPair:
        return 'Naked Pair';
      case TrainingSkill.hiddenPair:
        return 'Hidden Pair';
      case TrainingSkill.pointingPair:
        return 'Pointing Pair';
      case TrainingSkill.boxLineReduction:
        return 'Box-Line Reduction';
    }
  }

  String get shortDescription {
    switch (this) {
      case TrainingSkill.nakedSingle:
        return 'Encuentra una casilla con un único candidato posible.';
      case TrainingSkill.hiddenSingle:
        return 'Encuentra un número que solo puede ir en una casilla de la unidad.';
      case TrainingSkill.nakedPair:
        return 'Detecta una pareja desnuda y úsala para reducir candidatos.';
      case TrainingSkill.hiddenPair:
        return 'Detecta una pareja oculta dentro de una fila, columna o bloque.';
      case TrainingSkill.pointingPair:
        return 'Usa la interacción entre bloque y línea para eliminar candidatos.';
      case TrainingSkill.boxLineReduction:
        return 'Usa una línea para eliminar candidatos dentro de un bloque.';
    }
  }
}

enum TrainingExerciseType {
  placeNumber,
  selectCells,
}

class TrainingLevel {
  final String id;
  final String title;
  final TrainingSkill skill;
  final int order;
  final TrainingExerciseType type;
  final String objective;
  final String explanation;

  final List<List<int>>? puzzle;
  final int? targetRow;
  final int? targetCol;
  final int? targetValue;

  final List<CellPosition> highlightedCells;
  final List<CellPosition> expectedSelectedCells;

  const TrainingLevel({
    required this.id,
    required this.title,
    required this.skill,
    required this.order,
    required this.type,
    required this.objective,
    required this.explanation,
    this.puzzle,
    this.targetRow,
    this.targetCol,
    this.targetValue,
    this.highlightedCells = const [],
    this.expectedSelectedCells = const [],
  });
}