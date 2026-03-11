enum TrainingDifficulty {
  basic,
  intermediate,
  advanced,
}

class TrainingLevel {
  final String id;
  final String title;
  final String technique;
  final TrainingDifficulty difficulty;
  final int order;
  final String objective;
  final String explanation;
  final List<List<int>> puzzle;
  final int targetRow;
  final int targetCol;
  final int targetValue;

  const TrainingLevel({
    required this.id,
    required this.title,
    required this.technique,
    required this.difficulty,
    required this.order,
    required this.objective,
    required this.explanation,
    required this.puzzle,
    required this.targetRow,
    required this.targetCol,
    required this.targetValue,
  });
}