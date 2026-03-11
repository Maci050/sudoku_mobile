import 'cell_position.dart';
import 'game_board.dart';
import 'hint_step.dart';

class SudokuHintEngine {
  HintStep? findNextHint(GameBoard board) {
    final candidates = _buildCandidates(board);

    return _findNakedSingle(board, candidates) ??
        _findHiddenSingle(board, candidates) ??
        _findNakedPair(board, candidates) ??
        _findHiddenPair(board, candidates) ??
        _findPointingPair(board, candidates) ??
        _findBoxLineReduction(board, candidates) ??
        _findIncorrectNotes(board, candidates) ??
        _findMissingNotes(board, candidates);
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
                  'Las dos casillas resaltadas forman una pareja desnuda. Esos dos números quedan reservados para ellas, así que revisa las casillas marcadas y elimina esas opciones.',
              focusCells: entry.value,
              relatedCells: related,
            );
          }
        }
      }
    }

    return null;
  }

  HintStep? _findHiddenPair(
    GameBoard board,
    List<List<Set<int>>> candidates,
  ) {
    final units = _allUnits();

    for (final unit in units) {
      final positionsByNumber = <int, List<CellPosition>>{};

      for (int number = 1; number <= 9; number++) {
        positionsByNumber[number] = unit.where((cell) {
          return board.values[cell.row][cell.col] == null &&
              candidates[cell.row][cell.col].contains(number);
        }).toList();
      }

      for (int a = 1; a <= 8; a++) {
        for (int b = a + 1; b <= 9; b++) {
          final cellsA = positionsByNumber[a]!;
          final cellsB = positionsByNumber[b]!;

          if (cellsA.length == 2 &&
              cellsB.length == 2 &&
              cellsA[0] == cellsB[0] &&
              cellsA[1] == cellsB[1]) {
            final pairCells = [cellsA[0], cellsA[1]];
            final needsCleanup = pairCells.any((cell) {
              final current = candidates[cell.row][cell.col];
              return current.length > 2 || !current.contains(a) || !current.contains(b);
            });

            if (needsCleanup) {
              return HintStep(
                technique: HintTechnique.hiddenPair,
                title: 'Hidden pair',
                description:
                    'Los números $a y $b solo pueden ir en estas dos casillas. Conserva esos dos candidatos ahí y elimina los demás.',
                focusCells: pairCells,
              );
            }
          }
        }
      }
    }

    return null;
  }

  HintStep? _findPointingPair(
    GameBoard board,
    List<List<Set<int>>> candidates,
  ) {
    for (int boxRow = 0; boxRow < 3; boxRow++) {
      for (int boxCol = 0; boxCol < 3; boxCol++) {
        final cells = <CellPosition>[];

        for (int r = 0; r < 3; r++) {
          for (int c = 0; c < 3; c++) {
            cells.add(
              CellPosition(
                row: boxRow * 3 + r,
                col: boxCol * 3 + c,
              ),
            );
          }
        }

        for (int number = 1; number <= 9; number++) {
          final matches = cells.where((cell) {
            return board.values[cell.row][cell.col] == null &&
                candidates[cell.row][cell.col].contains(number);
          }).toList();

          if (matches.length < 2) continue;

          final sameRow = matches.every((cell) => cell.row == matches.first.row);
          final sameCol = matches.every((cell) => cell.col == matches.first.col);

          if (sameRow) {
            final row = matches.first.row;
            final related = List.generate(9, (col) => CellPosition(row: row, col: col))
                .where((cell) =>
                    !_sameBox(cell, matches.first) &&
                    board.values[cell.row][cell.col] == null &&
                    candidates[cell.row][cell.col].contains(number))
                .toList();

            if (related.isNotEmpty) {
              return HintStep(
                technique: HintTechnique.pointingPair,
                title: 'Pointing pair',
                description:
                    'Dentro de este bloque, el número $number solo aparece en una misma fila. Puedes eliminar ese candidato de las casillas marcadas fuera del bloque.',
                focusCells: matches,
                relatedCells: related,
              );
            }
          }

          if (sameCol) {
            final col = matches.first.col;
            final related = List.generate(9, (row) => CellPosition(row: row, col: col))
                .where((cell) =>
                    !_sameBox(cell, matches.first) &&
                    board.values[cell.row][cell.col] == null &&
                    candidates[cell.row][cell.col].contains(number))
                .toList();

            if (related.isNotEmpty) {
              return HintStep(
                technique: HintTechnique.pointingPair,
                title: 'Pointing pair',
                description:
                    'Dentro de este bloque, el número $number solo aparece en una misma columna. Puedes eliminar ese candidato de las casillas marcadas fuera del bloque.',
                focusCells: matches,
                relatedCells: related,
              );
            }
          }
        }
      }
    }

    return null;
  }

  HintStep? _findBoxLineReduction(
    GameBoard board,
    List<List<Set<int>>> candidates,
  ) {
    for (int row = 0; row < 9; row++) {
      for (int number = 1; number <= 9; number++) {
        final matches = List.generate(9, (col) => CellPosition(row: row, col: col))
            .where((cell) =>
                board.values[cell.row][cell.col] == null &&
                candidates[cell.row][cell.col].contains(number))
            .toList();

        if (matches.length < 2) continue;

        final sameBox =
            matches.every((cell) => _sameBox(cell, matches.first));

        if (sameBox) {
          final base = matches.first;
          final startRow = (base.row ~/ 3) * 3;
          final startCol = (base.col ~/ 3) * 3;

          final related = <CellPosition>[];
          for (int r = startRow; r < startRow + 3; r++) {
            for (int c = startCol; c < startCol + 3; c++) {
              final cell = CellPosition(row: r, col: c);
              if (matches.contains(cell)) continue;
              if (board.values[r][c] == null && candidates[r][c].contains(number)) {
                related.add(cell);
              }
            }
          }

          if (related.isNotEmpty) {
            return HintStep(
              technique: HintTechnique.boxLineReduction,
              title: 'Box-line reduction',
              description:
                  'En esta fila, el número $number solo puede estar dentro del bloque resaltado. Elimina ese candidato de las otras casillas marcadas del bloque.',
              focusCells: matches,
              relatedCells: related,
            );
          }
        }
      }
    }

    for (int col = 0; col < 9; col++) {
      for (int number = 1; number <= 9; number++) {
        final matches = List.generate(9, (row) => CellPosition(row: row, col: col))
            .where((cell) =>
                board.values[cell.row][cell.col] == null &&
                candidates[cell.row][cell.col].contains(number))
            .toList();

        if (matches.length < 2) continue;

        final sameBox =
            matches.every((cell) => _sameBox(cell, matches.first));

        if (sameBox) {
          final base = matches.first;
          final startRow = (base.row ~/ 3) * 3;
          final startCol = (base.col ~/ 3) * 3;

          final related = <CellPosition>[];
          for (int r = startRow; r < startRow + 3; r++) {
            for (int c = startCol; c < startCol + 3; c++) {
              final cell = CellPosition(row: r, col: c);
              if (matches.contains(cell)) continue;
              if (board.values[r][c] == null && candidates[r][c].contains(number)) {
                related.add(cell);
              }
            }
          }

          if (related.isNotEmpty) {
            return HintStep(
              technique: HintTechnique.boxLineReduction,
              title: 'Box-line reduction',
              description:
                  'En esta columna, el número $number solo puede estar dentro del bloque resaltado. Elimina ese candidato de las otras casillas marcadas del bloque.',
              focusCells: matches,
              relatedCells: related,
            );
          }
        }
      }
    }

    return null;
  }

  HintStep? _findIncorrectNotes(
    GameBoard board,
    List<List<Set<int>>> candidates,
  ) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board.values[row][col] != null) continue;

        final currentNotes = board.notes[row][col];
        final validCandidates = candidates[row][col];

        final invalidNotes = currentNotes.difference(validCandidates);
        if (invalidNotes.isNotEmpty) {
          return HintStep(
            technique: HintTechnique.noteCleanup,
            title: 'Corrección de notas',
            description:
                'La casilla resaltada tiene notas que ya no son válidas. Revisa fila, columna y bloque, y elimina esas opciones sobrantes.',
            focusCells: [
              CellPosition(row: row, col: col),
            ],
            canAutoApply: true,
          );
        }
      }
    }

    return null;
  }

  HintStep? _findMissingNotes(
    GameBoard board,
    List<List<Set<int>>> candidates,
  ) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board.values[row][col] != null) continue;

        final currentNotes = board.notes[row][col];
        final validCandidates = candidates[row][col];

        if (currentNotes.isEmpty && validCandidates.isNotEmpty) {
          return HintStep(
            technique: HintTechnique.missingNotes,
            title: 'Faltan notas',
            description:
                'La casilla resaltada todavía no tiene notas. Añade las opciones posibles para verla con más claridad.',
            focusCells: [
              CellPosition(row: row, col: col),
            ],
            canAutoApply: true,
          );
        }

        final missing = validCandidates.difference(currentNotes);
        if (missing.isNotEmpty && currentNotes.isNotEmpty) {
          return HintStep(
            technique: HintTechnique.missingNotes,
            title: 'Faltan notas',
            description:
                'La casilla resaltada aún no incluye todas sus opciones válidas. Revisa fila, columna y bloque y añade las que faltan.',
            focusCells: [
              CellPosition(row: row, col: col),
            ],
            canAutoApply: true,
          );
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

  bool _sameBox(CellPosition a, CellPosition b) {
    return (a.row ~/ 3 == b.row ~/ 3) && (a.col ~/ 3 == b.col ~/ 3);
  }
}