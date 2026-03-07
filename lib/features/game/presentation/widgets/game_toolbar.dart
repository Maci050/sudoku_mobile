import 'package:flutter/material.dart';

class GameToolbar extends StatelessWidget {
  final bool notesMode;
  final VoidCallback onToggleNotes;
  final VoidCallback onErase;

  const GameToolbar({
    super.key,
    required this.notesMode,
    required this.onToggleNotes,
    required this.onErase,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.tonal(
          onPressed: onToggleNotes,
          child: Text(notesMode ? 'Notas: ON' : 'Notas'),
        ),
        const SizedBox(width: 12),
        FilledButton.tonal(
          onPressed: onErase,
          child: const Text('Borrar'),
        ),
      ],
    );
  }
}