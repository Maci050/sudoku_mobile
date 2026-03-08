import '../../game/domain/difficulty.dart';

class CompletedGame {
  final Difficulty difficulty;
  final Duration time;
  final DateTime completedAt;

  const CompletedGame({
    required this.difficulty,
    required this.time,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'difficulty': difficulty.name,
      'time': time.inSeconds,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory CompletedGame.fromMap(Map<dynamic, dynamic> map) {
    return CompletedGame(
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == map['difficulty'],
      ),
      time: Duration(seconds: map['time']),
      completedAt: DateTime.parse(map['completedAt']),
    );
  }
}