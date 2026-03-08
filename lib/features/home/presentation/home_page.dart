import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../game/domain/difficulty.dart';
import '../../game/presentation/controllers/game_controller.dart';
import '../../game/presentation/pages/game_page.dart';
import '../../history/presentation/history_page.dart';

class HomePage extends ConsumerWidget {
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

  void _openDailyChallenge(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameControllerProvider.notifier);
    final opened = controller.openDailyChallenge();

    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ya has completado el desafío diario de hoy.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GamePage(
          startDailyChallenge: true,
        ),
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

  String _formatContinueSubtitle({
    required Duration elapsed,
    required String mode,
  }) {
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds • $mode';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(gameControllerProvider);
    final dailyCompleted =
        ref.read(gameControllerProvider.notifier).isTodayDailyChallengeCompleted();

    final modeLabel =
        board.isDailyChallenge ? 'Desafío diario' : board.difficulty.label;

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
                subtitle: _formatContinueSubtitle(
                  elapsed: board.elapsed,
                  mode: modeLabel,
                ),
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
              child: Center(
                child: Text(
                  'Selecciona cómo quieres jugar',
                  style: Theme.of(context).textTheme.titleMedium,
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
            if (dailyCompleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ya has completado el desafío diario de hoy.'),
                ),
              );
              return;
            }
            _openDailyChallenge(context, ref);
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

class _NewGameDifficultySheet extends ConsumerWidget {
  const _NewGameDifficultySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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