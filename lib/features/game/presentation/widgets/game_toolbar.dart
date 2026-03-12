import 'package:flutter/material.dart';

class GameToolbar extends StatelessWidget {
  final bool notesMode;
  final VoidCallback onSurrender;
  final VoidCallback onToggleNotes;
  final VoidCallback onErase;
  final VoidCallback onOpenSettings;
  final VoidCallback onHint;

  const GameToolbar({
    super.key,
    required this.notesMode,
    required this.onSurrender,
    required this.onToggleNotes,
    required this.onErase,
    required this.onOpenSettings,
    required this.onHint,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ToolButton(
          icon: Icons.flag_outlined,
          label: 'Rendirse',
          onTap: onSurrender,
        ),
        _ToolButton(
          icon: Icons.backspace_outlined,
          label: 'Borrar',
          onTap: onErase,
        ),
        _ToolButton(
          icon: notesMode ? Icons.edit_note : Icons.edit_note_outlined,
          label: 'Notas',
          onTap: onToggleNotes,
          isActive: notesMode,
        ),
        _ToolButton(
          icon: Icons.tune,
          label: 'Ayudas',
          onTap: onOpenSettings,
        ),
        _ToolButton(
          icon: Icons.lightbulb_outline,
          label: 'Pista',
          onTap: onHint,
        ),
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isActive
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              child: Icon(
                icon,
                color: isActive
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}