import 'package:flutter/material.dart';

class GameToolbar extends StatelessWidget {
  final bool notesMode;
  final VoidCallback onNewGame;
  final VoidCallback onToggleNotes;
  final VoidCallback onErase;

  const GameToolbar({
    super.key,
    required this.notesMode,
    required this.onNewGame,
    required this.onToggleNotes,
    required this.onErase,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      alignment: WrapAlignment.center,
      children: [
        FilledButton.tonal(
          onPressed: onNewGame,
          child: const Text('Nuevo juego'),
        ),
        FilledButton.tonal(
          onPressed: onToggleNotes,
          child: Text(notesMode ? 'Notas: ON' : 'Notas'),
        ),
        FilledButton.tonal(
          onPressed: onErase,
          child: const Text('Borrar'),
        ),
      ],
    );
  }
}