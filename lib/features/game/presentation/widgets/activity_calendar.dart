import 'package:flutter/material.dart';

class ActivityCalendar extends StatelessWidget {
  final Map<DateTime, int> activityCounts;
  final int totalDays;

  const ActivityCalendar({
    super.key,
    required this.activityCounts,
    this.totalDays = 35,
  });

  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Color _activityColor(BuildContext context, int count) {
    final colorScheme = Theme.of(context).colorScheme;

    if (count <= 0) {
      return colorScheme.surfaceContainerHighest;
    } else if (count == 1) {
      return colorScheme.primary.withValues(alpha: 0.35);
    } else if (count <= 3) {
      return colorScheme.primary.withValues(alpha: 0.65);
    } else {
      return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = _normalize(DateTime.now());

    final days = List.generate(
      totalDays,
      (index) => today.subtract(Duration(days: totalDays - 1 - index)),
    );

    final activeDaysCount = days.where((day) {
      final normalizedDay = _normalize(day);
      return (activityCounts[normalizedDay] ?? 0) > 0;
    }).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actividad de juego',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Días en los que jugaste al menos un Sudoku durante los últimos $totalDays días.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: days.map((day) {
                final normalizedDay = _normalize(day);
                final count = activityCounts[normalizedDay] ?? 0;
                final isToday = normalizedDay == today;

                return Tooltip(
                  message: count > 0
                      ? '${day.day}/${day.month}/${day.year} · $count partida${count == 1 ? '' : 's'}'
                      : '${day.day}/${day.month}/${day.year} · Sin actividad',
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: _activityColor(context, count),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isToday
                            ? colorScheme.onSurface
                            : colorScheme.outlineVariant,
                        width: isToday ? 1.3 : 0.5,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            Text(
              'Has jugado $activeDaysCount de los últimos $totalDays días.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _LegendItem(
                  color: colorScheme.surfaceContainerHighest,
                  label: 'Sin actividad',
                ),
                _LegendItem(
                  color: colorScheme.primary.withValues(alpha: 0.35),
                  label: '1 partida',
                ),
                _LegendItem(
                  color: colorScheme.primary.withValues(alpha: 0.65),
                  label: '2-3 partidas',
                ),
                _LegendItem(
                  color: colorScheme.primary,
                  label: '4 o más',
                ),
                _LegendTodayItem(
                  label: 'Hoy',
                  borderColor: colorScheme.onSurface,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class _LegendTodayItem extends StatelessWidget {
  final String label;
  final Color borderColor;

  const _LegendTodayItem({
    required this.label,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: borderColor,
              width: 1.3,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}