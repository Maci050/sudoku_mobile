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

  const CompletedGame({
    required this.difficulty,
    required this.time,
    required this.completedAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'difficulty': difficulty.name,
      'time': time.inSeconds,
      'completedAt': completedAt.toIso8601String(),
      'status': status.name,
    };
  }

  factory CompletedGame.fromMap(Map<dynamic, dynamic> map) {
    return CompletedGame(
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == map['difficulty'],
      ),
      time: Duration(seconds: map['time']),
      completedAt: DateTime.parse(map['completedAt']),
      status: GameResultStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => GameResultStatus.completed,
      ),
    );
  }
}