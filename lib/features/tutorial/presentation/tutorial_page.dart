import 'package:flutter/material.dart';

import '../data/tutorial_storage.dart';
import '../domain/tutorial_step.dart';
import '../../home/presentation/home_page.dart';

class TutorialPage extends StatefulWidget {
  final bool fromSettings;

  const TutorialPage({
    super.key,
    this.fromSettings = false,
  });

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  late List<List<int?>> _values;
  late List<List<bool>> _fixedCells;
  late List<List<Set<int>>> _notes;

  int? _selectedRow;
  int? _selectedCol;
  bool _notesMode = false;
  int _stepIndex = 0;

  late final List<TutorialStep> _steps;

  @override
  void initState() {
    super.initState();
    _values = _buildInitialBoard();
    _fixedCells = List.generate(
      9,
      (r) => List.generate(9, (c) => _values[r][c] != null),
    );
    _notes = List.generate(9, (_) => List.generate(9, (_) => <int>{}));

    _steps = [
      TutorialStep(
        title: 'Cómo funciona una fila',
        message:
            'En una fila no se puede repetir ningún número del 1 al 9. Observa la fila resaltada.',
        type: TutorialStepType.info,
        focusCells: List.generate(9, (c) => TutorialCellPosition(0, c)),
      ),
      TutorialStep(
        title: 'Cómo funciona una columna',
        message:
            'En una columna tampoco se puede repetir ningún número. Observa la columna resaltada.',
        type: TutorialStepType.info,
        focusCells: List.generate(9, (r) => TutorialCellPosition(r, 2)),
      ),
      TutorialStep(
        title: 'Cómo funciona un bloque',
        message:
            'Cada bloque de 3x3 también debe contener los números del 1 al 9 sin repetir.',
        type: TutorialStepType.info,
        focusCells: const [
          TutorialCellPosition(0, 0),
          TutorialCellPosition(0, 1),
          TutorialCellPosition(0, 2),
          TutorialCellPosition(1, 0),
          TutorialCellPosition(1, 1),
          TutorialCellPosition(1, 2),
          TutorialCellPosition(2, 0),
          TutorialCellPosition(2, 1),
          TutorialCellPosition(2, 2),
        ],
      ),
      TutorialStep(
        title: 'Selecciona una casilla',
        message:
            'Ahora toca la casilla resaltada. Ahí iremos colocando un número.',
        type: TutorialStepType.selectCell,
        targetCell: const TutorialCellPosition(0, 2),
        focusCells: const [TutorialCellPosition(0, 2)],
      ),
      TutorialStep(
        title: 'Coloca el número correcto',
        message:
            'Usa el teclado de abajo y coloca el 4 en la casilla seleccionada.',
        type: TutorialStepType.placeNumber,
        targetCell: const TutorialCellPosition(0, 2),
        expectedNumber: 4,
        focusCells: const [TutorialCellPosition(0, 2)],
      ),
      TutorialStep(
        title: 'Activa el modo notas',
        message:
            'Si no estás seguro de un número, puedes guardar candidatos. Activa ahora el modo notas.',
        type: TutorialStepType.toggleNotes,
        targetCell: const TutorialCellPosition(1, 3),
        focusCells: const [TutorialCellPosition(1, 3)],
      ),
      TutorialStep(
        title: 'Añade notas',
        message:
            'En la casilla resaltada añade las notas 1 y 8. Pulsa esos números con el modo notas activado.',
        type: TutorialStepType.addNotes,
        targetCell: const TutorialCellPosition(1, 3),
        expectedNotes: [1, 8],
        focusCells: const [TutorialCellPosition(1, 3)],
      ),
      TutorialStep(
        title: 'Listo para empezar',
        message:
            'Ya sabes lo básico: filas, columnas, bloques, números y notas. Ya puedes empezar a jugar.',
        type: TutorialStepType.finish,
      ),
    ];
  }

  List<List<int?>> _buildInitialBoard() {
    return [
      [5, 3, null, 6, 7, 8, 9, 1, 2],
      [6, 7, 2, null, 9, 5, 3, 4, 8],
      [1, 9, 8, 3, 4, 2, 5, 6, 7],
      [8, 5, 9, 7, 6, 1, 4, 2, 3],
      [4, 2, 6, 8, 5, 3, 7, 9, 1],
      [7, 1, 3, 9, 2, 4, 8, 5, 6],
      [9, 6, 1, 5, 3, 7, 2, 8, 4],
      [2, 8, 7, 4, 1, 9, 6, 3, 5],
      [3, 4, 5, 2, 8, 6, 1, 7, 9],
    ];
  }

  TutorialStep get _currentStep => _steps[_stepIndex];

  bool _isFocusedCell(int row, int col) {
    return _currentStep.focusCells.contains(TutorialCellPosition(row, col));
  }

  bool _isTargetCell(int row, int col) {
    final target = _currentStep.targetCell;
    return target != null && target.row == row && target.col == col;
  }

  void _goToNextStep() {
    if (_stepIndex < _steps.length - 1) {
      setState(() {
        _stepIndex++;
      });
    }
  }

