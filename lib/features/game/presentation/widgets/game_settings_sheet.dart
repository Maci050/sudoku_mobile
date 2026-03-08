import 'package:flutter/material.dart';
import '../../domain/game_board.dart';

class GameSettingsSheet extends StatelessWidget {
  final GameBoard board;
  final ValueChanged<bool> onToggleLimitMistakes;
  final ValueChanged<bool> onToggleHighlightErrors;
  final ValueChanged<bool> onToggleHighlightDuplicates;
  final ValueChanged<bool> onToggleHideUsedNumbers;
  final ValueChanged<bool> onToggleHighlightRegions;
  final ValueChanged<bool> onToggleHighlightSameNumbers;

  const GameSettingsSheet({
    super.key,
    required this.board,
    required this.onToggleLimitMistakes,
    required this.onToggleHighlightErrors,
    required this.onToggleHighlightDuplicates,
    required this.onToggleHideUsedNumbers,
    required this.onToggleHighlightRegions,
    required this.onToggleHighlightSameNumbers,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ayudas y reglas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Límite de errores'),
              subtitle: Text('Pierdes al llegar a ${board.maxMistakes} errores'),
              value: board.limitMistakesEnabled,
              onChanged: onToggleLimitMistakes,
            ),
            SwitchListTile(
              title: const Text('Resaltar errores'),
              value: board.highlightErrors,
              onChanged: onToggleHighlightErrors,
            ),
            SwitchListTile(
              title: const Text('Resaltar duplicados'),
              value: board.highlightDuplicates,
              onChanged: onToggleHighlightDuplicates,
            ),
            SwitchListTile(
              title: const Text('Ocultar números usados'),
              value: board.hideUsedNumbers,
              onChanged: onToggleHideUsedNumbers,
            ),
            SwitchListTile(
              title: const Text('Resaltar fila, columna y bloque'),
              value: board.highlightRegions,
              onChanged: onToggleHighlightRegions,
            ),
            SwitchListTile(
              title: const Text('Resaltar números iguales'),
              value: board.highlightSameNumbers,
              onChanged: onToggleHighlightSameNumbers,
            ),
          ],
        ),
      ),
    );
  }
}