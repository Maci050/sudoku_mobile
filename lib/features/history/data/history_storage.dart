import 'package:hive/hive.dart';
import '../domain/completed_game.dart';

class HistoryStorage {
  static const String _boxName = 'sudokuBox';
  static const String _historyKey = 'history';

  Box get _box => Hive.box(_boxName);

  List<CompletedGame> loadHistory() {
    final data = _box.get(_historyKey);

    if (data == null) return [];

    return (data as List)
        .map((e) => CompletedGame.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();
  }

  Future<void> addGame(CompletedGame game) async {
    final history = loadHistory();

    history.insert(0, game);

    await _box.put(
      _historyKey,
      history.map((e) => e.toMap()).toList(),
    );
  }
}