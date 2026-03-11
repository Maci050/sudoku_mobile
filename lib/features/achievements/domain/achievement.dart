enum AchievementId {
  firstStep,
  inARow3,
  sudokuLover,
  streak7,
  streak14,
  streak30,
  under10Minutes,
  under7Minutes,
  under5Minutes,
  hardCompleted,
  masterCompleted,
  extremeCompleted,
  noMistakesOne,
  noMistakesFive,
  firstDaily,
  daily7,
  veteran50,
  legend100,
  noHintsOne,
  noHintsTen,
  noHintsFifty,
  firstHintUsed,
  hints25,
  hints100,
  perfectRun,
  trainingBasicCompleted,
  trainingIntermediateCompleted,
  trainingAdvancedCompleted,
  trainingAllCompleted,
}

class Achievement {
  final AchievementId id;
  final String title;
  final String description;
  final String emoji;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
  });
}

const allAchievements = [
  Achievement(
    id: AchievementId.firstStep,
    title: 'Primer paso',
    description: 'Completa tu primer Sudoku.',
    emoji: '🏆',
  ),
  Achievement(
    id: AchievementId.inARow3,
    title: 'En racha',
    description: 'Juega durante 3 días seguidos.',
    emoji: '🔥',
  ),
  Achievement(
    id: AchievementId.sudokuLover,
    title: 'Amante del Sudoku',
    description: 'Completa 10 Sudokus.',
    emoji: '🧠',
  ),
  Achievement(
    id: AchievementId.streak7,
    title: 'Constancia',
    description: 'Juega 7 días seguidos.',
    emoji: '🔥',
  ),
  Achievement(
    id: AchievementId.streak14,
    title: 'Dedicación',
    description: 'Juega 14 días seguidos.',
    emoji: '🔥',
  ),
  Achievement(
    id: AchievementId.streak30,
    title: 'Hábito formado',
    description: 'Juega 30 días seguidos.',
    emoji: '🔥',
  ),
  Achievement(
    id: AchievementId.under10Minutes,
    title: 'Rápido',
    description: 'Completa un Sudoku en menos de 10 minutos.',
    emoji: '⚡',
  ),
  Achievement(
    id: AchievementId.under7Minutes,
    title: 'Velocista',
    description: 'Completa un Sudoku en menos de 7 minutos.',
    emoji: '⚡',
  ),
  Achievement(
    id: AchievementId.under5Minutes,
    title: 'Relámpago',
    description: 'Completa un Sudoku en menos de 5 minutos.',
    emoji: '⚡',
  ),
  Achievement(
    id: AchievementId.hardCompleted,
    title: 'Jugador experto',
    description: 'Completa un Sudoku difícil.',
    emoji: '🧠',
  ),
  Achievement(
    id: AchievementId.masterCompleted,
    title: 'Maestro',
    description: 'Completa un Sudoku en dificultad Maestro.',
    emoji: '🧠',
  ),
  Achievement(
    id: AchievementId.extremeCompleted,
    title: 'Gran maestro',
    description: 'Completa un Sudoku en dificultad Extremo.',
    emoji: '🧠',
  ),
  Achievement(
    id: AchievementId.noMistakesOne,
    title: 'Sin errores',
    description: 'Completa un Sudoku sin cometer errores.',
    emoji: '🎯',
  ),
  Achievement(
    id: AchievementId.noMistakesFive,
    title: 'Precisión total',
    description: 'Completa 5 Sudokus sin errores.',
    emoji: '🎯',
  ),
  Achievement(
    id: AchievementId.firstDaily,
    title: 'Primer desafío',
    description: 'Completa tu primer desafío diario.',
    emoji: '📅',
  ),
  Achievement(
    id: AchievementId.daily7,
    title: 'Constancia diaria',
    description: 'Completa 7 desafíos diarios.',
    emoji: '📅',
  ),
  Achievement(
    id: AchievementId.veteran50,
    title: 'Veterano',
    description: 'Completa 50 Sudokus.',
    emoji: '🏁',
  ),
  Achievement(
    id: AchievementId.legend100,
    title: 'Leyenda',
    description: 'Completa 100 Sudokus.',
    emoji: '🏁',
  ),

  Achievement(
    id: AchievementId.noHintsOne,
    title: 'Pensador independiente',
    description: 'Completa un Sudoku sin usar pistas.',
    emoji: '🧩',
  ),
  Achievement(
    id: AchievementId.noHintsTen,
    title: 'Mente lógica',
    description: 'Completa 10 Sudokus sin usar pistas.',
    emoji: '🧩',
  ),
  Achievement(
    id: AchievementId.noHintsFifty,
    title: 'Maestro sin ayuda',
    description: 'Completa 50 Sudokus sin usar pistas.',
    emoji: '🧩',
  ),
  Achievement(
    id: AchievementId.firstHintUsed,
    title: 'Primera pista',
    description: 'Usa una pista por primera vez.',
    emoji: '💡',
  ),
  Achievement(
    id: AchievementId.hints25,
    title: 'Explorador',
    description: 'Usa 25 pistas en total.',
    emoji: '💡',
  ),
  Achievement(
    id: AchievementId.hints100,
    title: 'Aprendiz',
    description: 'Usa 100 pistas en total.',
    emoji: '💡',
  ),
  Achievement(
    id: AchievementId.perfectRun,
    title: 'Perfecto',
    description: 'Completa un Sudoku sin errores ni pistas.',
    emoji: '✨',
  ),
    Achievement(
    id: AchievementId.trainingBasicCompleted,
    title: 'Base sólida',
    description: 'Completa todos los ejercicios de entrenamiento básico.',
    emoji: '🎓',
  ),
  Achievement(
    id: AchievementId.trainingIntermediateCompleted,
    title: 'Técnica refinada',
    description: 'Completa todos los ejercicios de entrenamiento intermedio.',
    emoji: '🧠',
  ),
  Achievement(
    id: AchievementId.trainingAdvancedCompleted,
    title: 'Dominio avanzado',
    description: 'Completa todos los ejercicios de entrenamiento avanzado.',
    emoji: '🏅',
  ),
  Achievement(
    id: AchievementId.trainingAllCompleted,
    title: 'Maestro del entrenamiento',
    description: 'Completa todos los ejercicios de entrenamiento.',
    emoji: '🏆',
  ),
];