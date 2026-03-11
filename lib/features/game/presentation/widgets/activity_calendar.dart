import 'package:flutter/material.dart';

class ActivityCalendar extends StatelessWidget {
  final Set<DateTime> activeDays;
  final int totalDays;

  const ActivityCalendar({
    super.key,
    required this.activeDays,
    this.totalDays = 35,
  });

  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = _normalize(DateTime.now());

    final days = List.generate(
      totalDays,
      (index) => today.subtract(Duration(days: totalDays - 1 - index)),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Actividad reciente',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: days.map((day) {
                final normalizedDay = _normalize(day);
                final isActive = activeDays.contains(normalizedDay);

                return Tooltip(
                  message: isActive
                      ? 'Jugado el ${day.day}/${day.month}/${day.year}'
                      : 'Sin actividad el ${day.day}/${day.month}/${day.year}',
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: isActive
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                        width: 0.5,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _LegendItem(
                  color: colorScheme.surfaceContainerHighest,
                  label: 'Sin actividad',
                ),
                const SizedBox(width: 12),
                _LegendItem(
                  color: colorScheme.primary,
                  label: 'Jugado',
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