import 'package:flutter/material.dart';
import '../../game/domain/difficulty.dart';
import '../../game/presentation/pages/game_page.dart';
import '../../history/presentation/history_page.dart';
import '../../daily_challenge/presentation/daily_challenge_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openContinueGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GamePage(),
      ),
    );
  }

  void _openNewGameSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => const _NewGameDifficultySheet(),
    );
  }

  void _openDailyChallenge(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DailyChallengesPage(),
        ),
    );
  }

  void _openHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HistoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _HomeActionButton(
                title: 'Continuar la partida',
                subtitle: 'Retoma tu última partida guardada',
                filled: true,
                icon: Icons.play_arrow,
                onTap: () => _openContinueGame(context),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _HomeActionButton(
                title: 'Nueva partida',
                filled: false,
                onTap: () => _openNewGameSelector(context),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    _InfoCard(
                      title: 'Consejo rápido',
                      icon: Icons.lightbulb_outline,
                      text:
                          'Empieza por filas, columnas o bloques que ya tengan muchos números colocados.',
                    ),
                    SizedBox(height: 16),
                    _InfoCard(
                      title: 'Modo notas',
                      icon: Icons.edit_note,
                      text:
                          'Usa las notas para marcar posibilidades antes de colocar un número definitivo.',
                    ),
                    SizedBox(height: 16),
                    _InfoCard(
                      title: 'Desafío diario',
                      icon: Icons.calendar_today,
                      text:
                          'Cada día puedes enfrentarte a un Sudoku único y mantener tu constancia.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) {
            _openDailyChallenge(context);
          } else if (index == 2) {
            _openHistory(context);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Desafíos diarios',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Historial',
          ),
        ],
      ),
    );
  }
}

class _HomeActionButton extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool filled;
  final IconData? icon;
  final VoidCallback onTap;

  const _HomeActionButton({
    required this.title,
    required this.filled,
    required this.onTap,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: filled ? colorScheme.primary : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: filled ? colorScheme.onPrimary : colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: filled ? colorScheme.onPrimary : colorScheme.primary,
                    ),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: filled
                        ? colorScheme.onPrimary.withValues(alpha: 0.85)
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String text;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewGameDifficultySheet extends StatelessWidget {
  const _NewGameDifficultySheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nueva partida',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Elige la dificultad',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: Difficulty.values.map((difficulty) {
                return FilledButton.tonal(
                  onPressed: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GamePage(
                          startDifficulty: difficulty,
                          startDailyChallenge: false,
                        ),
                      ),
                    );
                  },
                  child: Text(difficulty.label),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}