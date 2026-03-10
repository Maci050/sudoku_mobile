import 'package:flutter/material.dart';
import '../../game/domain/difficulty.dart';
import '../data/history_storage.dart';
import '../domain/completed_game.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryStorage storage = HistoryStorage();

  late List<CompletedGame> history;

  @override
  void initState() {
    super.initState();
    history = storage.loadHistory();
  }

  String _statusLabel(GameResultStatus status) {
    switch (status) {
      case GameResultStatus.completed:
        return 'Completado';
      case GameResultStatus.surrendered:
        return 'Rendido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final game = history[index];

          return ListTile(
            leading: Icon(
              game.status == GameResultStatus.completed
                  ? Icons.emoji_events
                  : Icons.flag_outlined,
            ),
            title: Text(game.difficulty.label),
            subtitle: Text(
              '${game.time.inMinutes}:${(game.time.inSeconds % 60).toString().padLeft(2, '0')} · ${_statusLabel(game.status)}',
            ),
            trailing: Text(
              '${game.completedAt.day}/${game.completedAt.month}/${game.completedAt.year}',
            ),
          );
        },
      ),
    );
  }
}