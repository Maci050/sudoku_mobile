import 'package:flutter/material.dart';
import '../data/training_progress_storage.dart';
import '../domain/training_level.dart';
import 'widgets/training_grid.dart';

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
  bool solved = false;

  @override
  void initState() {
    super.initState();
    values = widget.level.puzzle
        .map((row) => row.map<int?>((v) => v == 0 ? null : v).toList())
        .toList();
  }

  void _selectCell(int row, int col) {
    if (solved) return;
    if (row != widget.level.targetRow || col != widget.level.targetCol) return;

    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  Future<void> _inputNumber(int number) async {
    if (solved) return;
    if (selectedRow == null || selectedCol == null) return;

    if (selectedRow == widget.level.targetRow &&
        selectedCol == widget.level.targetCol &&
        number == widget.level.targetValue) {
      setState(() {
        values[selectedRow!][selectedCol!] = number;
        solved = true;
      });

      await TrainingProgressStorage().markCompleted(widget.level.id);

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('¡Correcto!'),
          content: Text(widget.level.explanation),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ese no es el movimiento correcto.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final numbers = List.generate(9, (i) => i + 1);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.level.technique} · ${widget.level.title}'),
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
                      const Text(
                        'Selecciona la casilla resaltada y coloca el número correcto.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: TrainingGrid(
                      values: values,
                      targetRow: widget.level.targetRow,
                      targetCol: widget.level.targetCol,
                      selectedRow: selectedRow,
                      selectedCol: selectedCol,
                      onCellTap: _selectCell,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}