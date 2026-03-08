class DailyChallengeInfo {
  final String challengeId;
  final bool completed;

  const DailyChallengeInfo({
    required this.challengeId,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'challengeId': challengeId,
      'completed': completed,
    };
  }

  factory DailyChallengeInfo.fromMap(Map<dynamic, dynamic> map) {
    return DailyChallengeInfo(
      challengeId: map['challengeId'] as String,
      completed: map['completed'] as bool? ?? false,
    );
  }
}