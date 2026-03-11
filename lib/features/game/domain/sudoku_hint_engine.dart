import 'cell_position.dart';
import 'game_board.dart';
import 'hint_step.dart';

class SudokuHintEngine {
  HintStep? findNextHint(GameBoard board) {
    final candidates = _buildCandidates(board);

    return _findNakedSingle(board, candidates) ??
        _findHiddenSingle(board, candidates) ??
        _findNakedPair(board, candidates);
  }

  List<List<Set<int>>> _buildCandidates(GameBoard board) {
    return List.generate(9, (row) {
      return List.generate(9, (col) {
        if (board.values[row][col] != null) return <int>{};

        final used = <int>{};

        for (int i = 0; i < 9; i++) {
          final rowValue = board.values[row][i];
          final colValue = board.values[i][col];
          if (rowValue != null) used.add(rowValue);
          if (colValue != null) used.add(colValue);
        }

        final startRow = (row ~/ 3) * 3;
        final startCol = (col ~/ 3) * 3;

        for (int r = startRow; r < startRow + 3; r++) {
          for (int c = startCol; c < startCol + 3; c++) {
            final value = board.values[r][c];
            if (value != null) used.add(value);
          }
        }

        return {1, 2, 3, 4, 5, 6, 7, 8, 9}.difference(used);
      });
    });
  }

  HintStep? _findNakedSingle(
    GameBoard board,
    List<List<Set<int>>> candidates,
  ) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board.values[row][col] == null && candidates[row][col].length == 1) {
          final value = candidates[row][col].first;
          return HintStep(
            technique: HintTechnique.nakedSingle,
            title: 'Naked single',
            description:
                'La casilla resaltada solo puede contener el número $value. Colócalo ahí.',
            focusCells: [
              CellPosition(row: row, col: col),
            ],
          );
        }
      }
    }
    return null;
  }

  HintStep? _findHiddenSingle(
    GameBoard board,
    List<List<Set<int>>> candidates,
  ) {
    final units = _allUnits();

    for (final unit in units) {
      for (int number = 1; number <= 9; number++) {
        final matches = unit.where((cell) {
          return board.values[cell.row][cell.col] == null &&
              candidates[cell.row][cell.col].contains(number);
        }).toList();

        if (matches.length == 1) {
          final cell = matches.first;
          return HintStep(
            technique: HintTechnique.hiddenSingle,
            title: 'Hidden single',
            description:
                'En esta fila, columna o bloque, el número $number solo puede ir en la casilla resaltada.',
            focusCells: [cell],
          );
        }
      }
    }

    return null;
  }

  HintStep? _findNakedPair(
    GameBoard board,
    List<List<Set<int>>> candidates,
  ) {
    final units = _allUnits();

    for (final unit in units) {
      final pairMap = <String, List<CellPosition>>{};

      for (final cell in unit) {
        final cellCandidates = candidates[cell.row][cell.col];
        if (board.values[cell.row][cell.col] == null && cellCandidates.length == 2) {
          final sorted = cellCandidates.toList()..sort();
          final key = sorted.join(',');
          pairMap.putIfAbsent(key, () => []).add(cell);
        }
      }

      for (final entry in pairMap.entries) {
        if (entry.value.length == 2) {
          final pairValues =
              entry.key.split(',').map((e) => int.parse(e)).toSet();

          final related = <CellPosition>[];

          for (final cell in unit) {
            if (entry.value.contains(cell)) continue;
            final cellCandidates = candidates[cell.row][cell.col];
            if (cellCandidates.intersection(pairValues).isNotEmpty) {
              related.add(cell);
            }
          }

          if (related.isNotEmpty) {
            return HintStep(
              technique: HintTechnique.nakedPair,
              title: 'Naked pair',
              description:
                  'Las dos casillas resaltadas forman una pareja desnuda. Esos dos números quedan reservados para ellas, así que revisa las otras casillas marcadas y elimina esas opciones.',
              focusCells: entry.value,
              relatedCells: related,
            );
          }
        }
      }
    }

    return null;
  }

  List<List<CellPosition>> _allUnits() {
    final units = <List<CellPosition>>[];

    for (int row = 0; row < 9; row++) {
      units.add(List.generate(9, (col) => CellPosition(row: row, col: col)));
    }

    for (int col = 0; col < 9; col++) {
      units.add(List.generate(9, (row) => CellPosition(row: row, col: col)));
    }

    for (int boxRow = 0; boxRow < 3; boxRow++) {
      for (int boxCol = 0; boxCol < 3; boxCol++) {
        final unit = <CellPosition>[];
        for (int r = 0; r < 3; r++) {
          for (int c = 0; c < 3; c++) {
            unit.add(
              CellPosition(
                row: boxRow * 3 + r,
                col: boxCol * 3 + c,
              ),
            );
          }
        }
        units.add(unit);
      }
    }

    return units;
  }
}