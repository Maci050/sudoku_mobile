import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../game/presentation/controllers/game_controller.dart';
import '../../game/presentation/pages/game_page.dart';
import '../../../../core/widgets/app_themed_scaffold.dart';

class DailyChallengesPage extends ConsumerWidget {
  const DailyChallengesPage({super.key});

  static final DateTime _appStartDate = DateTime(2026, 3, 7);

  List<DateTime> _lastDays({int count = 14}) {
    final today = DateTime.now();
    return List.generate(
      count,
      (index) => DateTime(today.year, today.month, today.day - index),
    ).where((date) => !date.isBefore(_appStartDate)).toList();
  }

  String _formatDate(DateTime date) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final today = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: _appStartDate,
      lastDate: DateTime(today.year, today.month, today.day),
      helpText: 'Selecciona un desafío diario',
      cancelText: 'Cancelar',
      confirmText: 'Jugar',
      locale: const Locale('es'),
    );

    if (picked == null) return;

    ref.read(gameControllerProvider.notifier).openDailyChallengeForDate(picked);

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GamePage(
          startDailyChallenge: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameControllerProvider.notifier);
    final days = _lastDays(count: 21);

    return AppThemedScaffold(
      appBar: AppBar(
        title: const Text('Desafíos diarios'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _pickDate(context, ref),
                icon: const Icon(Icons.calendar_month),
                label: const Text('Elegir fecha del calendario'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Disponible desde el 7 de marzo de 2026',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: days.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final date = days[index];
                final completed = controller.isDailyChallengeCompletedForDate(date);
                final isToday = _isToday(date);

                return Card(
                  child: ListTile(
                    leading: Icon(
                      completed ? Icons.check_circle : Icons.calendar_today,
                    ),
                    title: Text(
                      isToday ? 'Hoy · ${_formatDate(date)}' : _formatDate(date),
                    ),
                    subtitle: Text(
                      completed ? 'Completado' : 'Disponible para jugar',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      controller.openDailyChallengeForDate(date);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GamePage(
                            startDailyChallenge: true,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}