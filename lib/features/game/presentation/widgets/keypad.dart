import 'package:flutter/material.dart';

class Keypad extends StatelessWidget {
  final void Function(int number) onPressed;
  final Set<int> disabledNumbers;

  const Keypad({
    super.key,
    required this.onPressed,
    required this.disabledNumbers,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(9, (index) {
        final number = index + 1;
        final disabled = disabledNumbers.contains(number);

        return SizedBox(
          width: 56,
          height: 56,
          child: Opacity(
            opacity: disabled ? 0.35 : 1,
            child: ElevatedButton(
              onPressed: disabled ? null : () => onPressed(number),
              child: Text(
                '$number',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
      }),
    );
  }
}