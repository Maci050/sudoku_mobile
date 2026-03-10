enum AchievementId {
  firstStep,
  inARow3,
  sudokuLover,
  streak7,
  streak14,
  streak30,
  under5Minutes,
  under3Minutes,
  under2Minutes,
  hardCompleted,
  masterCompleted,
  extremeCompleted,
  noMistakesOne,
  noMistakesFive,
  firstDaily,
  daily7,
  veteran50,
  legend100,
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
    id: AchievementId.under5Minutes,
    title: 'Rápido',
    description: 'Completa un Sudoku en menos de 5 minutos.',
    emoji: '⚡',
  ),
  Achievement(
    id: AchievementId.under3Minutes,
    title: 'Velocista',
    description: 'Completa un Sudoku en menos de 3 minutos.',
    emoji: '⚡',
  ),
  Achievement(
    id: AchievementId.under2Minutes,
    title: 'Relámpago',
    description: 'Completa un Sudoku en menos de 2 minutos.',
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
];