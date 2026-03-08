import 'difficulty.dart';

class GameBoard {
  final List<List<int?>> values;
  final List<List<bool>> fixedCells;
  final List<List<int>> solution;
  final Difficulty difficulty;
  final int? selectedRow;
  final int? selectedCol;
  final bool notesMode;
  final List<List<Set<int>>> notes;
  final Duration elapsed;
  final bool isPaused;
  final bool isFinished;
  final bool isDailyChallenge;
  final String? dailyChallengeId;

  const GameBoard({
    required this.values,
    required this.fixedCells,
    required this.solution,
    required this.difficulty,
    required this.notes,
    required this.elapsed,
    required this.isPaused,
    required this.isFinished,
    required this.isDailyChallenge,
    required this.dailyChallengeId,
    this.selectedRow,
    this.selectedCol,
    this.notesMode = false,
  });

  GameBoard copyWith({
    List<List<int?>>? values,
    List<List<bool>>? fixedCells,
    List<List<int>>? solution,
    Difficulty? difficulty,
    List<List<Set<int>>>? notes,
    Duration? elapsed,
    bool? isPaused,
    bool? isFinished,
    bool? isDailyChallenge,
    String? dailyChallengeId,
    int? selectedRow,
    int? selectedCol,
    bool? notesMode,
  }) {
    return GameBoard(
      values: values ?? this.values,
      fixedCells: fixedCells ?? this.fixedCells,
      solution: solution ?? this.solution,
      difficulty: difficulty ?? this.difficulty,
      notes: notes ?? this.notes,
      elapsed: elapsed ?? this.elapsed,
      isPaused: isPaused ?? this.isPaused,
      isFinished: isFinished ?? this.isFinished,
      isDailyChallenge: isDailyChallenge ?? this.isDailyChallenge,
      dailyChallengeId: dailyChallengeId ?? this.dailyChallengeId,
      selectedRow: selectedRow ?? this.selectedRow,
      selectedCol: selectedCol ?? this.selectedCol,
      notesMode: notesMode ?? this.notesMode,
    );
  }

  factory GameBoard.fromPuzzle({
    required List<List<int>> puzzle,
    required List<List<int>> solution,
    required Difficulty difficulty,
    bool isDailyChallenge = false,
    String? dailyChallengeId,
  }) {
    return GameBoard(
      values: puzzle
          .map((row) => row.map((value) => value == 0 ? null : value).toList())
          .toList(),
      fixedCells: puzzle
          .map((row) => row.map((value) => value != 0).toList())
          .toList(),
      solution: solution,
      difficulty: difficulty,
      notes: List.generate(
        9,
        (_) => List.generate(9, (_) => <int>{}),
      ),
      elapsed: Duration.zero,
      isPaused: false,
      isFinished: false,
      isDailyChallenge: isDailyChallenge,
      dailyChallengeId: dailyChallengeId,
    );
  }

  factory GameBoard.empty() {
    return GameBoard(
      values: List.generate(9, (_) => List.generate(9, (_) => null)),
      fixedCells: List.generate(9, (_) => List.generate(9, (_) => false)),
      solution: List.generate(9, (_) => List.generate(9, (_) => 0)),
      difficulty: Difficulty.easy,
      notes: List.generate(
        9,
        (_) => List.generate(9, (_) => <int>{}),
      ),
      elapsed: Duration.zero,
      isPaused: false,
      isFinished: false,
      isDailyChallenge: false,
      dailyChallengeId: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'values': values
          .map((row) => row.map((value) => value ?? 0).toList())
          .toList(),
      'fixedCells': fixedCells,
      'solution': solution,
      'difficulty': difficulty.name,
      'selectedRow': selectedRow,
      'selectedCol': selectedCol,
      'notesMode': notesMode,
      'notes': notes
          .map((row) => row.map((cellNotes) => cellNotes.toList()).toList())
          .toList(),
      'elapsedSeconds': elapsed.inSeconds,
      'isPaused': isPaused,
      'isFinished': isFinished,
      'isDailyChallenge': isDailyChallenge,
      'dailyChallengeId': dailyChallengeId,
    };
  }

  factory GameBoard.fromMap(Map<dynamic, dynamic> map) {
    return GameBoard(
      values: (map['values'] as List)
          .map<List<int?>>(
            (row) => (row as List)
                .map<int?>((value) => value == 0 ? null : value as int)
                .toList(),
          )
          .toList(),
      fixedCells: (map['fixedCells'] as List)
          .map<List<bool>>(
            (row) => (row as List).map<bool>((value) => value as bool).toList(),
          )
          .toList(),
      solution: (map['solution'] as List)
          .map<List<int>>(
            (row) => (row as List).map<int>((value) => value as int).toList(),
          )
          .toList(),
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == map['difficulty'],
        orElse: () => Difficulty.easy,
      ),
      selectedRow: map['selectedRow'] as int?,
      selectedCol: map['selectedCol'] as int?,
      notesMode: map['notesMode'] as bool? ?? false,
      notes: (map['notes'] as List)
          .map<List<Set<int>>>(
            (row) => (row as List)
                .map<Set<int>>(
                  (cellNotes) => (cellNotes as List)
                      .map<int>((value) => value as int)
                      .toSet(),
                )
                .toList(),
          )
          .toList(),
      elapsed: Duration(seconds: map['elapsedSeconds'] as int? ?? 0),
      isPaused: map['isPaused'] as bool? ?? false,
      isFinished: map['isFinished'] as bool? ?? false,
      isDailyChallenge: map['isDailyChallenge'] as bool? ?? false,
      dailyChallengeId: map['dailyChallengeId'] as String?,
    );
  }
}