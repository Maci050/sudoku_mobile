import 'package:flutter/material.dart';
import '../../history/data/history_storage.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final history = HistoryStorage().loadHistory();

    final totalGames = history.length;

    Duration? bestTime;
    Duration? averageTime;

    if (history.isNotEmpty) {
      bestTime = history
          .map((e) => e.time)
          .reduce((a, b) => a.inSeconds < b.inSeconds ? a : b);

      averageTime = Duration(
        seconds: history
                .map((e) => e.time.inSeconds)
                .reduce((a, b) => a + b) ~/
            history.length,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatCard(
            title: 'Sudokus completados',
            value: '$totalGames',
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Mejor tiempo',
            value: bestTime != null ? _formatDuration(bestTime) : '--:--',
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Tiempo medio',
            value: averageTime != null ? _formatDuration(averageTime) : '--:--',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}