  Future<void> _finishTutorial() async {
    await TutorialStorage().markTutorialSeen();

    if (!mounted) return;

    if (widget.fromSettings) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  Future<void> _skipTutorial() async {
    await TutorialStorage().markTutorialSeen();

    if (!mounted) return;

    if (widget.fromSettings) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  void _showWrongActionMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void _onCellTap(int row, int col) {
    final step = _currentStep;

    if (step.type == TutorialStepType.info ||
        step.type == TutorialStepType.finish) {
      return;
    }

    if (_fixedCells[row][col]) {
      return;
    }

    if (step.targetCell == null) return;

    if (row != step.targetCell!.row || col != step.targetCell!.col) {
      _showWrongActionMessage('En este paso debes usar la casilla resaltada.');
      return;
    }

    setState(() {
      _selectedRow = row;
      _selectedCol = col;
    });

    if (step.type == TutorialStepType.selectCell) {
      _goToNextStep();
    }
  }

  void _toggleNotesMode() {
    final step = _currentStep;

    if (step.type != TutorialStepType.toggleNotes) {
      return;
    }

    if (_selectedRow != step.targetCell?.row || _selectedCol != step.targetCell?.col) {
      _showWrongActionMessage('Selecciona primero la casilla resaltada.');
      return;
    }

    setState(() {
      _notesMode = true;
    });

    _goToNextStep();
  }

  void _onNumberTap(int number) {
    final step = _currentStep;

    if (_selectedRow == null || _selectedCol == null) {
      _showWrongActionMessage('Selecciona primero la casilla resaltada.');
      return;
    }

    if (step.targetCell == null) return;

    if (_selectedRow != step.targetCell!.row || _selectedCol != step.targetCell!.col) {
      _showWrongActionMessage('Usa la casilla resaltada.');
      return;
    }

    if (step.type == TutorialStepType.placeNumber) {
      if (number != step.expectedNumber) {
        _showWrongActionMessage('Ese no es el número correcto para este paso.');
        return;
      }

      setState(() {
        _values[_selectedRow!][_selectedCol!] = number;
        _notes[_selectedRow!][_selectedCol!].clear();
      });

      _goToNextStep();
      return;
    }

    if (step.type == TutorialStepType.addNotes) {
      if (!_notesMode) {
        _showWrongActionMessage('Primero activa el modo notas.');
        return;
      }

      if (!step.expectedNotes.contains(number)) {
        _showWrongActionMessage('En este paso debes añadir solo las notas indicadas.');
        return;
      }

      setState(() {
        final cellNotes = _notes[_selectedRow!][_selectedCol!];
        if (cellNotes.contains(number)) {
          cellNotes.remove(number);
        } else {
          cellNotes.add(number);
        }
      });

      final currentNotes = _notes[_selectedRow!][_selectedCol!].toList()..sort();
      final expectedNotes = [...step.expectedNotes]..sort();

      if (_sameIntList(currentNotes, expectedNotes)) {
        _goToNextStep();
      }
    }
  }

  bool _sameIntList(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Widget _buildTopCard(BuildContext context) {
    final step = _currentStep;
    final isInfoStep =
        step.type == TutorialStepType.info || step.type == TutorialStepType.finish;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              step.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              step.message,
              textAlign: TextAlign.center,
            ),
            if (isInfoStep) ...[
              const SizedBox(height: 14),
              FilledButton(
                onPressed: step.type == TutorialStepType.finish
                    ? _finishTutorial
                    : _goToNextStep,
                child: Text(
                  step.type == TutorialStepType.finish ? 'Empezar a jugar' : 'Siguiente',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
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
                  final value = _values[row][col];
                  final notes = _notes[row][col];
                  final isFixed = _fixedCells[row][col];
                  final isSelected = _selectedRow == row && _selectedCol == col;
                  final isFocused = _isFocusedCell(row, col);
                  final isTarget = _isTargetCell(row, col);

                  Color backgroundColor = Colors.white;

                  if (isFocused) {
                    backgroundColor = Colors.blue.withValues(alpha: 0.10);
                  }

                  if (isTarget) {
                    backgroundColor = Colors.amber.withValues(alpha: 0.25);
                  }

                  if (isSelected) {
                    backgroundColor = Colors.blue.withValues(alpha: 0.20);
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _onCellTap(row, col),
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
                                    fontWeight:
                                        isFixed ? FontWeight.bold : FontWeight.w500,
                                    color: isFixed ? Colors.black : Colors.blue[800],
                                  ),
                                )
                              : _TutorialNotesView(notes: notes),
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

  Widget _buildControls(BuildContext context) {
    final step = _currentStep;
    final showControls = step.type == TutorialStepType.placeNumber ||
        step.type == TutorialStepType.toggleNotes ||
        step.type == TutorialStepType.addNotes;

    if (!showControls) return const SizedBox(height: 8);

    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.tonalIcon(
              onPressed: _toggleNotesMode,
              icon: const Icon(Icons.edit_note),
              label: Text(_notesMode ? 'Notas activadas' : 'Notas'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: List.generate(9, (index) {
            final number = index + 1;
            return SizedBox(
              width: 52,
              height: 52,
              child: FilledButton(
                onPressed: () => _onNumberTap(number),
                child: Text('$number'),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFinishStep = _currentStep.type == TutorialStepType.finish;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _skipTutorial,
            child: const Text('Saltar'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopCard(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    _buildGrid(context),
                    if (!isFinishStep) _buildControls(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorialNotesView extends StatelessWidget {
  final Set<int> notes;

  const _TutorialNotesView({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: List.generate(9, (index) {
          final number = index + 1;
          return Center(
            child: Text(
              notes.contains(number) ? '$number' : '',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          );
        }),
      ),
    );
  }
}