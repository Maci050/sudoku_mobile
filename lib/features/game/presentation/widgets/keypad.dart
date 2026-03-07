import 'package:flutter/material.dart';

class Keypad extends StatelessWidget {
  final void Function(int number) onPressed;

  const Keypad({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(9, (index) {
        final number = index + 1;

        return SizedBox(
          width: 56,
          height: 56,
          child: ElevatedButton(
            onPressed: () => onPressed(number),
            child: Text(
              '$number',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        );
      }),
    );
  }
}