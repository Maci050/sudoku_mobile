import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../../achievements/domain/achievement_service.dart';
import '../../../../core/services/feedback_service.dart';
import '../../../home/presentation/home_page.dart';
import '../../../streak/domain/streak_service.dart';
import '../../domain/difficulty.dart';

class GameResultPage extends StatefulWidget {
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

  @override
  State<GameResultPage> createState() => _GameResultPageState();
}

class _GameResultPageState extends State<GameResultPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final ConfettiController _confettiController;

  String get formattedTime {
    final totalSeconds = widget.elapsed.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    _controller.forward();

    if (widget.won) {
      _confettiController.play();
      FeedbackService.vibrateWin();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleProgressAndAchievements();
      });
    }
  }

  Future<void> _handleProgressAndAchievements() async {
    await StreakService().registerPlay();
    await Future.delayed(const Duration(milliseconds: 500));
    final unlocked = await AchievementService().evaluateAndUnlockNewAchievements();

    if (!mounted || unlocked.isEmpty) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🏆 Logro desbloqueado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: unlocked
              .map(
                (a) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('${a.emoji} ${a.title}'),
                ),
              )
              .toList(),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Genial'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.won ? '¡Nivel completado!' : 'Partida terminada';
    final subtitle = widget.won
        ? (widget.isDailyChallenge
            ? 'Has superado el desafío diario'
            : 'Has completado un Sudoku ${widget.difficulty.name}')
        : 'Has alcanzado el límite de errores';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 0.8,
                emissionFrequency: 0.05,
                numberOfParticles: 12,
                gravity: 0.18,
                maxBlastForce: 18,
                minBlastForce: 8,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 2.3,
                emissionFrequency: 0.05,
                numberOfParticles: 12,
                gravity: 0.18,
                maxBlastForce: 18,
                minBlastForce: 8,
              ),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Icon(
                        widget.won ? Icons.emoji_events : Icons.error_outline,
                        size: 84,
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
                                value: widget.isDailyChallenge
                                    ? 'Desafío diario'
                                    : widget.difficulty.name,
                              ),
                              const SizedBox(height: 12),
                              _SummaryRow(
                                label: 'Tiempo',
                                value: formattedTime,
                              ),
                              const SizedBox(height: 12),
                              _SummaryRow(
                                label: 'Errores',
                                value: '${widget.mistakes}',
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
                            MaterialPageRoute(
                              builder: (_) => const HomePage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text('Volver al inicio'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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