import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../game/presentation/controllers/game_controller.dart';
import '../../game/presentation/pages/game_page.dart';

class DailyChallengesPage extends ConsumerWidget {
  const DailyChallengesPage({super.key});

  List<DateTime> _lastDays({int count = 14}) {
    final today = DateTime.now();
    return List.generate(
      count,
      (index) => DateTime(today.year, today.month, today.day - index),
    );
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameControllerProvider.notifier);
    final days = _lastDays(count: 21);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Desafíos diarios'),
        centerTitle: true,
      ),
      body: ListView.separated(
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
    );
  }
}