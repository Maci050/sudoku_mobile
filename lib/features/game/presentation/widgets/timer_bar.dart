import 'package:flutter/material.dart';

class TimerBar extends StatelessWidget {
  final String timeText;
  final bool isPaused;
  final VoidCallback onTogglePause;

  const TimerBar({
    super.key,
    required this.timeText,
    required this.isPaused,
    required this.onTogglePause,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined),
                  const SizedBox(width: 8),
                  Text(
                    timeText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: onTogglePause,
                    icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                    label: Text(isPaused ? 'Reanudar' : 'Pausar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}