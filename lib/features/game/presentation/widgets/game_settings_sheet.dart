import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';

class GameSettingsSheet extends ConsumerWidget {
  const GameSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ayudas y reglas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Límite de errores'),
              subtitle: Text('Pierdes al llegar a ${board.maxMistakes} errores'),
              value: board.limitMistakesEnabled,
              onChanged: controller.toggleLimitMistakes,
            ),
            SwitchListTile(
              title: const Text('Resaltar errores'),
              value: board.highlightErrors,
              onChanged: controller.toggleHighlightErrors,
            ),
            SwitchListTile(
              title: const Text('Resaltar duplicados'),
              value: board.highlightDuplicates,
              onChanged: controller.toggleHighlightDuplicates,
            ),
            SwitchListTile(
              title: const Text('Ocultar números usados'),
              value: board.hideUsedNumbers,
              onChanged: controller.toggleHideUsedNumbers,
            ),
            SwitchListTile(
              title: const Text('Resaltar fila, columna y bloque'),
              value: board.highlightRegions,
              onChanged: controller.toggleHighlightRegions,
            ),
            SwitchListTile(
              title: const Text('Resaltar números iguales'),
              value: board.highlightSameNumbers,
              onChanged: controller.toggleHighlightSameNumbers,
            ),
          ],
        ),
      ),
    );
  }
}