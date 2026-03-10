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
    return Row(
      children: List.generate(9, (index) {
        final number = index + 1;
        final disabled = disabledNumbers.contains(number);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: TextButton(
              onPressed: disabled ? null : () => onPressed(number),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Opacity(
                opacity: disabled ? 0.30 : 1,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}