import 'package:hive/hive.dart';
import '../domain/game_board.dart';

class GameStorage {
  static const String _boxName = 'sudokuBox';
  static const String _activeGameKey = 'activeGame';

  Box get _box => Hive.box(_boxName);

  Future<void> saveGame(GameBoard board) async {
    await _box.put(_activeGameKey, board.toMap());
  }

  GameBoard? loadGame() {
    try {
      final data = _box.get(_activeGameKey);

      if (data == null) return null;
      if (data is! Map) return null;

      return GameBoard.fromMap(data);
    } catch (_) {
      _box.delete(_activeGameKey);
      return null;
    }
  }

  Future<void> clearGame() async {
    await _box.delete(_activeGameKey);
  }
}