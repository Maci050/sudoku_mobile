import 'package:flutter/material.dart';
import '../../../home/presentation/home_page.dart';
import '../../domain/difficulty.dart';

class GameResultPage extends StatelessWidget {
  final bool won;
  final bool isDailyChallenge;
  final Difficulty difficulty;
  final Duration elapsed;
  final int mistakes;

  const GameResultPage({
    super.key,
    required this.won,
    required this.isDailyChallenge,
    required this.difficulty,
    required this.elapsed,
    required this.mistakes,
  });

  String get formattedTime {
    final totalSeconds = elapsed.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final title = won ? '¡Nivel completado!' : 'Partida terminada';
    final subtitle = won
        ? (isDailyChallenge
            ? 'Has superado el desafío diario'
            : 'Has completado un Sudoku ${difficulty.label}')
        : 'Has alcanzado el límite de errores';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Icon(
                won ? Icons.emoji_events : Icons.error_outline,
                size: 72,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: 'Modo',
                        value: isDailyChallenge ? 'Desafío diario' : difficulty.label,
                      ),
                      const SizedBox(height: 12),
                      _SummaryRow(
                        label: 'Tiempo',
                        value: formattedTime,
                      ),
                      const SizedBox(height: 12),
                      _SummaryRow(
                        label: 'Errores',
                        value: '$mistakes',
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
                  );
                },
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}