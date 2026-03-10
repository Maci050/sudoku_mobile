import 'package:flutter/material.dart';

class GameToolbar extends StatelessWidget {
  final bool notesMode;
  final VoidCallback onNewGame;
  final VoidCallback onToggleNotes;
  final VoidCallback onErase;
  final VoidCallback onOpenSettings;

  const GameToolbar({
    super.key,
    required this.notesMode,
    required this.onNewGame,
    required this.onToggleNotes,
    required this.onErase,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ToolButton(
          icon: Icons.refresh_rounded,
          label: 'Nuevo',
          onTap: onNewGame,
        ),
        _ToolButton(
          icon: Icons.backspace_outlined,
          label: 'Borrar',
          onTap: onErase,
        ),
        _ToolButton(
          icon: Icons.edit_outlined,
          label: notesMode ? 'Notas ON' : 'Notas',
          onTap: onToggleNotes,
          highlighted: notesMode,
        ),
        _ToolButton(
          icon: Icons.tune_rounded,
          label: 'Ayudas',
          onTap: onOpenSettings,
        ),
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: highlighted
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                child: Icon(
                  icon,
                  color: highlighted
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}