import 'difficulty.dart';
import 'hint_step.dart';

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
  final bool isSurrendered;

  final bool limitMistakesEnabled;
  final int mistakes;
  final int maxMistakes;
  final bool highlightErrors;
  final bool highlightDuplicates;
  final bool hideUsedNumbers;
  final bool highlightRegions;
  final bool highlightSameNumbers;

  final HintStep? activeHint;

  static const _noChange = Object();

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
    required this.isSurrendered,
    required this.limitMistakesEnabled,
    required this.mistakes,
    required this.maxMistakes,
    required this.highlightErrors,
    required this.highlightDuplicates,
    required this.hideUsedNumbers,
    required this.highlightRegions,
    required this.highlightSameNumbers,
    required this.activeHint,
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
    Object? dailyChallengeId = _noChange,
    bool? isSurrendered,
    bool? limitMistakesEnabled,
    int? mistakes,
    int? maxMistakes,
    bool? highlightErrors,
    bool? highlightDuplicates,
    bool? hideUsedNumbers,
    bool? highlightRegions,
    bool? highlightSameNumbers,
    Object? selectedRow = _noChange,
    Object? selectedCol = _noChange,
    bool? notesMode,
    Object? activeHint = _noChange,
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
      dailyChallengeId: identical(dailyChallengeId, _noChange)
          ? this.dailyChallengeId
          : dailyChallengeId as String?,
      isSurrendered: isSurrendered ?? this.isSurrendered,
      limitMistakesEnabled: limitMistakesEnabled ?? this.limitMistakesEnabled,
      mistakes: mistakes ?? this.mistakes,
      maxMistakes: maxMistakes ?? this.maxMistakes,
      highlightErrors: highlightErrors ?? this.highlightErrors,
      highlightDuplicates: highlightDuplicates ?? this.highlightDuplicates,
      hideUsedNumbers: hideUsedNumbers ?? this.hideUsedNumbers,
      highlightRegions: highlightRegions ?? this.highlightRegions,
      highlightSameNumbers:
          highlightSameNumbers ?? this.highlightSameNumbers,
      selectedRow: identical(selectedRow, _noChange)
          ? this.selectedRow
          : selectedRow as int?,
      selectedCol: identical(selectedCol, _noChange)
          ? this.selectedCol
          : selectedCol as int?,
      notesMode: notesMode ?? this.notesMode,
      activeHint: identical(activeHint, _noChange)
          ? this.activeHint
          : activeHint as HintStep?,
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
      notes: List.generate(9, (_) => List.generate(9, (_) => <int>{})),
      elapsed: Duration.zero,
      isPaused: false,
      isFinished: false,
      isDailyChallenge: isDailyChallenge,
      dailyChallengeId: dailyChallengeId,
      isSurrendered: false,
      limitMistakesEnabled: false,
      mistakes: 0,
      maxMistakes: 3,
      highlightErrors: true,
      highlightDuplicates: true,
      hideUsedNumbers: true,
      highlightRegions: true,
      highlightSameNumbers: true,
      activeHint: null,
    );
  }

  factory GameBoard.empty() {
    return GameBoard(
      values: List.generate(9, (_) => List.generate(9, (_) => null)),
      fixedCells: List.generate(9, (_) => List.generate(9, (_) => false)),
      solution: List.generate(9, (_) => List.generate(9, (_) => 0)),
      difficulty: Difficulty.easy,
      notes: List.generate(9, (_) => List.generate(9, (_) => <int>{})),
      elapsed: Duration.zero,
      isPaused: false,
      isFinished: false,
      isDailyChallenge: false,
      dailyChallengeId: null,
      isSurrendered: false,
      limitMistakesEnabled: false,
      mistakes: 0,
      maxMistakes: 3,
      highlightErrors: true,
      highlightDuplicates: true,
      hideUsedNumbers: true,
      highlightRegions: true,
      highlightSameNumbers: true,
      activeHint: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'values': values
          .map((row) => row.map((value) => value ?? 0).toList())
          .toList(),
      'fixedCells': fixedCells,
      'solution': solution,
      'difficulty': difficulty.toString(),
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
      'isSurrendered': isSurrendered,
      'limitMistakesEnabled': limitMistakesEnabled,
      'mistakes': mistakes,
      'maxMistakes': maxMistakes,
      'highlightErrors': highlightErrors,
      'highlightDuplicates': highlightDuplicates,
      'hideUsedNumbers': hideUsedNumbers,
      'highlightRegions': highlightRegions,
      'highlightSameNumbers': highlightSameNumbers,
      'activeHint': activeHint?.toMap(),
    };
  }

  factory GameBoard.fromMap(Map<dynamic, dynamic> map) {
    final difficultyString = (map['difficulty'] as String? ?? '').toLowerCase();

    Difficulty parseDifficulty() {
      for (final d in Difficulty.values) {
        if (d.toString().toLowerCase() == difficultyString) {
          return d;
        }
      }
      return Difficulty.easy;
    }

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
      difficulty: parseDifficulty(),
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
      isSurrendered: map['isSurrendered'] as bool? ?? false,
      limitMistakesEnabled: map['limitMistakesEnabled'] as bool? ?? false,
      mistakes: map['mistakes'] as int? ?? 0,
      maxMistakes: map['maxMistakes'] as int? ?? 3,
      highlightErrors: map['highlightErrors'] as bool? ?? true,
      highlightDuplicates: map['highlightDuplicates'] as bool? ?? true,
      hideUsedNumbers: map['hideUsedNumbers'] as bool? ?? true,
      highlightRegions: map['highlightRegions'] as bool? ?? true,
      highlightSameNumbers: map['highlightSameNumbers'] as bool? ?? true,
      activeHint: map['activeHint'] != null
          ? HintStep.fromMap(map['activeHint'] as Map)
          : null,
    );
  }
}