import 'package:flutter/material.dart';
import '../data/history_storage.dart';
import '../domain/completed_game.dart';
import '../../game/domain/difficulty.dart';

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
            leading: const Icon(Icons.emoji_events),
            title: Text(game.difficulty.label),
            subtitle: Text(
              "${game.time.inMinutes}:${(game.time.inSeconds % 60).toString().padLeft(2, '0')}",
            ),
            trailing: Text(
              "${game.completedAt.day}/${game.completedAt.month}/${game.completedAt.year}",
            ),
          );
        },
      ),
    );
  }
}