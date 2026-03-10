import '../../game/domain/difficulty.dart';

enum GameResultStatus {
  completed,
  surrendered,
}

class CompletedGame {
  final Difficulty difficulty;
  final Duration time;
  final DateTime completedAt;
  final GameResultStatus status;
  final int mistakes;
  final bool isDailyChallenge;

  const CompletedGame({
    required this.difficulty,
    required this.time,
    required this.completedAt,
    required this.status,
    this.mistakes = 0,
    this.isDailyChallenge = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'difficulty': difficulty.name,
      'time': time.inSeconds,
      'completedAt': completedAt.toIso8601String(),
      'status': status.name,
      'mistakes': mistakes,
      'isDailyChallenge': isDailyChallenge,
    };
  }

  factory CompletedGame.fromMap(Map<dynamic, dynamic> map) {
    return CompletedGame(
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == map['difficulty'],
        orElse: () => Difficulty.easy,
      ),
      time: Duration(seconds: map['time'] as int? ?? 0),
      completedAt: DateTime.parse(map['completedAt'] as String),
      status: GameResultStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => GameResultStatus.completed,
      ),
      mistakes: map['mistakes'] as int? ?? 0,
      isDailyChallenge: map['isDailyChallenge'] as bool? ?? false,
    );
  }
}