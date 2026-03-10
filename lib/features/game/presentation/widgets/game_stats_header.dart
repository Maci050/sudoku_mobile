import 'package:flutter/material.dart';

class GameStatsHeader extends StatelessWidget {
  final int progress;
  final String difficultyLabel;
  final String timeText;
  final bool isPaused;
  final String? mistakesText;
  final VoidCallback onTogglePause;

  const GameStatsHeader({
    super.key,
    required this.progress,
    required this.difficultyLabel,
    required this.timeText,
    required this.isPaused,
    required this.onTogglePause,
    this.mistakesText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              label: 'Progreso',
              value: '$progress/81',
              subtitle: mistakesText != null ? 'Errores $mistakesText' : null,
            ),
          ),
          Expanded(
            child: _StatItem(
              label: 'Dificultad',
              value: difficultyLabel,
            ),
          ),
          Expanded(
            child: _StatItem(
              label: 'Tiempo',
              value: timeText,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 24,
            backgroundColor: colorScheme.surface,
            child: IconButton(
              onPressed: onTogglePause,
              icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;

  const _StatItem({
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    final valueStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        );

    final subtitleStyle = Theme.of(context).textTheme.bodySmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 2),
        Text(value, style: valueStyle),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: subtitleStyle),
        ],
      ],
    );
  }
}