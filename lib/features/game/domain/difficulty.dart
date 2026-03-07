enum Difficulty {
  easy,
  medium,
  hard,
  expert,
  master,
  extreme,
}

extension DifficultyX on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'Fácil';
      case Difficulty.medium:
        return 'Medio';
      case Difficulty.hard:
        return 'Difícil';
      case Difficulty.expert:
        return 'Experto';
      case Difficulty.master:
        return 'Maestro';
      case Difficulty.extreme:
        return 'Extremo';
    }
  }

  int get cellsToRemove {
    switch (this) {
      case Difficulty.easy:
        return 40;
      case Difficulty.medium:
        return 46;
      case Difficulty.hard:
        return 52;
      case Difficulty.expert:
        return 56;
      case Difficulty.master:
        return 60;
      case Difficulty.extreme:
        return 64;
    }
  }
}