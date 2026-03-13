import 'package:flutter/material.dart';
import '../../achievements/domain/achievement_service.dart';
import '../../game/domain/cell_position.dart';
import '../data/training_progress_storage.dart';
import '../domain/training_level.dart';

class TrainingSessionPage extends StatefulWidget {
  final TrainingLevel level;

  const TrainingSessionPage({
    super.key,
    required this.level,
  });

  @override
  State<TrainingSessionPage> createState() => _TrainingSessionPageState();
}

class _TrainingSessionPageState extends State<TrainingSessionPage> {
  late List<List<int?>> values;

  int? selectedRow;
  int? selectedCol;

  final Set<String> selectedCells = {};
  bool solved = false;

  @override
  void initState() {
    super.initState();

    final puzzle = widget.level.puzzle ?? [];
    values = puzzle
        .map((row) => row.map<int?>((v) => v == 0 ? null : v).toList())
        .toList();
  }

  String _cellKey(int row, int col) => '$row-$col';

  void _selectCell(int row, int col) {
    if (solved) return;

    if (widget.level.type == TrainingExerciseType.placeNumber) {
      if (row != widget.level.targetRow || col != widget.level.targetCol) return;

      setState(() {
        selectedRow = row;
        selectedCol = col;
      });
      return;
    }

    setState(() {
      final key = _cellKey(row, col);
      if (selectedCells.contains(key)) {
        selectedCells.remove(key);
      } else {
        selectedCells.add(key);
      }
    });
  }

  Future<void> _completeExercise() async {
    setState(() {
      solved = true;
    });

    await TrainingProgressStorage().markCompleted(widget.level.id);
    final unlocked = await AchievementService().evaluateAndUnlockNewAchievements();

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Correcto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.level.explanation),
            if (unlocked.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Text(
                'Logros desbloqueados:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...unlocked.map(
                (achievement) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('${achievement.emoji} ${achievement.title}'),
                ),
              ),
            ],
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Seguir'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _inputNumber(int number) async {
    if (widget.level.type != TrainingExerciseType.placeNumber) return;
    if (selectedRow == null || selectedCol == null) return;

    final isCorrect = selectedRow == widget.level.targetRow &&
        selectedCol == widget.level.targetCol &&
        number == widget.level.targetValue;

    if (!isCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ese no es el movimiento correcto.'),
        ),
      );
      return;
    }

    setState(() {
      values[selectedRow!][selectedCol!] = number;
    });

    await _completeExercise();
  }

  Future<void> _validateSelectedCells() async {
    if (widget.level.type != TrainingExerciseType.selectCells) return;

    final expected = widget.level.expectedSelectedCells
        .map((cell) => _cellKey(cell.row, cell.col))
        .toSet();

    if (selectedCells.length != expected.length || !selectedCells.containsAll(expected)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No has seleccionado las casillas correctas.'),
        ),
      );
      return;
    }

    await _completeExercise();
  }

  String _instructionText() {
    switch (widget.level.type) {
      case TrainingExerciseType.placeNumber:
        return 'Selecciona la casilla objetivo y coloca el número correcto.';
      case TrainingExerciseType.selectCells:
        return 'Selecciona las casillas clave que forman la técnica y confirma tu respuesta.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final numbers = List.generate(9, (i) => i + 1);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.level.skill.label} · ${widget.level.title}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.level.objective,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(_instructionText()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: _TrainingBoard(
                      values: values,
                      highlightedCells: widget.level.highlightedCells,
                      selectedRow: selectedRow,
                      selectedCol: selectedCol,
                      selectedCells: selectedCells,
                      onCellTap: _selectCell,
                      isSelectionMode:
                          widget.level.type == TrainingExerciseType.selectCells,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (widget.level.type == TrainingExerciseType.placeNumber)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: numbers
                      .map(
                        (n) => SizedBox(
                          width: 56,
                          height: 56,
                          child: FilledButton(
                            onPressed: () => _inputNumber(n),
                            child: Text('$n'),
                          ),
                        ),
                      )
                      .toList(),
                )
              else
                FilledButton.icon(
                  onPressed: _validateSelectedCells,
                  icon: const Icon(Icons.check),
                  label: const Text('Confirmar selección'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrainingBoard extends StatelessWidget {
  final List<List<int?>> values;
  final List<CellPosition> highlightedCells;
  final int? selectedRow;
  final int? selectedCol;
  final Set<String> selectedCells;
  final void Function(int row, int col) onCellTap;
  final bool isSelectionMode;

  const _TrainingBoard({
    required this.values,
    required this.highlightedCells,
    required this.selectedRow,
    required this.selectedCol,
    required this.selectedCells,
    required this.onCellTap,
    required this.isSelectionMode,
  });

  bool _isHighlighted(int row, int col) {
    return highlightedCells.any((cell) => cell.row == row && cell.col == col);
  }

  bool _isSelected(int row, int col) {
    if (isSelectionMode) {
      return selectedCells.contains('$row-$col');
    }
    return selectedRow == row && selectedCol == col;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          children: List.generate(9, (row) {
            return Expanded(
              child: Row(
                children: List.generate(9, (col) {
                  final value = values[row][col];
                  final isHighlighted = _isHighlighted(row, col);
                  final isSelected = _isSelected(row, col);

                  Color backgroundColor = Colors.white;

                  if (isHighlighted) {
                    backgroundColor = Colors.amber.withValues(alpha: 0.25);
                  }

                  if (isSelected) {
                    backgroundColor = Colors.blue.withValues(alpha: 0.25);
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onCellTap(row, col),
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border(
                            top: BorderSide(
                              color: row % 3 == 0 ? Colors.black : Colors.grey,
                              width: row % 3 == 0 ? 2 : 0.5,
                            ),
                            left: BorderSide(
                              color: col % 3 == 0 ? Colors.black : Colors.grey,
                              width: col % 3 == 0 ? 2 : 0.5,
                            ),
                            right: BorderSide(
                              color: col == 8 ? Colors.black : Colors.grey,
                              width: col == 8 ? 2 : 0.5,
                            ),
                            bottom: BorderSide(
                              color: row == 8 ? Colors.black : Colors.grey,
                              width: row == 8 ? 2 : 0.5,
                            ),
                          ),
                        ),
                        child: Center(
                          child: value != null
                              ? Text(
                                  '$value',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[800],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}