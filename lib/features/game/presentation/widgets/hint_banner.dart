import 'package:flutter/material.dart';
import '../../domain/hint_step.dart';

class HintBanner extends StatelessWidget {
  final HintStep hint;
  final VoidCallback onClose;
  final VoidCallback? onApply;

  const HintBanner({
    super.key,
    required this.hint,
    required this.onClose,
    this.onApply,
  });

  String _buttonText() {
    switch (hint.technique) {
      case HintTechnique.noteCleanup:
        return 'Corregir notas';
      case HintTechnique.missingNotes:
        return 'Añadir notas';
      default:
        return 'Aplicar';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hint.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(hint.description),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            if (hint.canAutoApply && onApply != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: onApply,
                  icon: const Icon(Icons.auto_fix_high),
                  label: Text(_buttonText()),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}